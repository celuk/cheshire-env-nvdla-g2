// 2-to-1 AXI merge for L2 cache bypass.  Port A (L2 cache) always uses
// ID = 0;  Port B (bypass) always uses IDs with non-zero upper bits.
// Response routing exploits this: ID == 0 → port A, else → port B.
// AW/AR use round-robin arbitration; W ordering is tracked with a FIFO.

module axi_l2_merge #(
    parameter type         axi_req_t  = logic,
    parameter type         axi_rsp_t  = logic,
    parameter int unsigned WFifoDepth = 4
) (
    input  logic      clk_i,
    input  logic      rst_ni,

    input  axi_req_t  l2_req_i,
    output axi_rsp_t  l2_rsp_o,

    input  axi_req_t  byp_req_i,
    output axi_rsp_t  byp_rsp_o,

    output axi_req_t  mst_req_o,
    input  axi_rsp_t  mst_rsp_i
);

    // ---- AW arbitration (round-robin) ----
    logic aw_prio_q, aw_sel, aw_handshake;
    logic w_fifo_full;

    always_comb begin
        if (l2_req_i.aw_valid && byp_req_i.aw_valid)
            aw_sel = aw_prio_q;
        else if (l2_req_i.aw_valid)
            aw_sel = 1'b0;
        else
            aw_sel = 1'b1;
    end

    assign mst_req_o.aw       = aw_sel ? byp_req_i.aw : l2_req_i.aw;
    assign mst_req_o.aw_valid = (l2_req_i.aw_valid | byp_req_i.aw_valid) & ~w_fifo_full;
    assign aw_handshake       = mst_req_o.aw_valid & mst_rsp_i.aw_ready;
    assign l2_rsp_o.aw_ready  = ~aw_sel & mst_rsp_i.aw_ready & ~w_fifo_full;
    assign byp_rsp_o.aw_ready =  aw_sel & mst_rsp_i.aw_ready & ~w_fifo_full;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni)
            aw_prio_q <= 1'b0;
        else if (aw_handshake)
            aw_prio_q <= ~aw_sel;
    end

    // ---- W tracking FIFO (AW→W association) ----
    logic w_fifo_empty, w_fifo_out;
    logic w_pop;
    assign w_pop = mst_req_o.w_valid & mst_rsp_i.w_ready & mst_req_o.w.last;

    fifo_v3 #(
        .FALL_THROUGH ( 1'b1 ),
        .DATA_WIDTH   ( 1 ),
        .DEPTH        ( WFifoDepth )
    ) i_w_fifo (
        .clk_i,
        .rst_ni,
        .flush_i    ( 1'b0 ),
        .testmode_i ( 1'b0 ),
        .full_o     ( w_fifo_full ),
        .empty_o    ( w_fifo_empty ),
        .usage_o    (  ),
        .data_i     ( aw_sel ),
        .push_i     ( aw_handshake ),
        .data_o     ( w_fifo_out ),
        .pop_i      ( w_pop )
    );

    // ---- W channel ----
    assign mst_req_o.w       = w_fifo_out ? byp_req_i.w : l2_req_i.w;
    assign mst_req_o.w_valid = ~w_fifo_empty &
                               (w_fifo_out ? byp_req_i.w_valid : l2_req_i.w_valid);
    assign l2_rsp_o.w_ready  = ~w_fifo_out & ~w_fifo_empty & mst_rsp_i.w_ready;
    assign byp_rsp_o.w_ready =  w_fifo_out & ~w_fifo_empty & mst_rsp_i.w_ready;

    // ---- AR arbitration (round-robin) ----
    logic ar_prio_q, ar_sel, ar_handshake;

    always_comb begin
        if (l2_req_i.ar_valid && byp_req_i.ar_valid)
            ar_sel = ar_prio_q;
        else if (l2_req_i.ar_valid)
            ar_sel = 1'b0;
        else
            ar_sel = 1'b1;
    end

    assign mst_req_o.ar       = ar_sel ? byp_req_i.ar : l2_req_i.ar;
    assign mst_req_o.ar_valid = l2_req_i.ar_valid | byp_req_i.ar_valid;
    assign ar_handshake       = mst_req_o.ar_valid & mst_rsp_i.ar_ready;
    assign l2_rsp_o.ar_ready  = ~ar_sel & mst_rsp_i.ar_ready;
    assign byp_rsp_o.ar_ready =  ar_sel & mst_rsp_i.ar_ready;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni)
            ar_prio_q <= 1'b0;
        else if (ar_handshake)
            ar_prio_q <= ~ar_sel;
    end

    // ---- B channel (route by ID: 0 → L2, else → bypass) ----
    logic b_to_l2;
    assign b_to_l2 = (mst_rsp_i.b.id == '0);

    assign l2_rsp_o.b        = mst_rsp_i.b;
    assign byp_rsp_o.b       = mst_rsp_i.b;
    assign l2_rsp_o.b_valid  = mst_rsp_i.b_valid &  b_to_l2;
    assign byp_rsp_o.b_valid = mst_rsp_i.b_valid & ~b_to_l2;
    assign mst_req_o.b_ready = b_to_l2 ? l2_req_i.b_ready : byp_req_i.b_ready;

    // ---- R channel (route by ID: 0 → L2, else → bypass) ----
    logic r_to_l2;
    assign r_to_l2 = (mst_rsp_i.r.id == '0);

    assign l2_rsp_o.r        = mst_rsp_i.r;
    assign byp_rsp_o.r       = mst_rsp_i.r;
    assign l2_rsp_o.r_valid  = mst_rsp_i.r_valid &  r_to_l2;
    assign byp_rsp_o.r_valid = mst_rsp_i.r_valid & ~r_to_l2;
    assign mst_req_o.r_ready = r_to_l2 ? l2_req_i.r_ready : byp_req_i.r_ready;

endmodule

// Adapter: translates the simple req/gnt/rvalid memory protocol of cache.sv
// into full AXI4 transactions. Write responses (B channel) are consumed
// silently because cache.sv does not expect rvalid for writes.

module cache_mem_to_axi #(
    parameter int unsigned AddrWidth = 32,
    parameter int unsigned DataWidth = 64,
    parameter type         axi_req_t = logic,
    parameter type         axi_rsp_t = logic
) (
    input  logic                  clk_i,
    input  logic                  rst_ni,

    // Memory port (from cache.sv memory side)
    input  logic                  mem_req_i,
    input  logic [AddrWidth-1:0]  mem_addr_i,
    input  logic                  mem_we_i,
    input  logic [DataWidth-1:0]  mem_wdata_i,
    output logic                  mem_gnt_o,
    output logic                  mem_rvalid_o,
    output logic [DataWidth-1:0]  mem_rdata_o,

    // AXI4 master port
    output axi_req_t              axi_req_o,
    input  axi_rsp_t              axi_rsp_i
);

    localparam int unsigned StrbWidth = DataWidth / 8;
    localparam int unsigned SizeBits  = $clog2(StrbWidth);

    // ---- Write channel decoupling: AW and W may be accepted independently ----
    logic aw_sent_q, aw_sent_d;
    logic w_sent_q,  w_sent_d;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            aw_sent_q <= 1'b0;
            w_sent_q  <= 1'b0;
        end else begin
            aw_sent_q <= aw_sent_d;
            w_sent_q  <= w_sent_d;
        end
    end

    // ---- AR channel (read requests) ----
    always_comb begin
        axi_req_o.ar       = '0;
        axi_req_o.ar.addr  = mem_addr_i;
        axi_req_o.ar.size  = SizeBits[2:0];
        axi_req_o.ar.burst = axi_pkg::BURST_FIXED;
        axi_req_o.ar_valid = mem_req_i & ~mem_we_i;
    end

    // ---- AW channel (write address) ----
    always_comb begin
        axi_req_o.aw       = '0;
        axi_req_o.aw.addr  = mem_addr_i;
        axi_req_o.aw.size  = SizeBits[2:0];
        axi_req_o.aw.burst = axi_pkg::BURST_FIXED;
        axi_req_o.aw_valid = mem_req_i & mem_we_i & ~aw_sent_q;
    end

    // ---- W channel (write data) ----
    always_comb begin
        axi_req_o.w        = '0;
        axi_req_o.w.data   = mem_wdata_i;
        axi_req_o.w.strb   = {StrbWidth{1'b1}};
        axi_req_o.w.last   = 1'b1;
        axi_req_o.w_valid  = mem_req_i & mem_we_i & ~w_sent_q;
    end

    // ---- R channel: forward read responses to cache ----
    assign axi_req_o.r_ready = 1'b1;
    assign mem_rvalid_o      = axi_rsp_i.r_valid;
    assign mem_rdata_o       = axi_rsp_i.r.data;

    // ---- B channel: silently consume write responses ----
    assign axi_req_o.b_ready = 1'b1;

    // ---- Grant logic ----
    always_comb begin
        aw_sent_d = aw_sent_q;
        w_sent_d  = w_sent_q;
        mem_gnt_o = 1'b0;

        if (mem_req_i & ~mem_we_i) begin
            // Read: grant when AR accepted
            mem_gnt_o = axi_rsp_i.ar_ready;
        end else if (mem_req_i & mem_we_i) begin
            // Write: grant when both AW and W accepted
            unique case ({aw_sent_q, w_sent_q})
                2'b00: begin
                    unique case ({axi_rsp_i.aw_ready, axi_rsp_i.w_ready})
                        2'b11: mem_gnt_o = 1'b1;
                        2'b10: aw_sent_d = 1'b1;
                        2'b01: w_sent_d  = 1'b1;
                        default: ;
                    endcase
                end
                2'b10: begin // AW was sent, waiting for W
                    if (axi_rsp_i.w_ready) begin
                        aw_sent_d = 1'b0;
                        mem_gnt_o = 1'b1;
                    end
                end
                2'b01: begin // W was sent, waiting for AW
                    if (axi_rsp_i.aw_ready) begin
                        w_sent_d  = 1'b0;
                        mem_gnt_o = 1'b1;
                    end
                end
                default: begin
                    aw_sent_d = 1'b0;
                    w_sent_d  = 1'b0;
                end
            endcase
        end
    end

endmodule

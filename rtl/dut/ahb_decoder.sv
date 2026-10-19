module ahb_decoder #(
    parameter logic [31:0] APB_BASE = 32'h4000_0000,
    parameter logic [31:0] APB_MASK = 32'hFFFF_0000
) (
    input  logic [31:0] HADDR,
    input  logic        HSEL,
    output logic        PSEL
);

    always_comb begin
        PSEL = HSEL &&
               ((HADDR & APB_MASK) ==
                (APB_BASE & APB_MASK));
    end

endmodule


module apb_peripheral_stub #(
    parameter int REG_WORDS = 16,
    parameter int WAIT_CYCLES = 0
) (
    input  logic        PCLK,
    input  logic        PRESETn,

    input  logic        PSEL,
    input  logic        PENABLE,
    input  logic        PWRITE,
    input  logic [31:0] PADDR,
    input  logic [31:0] PWDATA,

    output logic        PREADY,
    output logic        PSLVERR,
    output logic [31:0] PRDATA
);

    localparam int IDX_W = $clog2(REG_WORDS);

    logic [31:0] regs [0:REG_WORDS-1];
    logic [31:0] read_data_q;
    logic [31:0] wait_count_q;

    wire access = PSEL && PENABLE;
    wire addr_valid =
        (PADDR[31:2] < REG_WORDS);

    integer i;

    always_comb begin
        PREADY  = (wait_count_q >= WAIT_CYCLES);
        PSLVERR = access && PREADY && !addr_valid;
        PRDATA  = read_data_q;
    end

    always_ff @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            wait_count_q <= '0;
            read_data_q  <= '0;

            for (i = 0; i < REG_WORDS; i++)
                regs[i] <= '0;
        end else begin
            if (!access)
                wait_count_q <= '0;
            else if (!PREADY)
                wait_count_q <= wait_count_q + 1'b1;

            if (access && PREADY && addr_valid) begin
                if (PWRITE)
                    regs[PADDR[IDX_W+1:2]] <= PWDATA;
                else
                    read_data_q <= regs[PADDR[IDX_W+1:2]];
            end
        end
    end

endmodule

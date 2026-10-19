module ahb_to_apb_bridge (
    input  logic        HCLK,
    input  logic        HRESETn,

    input  logic        HSEL,
    input  logic [31:0] HADDR,
    input  logic [1:0]  HTRANS,
    input  logic        HWRITE,
    input  logic [2:0]  HSIZE,
    input  logic [31:0] HWDATA,
    input  logic        HREADY,

    output logic        HREADYOUT,
    output logic        HRESP,
    output logic [31:0] HRDATA,

    output logic        PSEL,
    output logic        PENABLE,
    output logic        PWRITE,
    output logic [31:0] PADDR,
    output logic [31:0] PWDATA,
    input  logic        PREADY,
    input  logic        PSLVERR,
    input  logic [31:0] PRDATA
);

    typedef enum logic [1:0] {
        IDLE,
        SETUP,
        ACCESS
    } state_t;

    state_t state_q;

    logic [31:0] addr_q;
    logic [31:0] wdata_q;
    logic        write_q;
    logic [2:0]  size_q;
    logic        selected_q;

    wire ahb_transfer_valid =
        HSEL && HREADY &&
        HTRANS[1];

    always_comb begin
        HREADYOUT = 1'b1;
        HRESP     = 1'b0;
        HRDATA    = 32'b0;

        PSEL      = 1'b0;
        PENABLE   = 1'b0;
        PWRITE    = write_q;
        PADDR     = addr_q;
        PWDATA    = wdata_q;

        case (state_q)
            IDLE: begin
                HREADYOUT = 1'b1;
            end

            SETUP: begin
                PSEL      = selected_q;
                PENABLE   = 1'b0;
                HREADYOUT = 1'b0;
            end

            ACCESS: begin
                PSEL      = selected_q;
                PENABLE   = 1'b1;
                HREADYOUT = PREADY;

                if (PREADY) begin
                    HRESP  = PSLVERR;
                    HRDATA = PRDATA;
                end
            end

            default: begin
                HREADYOUT = 1'b1;
            end
        endcase
    end

    always_ff @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            state_q    <= IDLE;
            addr_q     <= '0;
            wdata_q    <= '0;
            write_q    <= 1'b0;
            size_q     <= '0;
            selected_q <= 1'b0;
        end else begin
            case (state_q)
                IDLE: begin
                    if (ahb_transfer_valid) begin
                        addr_q     <= HADDR;
                        write_q    <= HWRITE;
                        size_q     <= HSIZE;
                        selected_q <= 1'b1;
                        state_q    <= SETUP;
                    end
                end

                SETUP: begin
                    // HWDATA belongs to the AHB data phase.
                    wdata_q <= HWDATA;
                    state_q <= ACCESS;
                end

                ACCESS: begin
                    if (PREADY) begin
                        state_q <= IDLE;
                        selected_q <= 1'b0;
                    end
                end

                default: state_q <= IDLE;
            endcase
        end
    end

endmodule


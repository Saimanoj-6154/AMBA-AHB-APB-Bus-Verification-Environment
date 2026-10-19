interface apb_if(input logic PCLK);

    logic PRESETn;
    logic PSEL;
    logic PENABLE;
    logic PWRITE;
    logic [31:0] PADDR;
    logic [31:0] PWDATA;
    logic [31:0] PRDATA;
    logic PREADY;
    logic PSLVERR;

    clocking monitor_cb @(posedge PCLK);
        default input #1step;
        input PRESETn, PSEL, PENABLE, PWRITE;
        input PADDR, PWDATA, PRDATA, PREADY, PSLVERR;
    endclocking

endinterface

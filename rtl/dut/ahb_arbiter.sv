
module ahb_arbiter #(
    parameter int NUM_MASTERS = 2,
    parameter int IDX_W = $clog2(NUM_MASTERS)
) (
    input  logic                   HCLK,
    input  logic                   HRESETn,

    input  logic [NUM_MASTERS-1:0] HREQ,
    input  logic                   HREADY,

    output logic [NUM_MASTERS-1:0] HGRANT
);

    logic [IDX_W-1:0] last_grant;
    logic [IDX_W-1:0] next_grant;
    logic found;

    integer offset;
    integer candidate;

    always_comb begin
        HGRANT     = '0;
        next_grant = last_grant;
        found      = 1'b0;

        for (offset = 1; offset <= NUM_MASTERS; offset++) begin
            candidate = (last_grant + offset) % NUM_MASTERS;

            if (!found && HREQ[candidate]) begin
                next_grant = candidate[IDX_W-1:0];
                HGRANT[candidate] = 1'b1;
                found = 1'b1;
            end
        end
    end

    always_ff @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn)
            last_grant <= NUM_MASTERS-1;
        else if (HREADY && |HGRANT)
            last_grant <= next_grant;
    end

endmodule

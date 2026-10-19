class ahb_slave_driver extends uvm_component;

    `uvm_component_utils(ahb_slave_driver)

    virtual ahb_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual ahb_if)::get(
                this, "", "vif", vif))
            `uvm_fatal("NOVIF", "AHB slave interface missing")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.HCLK);

            // Default ready response for a simple memory target.
            if (vif.HRESETn) begin
                vif.HREADYOUT <= 1'b1;
                vif.HRESP <= 1'b0;
                vif.HRDATA <= 32'b0;
            end else begin
                vif.HREADYOUT <= 1'b0;
                vif.HRESP <= 1'b0;
                vif.HRDATA <= 32'b0;
            end
        end
    endtask

endclass

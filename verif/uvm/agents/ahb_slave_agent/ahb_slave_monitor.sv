class ahb_slave_monitor extends uvm_monitor;

    `uvm_component_utils(ahb_slave_monitor)

    virtual ahb_if vif;
    uvm_analysis_port #(ahb_master_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual ahb_if)::get(
                this, "", "vif", vif))
            `uvm_fatal("NOVIF", "AHB slave monitor interface missing")
    endfunction

    task run_phase(uvm_phase phase);
        ahb_master_item item;

        forever begin
            @(posedge vif.HCLK);

            if (vif.HRESETn && vif.HREADYOUT) begin
                item = ahb_master_item::type_id::create("item");

                item.read_data = vif.HRDATA;
                item.response_error = vif.HRESP;

                ap.write(item);
            end
        end
    endtask

endclass

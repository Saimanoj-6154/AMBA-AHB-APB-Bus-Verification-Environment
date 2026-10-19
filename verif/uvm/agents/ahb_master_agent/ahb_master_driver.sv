class ahb_master_driver extends uvm_driver #(ahb_master_item);

    `uvm_component_utils(ahb_master_driver)

    virtual ahb_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual ahb_if)::get(
                this, "", "vif", vif))
            `uvm_fatal("NOVIF", "AHB virtual interface not configured")
    endfunction

    task run_phase(uvm_phase phase);
        ahb_master_item req;

        vif.master_cb.HSEL   <= 1'b0;
        vif.master_cb.HTRANS <= 2'b00;
        vif.master_cb.HADDR  <= '0;
        vif.master_cb.HWRITE <= 1'b0;
        vif.master_cb.HSIZE  <= 3'b010;
        vif.master_cb.HBURST <= 3'b000;
        vif.master_cb.HWDATA <= '0;

        forever begin
            seq_item_port.get_next_item(req);

            // Drive the address/control phase.
            @(vif.master_cb);
            vif.master_cb.HSEL   <= 1'b1;
            vif.master_cb.HADDR  <= req.addr;
            vif.master_cb.HTRANS <= req.trans;
            vif.master_cb.HWRITE <= req.write;
            vif.master_cb.HSIZE  <= req.size;
            vif.master_cb.HBURST <= 3'b000;

            // Wait for the address phase to be accepted.
            do @(vif.master_cb);
            while (!vif.master_cb.HREADY);

            // Drive the write data phase.
            vif.master_cb.HWDATA <= req.data;

            // Wait for the simplified slave response.
            do @(vif.master_cb);
            while (!vif.master_cb.HREADYOUT);

            req.read_data = vif.master_cb.HRDATA;
            req.response_error = vif.master_cb.HRESP;

            vif.master_cb.HSEL   <= 1'b0;
            vif.master_cb.HTRANS <= 2'b00;

            seq_item_port.item_done();
        end
    endtask

endclass

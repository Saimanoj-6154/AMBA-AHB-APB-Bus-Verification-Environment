class error_injection_vseq extends base_vseq;

    `uvm_object_utils(error_injection_vseq)

    function new(string name = "error_injection_vseq");
        super.new(name);
    endfunction

    task body();
        ahb_master_item req;

        req = ahb_master_item::type_id::create("invalid_access");

        start_item(req, -1, p_sequencer.master_seqr[0]);

        req.addr  = 32'h5000_0000; // Outside configured APB region
        req.data  = 32'hDEAD_BEEF;
        req.write = 1'b0;
        req.size  = 3'b010;
        req.trans = 2'b10;

        finish_item(req);
    endtask

endclass

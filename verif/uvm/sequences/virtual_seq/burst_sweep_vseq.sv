class burst_sweep_vseq extends base_vseq;

    `uvm_object_utils(burst_sweep_vseq)

    function new(string name = "burst_sweep_vseq");
        super.new(name);
    endfunction

    task body();
        ahb_master_item req;

        for (int burst = 0; burst < 8; burst++) begin
            req = ahb_master_item::type_id::create("req");

            start_item(req, -1, p_sequencer.master_seqr[0]);

            req.addr  = 32'h4000_0000 + (burst * 4);
            req.data  = $urandom();
            req.write = 1'b1;
            req.size  = 3'b010;
            req.trans = 2'b10;

            finish_item(req);
        end
    endtask

endclass

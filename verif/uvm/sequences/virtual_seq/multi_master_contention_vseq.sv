class multi_master_contention_vseq extends base_vseq;

    `uvm_object_utils(multi_master_contention_vseq)

    function new(string name = "multi_master_contention_vseq");
        super.new(name);
    endfunction

    task body();
        ahb_basic_seq seq;

        if (p_sequencer.master_seqr.size() < 2)
            `uvm_fatal("NOMASTERS", "Two master sequencers required")

        fork
            begin
                seq = ahb_basic_seq::type_id::create("master0_seq");
                seq.start(p_sequencer.master_seqr[0]);
            end

            begin
                seq = ahb_basic_seq::type_id::create("master1_seq");
                seq.start(p_sequencer.master_seqr[1]);
            end
        join
    endtask

endclass

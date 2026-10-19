class base_vseq extends uvm_sequence;

    `uvm_object_utils(base_vseq)
    `uvm_declare_p_sequencer(ahb_apb_virtual_sequencer)

    function new(string name = "base_vseq");
        super.new(name);
    endfunction

    task body();
        `uvm_info("BASE_VSEQ", "Base virtual sequence started", UVM_LOW)
    endtask

endclass

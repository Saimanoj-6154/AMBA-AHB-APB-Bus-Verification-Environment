class ahb_apb_virtual_sequencer extends uvm_sequencer;

    `uvm_component_utils(ahb_apb_virtual_sequencer)

    ahb_master_sequencer master_seqr[];

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass

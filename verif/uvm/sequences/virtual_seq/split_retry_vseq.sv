class split_retry_vseq extends base_vseq;

    `uvm_object_utils(split_retry_vseq)

    function new(string name = "split_retry_vseq");
        super.new(name);
    endfunction

    task body();
        `uvm_warning(
            "UNSUPPORTED",
            "SPLIT/RETRY require full AHB, not AHB-Lite. "
            "Use wait-state and ERROR response tests for this DUT."
        )
    endtask

endclass

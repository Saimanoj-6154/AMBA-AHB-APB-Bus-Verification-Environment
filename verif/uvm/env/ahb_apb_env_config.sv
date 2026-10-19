class ahb_apb_env_config extends uvm_object;

    `uvm_object_utils(ahb_apb_env_config)

    bit enable_scoreboard = 1'b1;
    bit enable_coverage = 1'b1;
    bit enable_protocol_checks = 1'b1;

    int unsigned num_masters = 2;

    function new(string name = "ahb_apb_env_config");
        super.new(name);
    endfunction

endclass

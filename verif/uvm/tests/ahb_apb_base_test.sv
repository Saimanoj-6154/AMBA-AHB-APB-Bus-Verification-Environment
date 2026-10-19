class ahb_apb_base_test extends uvm_test;

    `uvm_component_utils(ahb_apb_base_test)

    ahb_apb_env env;
    ahb_apb_env_config cfg;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        cfg = ahb_apb_env_config::type_id::create("cfg");

        uvm_config_db#(ahb_apb_env_config)::set(
            this, "env", "cfg", cfg);

        env = ahb_apb_env::type_id::create("env", this);
    endfunction

endclass

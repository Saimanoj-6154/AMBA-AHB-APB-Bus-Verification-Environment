class ahb_apb_env extends uvm_env;

    `uvm_component_utils(ahb_apb_env)

    ahb_master_agent master_agent;
    ahb_apb_scoreboard scoreboard;
    ahb_apb_coverage coverage;
    ahb_apb_env_config cfg;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(ahb_apb_env_config)::get(
                this, "", "cfg", cfg))
            cfg = ahb_apb_env_config::type_id::create("cfg");

        master_agent = ahb_master_agent::type_id::create(
            "master_agent", this);

        if (cfg.enable_scoreboard)
            scoreboard = ahb_apb_scoreboard::type_id::create(
                "scoreboard", this);

        if (cfg.enable_coverage)
            coverage = ahb_apb_coverage::type_id::create(
                "coverage", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if (cfg.enable_scoreboard)
            master_agent.monitor.ap.connect(
                scoreboard.analysis_export);

        if (cfg.enable_coverage)
            master_agent.monitor.ap.connect(
                coverage.analysis_export);
    endfunction

endclass

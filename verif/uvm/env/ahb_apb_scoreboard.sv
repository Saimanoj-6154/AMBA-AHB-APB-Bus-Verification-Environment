class ahb_apb_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(ahb_apb_scoreboard)

    uvm_analysis_imp #(ahb_master_item, ahb_apb_scoreboard) analysis_export;

    int unsigned transactions_checked;
    int unsigned mismatches;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
    endfunction

    function void write(ahb_master_item item);
        transactions_checked++;

        `uvm_info(
            "AHB_APB_SB",
            $sformatf(
                "Observed address=%08h write=%0b data=%08h error=%0b",
                item.addr,
                item.write,
                item.data,
                item.response_error
            ),
            UVM_MEDIUM
        )
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info(
            "AHB_APB_SB",
            $sformatf(
                "Observed %0d transactions; mismatches=%0d",
                transactions_checked,
                mismatches
            ),
            UVM_LOW
        )
    endfunction

endclass

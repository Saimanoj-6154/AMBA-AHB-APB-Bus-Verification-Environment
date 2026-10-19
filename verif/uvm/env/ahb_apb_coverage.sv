class ahb_apb_coverage extends uvm_subscriber #(ahb_master_item);

    `uvm_component_utils(ahb_apb_coverage)

    bit [2:0] sampled_size;
    bit sampled_write;
    bit sampled_error;

    covergroup transfer_cg;
        option.per_instance = 1;

        cp_size: coverpoint sampled_size {
            bins byte_transfer = {3'b000};
            bins halfword     = {3'b001};
            bins word         = {3'b010};
        }

        cp_write: coverpoint sampled_write {
            bins reads  = {0};
            bins writes = {1};
        }

        cp_error: coverpoint sampled_error {
            bins success = {0};
            bins error   = {1};
        }

        size_write_cross: cross cp_size, cp_write;
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        transfer_cg = new();
    endfunction

    function void write(ahb_master_item t);
        sampled_size  = t.size;
        sampled_write = t.write;
        sampled_error = t.response_error;

        transfer_cg.sample();
    endfunction

endclass

class ahb_master_item extends uvm_sequence_item;

    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit        write;
    rand bit [2:0]  size;
    rand bit [1:0]  trans;

    bit [31:0] read_data;
    bit        response_error;

    constraint c_alignment {
        if (size == 3'b001) addr[0] == 1'b0;
        if (size == 3'b010) addr[1:0] == 2'b00;
    }

    constraint c_transfer {
        trans inside {2'b10, 2'b11};
        size inside {3'b000, 3'b001, 3'b010};
    }

    `uvm_object_utils_begin(ahb_master_item)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(write, UVM_ALL_ON)
        `uvm_field_int(size, UVM_ALL_ON)
        `uvm_field_int(trans, UVM_ALL_ON)
        `uvm_field_int(read_data, UVM_ALL_ON)
        `uvm_field_int(response_error, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "ahb_master_item");
        super.new(name);
    endfunction

endclass

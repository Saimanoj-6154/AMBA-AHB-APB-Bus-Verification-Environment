class ahb_basic_seq extends uvm_sequence #(ahb_master_item);

    `uvm_object_utils(ahb_basic_seq)

    function new(string name = "ahb_basic_seq");
        super.new(name);
    endfunction

    task body();
        ahb_master_item req;

        repeat (20) begin
            req = ahb_master_item::type_id::create("req");

            start_item(req);

            if (!req.randomize())
                `uvm_fatal("RANDFAIL", "AHB request randomization failed")

            finish_item(req);
        end
    endtask

endclass


class ahb_write_read_seq extends uvm_sequence #(ahb_master_item);

    `uvm_object_utils(ahb_write_read_seq)

    function new(string name = "ahb_write_read_seq");
        super.new(name);
    endfunction

    task body();
        ahb_master_item req;

        // Write a word to an aligned address.
        req = ahb_master_item::type_id::create("write_req");
        start_item(req);

        req.addr  = 32'h4000_0000;
        req.data  = 32'h1234_ABCD;
        req.write = 1'b1;
        req.size  = 3'b010;
        req.trans = 2'b10;

        finish_item(req);

        // Read the same address.
        req = ahb_master_item::type_id::create("read_req");
        start_item(req);

        req.addr  = 32'h4000_0000;
        req.data  = '0;
        req.write = 1'b0;
        req.size  = 3'b010;
        req.trans = 2'b10;

        finish_item(req);
    endtask

endclass

class bridge_ref_model extends uvm_object;

    `uvm_object_utils(bridge_ref_model)

    typedef struct packed {
        bit [31:0] addr;
        bit [31:0] data;
        bit        write;
        bit [2:0]  size;
    } expected_transfer_t;

    expected_transfer_t expected_q[$];

    function new(string name = "bridge_ref_model");
        super.new(name);
    endfunction

    function void predict(
        bit [31:0] addr,
        bit [31:0] data,
        bit write,
        bit [2:0] size
    );
        expected_transfer_t exp;

        exp.addr  = addr;
        exp.data  = data;
        exp.write = write;
        exp.size  = size;

        expected_q.push_back(exp);
    endfunction

    function bit compare_transfer(
        bit [31:0] addr,
        bit [31:0] data,
        bit write
    );
        expected_transfer_t exp;

        if (expected_q.size() == 0)
            return 1'b0;

        exp = expected_q.pop_front();

        return (exp.addr == addr) &&
               (exp.data == data) &&
               (exp.write == write);
    endfunction

endclass

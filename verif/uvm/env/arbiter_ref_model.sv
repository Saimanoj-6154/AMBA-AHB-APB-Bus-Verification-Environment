class arbiter_ref_model extends uvm_object;

    `uvm_object_utils(arbiter_ref_model)

    int unsigned last_grant;

    function new(string name = "arbiter_ref_model");
        super.new(name);
        last_grant = 0;
    endfunction

    function int next_grant(bit requests[]);
        int count;

        count = requests.size();

        if (count == 0)
            return -1;

        for (int offset = 1; offset <= count; offset++) begin
            int candidate;
            candidate = (last_grant + offset) % count;

            if (requests[candidate]) begin
                last_grant = candidate;
                return candidate;
            end
        end

        return -1;
    endfunction

endclass

class demote_catcher extends uvm_report_catcher;
    `uvm_object_utils(demote_catcher)
    int n_demoted, n_caught;

    function new(string name = "demote_catcher"); super.new(name); endfunction

    function action_e catch();
        if (get_severity() == UVM_ERROR && get_id() == "KNOWN_BUG") begin
            set_severity(UVM_WARNING);           // waived: still visible, no longer fails the test
            n_demoted++;
        end else if (get_severity() == UVM_INFO && get_id() == "NOISY") begin
            n_caught++;
            return CAUGHT;                       // swallowed: never reaches the report server
        end
        return THROW;
    endfunction
endclass

class demote_catcher extends uvm_report_catcher;
    `uvm_object_utils(demote_catcher)
    int n_demoted, n_caught;

    function new(string name = "demote_catcher"); super.new(name); endfunction

    function action_e catch();
        // TODO
        return THROW;
    endfunction
endclass

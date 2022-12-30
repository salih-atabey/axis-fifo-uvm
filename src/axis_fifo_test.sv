`include "uvm_macros.svh"
import uvm_pkg::*;
import axis_fifo_pkg::*;

class axis_fifo_test extends uvm_test;
    `uvm_component_utils(axis_fifo_test)

    function new(string name = "axis_fifo_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    uvm_verbosity             verbose          = UVM_LOW;
    int                       seq_min          = ITEM_NUM;
    int                       seq_max          = ITEM_NUM;
    time                      timeout          = TIMEOUT;
    axis_fifo_env             axis_fifo_env_0;
    virtual axis_if           axis_if_slave;
    virtual axis_if           axis_if_master;
    virtual reset_if          rif;
    axis_sequence #("slave")  seq_slave;
    axis_sequence #("master") seq_master;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axis_fifo_env_0 = axis_fifo_env::type_id::create("axis_fifo_env_0", this);

        axis_fifo_env_0.set_report_verbosity_level(verbose);
        seq_slave = axis_sequence#("slave")::type_id::create("seq_slave");
        seq_slave.randomize() with {
            num inside {[seq_min : seq_max]};
        };
        seq_master = axis_sequence#("master")::type_id::create("seq_master");
        seq_master.num = seq_slave.num;
        uvm_top.set_timeout(timeout, 1);

        if (!uvm_config_db#(virtual reset_if)::get(this, "", "reset_if", rif)) `uvm_fatal("TEST", "Did not get reset interface")
        uvm_config_db#(virtual reset_if)::set(this, "axis_fifo_env_0.axis_agent_slave.*", "reset_if", rif);
        uvm_config_db#(virtual reset_if)::set(this, "axis_fifo_env_0.axis_agent_master.*", "reset_if", rif);

        if (!uvm_config_db#(virtual axis_if)::get(this, "", "axis_if_slave", axis_if_slave)) `uvm_fatal("TEST", "Did not get slave interface")
        uvm_config_db#(virtual axis_if)::set(this, "axis_fifo_env_0.axis_agent_slave.*", "axis_if_slave", axis_if_slave);

        if (!uvm_config_db#(virtual axis_if)::get(this, "", "axis_if_master", axis_if_master)) `uvm_fatal("TEST", "Did not get master interface")
        uvm_config_db#(virtual axis_if)::set(this, "axis_fifo_env_0.axis_agent_master.*", "axis_if_master", axis_if_master);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        init_if();
        apply_reset();
        fork
            seq_slave.start(axis_fifo_env_0.axis_agent_slave.axis_sequencer_0);
            seq_master.start(axis_fifo_env_0.axis_agent_master.axis_sequencer_0);
        join
        #200;
        phase.drop_objection(this);
    endtask

    virtual task init_if();
        rif.reset <= 0;
        axis_if_slave.valid <= 0;
        axis_if_master.ready <= 0;
    endtask

    virtual task apply_reset();
        rif.reset <= 1;
        repeat (5) @(posedge rif.clk);
        rif.reset <= 0;
        repeat (10) @(posedge rif.clk);
    endtask
endclass


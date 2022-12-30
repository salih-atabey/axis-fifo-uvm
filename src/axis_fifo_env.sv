`include "uvm_macros.svh"
import uvm_pkg::*;

class axis_fifo_env extends uvm_env;
    `uvm_component_utils(axis_fifo_env)

    function new(string name = "axis_fifo_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    axis_agent           #("slave")  axis_agent_slave;
    axis_agent           #("master") axis_agent_master;
    axis_fifo_scoreboard axis_fifo_scoreboard_0;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axis_agent_slave = axis_agent#("slave")::type_id::create("axis_agent_slave", this);
        axis_agent_master = axis_agent#("master")::type_id::create("axis_agent_master", this);
        axis_fifo_scoreboard_0 = axis_fifo_scoreboard::type_id::create("axis_fifo_scoreboard_0", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        axis_agent_slave.axis_monitor_0.mon_analysis_port.connect(axis_fifo_scoreboard_0.s_analysis_port);
        axis_agent_master.axis_monitor_0.mon_analysis_port.connect(axis_fifo_scoreboard_0.m_analysis_port);
    endfunction
endclass

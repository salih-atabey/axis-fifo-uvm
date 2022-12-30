`include "uvm_macros.svh"
import uvm_pkg::*;

class axis_agent #(string Direction="") extends uvm_agent;
    `uvm_component_utils(axis_agent#(Direction))

    function new(string name = "axis_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    axis_driver    #(Direction) axis_driver_0;
    axis_monitor   #(Direction) axis_monitor_0;
    uvm_sequencer  #(axis_item) axis_sequencer_0;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axis_driver_0 = axis_driver#(Direction)::type_id::create("axis_driver_0", this);
        axis_sequencer_0 = uvm_sequencer#(axis_item)::type_id::create("axis_sequencer_0", this);
        axis_monitor_0 = axis_monitor#(Direction)::type_id::create("axis_monitor_0", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        axis_driver_0.seq_item_port.connect(axis_sequencer_0.seq_item_export);
    endfunction
endclass

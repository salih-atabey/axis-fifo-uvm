`include "uvm_macros.svh"
import uvm_pkg::*;

class axis_monitor #(string Direction="") extends uvm_monitor;
    `uvm_component_utils(axis_monitor#(Direction))

    function new(string name = "axis_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    uvm_analysis_port #(axis_item) mon_analysis_port;
    virtual axis_if vif;
    virtual reset_if rif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual reset_if)::get(this, "", "reset_if", rif))
            `uvm_fatal("MON", "Could not get rif")
        if (!uvm_config_db#(virtual axis_if)::get(this, "", $sformatf("axis_if_%s",Direction), vif))
            `uvm_fatal("MON", "Could not get vif")
        mon_analysis_port = new("mon_analysis_port", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            forever begin
                monitor_item();
            end
        join
    endtask

    virtual task automatic monitor_item();
        if (Direction == "slave") begin
            @(vif.cb_slave);
            if (!rif.reset && vif.valid && vif.cb_slave.ready) begin
                automatic axis_item item = axis_item::type_id::create($sformatf("axis_item_%s", Direction));
                item.data = vif.data;
                item.keep = vif.keep;
                item.valid = vif.valid;
                item.ready = vif.cb_slave.ready;
                item.last = vif.last;
                item.id = vif.id;
                item.dest = vif.dest;
                item.user = vif.user;
                mon_analysis_port.write(item);
                `uvm_info("MON", $sformatf("Saw slave item %s", item.convert2str()), UVM_HIGH)
            end
        end else if (Direction == "master") begin
            @(vif.cb_master);
            if (!rif.reset && vif.cb_master.valid && vif.ready) begin
                automatic axis_item item = axis_item::type_id::create($sformatf("axis_item_%s", Direction));
                item.data = vif.cb_master.data;
                item.keep = vif.cb_master.keep;
                item.valid = vif.cb_master.valid;
                item.ready = vif.ready;
                item.last = vif.cb_master.last;
                item.id = vif.cb_master.id;
                item.dest = vif.cb_master.dest;
                item.user = vif.cb_master.user;
                mon_analysis_port.write(item);
                `uvm_info("MON", $sformatf("Saw master item %s", item.convert2str()), UVM_HIGH)
            end
        end else begin
            `uvm_fatal("MON", "Direction must be 'slave' or 'master'")
        end
    endtask
endclass

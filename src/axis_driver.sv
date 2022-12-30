`include "uvm_macros.svh"
import uvm_pkg::*;

class axis_driver #(string Direction="") extends uvm_driver #(axis_item);
    `uvm_component_utils(axis_driver#(Direction))

    function new(string name = "axis_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual axis_if vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual axis_if)::get(this, "", $sformatf("axis_if_%s",Direction), vif))
            `uvm_fatal("DRV", "Could not get vif")
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            forever begin
                seq_item_port.get_next_item(req);
                drive_item();
                seq_item_port.item_done();
            end
        join
    endtask

    virtual task automatic drive_item();
        if (Direction == "slave") begin
            vif.cb_slave.data <= req.data;
            vif.cb_slave.keep <= req.keep;
            vif.cb_slave.valid <= req.valid;
            vif.cb_slave.last <= req.last;
            vif.cb_slave.id <= req.id;
            vif.cb_slave.dest <= req.dest;
            vif.cb_slave.user <= req.user;
            do begin
                @(posedge vif.clk);
            end while (req.valid && !vif.ready);
        end else if (Direction == "master") begin
            vif.cb_master.ready <= req.ready;
            do begin
                @(posedge vif.clk);
            end while (req.ready && !vif.valid);
        end else begin
            `uvm_fatal("DRV", "Direction must be 'slave' or 'master'")
        end
    endtask
endclass

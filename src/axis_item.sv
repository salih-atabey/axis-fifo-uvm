`include "uvm_macros.svh"
import uvm_pkg::*;
import axis_if_pkg::*;

class axis_item extends uvm_sequence_item;
    `uvm_object_utils(axis_item)

    rand bit [  DATA_WIDTH-1:0] data;
    rand bit [DATA_WIDTH/8-1:0] keep;
    rand bit                    valid;
    rand bit                    ready;
    rand bit                    last;
    rand bit [    ID_WIDTH-1:0] id;
    rand bit [  DEST_WIDTH-1:0] dest;
    rand bit [  USER_WIDTH-1:0] user;

    function new(string name = "axis_item");
        super.new(name);
        if (name == "axis_item_slave") begin
            ready.rand_mode(0);
        end else if (name == "axis_item_master") begin
            data.rand_mode(0);
            keep.rand_mode(0);
            valid.rand_mode(0);
            last.rand_mode(0);
            id.rand_mode(0);
            dest.rand_mode(0);
            user.rand_mode(0);
        end else if (name == "axis_item") begin
            data.rand_mode(0);
            keep.rand_mode(0);
            valid.rand_mode(0);
            ready.rand_mode(0);
            last.rand_mode(0);
            id.rand_mode(0);
            dest.rand_mode(0);
            user.rand_mode(0);
        end else begin
            `uvm_fatal("ITEM", "Name must be 'axis_item', 'axis_item_slave' or 'axis_item_master'")
        end
    endfunction

    virtual function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_field("data", data, DATA_WIDTH, UVM_HEX);
        printer.print_field("keep", keep, DATA_WIDTH / 8, UVM_BIN);
        printer.print_field("valid", valid, 1, UVM_BIN);
        printer.print_field("ready", ready, 1, UVM_BIN);
        printer.print_field("last", last, 1, UVM_BIN);
        printer.print_field("id", id, USER_WIDTH, UVM_HEX);
        printer.print_field("dest", dest, DEST_WIDTH, UVM_HEX);
        printer.print_field("user", user, ID_WIDTH, UVM_HEX);
    endfunction

    virtual function string convert2str();
        return $sformatf("data:%0x, keep:%0b, valid:%0b, ready:%0b, last:%0b, id:%0x, dest:%0x, user:%0x", data, keep, valid, ready, last, id, dest, user);
    endfunction
endclass

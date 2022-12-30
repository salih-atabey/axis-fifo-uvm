`include "uvm_macros.svh"
import uvm_pkg::*;

class axis_sequence #(string Direction="") extends uvm_sequence #(axis_item);
    `uvm_object_utils(axis_sequence#(Direction))

    function new(string name = "axis_sequence");
        super.new(name);
    endfunction

    int i;
    rand int num;
    axis_item item;

    virtual task pre_body();
        item = axis_item::type_id::create($sformatf("axis_item_%s", Direction));
        start_item(item);
        finish_item(item);
    endtask

    virtual task body();
        fork
            repeat(num) begin
                do begin
                    start_item(item);
                    item.randomize();
                    finish_item(item);                
                end while ((Direction == "slave" && !item.valid) || (Direction == "master" && !item.ready));
                `uvm_info("SEQ", $sformatf("Generate %0d. %s item: %s", i++, Direction, item.convert2str()), UVM_HIGH)
            end
        join
        `uvm_info("SEQ", $sformatf("Done generation of %0d axis %s items", num, Direction), UVM_LOW)
    endtask

    virtual task post_body();
        item.valid = 0;
        item.ready = 0;
        start_item(item);
        finish_item(item);
    endtask
endclass

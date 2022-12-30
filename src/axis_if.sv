`timescale 1ns / 1ps

import axis_if_pkg::*;

interface axis_if #(
    parameter integer DATA_WIDTH = DATA_WIDTH,
    parameter integer ID_WIDTH   = ID_WIDTH,
    parameter integer DEST_WIDTH = DEST_WIDTH,
    parameter integer USER_WIDTH = USER_WIDTH
) (
    input logic clk
);
    logic [  DATA_WIDTH-1:0] data;
    logic [DATA_WIDTH/8-1:0] keep;
    logic                    valid;
    logic                    ready;
    logic                    last;
    logic [    ID_WIDTH-1:0] id;
    logic [  DEST_WIDTH-1:0] dest;
    logic [  USER_WIDTH-1:0] user;

    modport slave(output ready, input data, keep, valid, last, id, dest, user);

    modport master(input ready, output data, keep, valid, last, id, dest, user);

    clocking cb_slave @(posedge clk);
        default input #1step output #1step;
        input ready;
        output data, keep, valid, last, id, dest, user;
    endclocking

    clocking cb_master @(posedge clk);
        default input #1step output #1step;
        output ready;
        input data, keep, valid, last, id, dest, user;
    endclocking

endinterface

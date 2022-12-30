`include "uvm_macros.svh"
import uvm_pkg::*;
import axis_fifo_pkg::*;

`timescale 1ns / 1ps

module axis_fifo_tb;

    reg clk;

    always #2 clk = ~clk;

    reset_if r_if (clk);
    axis_if  s_if (clk);
    axis_if  m_if (clk);

    axis_fifo #(
        .DEPTH(DEPTH),
        .DATA_WIDTH(s_if.DATA_WIDTH),
        .KEEP_ENABLE(KEEP_ENABLE),
        .KEEP_WIDTH(DATA_WIDTH/8),
        .LAST_ENABLE(LAST_ENABLE),
        .ID_ENABLE(ID_ENABLE),
        .ID_WIDTH(s_if.ID_WIDTH),
        .DEST_ENABLE(DEST_ENABLE),
        .DEST_WIDTH(s_if.DEST_WIDTH),
        .USER_ENABLE(USER_ENABLE),
        .USER_WIDTH(s_if.USER_WIDTH),
        .PIPE_LEVEL(PIPE_LEVEL)
    ) axis_fifo_dut (
        .clk(clk),
        .rst(r_if.reset),
        .s_axis_tdata(s_if.data),
        .s_axis_tkeep(s_if.keep),
        .s_axis_tvalid(s_if.valid),
        .s_axis_tready(s_if.ready),
        .s_axis_tlast(s_if.last),
        .s_axis_tid(s_if.id),
        .s_axis_tdest(s_if.dest),
        .s_axis_tuser(s_if.user),
        .m_axis_tdata(m_if.data),
        .m_axis_tkeep(m_if.keep),
        .m_axis_tvalid(m_if.valid),
        .m_axis_tready(m_if.ready),
        .m_axis_tlast(m_if.last),
        .m_axis_tid(m_if.id),
        .m_axis_tdest(m_if.dest),
        .m_axis_tuser(m_if.user)
    );

    initial begin
        clk <= 0;
        uvm_config_db#(virtual reset_if)::set(null, "", "reset_if", r_if);
        uvm_config_db#(virtual axis_if)::set(null, "", "axis_if_slave", s_if);
        uvm_config_db#(virtual axis_if)::set(null, "", "axis_if_master", m_if);
        run_test("axis_fifo_test");
    end

endmodule

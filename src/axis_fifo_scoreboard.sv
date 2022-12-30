`include "uvm_macros.svh"
import uvm_pkg::*;

class axis_fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(axis_fifo_scoreboard)

    function new(string name = "axis_fifo_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    axis_item s_item;
    axis_item m_item;
    uvm_tlm_analysis_fifo #(axis_item) s_tlm_fifo;
    uvm_tlm_analysis_fifo #(axis_item) m_tlm_fifo;
    uvm_analysis_port #(axis_item) s_analysis_port;
    uvm_analysis_port #(axis_item) m_analysis_port;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        s_tlm_fifo = new("s_tlm_fifo", this);
        m_tlm_fifo = new("m_tlm_fifo", this);
        s_analysis_port = new("s_analysis_port", this);
        m_analysis_port = new("m_analysis_port", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        s_analysis_port.connect(s_tlm_fifo.analysis_export);
        m_analysis_port.connect(m_tlm_fifo.analysis_export);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            forever begin
                score_item();
            end
        join
    endtask

    virtual task automatic score_item();
        s_tlm_fifo.get(s_item);
        m_tlm_fifo.get(m_item);
        if (
            s_item.data == m_item.data &&
            s_item.keep == m_item.keep &&
            s_item.valid == m_item.valid &&
            s_item.ready == m_item.ready &&
            s_item.last == m_item.last &&
            s_item.id == m_item.id &&
            s_item.dest == m_item.dest &&
            s_item.user == m_item.user
        ) begin
            `uvm_info("SCBD", $sformatf("PASS ! item = %s", s_item.convert2str()), UVM_HIGH)
        end else begin
            `uvm_error("SCBD", $sformatf("ERROR ! s_item = %s, m_item = %s", s_item.convert2str(), m_item.convert2str()))
        end
    endtask
endclass

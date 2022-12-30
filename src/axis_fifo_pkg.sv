package axis_fifo_pkg;
    // Entity Parameters
    parameter integer DEPTH = 512;
    parameter integer KEEP_ENABLE = 1;
    parameter integer LAST_ENABLE = 1;
    parameter integer ID_ENABLE = 1;
    parameter integer DEST_ENABLE = 1;
    parameter integer USER_ENABLE = 1;
    parameter integer PIPE_LEVEL = 4;
    // Testbench Parameters
    parameter integer ITEM_NUM = 123456;
    parameter time TIMEOUT = 10ms;
endpackage

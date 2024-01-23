/*
 * File: ram.sv
 * Created Date: 2023-02-25 12:54:02 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2024-01-23 11:59:40 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2024 ENSEIRB-MATMECA
 * -----
 * Description: 
 */


module RamSv
  #(  parameter INITFILE = "",
      parameter NDATA = 64,
      parameter NDATABYTE = 4,
      
      localparam NADDRBIT = $clog2(NDATA))

  (   input logic                     clock,
      input logic                     reset,

      // PORT 1
      input logic                     i_p1_en,
      input logic [NDATABYTE-1:0]     i_p1_wen,
      input logic [NADDRBIT-1:0]      i_p1_addr,
      input logic [NDATABYTE*8-1:0]   i_p1_wdata,
      output logic [NDATABYTE*8-1:0]  o_p1_rdata,

      // PORT 2
      input logic                     i_p2_en,
      input logic [NDATABYTE-1:0]     i_p2_wen,
      input logic [NADDRBIT-1:0]      i_p2_addr,
      input logic [NDATABYTE*8-1:0]   i_p2_wdata,
      output logic [NDATABYTE*8-1:0]  o_p2_rdata);  

  logic [NDATABYTE * 8 - 1: 0] r_mem [NDATA - 1:0];

  // ******************************
  //           FILE INIT
  // ******************************  
  `ifdef verilator
    export "DPI-C" task ext_readmemh_byte;
    export "DPI-C" task ext_readmemh_data;

    logic [7:0] init_byte [NDATA - 1:0] [NDATABYTE - 1:0];

    task ext_readmemh_byte;
      input string TASK_INITFILE;
      $readmemh(TASK_INITFILE, init_byte);

      for (int d = 0; d < NDATA; d++) begin
        for (int db = 0; db < NDATABYTE; db++) begin
          r_mem[d][db*8 +: 8] = init_byte[d][db];
        end
      end
    endtask

    task ext_readmemh_data;
      input string TASK_INITFILE;
      $readmemh(TASK_INITFILE, r_mem);
    endtask
  `else
    initial begin
      if (INITFILE != "") begin
        $readmemh(INITFILE, r_mem);
      end
    end
  `endif  

  // ******************************
  //            WRITE
  // ******************************
  // Separated processes for Vivado synthesis
  always_ff @(posedge clock) begin
    if (~reset) begin
      for (int db = 0; db < NDATABYTE; db++) begin
        if (i_p1_en && i_p1_wen[db]) begin
          r_mem[i_p1_addr][db*8 +: 8] = i_p1_wdata[db*8 +: 8];
        end
      end
    end    
  end

  always_ff @(posedge clock) begin
    if (~reset) begin
      for (int db = 0; db < NDATABYTE; db++) begin
        if (i_p2_en && i_p2_wen[db]) begin
          r_mem[i_p2_addr][db*8 +: 8] = i_p2_wdata[db*8 +: 8];
        end
      end
    end    
  end

  // ******************************
  //             READ
  // ******************************
  always_ff @(posedge clock) begin
    if (reset) begin
      o_p1_rdata = 'h0;
      o_p2_rdata = 'h0;
    end
    else begin
      if (i_p1_en) begin
        o_p1_rdata = r_mem[i_p1_addr];
      end

      if (i_p2_en) begin
        o_p2_rdata = r_mem[i_p2_addr];
      end    
    end
  end
endmodule

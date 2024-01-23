/*
 * File: top.cpp
 * Created Date: 2023-02-26 09:45:59 am                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 02:22:18 pm
 * Modified By: Mathieu Escouteloup
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA
 * -----                                                                       *
 * Description:                                                                *
 */


#include <stdlib.h>
#include <stdio.h>
#include "VTop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "svdpi.h"
#include "VTop__Dpi.h"
#include <time.h>

#include <iostream>
#include <iomanip>
#include <fstream>
using namespace std;


int main(int argc, char **argv) {
  // ******************************
  //           ARGUMENTS
  // ******************************
  char* imemfile;   // .hex format
  char* dmemfile;   // .hex format
  char* vcdfile;    // .vcd format

  int ntrigger = 0;

  bool use_vcd = false;
  bool use_trigger = false;

  for (int a = 1; a < argc; a++) {
    string cmd = argv[a];
    char* val = argv[a + 1];

    if (cmd == "--imem") {
      imemfile = val;
      a++;
    }
    if (cmd == "--dmem") {
      dmemfile = val;
      a++;
    }
    if (cmd == "--ntrigger") {
      use_trigger = true;
      ntrigger = atoi(val);
      if (ntrigger == 0) {
        use_trigger = false;
      }
      a++;
    }
    if (cmd == "--vcd") {
      use_vcd = true;
      vcdfile = val;
      a++;
    }
  }

  // ******************************
  //    SIMULATION CONFIGURATION
  // ******************************
  time_t test_time = time(NULL);

	// Initialize Verilators variables
	Verilated::commandArgs(argc, argv);

  // Create an instance of our module under test
	VTop *dut = new VTop;

  // Generate VCD
  Verilated::traceEverOn(true);
  VerilatedVcdC* dut_trace = new VerilatedVcdC;
  dut->trace(dut_trace, 99);
  if (use_vcd) {
    dut_trace->open(vcdfile);
  }

	// Test variables
  int clock = 0;      // Clock cycle since start
  bool end = false;   // Test end
  int cycle = 0;      // Cycles
  
  // ******************************
  //           INITIATION
  // ******************************
  // ------------------------------
  //            MEMORY
  // ------------------------------
  // IMem
  // Call task to initialize memory
  svSetScope(svGetScopeFromName("TOP.Top.m_imem.m_ram.m_ram"));
  // Verilated::scopesDump();
  dut->ext_readmemh_byte(imemfile);

  // DMem
  // Call task to initialize memory
  svSetScope(svGetScopeFromName("TOP.Top.m_dmem.m_ram.m_ram"));
  // Verilated::scopesDump();
  dut->ext_readmemh_byte(dmemfile);

  // ******************************
  //             RESET
  // ******************************
  for (int i = 0; i < 5; i++) {
		dut->clock = 0;
    dut->reset = 1;
		dut->eval();
    if (use_vcd) {
      dut_trace->dump(clock * 10);
    }  

    dut->clock = 1;
  	dut->eval();
    if (use_vcd) {
      dut_trace->dump(clock * 10 + 5);
    }
    clock = clock + 1;
  }
  dut->reset = 0;

  // ******************************
  //           TEST LOOP
  // ******************************
	while ((!Verilated::gotFinish()) && (end == false)) {
    test_time = time(NULL);
    // ------------------------------
    //          FALLING EDGE
    // ------------------------------
		dut->clock = 0;
		dut->eval();
    if (use_vcd) {
      dut_trace->dump(clock * 10);
    }      

    // ------------------------------
    //          RISING EDGE
    // ------------------------------
		dut->clock = 1;
		dut->eval();
    if (use_vcd) {
      dut_trace->dump(clock * 10 + 5);
    }   

    // ------------------------------
    //             END
    // ------------------------------
    // SW Trigger
    if (dut->io_o_sim_gpr_31 & 1) {
      end = true;
    }

    // Test trigger
    if ((clock > ntrigger) && (ntrigger > 0)) {
      end = true;
    }

    clock = clock + 1;
	}

  // ******************************
  //             REPORT
  // ******************************
  //cout << "\033[1;37m";
  cout << "IMem file: " << imemfile << endl;
  cout << "DMem file: " << dmemfile << endl;
  cout << "Simulation clock cycles: " << clock << endl;  
  //cout << "\033[0m"; 
  cout << endl;

  // ******************************
  //             CLOSE
  // ******************************
  dut_trace->close();
  exit(EXIT_SUCCESS);
}

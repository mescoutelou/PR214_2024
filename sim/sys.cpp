/*
 * File: sys.cpp
 * Created Date: 2023-02-26 09:45:59 am                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-10 01:23:50 pm
 * Modified By: Mathieu Escouteloup
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA
 * -----                                                                       *
 * Description:                                                                *
 */


#include <stdlib.h>
#include <stdio.h>
#include "VSys.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "svdpi.h"
#include "VSys__Dpi.h"
#include <time.h>

#include <iostream>
#include <iomanip>
#include <fstream>
using namespace std;


int main(int argc, char **argv) {
  // ******************************
  //           ARGUMENTS
  // ******************************
  char* romfile;   // .hex format
  char* ramfile;   // .hex format
  char* vcdfile;    // .vcd format

  int ntrigger = 0;

  bool load_ram = false;
  bool use_vcd = false;
  bool use_trigger = false;

  for (int a = 1; a < argc; a++) {
    string cmd = argv[a];
    char* val = argv[a + 1];

    if (cmd == "--rom") {
      romfile = val;
      a++;
    }
    if (cmd == "--ram") {
      load_ram = true;
      ramfile = val;
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
	VSys *dut = new VSys;

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
  // ROM
  // Call task to initialize memory
  svSetScope(svGetScopeFromName("TOP.Sys.m_rom.m_ram.m_ram"));
  // Verilated::scopesDump();
  dut->ext_readmemh_byte(romfile);

  // RAM
  if (load_ram) {
    // Call task to initialize memory
    svSetScope(svGetScopeFromName("TOP.Sys.m_ram.m_ram.m_ram"));
    // Verilated::scopesDump();
    dut->ext_readmemh_byte(ramfile);
  }

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
    if ((dut->io_o_sim_gpr_31 >> 31) & 1) {
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
  cout << endl;
  if ((dut->io_o_sim_gpr_31 >> 31) & 1) {
    if (dut->io_o_sim_gpr_30 == 0) {
      cout << "\033[1;32m";
      cout << "TEST REPORT: SUCCESS.";
      cout << "\033[0m" << endl;
    } else {
      cout << "\033[1;31m";
      cout << "TEST REPORT: FAILED.";
      cout << "\033[0m" << endl;
    }
  }
  //cout << "\033[1;37m";
  cout << "ROM file: " << romfile << endl;
  if (load_ram) {
    cout << "RAM file: " << ramfile << endl;
  }
  if (use_vcd) {
    cout << "VCD file: " << vcdfile << endl;
  }
  cout << "Simulation clock cycles: " << clock << endl;  
  //cout << "\033[0m"; 
  cout << endl;

  // ******************************
  //             CLOSE
  // ******************************
  dut_trace->close();
  exit(EXIT_SUCCESS);
}

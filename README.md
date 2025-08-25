# Vending Machine (Verilog HDL)
#  Overview

This project is a Vending Machine design implemented in Verilog HDL.
It uses a Finite State Machine (FSM) approach to handle product selection, payment (coin/online), cancellation, and product dispensing with change return.
The design was simulated and tested using Vivado.

#  Features
- Supports multiple products: Sprite, Pepsi, CocaCola, Slice, Mountain Dew
- Accepts coins as input or online payment
- Handles cancel operation (returns inserted amount)
- Calculates and returns balance change
- FSM-based design for clear state transitions
- Tested using a Verilog Testbench

#  Technology Used
- Language: Verilog HDL
- Simulation Tool: Vivado
- Design Approach: FSM (Finite State Machine)

#  Project Files
- VM_design.v → Main Vending Machine Verilog code
- VMtb.v → Testbench for simulation

#  How It Works
- User presses start to begin.
- Selects a product (Sprite, Pepsi, etc.).
- Inserts coin value or chooses online payment.
- If sufficient balance is given → machine dispenses product and returns change.
- If cancelled → machine returns inserted coins.

#  Example Simulation (Testbench)
- Inserted coins = 60
- Selected product = Pepsi (cost 35)
- Machine dispenses Pepsi and returns 25 as change

#  Future Improvements
- Add more products with dynamic pricing
- Display interface using 7-segment/LED simulation
- Integration with FPGA board for real hardware demo

#  Author
Developed by Shubham Kumar Sah

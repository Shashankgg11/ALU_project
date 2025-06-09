# ALU_project
This project implements an Arithmetic Logic Unit (ALU) using Verilog, capable of performing a wide range of arithmetic and logical operations such as addition, subtraction, bitwise logic (AND, OR, XOR, etc.), shifting, rotating, and comparison. The design is modular, parameterized, and includes additional functionality such as overflow detection, carry-out, and flag generation (Greater, Equal, Less).

The ALU supports two input operands (OPA, OPB), a 4-bit command input (CMD), and a mode select (MODE) to choose between arithmetic and logic operations. An INP_VALID signal controls operand validity (00: invalid, 01: A valid, 10: B valid, 11: both valid). For multiplication operations, internal registers introduce 1-cycle and 2-cycle delays to simulate realistic timing.

The design was simulated and verified using testbenches. The architecture includes input/output registers, control decoding, arithmetic and logic blocks, and a delayed multiplication unit. This RTL code is fully synthesizable and well-suited for extension with pipelining, wider data widths, and more complex instruction sets in future versions.

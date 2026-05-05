# \# AHB to APB Bridge (Verilog HDL on FPGA - Basys 3)

# 

# \## 📌 Project Overview

# This project implements an \*\*AHB to APB bridge using Verilog HDL\*\* and is successfully tested on the \*\*Basys 3 FPGA board\*\*.

# 

# The bridge connects a \*\*high-speed AHB bus\*\* to \*\*low-speed APB peripherals\*\* by converting protocols using a \*\*Finite State Machine (FSM)\*\*.

# 

# \---

# 

# \## ⚙️ System Working (Simple Explanation)

# 

# 1\. After reset, the \*\*AHB master\*\* generates a sequence of operations automatically.

# 

# 2\. It first performs \*\*WRITE operations\*\* to peripherals:

# &#x20;  - LED  

# &#x20;  - Timer  

# &#x20;  - UART  

# 

# 3\. The \*\*AHB slave interface\*\*:

# &#x20;  - Receives `Haddr`, `Hwrite`, `Htrans`, `Hwdata`

# &#x20;  - Stores valid transaction signals  

# &#x20;  - Decodes address and selects peripheral using `Pselx`  

# &#x20;    - `001` → LED  

# &#x20;    - `010` → Timer  

# &#x20;    - `100` → UART  

# 

# 4\. The \*\*APB controller (FSM)\*\* converts AHB signals into APB protocol signals.

# 

# \---

# 

# \## 🔄 Write Operation (AHB → APB)

# 

# \- `Pselx` selects the peripheral  

# \- `Pwrite = 1`  

# \- `Penable = 1` during access phase  

# \- `Paddr` carries address  

# \- `Pwdata` carries data  

# 

# \*\*FSM States:\*\*

# 

# WWAIT → WRITE → WENABLE

# 

# 

# \---

# 

# \## 🔄 Read Operation (APB → AHB)

# 

# \- Read performed from \*\*Timer peripheral\*\*  

# \- Address: `0x8400\_0000`  

# \- `Pwrite = 0`  

# \- Data returned through `Prdata`  

# 

# \*\*FSM States:\*\*

# 

# READ → RENABLE

# 

# 

# \---

# 

# \## 🔌 Peripherals

# 

# \### 💡 LED + Pattern Generator

# \- Stores LED input data  

# \- Timer generates tick signal  

# \- LEDs blink based on input pattern  

# 

# \*\*Example:\*\*

# 

# Input = 1011

# → LEDs 3, 1, 0 blink

# → LED 2 OFF

# 

# 

# \---

# 

# \### ⏱️ Timer

# \- Stores delay value  

# \- Generates periodic tick pulses  

# 

# \---

# 

# \### 📡 UART

# \- Receives data through APB writes  

# \- Transmits serial data (`tx`)  

# \- Output observed on PC using \*\*PuTTY\*\*  

# 

# \---

# 

# \### 🔢 Seven Segment Display

# Displays:

# \- 1st digit → Read / Write  

# \- 2nd digit → Peripheral number  

# \- Last digits → Data value  

# 

# \---

# 

# \## 🔍 Hardware Debugging (ILA)

# 

# Used to monitor:

# \- FSM states  

# \- `Pselx`, `Pwrite`, `Penable`  

# \- Address and data signals  

# 

# \---

# 

# \## 📊 Results

# \- Successful protocol conversion  

# \- Verified read and write operations  

# \- FPGA implementation working correctly  

# \- UART output observed on PC  

# \- LEDs and display functioning as expected  

# 

# \---

# 

# \## 🚀 Key Features

# \- FSM-based design  

# \- Multiple APB peripherals  

# \- Synthesizable Verilog RTL  

# \- FPGA hardware validation  

# \- ILA-based debugging  

# 

# \---

# 

# \## 🛠️ Tools Used

# \- Verilog HDL  

# \- Xilinx Vivado  

# \- Basys 3 FPGA  

# \- PuTTY  

# 

# \---

# 

# \## 📂 Project Structure

# 

# ahb-to-apb-bridge/

# ├── src/ # RTL design files

# ├── sim/ # Testbench

# ├── diagrams/ # Block \& state diagrams

# ├── results/ # Waveforms \& hardware outputs

# ├── bridge.xdc # Constraints

# └── README.md

# 

# 

# \---

# 

# \## 👤 Author

# \*\*P. Devraj\*\*  

# B.Tech ECE, GIET University 


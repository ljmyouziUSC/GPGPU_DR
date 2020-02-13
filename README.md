# GPGPU_DR
RAU(Register allocation unit) -- contains FSM, LUT and MT;  
Parallel IU Decoding Unit -- Decode instr from IU, get the mapping, find available OC_ID  
Register file -- contains 4 BRAMS with 8 loctions, and 32 bit in each location  
RF control units -- contains 4 Request FIFO, constrained by CDB_Write  
OC -- contains 4 collection units  
  
special regs not implememted  
all the sensitive lists  
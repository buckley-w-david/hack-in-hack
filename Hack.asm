// Program interprets and executes Hack machine code instructions starting at MEM[16]

(INIT)
    @instruction_base
    // R0 = D
    @R0
    M=0
    // R1 = A
    @R1
    M=0
    // R2 = PC
    @R2
    M=0
    // R3 = Instruction bitmask
    @16384
    D=A
    D=D+A
    @R3
    M=D
    // R4 = Current instruction 
    // Set in (BEGIN) 

(BEGIN)
    // Point A at current instruction
    // Load PC into D
    @R2
    D=M
    // Add PC to instruction_base
    @instruction_base
    A=A+D

    // R4 = next instruction
    D=M
    @R4
    M=D
    
    // D = instruction bitmask
    @R3
    D=M

    @R4
    D=D&M

    @A_INSTRUCTION
    D;JEQ

(C_INSTRUCTION)
(EXTRACT_A)
    // Extract a bit to get A/M operand 
    @4096
    D=A
    @R4
    D=D&M
    @A_PARAM
    D;JEQ
    // Store A/M operand at R6 (Remember to translate memory spaces with M=MEM[A+instruction_base])
(M_PARAM)
    //R6 = MEM[A+16]
    @R1
    D=M
    @16
    A=D+A
    D=M
    @R6
    M=D
    @EXTRACT_C
    0;JMP
(A_PARAM)
    //R6 = A(R1)
    @R1
    D=M
    @R6
    M=D
(EXTRACT_C)
    // Extract c1-5 bits for computation (stored at R=5)
    @4032
    D=A
    @R4
    D=D&M
    @R5
    M=D
// Decode instruction from c bits (c1c2c3c4c5c6 << 6 - masked_bits == 0)
    // 0   = 2688
    @R5
    D=M
    @2688
    D=D-A
    @COMPUTE_ZERO
    D;JEQ
    // 1   = 4032
    @R5
    D=M
    @4032
    D=D-A
    @COMPUTE_ONE
    D;JEQ
    // -1  = 3712
    @R5
    D=M
    @3712
    D=D-A
    @COMPUTE_NEGATIVE_ONE
    D;JEQ
    // D   = 768
    @R5
    D=M
    @768
    D=D-A
    @COMPUTE_D
    D;JEQ
    // A   = 3072
    @R5
    D=M
    @3072
    D=D-A
    @COMPUTE_A
    D;JEQ
    // !D  = 832
    @R5
    D=M
    @832
    D=D-A
    @COMPUTE_NOT_D
    D;JEQ
    // !A  = 3136
    @R5
    D=M
    @3136
    D=D-A
    @COMPUTE_NOT_A
    D;JEQ
    // -D  = 960
    @R5
    D=M
    @960
    D=D-A
    @COMPUTE_NEGATIVE_D
    D;JEQ
    // -A  = 3264
    @R5
    D=M
    @3264
    D=D-A
    @COMPUTE_NEGATIVE_A
    D;JEQ
    // D+1 = 1984
    @R5
    D=M
    @1984
    D=D-A
    @COMPUTE_D_P1
    D;JEQ
    // A+1 = 3520
    @R5
    D=M
    @3520
    D=D-A
    @COMPUTE_A_P1
    D;JEQ
    // D-1 = 896
    @R5
    D=M
    @896
    D=D-A
    @COMPUTE_D_M1
    D;JEQ
    // A-1 = 3200
    @R5
    D=M
    @3200
    D=D-A
    @COMPUTE_A_M1
    D;JEQ
    // D+A = 128
    @R5
    D=M
    @128
    D=D-A
    @COMPUTE_D_P_A
    D;JEQ
    // D-A = 1216
    @R5
    D=M
    @1216
    D=D-A
    @COMPUTE_D_M_A
    D;JEQ
    // A-D = 448
    @R5
    D=M
    @448
    D=D-A
    @COMPUTE_A_M_D
    D;JEQ
    // D&A = 0
    @R5
    D=M
    @COMPUTE_D_A_A
    D;JEQ
    // D|A = 1344
    @R5
    D=M
    @1344
    D=D-A
    @COMPUTE_D_O_A
    D;JEQ
    
// Compute Implementations
// Perform computation - Stored result at R7
(COMPUTE_ZERO)
    @0
    D=A
    @R7
    M=D
    @AFTER_COMPUTE
    0;JMP
(COMPUTE_ONE)
    @1
    D=A
    @R7
    M=D
    @AFTER_COMPUTE
    0;JMP
(COMPUTE_NEGATIVE_ONE)
    @0
    D=A-1
    @R7
    M=D
    @AFTER_COMPUTE
    0;JMP
(COMPUTE_D)
    @R0
    D=M
    @R7
    M=D
    @AFTER_COMPUTE
    0;JMP
(COMPUTE_A)
// A/M is stored at R6
    @R6
    D=M
    @R7
    M=D
    @AFTER_COMPUTE
    0;JMP
(COMPUTE_NOT_D)
    @R0
    D=!M
    @R7
    M=D
    @AFTER_COMPUTE
    0;JMP
(COMPUTE_NOT_A)
    @R6
    D=!M
    @R7
    M=D
    @AFTER_COMPUTE
    0;JMP
(COMPUTE_NEGATIVE_D)
    @R0
    D=-M
    @R7
    M=D
    @AFTER_COMPUTE
    0;JMP
(COMPUTE_NEGATIVE_A)
    @R6
    D=-M
    @R7
    M=D
    @AFTER_COMPUTE
    0;JMP
(COMPUTE_D_P1)
    @R0
    D=M+1
    @R7
    M=D
    @AFTER_COMPUTE
    0;JMP
(COMPUTE_A_P1)
    @R6
    D=M+1
    @R7
    M=D
    @AFTER_COMPUTE
    0;JMP
(COMPUTE_D_M1)
    @R0
    D=M-1
    @R7
    M=D
    @AFTER_COMPUTE
    0;JMP
(COMPUTE_A_M1)
    @R6
    D=M-1
    @R7
    M=D
    @AFTER_COMPUTE
    0;JMP
(COMPUTE_D_P_A)
    @R0
    D=M
    @R6
    D=D+M
    @R7
    M=D
    @AFTER_COMPUTE
    0;JMP
(COMPUTE_D_M_A)
    @R0
    D=M
    @R6
    D=D-M
    @R7
    M=D
    @AFTER_COMPUTE
    0;JMP
(COMPUTE_A_M_D)
    @R6
    D=M
    @R0
    D=D-M
    @R7
    M=D
    @AFTER_COMPUTE
    0;JMP
(COMPUTE_D_A_A)
    @R0
    D=M
    @R6
    D=D&M
    @R7
    M=D
    @AFTER_COMPUTE
    0;JMP
(COMPUTE_D_O_A)
    @R0
    D=M
    @R6
    D=D|M
    @R7
    M=D
    // @AFTER_COMPUTE
    // 0;JMP

(AFTER_COMPUTE)
    @R1
    D=M
    @16
    A=D+A
    D=A
    @R6
    M=D
// R5 will now store destination
// R6 is now a pointer to MEM[A+16]
(EXTRACT_D)
    // Extract d1-3 bits for destination
    @56
    D=A
    @R4
    D=D&M
    @R5
    M=D
// Store result (R7) in destinations
// I can probably do something more clever than this
// But it's only 8 conditions...
// TODO: I can decode into R8,9,10 Store A,M,D and clean this up
    // null = 0
    @R5
    D=M
    @EXTRACT_J
    D;JEQ
    // M   = 0b001 << 3 = 8
    @R5
    D=M
    @8
    D=D-A
    @STORE_M
    D;JEQ
    // D   = 0b010 << 3 = 16
    @R5
    D=M
    @16
    D=D-A
    @STORE_D
    D;JEQ
    // MD  = 0b011 << 3 = 24
    @R5
    D=M
    @24
    D=D-A
    @STORE_MD
    D;JEQ
    // A   = 0b100 << 3 = 32
    @R5
    D=M
    @32
    D=D-A
    @STORE_A
    D;JEQ
    // AM  = 0b101 << 40
    @R5
    D=M
    @40
    D=D-A
    @STORE_AM
    D;JEQ
    // AD  = 0b110 << 3 << 48
    @R5
    D=M
    @48
    D=D-A
    @STORE_AD
    D;JEQ
    // AMD = 0b111 << 3 = 56
    // Since we checked literally every condition, we can just go right to STORE_ADM
(STORE_ADM)
    // Load result
    @R7
    D=M

    // Store A
    @R1
    M=D

    // Store M
    @R6
    A=M
    M=D

    // Store D
    @R0
    M=D

    @EXTRACT_J
    0;JMP
(STORE_M)
    // Load result
    @R7
    D=M

    // Store M
    @R6
    A=M
    M=D

    @EXTRACT_J
    0;JMP
(STORE_D)
    // Load result
    @R7
    D=M

    // Store D
    @R0
    M=D

    @EXTRACT_J
    0;JMP
(STORE_MD)
    // Load result
    @R7
    D=M

    // Store M
    @R6
    A=M
    M=D

    // Store D
    @R0
    M=D

    @EXTRACT_J
    0;JMP
(STORE_A)
    // Load result
    @R7
    D=M

    // Store A
    @R1
    M=D

    @EXTRACT_J
    0;JMP
(STORE_AM)
    // Load result
    @R7
    D=M

    // Store A
    @R1
    M=D

    // Store M
    @R6
    A=M
    M=D

    @EXTRACT_J
    0;JMP
(STORE_AD)
    // Load result
    @R7
    D=M

    // Store A
    @R1
    M=D

    // Store D
    @R0
    M=D

    // @EXTRACT_J
    // 0;JMP

(EXTRACT_J)
    // R5, R6 are now all free
    // Use R5 for storing jump bits
    // Calculate jump and store in PC (Remember to translate memory spaces with +instruction_base)
    // Extract j1-3 bits for jump
    @7
    D=A
    @R4
    D=D&M
    @R5
    M=D

    // null = 0
    @PCPP
    D;JEQ
    // JGT = 0b001
    D=D-1
    @JUMP_JGT
    D;JEQ
    // JEQ = 0b010
    @R5
    D=M
    @2
    D=D-A
    @JUMP_JEQ
    D;JEQ
    // JGE = 0b011
    @R5
    D=M
    @3
    D=D-A
    @JUMP_JGE
    D;JEQ
    // JLT = 0b100
    @R5
    D=M
    @4
    D=D-A
    @JUMP_JLT
    D;JEQ
    // JNE = 0b101
    @R5
    D=M
    @5
    D=D-A
    @JUMP_JNE
    D;JEQ
    // JLE = 0b110
    @R5
    D=M
    @6
    D=D-A
    @JUMP_JLE
    D;JEQ
    // JMP = 0b111
    // Exhausted all possibilities, just jump
    @JUMP_JMP
    0;JMP

(PCPP)
    @R2
    M=M+1
    @BEGIN
    0;JMP
(PC_A)
    @R1
    D=M
    @16
    D=D+A
    @R2
    M=D
    @BEGIN
    0;JMP
(JUMP_JGT)
    @R7
    D=M
    @PC_A
    D;JGT
    @PCPP
    0;JMP
(JUMP_JEQ)
    @R7
    D=M
    @PC_A
    D;JEQ
    @PCPP
    0;JMP
(JUMP_JGE)
    @R7
    D=M
    @PC_A
    D;JGE
    @PCPP
    0;JMP
(JUMP_JLT)
    @R7
    D=M
    @PC_A
    D;JLT
    @PCPP
    0;JMP
(JUMP_JNE)
    @R7
    D=M
    @PC_A
    D;JNE
    @PCPP
    0;JMP
(JUMP_JLE)
    @R7
    D=M
    @PC_A
    D;JLE
    @PCPP
    0;JMP
(JUMP_JMP)
    @PC_A
    0;JMP

(A_INSTRUCTION)
    // R1(A) = R4
    @R4
    D=M
    @R1
    M=D

    // PC++
    @R2
    M=M+1

    // Back to beginning
    @BEGIN
    0;JMP



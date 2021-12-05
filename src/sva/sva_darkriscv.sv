// Instruction types

// r-type 

typedef struct packed{
	bit [31:25] funct7;
	bit [24:20] rs2;
	bit [19:15] rs1;
	bit [14:12] funct3;
	bit [11:7] rd;
	bit [6:0] opcode;
	} rtype;

// i-type

typedef struct packed{
	bit [31:20] imm;
	bit [19:15] rs1;
	bit [14:12] funct3;
	bit [11:7] rd;
	bit [6:0] opcode;
	} itype;

// s-type

typedef struct packed{
	bit [31:25] imm1;
	bit [24:20] rs2;
	bit [19:15] rs1;
	bit [14:12] funct3;
	bit [11:7] imm2;
	bit [6:0] opcode;
	} stype;
	
// b-type 

typedef struct packed{
	bit [31:31] imm1;
	bit [30:25] imm2;
	bit [24:20] rs2;
	bit [19:15] rs1;
	bit [14:12] funct3;
	bit [11:8] rd;
	bit [7:7] imm3;
	bit [6:0] opcode;
	} btype;

// u-type

typedef struct packed{
	bit [31:12] imm;
	bit [11:7] rd;
	bit [6:0] opcode;
	} utype;
	
// j-type

typedef struct packed{
	bit [31:31] imm1;
	bit [30:21] imm2;
	bit [20:20] imm3;
	bit [19:12] imm4;
	bit [11:7] rd;
	bit [6:0] opcode;
	} jtype;
	
`define NUM_OPS 37

// Helper functions

function bit [6:0] opcode (bit [31:0] idata);
	opcode = idata[6:0];
endfunction

// implemented opcodes:

`define LUI     7'b01101_11      // lui   rd,imm[31:12]
`define AUIPC   7'b00101_11      // auipc rd,imm[31:12]
`define JAL     7'b11011_11      // jal   rd,imm[xxxxx]
`define JALR    7'b11001_11      // jalr  rd,rs1,imm[11:0] 
`define BCC     7'b11000_11      // bcc   rs1,rs2,imm[12:1]
`define LCC     7'b00000_11      // lxx   rd,rs1,imm[11:0]
`define SCC     7'b01000_11      // sxx   rs1,rs2,imm[11:0]
`define MCC     7'b00100_11      // xxxi  rd,rs1,imm[11:0]
`define RCC     7'b01100_11      // xxx   rd,rs1,rs2 
`define MAC     7'b11111_11      // mac   rd,rs1,rs2

// not implemented opcodes:

`define FCC     7'b00011_11      // fencex
`define CCC     7'b11100_11      // exx, csrxx

module darkriscv_checker_sva(
    input             CLK,   // clock
    input             RES,   // reset
    input             HLT,   // halt

    input      [31:0] IDATA, // instruction data bus
    
    input      [31:0] DATAI, // data bus (input)
	
	// Immediate variables
	input [19:0] uimm,
	input [11:0] iimm,
	input [6:0] simm1,
	input [5:0] bimm2,
	input [4:0] simm2,
	input bimm1, bimm3,

	// Register variables
	input [4:0] rs1, rs2, rd
	
	);
	


// Instruction types
typedef enum bit [2:0] {ITYPE, STYPE, UTYPE, RTYPE, JTYPE, BTYPE, INSTR_ERR} INSTR_TYPE;
INSTR_TYPE instr_type;
bit [31:0] instr;

// Operations
typedef enum bit [5:0] {ADDI_OP, SLTI_OP, SLTIU_OP, ANDI_OP, ORI_OP, XORI_OP, JALR_OP, LW_OP, LH_OP, LHU_OP, LB_OP, LBU_OP, SLLI_OP, SRLI_OP, SRAI_OP, SW_OP, SH_OP, SB_OP, LUI_OP, AUIPC_OP, ADD_OP, SUB_OP, SLT_OP, SLTU_OP, AND_OP, OR_OP, XOR_OP, SLL_OP, SRL_OP, SRA_OP, JAL_OP, BEQ_OP, BNE_OP, BLT_OP, BLTU_OP, BGE_OP, BGEU_OP, OP_ERR} OP_TYPE;
OP_TYPE op_type;

itype IOP, ADDI, SLTI, SLTIU, ANDI, ORI, XORI, JALR, LW, LH, LHU, LB, LBU, SLLI, SRLI, SRAI;
stype SOP, SW, SH, SB;
utype UOP, LUI, AUIPC;
rtype ROP, ADD, SUB, SLT, SLTU, AND, OR, XOR, SLL, SRL, SRA;
jtype JOP, JAL;
btype BOP, BEQ, BNE, BLT, BLTU, BGE, BGEU;

// Operation Array

wire [31:0] OPS [`NUM_OPS];
assign OPS = RES ? '{`NUM_OPS{'x}} : {ADDI, SLTI, SLTIU, ANDI, ORI, XORI, JALR, LW, LH, LHU, LB, LBU, SLLI, SRLI, SRAI, SW, SH, SB, LUI, AUIPC, ADD, SUB, SLT, SLTU, AND, OR, XOR, SLL, SRL, SRA, JAL, BEQ, BNE, BLT, BLTU, BGE, BGEU};

// Encoding operations block.

always_comb begin
	
	// i-type
	
	ADDI.funct3 = 0; ADDI.opcode 	= `MCC; ADDI.imm = iimm; 	ADDI.rs1 = rs1; 	ADDI.rd = rd;
	SLTI.funct3 = 2; SLTI.opcode 	= `MCC; SLTI.imm = iimm; 	SLTI.rs1 = rs1; 	SLTI.rd = rd;
	SLTIU.funct3 = 3; SLTIU.opcode 	= `MCC; SLTIU.imm = iimm; 	SLTIU.rs1 = rs1; 	SLTIU.rd = rd;
	XORI.funct3 = 4; XORI.opcode 	= `MCC; XORI.imm = iimm; 	XORI.rs1 = rs1; 	XORI.rd = rd;
	ANDI.funct3 = 7; ANDI.opcode 	= `MCC; ANDI.imm = iimm; 	ANDI.rs1 = rs1; 	ANDI.rd = rd;
	ORI.funct3 	= 6; ORI.opcode 	= `MCC; ORI.imm = iimm; 		ORI.rs1 = rs1; 		ORI.rd = rd;
	SLLI.funct3 = 1; SLLI.opcode 	= `MCC;	SLLI.imm = 0; 			SLLI.rs1 = rs1; 	SLLI.rd = rd;
	SRLI.funct3 = 5; SRLI.opcode 	= `MCC; SRLI.imm = 0; 			SRLI.rs1 = rs1; 	SRLI.rd = rd;
	SRAI.funct3 = 5; SRAI.opcode 	= `MCC; SRAI.imm = 32;			SRAI.rs1 = rs1; 	SRAI.rd = rd;
	
	LW.funct3 		= 2; LW.opcode 		= `LCC; LW.imm = iimm; 	LW.rs1 = rs1; 	LW.rd = rs1;
	LH.funct3 		= 1; LH.opcode 		= `LCC; LH.imm = iimm; 	LH.rs1 = rs1; 	LH.rd = rs1;
	LHU.funct3 		= 5; LHU.opcode 	= `LCC; LHU.imm = iimm; 	LHU.rs1 = rs1; 	LHU.rd = rs1;
	LB.funct3 		= 0; LB.opcode 		= `LCC; LB.imm = iimm; 	LB.rs1 = rs1; 	LB.rd = rs1;
	LBU.funct3 		= 4; LBU.opcode 	= `LCC; LBU.imm = iimm; 	LBU.rs1 = rs1; 	LBU.rd = rs1;
	
	JALR.funct3		= 0; JALR.opcode    = `JALR; JALR.imm = iimm; 	JALR.rs1 = rs1; 	JALR.rd = rs1;
	
	// s-type
	
	SW.funct3 		= 2; SW.opcode 		= `SCC; SW.imm1 = simm1; 	SW.rs1 = rs1;	SW.imm2 = simm2; 	SW.rs2 = rs2;
	SH.funct3 		= 1; SH.opcode 		= `SCC;	SH.imm1 = simm1; 	SH.rs1 = rs1;	SH.imm2 = simm2; 	SH.rs2 = rs2;
	SB.funct3 		= 0; SB.opcode 		= `SCC;	SB.imm1 = simm1; 	SB.rs1 = rs1;	SB.imm2 = simm2; 	SB.rs2 = rs2;
	
	// u-type
	
	LUI.opcode 		= `LUI;		LUI.imm = uimm; 	 	LUI.rd = UOP.rd;						
	AUIPC.opcode 	= `AUIPC;	AUIPC.imm = uimm; 	 	AUIPC.rd = UOP.rd;
	
	// r-type
	
	ADD.funct7		= 0; ADD.funct3		= 0;	ADD.opcode = `RCC; 	ADD.rs2 = rs2; 	ADD.rs1 = rs1; 	ADD.rd = rd;
	SUB.funct7		= 32; SUB.funct3	= 0;	SUB.opcode = `RCC; 	SUB.rs2 = rs2; 	SUB.rs1 = rs1; 	SUB.rd = rd;
	SLT.funct7		= 0; SLT.funct3		= 2;	SLT.opcode = `RCC; 	SLT.rs2 = rs2; 	SLT.rs1 = rs1; 	SLT.rd = rd;
	SLTU.funct7		= 0; SLTU.funct3	= 3;	SLTU.opcode = `RCC; SLTU.rs2 = rs2; 	SLTU.rs1 = rs1; 	SLTU.rd = rd;
	AND.funct7		= 0; AND.funct3		= 7;	AND.opcode = `RCC; 	AND.rs2 = rs2; 	AND.rs1 = rs1; 	AND.rd = rd;
	OR.funct7		= 0; OR.funct3		= 6;	OR.opcode = `RCC; 	OR.rs2 = rs2; 	OR.rs1 = rs1; 	OR.rd = rd;
	XOR.funct7		= 0; XOR.funct3		= 4;	XOR.opcode = `RCC; 	XOR.rs2 = rs2; 	XOR.rs1 = rs1; 	XOR.rd = rd;
	SLL.funct7		= 0; SLL.funct3		= 1;	SLL.opcode = `RCC; 	SLL.rs2 = rs2; 	SLL.rs1 = rs1; 	SLL.rd = rd;
	SRL.funct7		= 0; SRL.funct3		= 5;	SRL.opcode = `RCC; 	SRL.rs2 = rs2; 	SRL.rs1 = rs1; 	SRL.rd = rd;
	SRA.funct7		= 32; SRA.funct3	= 5;	SRA.opcode = `RCC; 	SRA.rs2 = rs2; 	SRA.rs1 = rs1; 	SRA.rd = rd;
	
	// j-type
	
	JAL.opcode 		= `JAL;	JAL.imm1 = JOP.imm1; 	JAL.imm2 = JOP.imm2;	JAL.imm3 = JOP.imm3;	JAL.imm4 = JOP.imm4; JAL.rd = rd;
	
	// b-type
	
	BEQ.funct3		= 0; BEQ.opcode		= `BCC; BEQ.imm1 = bimm1; BEQ.imm2 = bimm2; BEQ.rs2 = rs2; BEQ.rs1 = rs1; BEQ.rd = rd; BEQ.imm3 = bimm3;
	BNE.funct3		= 1; BNE.opcode		= `BCC; BNE.imm1 = bimm1; BNE.imm2 = bimm2; BNE.rs2 = rs2; BNE.rs1 = rs1; BNE.rd = rd; BNE.imm3 = bimm3;
	BLT.funct3		= 4; BLT.opcode		= `BCC; BLT.imm1 = bimm1; BLT.imm2 = bimm2; BLT.rs2 = rs2; BLT.rs1 = rs1; BLT.rd = rd; BLT.imm3 = bimm3;
	BLTU.funct3		= 6; BLTU.opcode	= `BCC; BLTU.imm1 = bimm1; BLTU.imm2 = bimm2; BLTU.rs2 = rs2; BLTU.rs1 = rs1; BLTU.rd = rd; BLTU.imm3 = bimm3;
	BGE.funct3		= 5; BGE.opcode		= `BCC; BGE.imm1 = bimm1; BGE.imm2 = bimm2; BGE.rs2 = rs2; BGE.rs1 = rs1; BGE.rd = rd; BGE.imm3 = bimm3;
	BGEU.funct3		= 7; BGEU.opcode	= `BCC; BGEU.imm1 = bimm1; BGEU.imm2 = bimm2; BGEU.rs2 = rs2; BGEU.rs1 = rs1; BGEU.rd = rd; BGEU.imm3 = bimm3;
	
end

// Decode block

always_comb begin 	

	// Feed instruction type fields
	
	IOP = IDATA;
	SOP = IDATA;
	UOP = IDATA;
	ROP = IDATA;
	JOP = IDATA;
	BOP = IDATA;
	
	// Given IDATA, what Instruction type?

	instr_type = IDATA[6:0] == (`MCC) 				? ITYPE :
				IDATA[6:0] == (`LCC) 				? ITYPE :
				IDATA[6:0] == (`JALR) 				? ITYPE :
				IDATA[6:0] == (`SCC)				? STYPE :
				IDATA[6:0] == (`LUI)				? UTYPE :
				IDATA[6:0] == (`AUIPC) 				? UTYPE :
				IDATA[6:0] == (`RCC)				? RTYPE :
				IDATA[6:0] == (`JAL)				? JTYPE :
				IDATA[6:0] == (`BCC)				? BTYPE : INSTR_ERR;
	
	// Given Instruction type, what operation?
	
	unique case (instr_type)
		ITYPE : begin
					if(IDATA[6:0] == `MCC) 
						op_type = 	(IOP.funct3 == 0) ? ADDI_OP :
									IOP.funct3 == 1 ? SLLI_OP :
									IOP.funct3 == 2 ? SLTI_OP :
									IOP.funct3 == 3 ? SLTIU_OP :
									IOP.funct3 == 4 ? XORI_OP :
									IOP.funct3 == 5 && IOP.imm == 0 ? SRLI_OP :
									IOP.funct3 == 5 && IOP.imm == 32 ? SRAI_OP :
									IOP.funct3 == 6 ? ORI_OP :
									IOP.funct3 == 7 ? ANDI_OP : OP_ERR;
					else if(IDATA[6:0] == `LCC)
						op_type =	IOP.funct3 == 0 ? LB_OP :
									IOP.funct3 == 1 ? LH_OP :
									IOP.funct3 == 2 ? LW_OP :
									IOP.funct3 == 4 ? LBU_OP :
									IOP.funct3 == 5 ? LHU_OP : OP_ERR;
					else if(IDATA[6:0] == `JALR)
						op_type =	IOP.funct3 == 0 ? JALR_OP : OP_ERR;
					else
						op_type = OP_ERR;
				end
				
		STYPE :	op_type = 	SOP.funct3 == 0 ? SB_OP :
							SOP.funct3 == 1	? SH_OP :
							SOP.funct3 == 2 ? SW_OP : OP_ERR;
							
		UTYPE : op_type =	UOP.opcode == `LUI ? LUI_OP :
							UOP.opcode == `AUIPC ? AUIPC_OP : OP_ERR;
							
		RTYPE :	op_type =	ROP.funct7 == 0 && ROP.funct3 == 0 	? ADD_OP :
							ROP.funct7 == 32 && ROP.funct3 == 0 ? SUB_OP :
							ROP.funct7 == 0 && ROP.funct3 == 2 	? SLT_OP :
							ROP.funct7 == 0 && ROP.funct3 == 3 	? SLTU_OP :
							ROP.funct7 == 0 && ROP.funct3 == 7 	? AND_OP :
							ROP.funct7 == 0 && ROP.funct3 == 6 	? OR_OP :
							ROP.funct7 == 0 && ROP.funct3 == 4 	? XOR_OP :
							ROP.funct7 == 0 && ROP.funct3 == 1 	? SLL_OP :
							ROP.funct7 == 0 && ROP.funct3 == 5 	? SRL_OP :
							ROP.funct7 == 32 && ROP.funct3 == 5 ? SRA_OP : OP_ERR;
							
		JTYPE : op_type = 	JOP.opcode == `JAL ? JAL_OP : OP_ERR;
		
		BTYPE : op_type =	BOP.funct3 == 0 ? BEQ_OP :
							BOP.funct3 == 1 ? BNE_OP :
							BOP.funct3 == 4 ? BLT_OP :
							BOP.funct3 == 5 ? BGE_OP :
							BOP.funct3 == 6 ? BLTU_OP :
							BOP.funct3 == 7 ? BGEU_OP : OP_ERR;
	endcase 
	
end



default clocking c0 @(posedge CLK); endclocking

// Sequences:

// Properties:

// Op code covers

genvar i;
generate for( i = 0; i < `NUM_OPS; i = i + 1) begin: instr_cover
	opcode: cover property(IDATA ==? OPS[i]);
end
endgenerate

// Write Enable cover

cover_wr_en: cover property( darkriscv.WR == 1'b1 );

// Read Enable cover

cover_rd_en: cover property( darkriscv.RD  == 1'b1 );

// Idle enable cover

cover_idle_en: cover property( darkriscv.IDLE == 1'b1 );

// Assuming valid instruction inputs.

assume_valid_idata: assume property( 
	IDATA ==? ADDI || IDATA ==? SLTI || IDATA ==? SLTIU || IDATA ==? ANDI || IDATA ==? ORI || IDATA ==? XORI || IDATA ==? JALR || IDATA ==? LW || IDATA ==? LH || IDATA ==? LHU || IDATA ==? LB || IDATA ==? LBU || IDATA ==? SLLI || IDATA ==? SRLI || IDATA ==? SRAI || IDATA ==? SW || IDATA ==? SH || IDATA ==? SB || IDATA ==? LUI || IDATA ==? AUIPC || IDATA ==? ADD || IDATA ==? SUB || IDATA ==? SLT || IDATA ==? SLTU || IDATA ==? AND || IDATA ==? OR || IDATA ==? XOR || IDATA ==? SLL || IDATA ==? SRL || IDATA ==? SRA || IDATA ==? JAL || IDATA ==? BEQ || IDATA ==? BNE || IDATA ==? BLT || IDATA ==? BLTU || IDATA ==? BGE || IDATA ==? BGEU );
	
// Assuming non-zero immediates
assume_imm_nonzero: assume property(
	uimm != 0 &&
	iimm != 0 &&
	simm1 != 0 &&
	bimm2 != 0 &&
	simm2 != 0 &&
	bimm1 != 0 &&
	bimm3 != 0 );
	
// Assuming non 0 register targets
assumme_rx_nonzero: assume property(
	rd != 0 &&
	rs1 != 0 &&
	rs2 != 0 );
		
// Assert Not both Read and Write

assert_not_rd_and_wr: assert property( !(darkriscv.WR == 1'b1 && darkriscv.RD == 1'b1) );

// Assert Write Enable follows store

`ifdef __3STAGE__
	assert_WR_3_after_store: assert property( (IDATA ==? SW) |-> ##3 darkriscv.WR );
`else
	assert_WR_2_after_store: assert property( (IDATA ==? SW) |-> ##2 darkriscv.WR );
`endif


endmodule




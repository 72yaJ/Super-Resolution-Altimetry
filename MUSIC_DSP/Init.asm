//************************************************************************/

#include <defts201.h>
#include "EC_UserDef.h"

//******************************************************************************
.global _Init;


.extern _irq0_int;
.extern _data_rx_int;
.extern _result_rx1_int;
.extern _result_rx2_int;
.extern _data_rd_int;

.extern _jtag0_dma1;
.extern _jtag1_dma1;
.extern _jtag2_dma1;
.extern _jtag3_dma1;

.extern _RESULT1RXDDR_pointer;
.extern _result1_rx_tcb1;
.extern _result1_rx_tcb2;
.extern _result1_rx;

.extern _RESULT2RXDDR_pointer;
.extern _result2_rx_tcb1;

.extern _result_tx1_tcb;
.extern _result_tx2_tcb;

.extern _table_pointer;
.extern _cfbcmd_cnt;
.extern _cfbcmd_rdpointer;
.extern _cfbcmd_wrpointer;
.extern _memory_table;
.extern _ID;
.extern _RXTCB_pointer;
.extern _result_tx;

.extern _DATARXTCB_pointer;

.extern _RESULTTXTCB_pointer;
.extern _cfbcmd_cnt;
.extern _cfbcmd;
.extern _data_rx_dma_cnt;
.extern _result1_wrpointer;
.extern _table_pointer;
.extern _memory_table;
.extern _distant;
.extern _tx_cnt;
.extern _pri_cnt;

//******************************************************************************
.section program;
_Init:
	
//*************disable GIE**************************//
	xr0 = sqctl;;
	xr0 = bclr r0 by  SQCTL_GIE_P;;
	sqctl = xr0;;
	
// Initialises SYSCON and SDRCON
	xr0 = 	SYSCON_MP_WID64 | SYSCON_MEM_WID64 | 
			SYSCON_MSH_PIPE2 | SYSCON_MSH_WT0 | SYSCON_MSH_IDLE |
			SYSCON_MS1_PIPE1 | SYSCON_MS1_WT0 | SYSCON_MS1_IDLE |
			SYSCON_MS0_SLOW  | SYSCON_MS0_WT3 | SYSCON_MS0_IDLE;;
	SYSCON = xr0;;
	
	xr0 =	0x000059a3;;
	SDRCON = xr0;;
//设置flag，FLAG1-3输入，flag0输出，中断触发方式
	xr0 = 0;;
	flagreg = xr0;;
	FLAGREGST  = FLAGREG_FLAG0_EN ;; 

	xr0 = 	0X0;;
	INTCTL = xr0;;
	
	xr0 = ltctl0;;
	xr0 = bclr r0 by LTCTL_TEN_P;;
	LTCTL0 = XR0;;
	
	xr0 = ltctl1;;
	xr0 = bclr r0 by LTCTL_TEN_P;;
	LTCTL1 = XR0;;
	
	xr0 = ltctl2;;
	xr0 = bclr r0 by LTCTL_TEN_P;;
	LTCTL2 = XR0;;
	
	xr0 = ltctl3;;
	xr0 = bclr r0 by LTCTL_TEN_P;;
	LTCTL3 = XR0;;
	
	xr0 = LTCTL_TEN |LTCTL_TDSIZE |LTCTL_TCLKDIV4;;
	LTCTL0 = xr0;;
	LTCTL1 = xr0;;
	LTCTL2 = xr0;;
	LTCTL3 = xr0;;
	
	xr0 = lRctl0;;
	xr0 = bclr r0 by LRCTL_REN_P;;
	LRCTL0 = XR0;;
	
	xr0 = lRctl1;;
	xr0 = bclr r0 by LRCTL_REN_P;;
	LRCTL1 = XR0;;
	
	xr0 = lRctl2;;
	xr0 = bclr r0 by LRCTL_REN_P;;
	LRCTL2 = XR0;;
	
	xr0 = lRctl3;;
	xr0 = bclr r0 by LRCTL_REN_P;;
	LRCTL3 = XR0;;
	
	
	xr0 = 0x11;;
	LRCTL0 = xr0;;
	LRCTL1 = xr0;;
	LRCTL2 = xr0;;
	LRCTL3 = xr0;;
	
	xr1:0 = dstatc;;	
	
	xr0 = 0;;
	xr1 = 0;;
	xr2 = 0;;
	xr3 = 0;;
	
	dcs0 = xr3:0;;
	dcd0 = xr3:0;;
	
	dcs1 = xr3:0;;
	dcd1 = xr3:0;;
	
	dcs2 = xr3:0;;
	dcd2 = xr3:0;;
	
	dcs3 = xr3:0;;
	dcd3 = xr3:0;;

_data_ini:
	xr0 = 0;;
	[j31+_cfbcmd_cnt] = xr0;;
	[j31+_data_rx_dma_cnt] =xr0;;
	[j31+_cfbcmd_cnt] = xr0;;
	
	xr0 = _cfbcmd;;
	[j31 + _cfbcmd_wrpointer] = xr0;;
	
	xr0 = _memory_table;;
	[j31+_table_pointer] =xr0;;
	
//	xr0 = _result_storage;;
//	[j31+_result_wrpointer] =xr0;;//结果写指针
	
	xr0 = _result1_rx;;
	[j31 + _result1_wrpointer] = xr0;;
	xr0 = _result2_rx;;
	[j31 + _result2_wrpointer] = xr0;;
	
	xr0 = 0;;
	[j31 + _tx_cnt] = xr0;;
	xr0 = 0;;
	[j31 + _pri_cnt] = xr0;;
	
/*
	xr0= 0xaaaaaaaa;;
	xr1 = 0x04000011;;
	xr2 = 0;;
	xr3 = 0;;
	q[j31 + _result_tx] = xr3:0;;
	xr0 = 1;;
	lc0 = 2200;;
	j10 = _result_tx+4;;
_ini_11:
	[j10+=1] = xr0;;
	xr0 = inc r0;;	
.align_code 4;
	if nlc0e,jump _ini_11;;
*/		
//	

	j10 = _memory_table;;
	xr0 = 0;;
	xr1 = SDRAM_ADDR;;
	xr2 = SDRAM_OFFSET;; 
	lc0 = CFB_STORAGEBLOCK;;
_table_ini:
	[j10+=1] = xr1;;
	[j10+=1] = xr0;;
	xr1 = r1 + r2;;
.align_code 4;
	if nlc0e,jump 	_table_ini;;
	
	xr0 = sqstat;;
	xr1 = 0x1103;;
	xr0 = fext r0 by r1;;
	[j31+_ID] = xr0;;
	xr2 = 1;;
	xr1 = 1;;
	xcomp(r0,r1);;
	if xaeq;do,[j31+_ID+1] = xr2;;
	xr1 = 3;;
	xcomp(r0,r1);;
	if xaeq;do,[j31+_ID+1] = xr2;;
	xr1 = 4;;	

	xr0 = _data_rd_int;;
	ivdma0 = xr0;;		//数据读取中断
	
	xr0 = [j31+ _ID];;		
	xr1 = 0;;
	xcomp(r0,r1);;
.align_code 4;
	if xaeq,jump _j0_isr_setup;;
	xr1 = 1;;
	xcomp(r0,r1);;
.align_code 4;
	if xaeq,jump _j1_isr_setup;;
	xr1 = 2;;
	xcomp(r0,r1);;
.align_code 4;
	if xaeq,jump _j2_isr_setup;;
	xr1 = 3;;
	xcomp(r0,r1);;
.align_code 4;
	if xaeq,jump _j3_isr_setup;;
	xr1 = 4;;
	xcomp(r0,r1);;
.align_code 4;
	jump _isr_setup_over;;	
	
_j0_isr_setup:
	xr0 = _jtag0_dma1;;
	[j31 + _DATARXTCB_pointer] = xr0;;
	j10 = _irq0_int;;
	ivirq0 = j10;;
	j10 = _data_rx_int;;
	ivdma11 = j10;;
	xr0 = WI_CS_DIV4 + WI_DATA_START;;
	xr1 = WI_CS_DIV4 + WI_DATA_START + WI_CS_DATADIV-1;;
	l[j31 + _distant] = xr1:0;;
	xr0 = 3663;;
	xr1 = 4666;;
	l[j31 + _distant + 2] = xr1:0;;
	xr0 = 1;;
	[j31+ _ID+2] = xr0;;
	
	
//	j10 = _result_rx1_int;;
//	ivirq
//	j10 = _result_rx2_int;;
//	ivirq
.align_code 4;
	jump _isr_setup_over;;
_j1_isr_setup:
	xr0 = _jtag1_dma1;;
	[j31 + _DATARXTCB_pointer] = xr0;;
	j10 = _irq0_int;;
	ivirq0 = j10;;
	j10 = _data_rx_int;;
	ivdma9 = j10;;
	xr0 = WI_CS_DIV3 + WI_DATA_START;;
	xr1 = WI_CS_DIV3 + WI_DATA_START + WI_CS_DATADIV-1;;
	l[j31 + _distant] = xr1:0;;
	xr0 = 2665;;
	xr1 = 3668;;
	l[j31 + _distant + 2] = xr1:0;;
	xr0 = 1;;
	[j31+ _ID+2] = xr0;;

//	j10 = _result_rx1_int;;
//	ivirq
//	j10 = _result_rx2_int;;
//	ivirq
.align_code 4;
	jump _isr_setup_over;;
_j2_isr_setup:
	xr0 = _jtag2_dma1;;
	[j31 + _DATARXTCB_pointer] = xr0;;
	j10 = _irq0_int;;
	ivirq0 = j10;;
	j10 = _data_rx_int;;
	ivdma11 = j10;;
	xr0 = WI_CS_DIV2 + WI_DATA_START;;
	xr1 = WI_CS_DIV2 + WI_DATA_START + WI_CS_DATADIV-1;;
	l[j31 + _distant] = xr1:0;;
	xr0 = 1665;;
	xr1 = 2668;;
	l[j31 + _distant + 2] = xr1:0;;
	xr0 = 1;;
	[j31+ _ID+2] = xr0;;
	
//	j10 = _result_rx1_int;;
//	ivirq
//	j10 = _result_rx2_int;;
//	ivirq
.align_code 4;
	jump _isr_setup_over;;
_j3_isr_setup:
	xr0 = _jtag3_dma1;;
	[j31 + _DATARXTCB_pointer] = xr0;;
	j10 = _irq0_int;;
	ivirq0 = j10;;
	j10 = _data_rx_int;;
	ivdma9 = j10;;
	xr0 = WI_CS_DIV1 + WI_DATA_START;;
	xr1 = WI_CS_DIV1 + WI_DATA_START + WI_CS_DATADIV-1;;
	l[j31 + _distant] = xr1:0;;
	xr0 = 667;;
	xr1 = 1700;;
	l[j31 + _distant + 2] = xr1:0;;
	xr0 = 1;;
	[j31+ _ID+2] = xr0;;

//	j10 = _result_rx1_int;;
//	ivirq
//	j10 = _result_rx2_int;;
//	ivirq
.align_code 4;
	jump _isr_setup_over;;
_j4_isr_setup:
	xr0 = _jtag4_dma1;;
	[j31 + _DATARXTCB_pointer] = xr0;;
	j10 = _irq0_int;;
	ivirq0 = j10;;
	j10 = _data_rx_int;;
	ivdma9 = j10;;
	j10 = _result_rx1_int;;
	ivdma10 = j10;;
	xr0 = NA_CS_DIV1 + NA_DATA_START;;
	xr1 = NA_CS_DIV1 + NA_DATA_START + NA_CS_DATADIV-1;;
	l[j31 + _distant] = xr1:0;;
	xr0 = 0;;
	[j31+ _ID+2] = xr0;;
//	j10 = _result_rx2_int;;
//	ivirq
.align_code 4;
	jump _isr_setup_over;;
_j5_isr_setup:
	xr0 = _jtag5_dma1;;
	[j31 + _DATARXTCB_pointer] = xr0;;
	j10 = _irq0_int;;
	ivirq0 = j10;;
	j10 = _data_rx_int;;
	ivdma11 = j10;;
	j10 = _result_rx1_int;;
	ivdma8 = j10;;
	j10 = _result_rx2_int;;
	ivdma9 = j10;;
	xr0 = NA_CS_DIV4 + NA_DATA_START;;
	xr1 = NA_CS_DIV4 + NA_DATA_START + NA_CS_DATADIV-1;;
	l[j31 + _distant] = xr1:0;;
	xr0 = 0;;
	[j31+ _ID+2] = xr0;;
	
.align_code 4;
	jump _isr_setup_over;;
_j6_isr_setup:
	xr0 = _jtag6_dma1;;
	[j31 + _DATARXTCB_pointer] = xr0;;
	j10 = _irq0_int;;
	ivirq0 = j10;;
	j10 = _data_rx_int;;
	ivdma9 = j10;;
	j10 = _result_rx1_int;;
	ivdma10 = j10;;
	xr0 = NA_CS_DIV3 + NA_DATA_START;;
	xr1 = NA_CS_DIV3 + NA_DATA_START + NA_CS_DATADIV-1;;
	l[j31 + _distant] = xr1:0;;
	xr0 = 0;;
	[j31+ _ID+2] = xr0;;
	
//	j10 = _result_rx2_int;;
//	ivirq
.align_code 4;
	jump _isr_setup_over;;
_j7_isr_setup:
	xr0 = _jtag7_dma1;;
	[j31 + _DATARXTCB_pointer] = xr0;;
	j10 = _irq0_int;;
	ivirq0 = j10;;
	j10 = _data_rx_int;;
	ivdma11 = j10;;
	j10 = _result_rx1_int;;
	ivdma8 = j10;;
	j10 = _result_rx2_int;;
	ivdma9 = j10;;
	xr0 = NA_CS_DIV2 + NA_DATA_START;;
	xr1 = NA_CS_DIV2 + NA_DATA_START + NA_CS_DATADIV-1;;
	l[j31 + _distant] = xr1:0;;
	xr0 = 0;;
	[j31+ _ID+2] = xr0;;
	
.align_code 4;
	jump _isr_setup_over;;
				
_isr_setup_over:			
// enable interrupt	
	xr0 = imaskh;;
	xr0 = bset r0 by INT_IRQ0_P;;
	imaskh = xr0;;

// enable GIE
	SQCTLST = SQCTL_GIE;;// Enable the Hardware Interrupts Enable bit in SQCTL

//******************************* Exit Routine	*****************************
.align_code 4;
	CJMP(ABS)(NP);;
	
_Init.end:

	
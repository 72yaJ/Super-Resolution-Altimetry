
#include "DefTS201.h"
#include "EC_UserDef.h"




.global _irq0_int;
.global _data_rx_int;
.global _result_rx1_int;
.global _result_rx2_int;
.global _data_rd_int;

.extern _PRIstack;
.extern _DATARXstack;
.extern _RESULTRX1stack;
.extern _RESULTRX2stack;
.extern _DATARDstack;
.extern _Priflag;
.extern _Data_rxflag;
.extern _Data_rdflag;
.extern _Led_cnt;
.extern _cfbcmd_cnt;
.extern _result_tx;
.extern _result_tx_tcb;

.extern _can;
.extern _data_rx_dma_cnt;
.extern _ID;
.extern _DATARXTCB_pointer;
.extern _RESULTTXTCB_pointer;
.extern _cfbcmd_cnt;
.extern _cfbcmd_wrpointer;
.extern _cfbcmd;
.extern _result1_wrpointer;
//.extern _result1_storage;
.extern _result2_wrpointer;
//.extern _result2_storage;
.extern _result_wrpointer;
//.extern _result_storage;
.extern _table_pointer;
.extern _memory_table;

.extern _RESULT1RXTCB_pointer;
.extern _result1_rx_tcb;
//.extern _result1_rx_tcb2;

.extern _RESULT2RXTCB_pointer;
.extern _result2_rx_tcb;
//.extern _result2_rx_tcb2;

.extern _local_dsp_rsult;
.extern _result1_rx;
.extern _result2_rx;


.extern _head;
.extern _head1;

.extern _jtag1_dma3;
.extern _jtag1_dma1;

.extern _tx_cnt;
.extern _pri_cnt;

/*********** j21做建栈基址寄存器，为全局变量，且在中断服务程序中
************ 无法保护，j21在所有程序中均不能使用 ****************/

.section program;
//=================================================================================================	
	
//============================PRI中断服务程序======================================================
_irq0_int:
	q[j31+_PRIstack+0] = xr3:0;;
	q[j31+_PRIstack+4] = xr7:4;;
	q[j31+_PRIstack+8] = xr11:8;;
	q[j31+_PRIstack+12] = xr15:12;;
	q[j31+_PRIstack+16] = xr19:16;;
    xr0 = xstat;;
    [j31+_PRIstack+24] = xr0;;
    xr0 = lc0;;
    [j31+_PRIstack+25] = xr0;;
    xr0 = cjmp;;
    [j31+_PRIstack+27] = xr0;;
    
//=======prf标志置位======= 
	xr0 = 1;;
    [j31+_Priflag] = xr0;;
//=======数据接收DMA中断计数器清零======= 
	xr0 = 0;;
//    [j31+_data_rx_dma_cnt] = xr0;;	 
 	[j31 + _Data_rxflag] = xr0;;     
//=======关闭irq0中断=======    
//  xr0 = imaskh;;
//	xr0 = bclr r0 by INT_IRQ0_P;;
//	imaskh = xr0;;   
		xr0 = 0x90;;
		ltctl0 = xr0;; 
		ltctl1 = xr0;;
		ltctl2 = xr0;;
		ltctl3 = xr0;;
		xr0 = 0x10;;
		lrctl0 = xr0;;
		lrctl1 = xr0;;
		lrctl2 = xr0;;
		lrctl3 = xr0;;    

		xr0 = 0;;
		xr1 = 0;;
		xr2 = 0;;
		xr3 = 0;;
		dc4 = xr3:0;;
		dc5 = xr3:0;;
		dc6 = xr3:0;;
		dc7 = xr3:0;;
		dc8 = xr3:0;;
		dc9 = xr3:0;;
		dc10 = xr3:0;;
		dc11 = xr3:0;;
     	xr1:0 = dstatc;;
/////////link tcb
		j4 = [j31+_DATARXTCB_pointer];;
		j5 = _result1_rx_tcb;;
		j6 = _result2_rx_tcb;;
		
		
		xr7:4 = q[j31+j4];;
     	xr11:8 = q[j31+j5];;
     	xr15:12 = q[j31+j6];;
     	

     	xr2 = 0x11;;
     	xr3 = 0x91;;
     	lrctl0 = xr2;;
		lrctl1 = xr2;;
		lrctl2 = xr2;;
		lrctl3 = xr2;;
		ltctl0 = xr3;; 
		ltctl1 = xr3;;
		ltctl2 = xr3;;
		ltctl3 = xr3;;
   	
     	

		xr0 = [j31+ _ID];;		
		xr1 = 0;;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _j0_tcb_setup;;
		xr1 = 1;;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _j1_tcb_setup;;
		xr1 = 2;;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _j2_tcb_setup;;
		xr1 = 3;;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _j3_tcb_setup;;
		xr1 = 4;;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _j4_tcb_setup;;
		xr1 = 5;;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _j5_tcb_setup;;
		xr1 = 6;;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _j6_tcb_setup;;
		xr1 = 7;;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _j7_tcb_setup;;
.align_code 4;
		jump _tcb_setup_over;;
		
_j0_tcb_setup:

		dc11 = xr7:4;;	
     	 		

.align_code 4;
		jump _tcb_setup_over;;
_j1_tcb_setup:

		dc9 = xr7:4;;
				

.align_code 4;
		jump _tcb_setup_over;;
_j2_tcb_setup:	

     	dc11 = xr7:4;; 
			

.align_code 4;
		jump _tcb_setup_over;;
_j3_tcb_setup:
	
     	dc9 = xr7:4;; 
		

.align_code 4;
		jump _tcb_setup_over;;
_j4_tcb_setup:	

     	dc9 = xr7:4;; 
		
		dc10 = xr11:8;;
		


.align_code 4;
		jump _tcb_setup_over;;										
_j5_tcb_setup:	

     	dc11 = xr7:4;; 
		
		dc8 = xr11:8;;
		
		dc9 = xr15:12;;
		
.align_code 4;
		jump _tcb_setup_over;;		
_j6_tcb_setup:	

     	dc9 = xr7:4;; 
		
		dc10 = xr11:8;;	
		

.align_code 4;
		jump _tcb_setup_over;;					
_j7_tcb_setup:	

     	dc11 = xr7:4;; 
		
		dc8 = xr11:8;;
		
		dc9 = xr15:12;;
			
_tcb_setup_over:
//		
/*	xr0 = [j31 + _pri_cnt];;
	xr1 = inc r0;;
	[j31 + _pri_cnt] = xr1;;
	xr1 = 100;;
	xcomp(r0,r1);;
.align_code 4;
	if nxaeq,jump _result_tx_over;;
	xr0 = 0;;
	[j31 + _pri_cnt] = xr0;;	
.align_code 4;
	jump _tx_data_fill_over;;*/
//
//======选择发送的结果源，优先本板数据源
		xr0 = [j31 + _local_dsp_rsult];;
		xr1 = 0xaaaaaaaa;;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq ,jump _local_data_fill;;
		
		k0 = [j31 + _result1_rx_tcb];;
		kb0 = _result1_rx;;
   		kl0 = CFB_HEADDATA_LEN*CFBRESULT_MAXCNT;;
   		k0 = k0 - CFB_HEADDATA_LEN(cb);;
   		xr1 = 0xaaaaaaaa;;
   		lc0 = CFBRESULT_MAXCNT-1;;
 _result1_effc_serch:  		
   		xr0 = [k31 + k0];;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _rx1_data_fill;;
		k0 = k0 - CFB_HEADDATA_LEN(cb);;
.align_code 4;
		if nlc0e,jump _result1_effc_serch;;	
		
		k1 = [j31 + _result2_rx_tcb];;
		kb1 = _result2_rx;;
   		kl1 = CFB_HEADDATA_LEN*CFBRESULT_MAXCNT;;
   		k1 = k1 - CFB_HEADDATA_LEN(cb);;
   		xr1 = 0xaaaaaaaa;;
   		lc0 = CFBRESULT_MAXCNT-1;;
 _result2_effc_serch:  		
   		xr0 = [k31 + k1];;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _rx2_data_fill;;
		k1 = k1 - CFB_HEADDATA_LEN(cb);;
.align_code 4;
		if nlc0e,jump _result2_effc_serch;;	
		
.align_code 4;
		jump _result_tx_over;;					
		
_local_data_fill:
	j10 = _local_dsp_rsult;;
	j11 = _result_tx;;
	lc0 = CFB_HEADDATA_LEN/4;;
_local_data_fill_loop:
	xr3:0=q[j10+=4];;
	q[j11+=4] = xr3:0;;
.align_code 4;
	if nlc0e,jump _local_data_fill_loop;;
	xr0 = 0;;
	[j31 + _local_dsp_rsult] = xr0;;
.align_code 4;
	jump _tx_data_fill_over;;			
	
_rx1_data_fill:
	j11 = _result_tx;;
	xr4 = k0;;
	lc0 = CFB_HEADDATA_LEN/4;;
_rx1_data_fill_loop:
	xr3:0 = q[k0+=4];;
	q[j11+=4] = xr3:0;;
.align_code 4;
	if nlc0e,jump _rx1_data_fill_loop;;
	k0 = xr4;;
	xr0 = 0;;
	[k31+k0] = xr0;;
.align_code 4;
	jump _tx_data_fill_over;;	 		

_rx2_data_fill:	
	j11 = _result_tx;;
	xr4 = k1;;
	lc0 = CFB_HEADDATA_LEN/4;;
_rx2_data_fill_loop:
	xr3:0 = q[k1+=4];;
	q[j11+=4] = xr3:0;;
.align_code 4;
	if nlc0e,jump _rx2_data_fill_loop;;
	k1 = xr4;;
	xr0 = 0;;
	[k31+k1] = xr0;;
	
_tx_data_fill_over:
		xr0 = [j31 + _tx_cnt];;
		[j31 + _result_tx + 2] = xr0;;
		xr0 = inc r0;;
		[j31 + _tx_cnt] = xr0;;
		
 		j7 = _result_tx_tcb;;
     	xr19:16= q[j31+j7];;
 
 		xr0 = [j31+ _ID];;		
		xr1 = 0;;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _j0_tcb_setup1;;
		xr1 = 1;;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _j1_tcb_setup1;;
		xr1 = 2;;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _j2_tcb_setup1;;
		xr1 = 3;;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _j3_tcb_setup1;;
		xr1 = 4;;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _j4_tcb_setup1;;
		xr1 = 5;;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _j5_tcb_setup1;;
		xr1 = 6;;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _j6_tcb_setup1;;
		xr1 = 7;;
		xcomp(r0,r1);;
.align_code 4;
		if xaeq,jump _j7_tcb_setup1;;
.align_code 4;
		jump _tcb_setup1_over;;
		
_j0_tcb_setup1:
	   	 		
		dc5 = xr19:16;;

.align_code 4;
		jump _result_tx_over;;
_j1_tcb_setup1:
				
		dc4 = xr19:16;;

.align_code 4;
		jump _result_tx_over;;
_j2_tcb_setup1:	
			
		dc5 = xr19:16;;

.align_code 4;
		jump _result_tx_over;;
_j3_tcb_setup1:
		
		dc4 = xr19:16;;

.align_code 4;
		jump _result_tx_over;;
_j4_tcb_setup1:	
		
		dc5 = xr19:16;;

.align_code 4;
		jump _result_tx_over;;										
_j5_tcb_setup1:	
		
		dc7 = xr19:16;;
		
.align_code 4;
		jump _result_tx_over;;		
_j6_tcb_setup1:	
		
		dc5 = xr19:16;;

.align_code 4;
		jump _result_tx_over;;					
_j7_tcb_setup1:	
		
		dc7 = xr19:16;;		
_tcb_setup1_over:
 	
_result_tx_over:				


_led_flash:
		xr0 = [j31 + _Led_cnt];;
		xr0 = inc r0;;
		xr1 = LED_CNT;;
		[j31+_Led_cnt] = xr0;;
		xcomp(r0,r1);;
.align_code 4;
		if xale,jump _no_flash;;
		xr0 = 0;;
		xr1 = flagreg;;
		[j31+_Led_cnt] = xr0;;	
		xr1 = btgl r1 by FLAGREG_FLAG0_OUT_P;;
		flagreg = xr1;;	
_no_flash:		

//-----------------------------------------------------------------------------
			
_PRF_Out:
  	xr3:0 = q[j31+_PRIstack+0];;
  	xr7:4	=q[j31+_PRIstack+4] ;;
	xr11:8=q[j31+_PRIstack+8] ;;
	xr15:12=q[j31+_PRIstack+12] ;;
	xr19:16=q[j31+_PRIstack+16] ;;
	
    xr0 = [j31+_PRIstack+24];;
    xstat = r0;;
    xr0 = [j31+_PRIstack+25];;
    lc0 = xr0;;
    xr0 = [j31+_PRIstack+27];;
    cjmp = xr0;; 
    xr0 = [j31+_PRIstack+0];;	  		
.align_code 4;
	rti(np)(abs);;nop;;nop;;nop;;	
_irq0_int.end:
//=================================================================================================	

//=================================================================================================	
//============================DMA中断服务程序=====================================================
//=================接收数据中断服务程序=================//
_data_rx_int:
	q[j31+_DATARXstack+0] = xr3:0;; 
	  		
	xr0 = 1;;	 
 	[j31 + _Data_rxflag] = xr0;;   
    
    xr3:0 = q[j31+_DATARXstack+0];;	  		
.align_code 4;
	rti(np)(abs);;nop;;nop;;nop;;		
_data_rx_int.end:


//=================接收结果1中断服务程序=================//
_result_rx1_int:
	q[j31 + _RESULTRX1stack + 0] = xr3:0;;
    xr0 = xstat;;
    [j31+_RESULTRX1stack+24] = xr0;;
    xr0 = cjmp;;
    [j31+_RESULTRX1stack+27] = xr0;;
	
	k0 = [k31 + _result1_rx_tcb];;
	xr0 = [k31 + k0];;
	xr1 = 0xaaaaaaaa;;
	xcomp(r0,r1);;
.align_code 4;
	if nxaeq,jump _result_rx1_noresult;;
	kb0 = _result1_rx;;
   	kl0 = CFB_HEADDATA_LEN*CFBRESULT_MAXCNT;;
    k0 = [k31 + _result1_rx_tcb];;
    k0 = k0 + CFB_HEADDATA_LEN(cb);;
    [k31 + _result1_rx_tcb] = k0;;	
_result_rx1_noresult:

	
    xr0 = [j31+_RESULTRX1stack+24];;
    xstat = r0;;
    xr0 = [j31+_RESULTRX1stack+27];;
    cjmp = xr0;; 
    xr3:0 = q[j31+_RESULTRX1stack+0];;	 		
.align_code 4;
	rti(np)(abs);;nop;;nop;;nop;;    
_result_rx1_int.end:


//=================接收结果2中断服务程序=================//
_result_rx2_int:
	q[j31 + _RESULTRX2stack + 0] = xr3:0;;
    xr0 = xstat;;
    [j31+_RESULTRX2stack+24] = xr0;;
    xr0 = cjmp;;
    [j31+_RESULTRX2stack+27] = xr0;;
	
	k1 = [k31 + _result2_rx_tcb];;
	xr0 = [k31 + k1];;
	xr1 = 0xaaaaaaaa;;
	xcomp(r0,r1);;
.align_code 4;
	if nxaeq,jump _result_rx2_noresult;;
	kb1 = _result2_rx;;
   	kl1 = CFB_HEADDATA_LEN*CFBRESULT_MAXCNT;;
    k1 = [k31 + _result2_rx_tcb];;
    k1 = k1 + CFB_HEADDATA_LEN(cb);;
    [k31 + _result2_rx_tcb] = k1;;
_result_rx2_noresult:

	
    xr0 = [j31+_RESULTRX2stack+24];;
    xstat = r0;;
    xr0 = [j31+_RESULTRX2stack+27];;
    cjmp = xr0;; 
    xr3:0 = q[j31+_RESULTRX2stack+0];;  		
.align_code 4;
	rti(np)(abs);;nop;;nop;;nop;; 
_result_rx2_int.end:

//=================sdram数据读取中断服务程序=================//
_data_rd_int:
	[j31 + _DATARDstack] = xr0;;
	xr0  = 1;;
	[j31 + _Data_rdflag] = xr0;;
	
	xr0 = [j31 + _DATARDstack];;  		
.align_code 4;
	rti(np)(abs);;nop;;nop;;nop;; 
_data_rd_int.end:







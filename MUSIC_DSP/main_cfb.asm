
#include "defTS201.h"
#include "cache_macros.h"
#include "EC_UserDef.h"



.global _PRIstack;
.global _DATARXstack;
.global _DATARDstack;
.global _RESULTRX1stack;
.global _RESULTRX2stack;
.global _Priflag;
.global _Data_rxflag;
.global _Data_rdflag;
.global _Led_cnt;
.global _cfbcmd_cnt;
.global _result_tx;
.global _result_tx_tcb;

.global _can;
.global _data_rx_dma_cnt;
.global _ID;
.global _DATARXTCB_pointer;

//.global _RESULTTXTCB_pointer;
.global _cfbcmd_wrpointer;
.global _cfbcmd;
.global _result1_wrpointer;
//.global _result1_storage;
.global _result2_wrpointer;
//.global _result2_storage;
.global _result_wrpointer;
//.global _result_storage;
.global _table_pointer;
.global _memory_table;

.global _jtag0_dma1;
.global _jtag1_dma1;
.global _jtag2_dma1;
.global _jtag3_dma1;
.global _jtag4_dma1;
.global _jtag5_dma1;
.global _jtag6_dma1;
.global _jtag7_dma1;

//.global _RESULT1RXDDR_pointer;
.global _result1_rx_tcb;
//.global _result1_rx_tcb2;

//.global _RESULT2RXDDR_pointer;
.global _result2_rx_tcb;
//.global _result2_rx_tcb2;

//.global _result_tx1_tcb;
//.global _result_tx2_tcb;

.global _local_dsp_rsult;

.global _head;
.global _result1_rx;
.global _result2_rx;
.global _result_tx;
.global _tx_cnt;
.global _pri_cnt;

//.global _head1;
.global _distant;

.extern _Init;
.extern _CFBCancmd;
.extern _WPData_Mix;


.section data2a;
.var _PRIstack[32];
.var _DATARXstack[32];
.var _RESULTRX1stack[32];
.var _RESULTRX2stack[32];
.var _DATARDstack[32];


.var _Priflag[4];
.var _Data_rxflag[4];
.var _Data_rdflag[4];
.var _Led_cnt[4];


.align 4;
.var _cfbcmd_cnt[4];	
.align 4;
.var _cfbcmd_wrpointer[4];
.align 4;
.var _cfbcmd[CFBCMD_MAXCNT*CFBCMD_LENTH];
.align 4;
.var _cmd[CFBCMD_LENTH];
.align 4;
.var _distant[4];		
.align 4;
.var _result1_wrpointer[4];
//.align 4;
//.var _result1_storage[CFBCMD_LENTH*CFBRESULT_MAXCNT];

//结果写指针，作为接收上级结果的指针，配置DMA
//发送时依次读8字，如果第一个字为aa，则认为有效，
//然后搬移到发送区,清除该结果的aa帧头
.align 4;
.var _result2_wrpointer[4];
//.align 4;
//.var _result2_storage[CFBCMD_LENTH*CFBRESULT_MAXCNT];

.align 4;
.var _result_wrpointer[4];
//.align 4;
//.var _result_storage[CFBCMD_LENTH*CFBRESULT_MAXCNT];//本片计算结果	 	

.align 4;
.var _table_pointer[4];
.align 4;
.var _memory_table[CFB_STORAGEBLOCK*CFB_TABLESINGLLEN];//
//存储区表
//0-地址
//1-方位

//======初始化各DSP的接收link dma，含链式和 link to link
.align 4;
.var _DATARXTCB_pointer[4];
.align 4;
.var _jtag0_dma1[4]={SDRAM_ADDR,((WI_CS_LINKTX_LEN<<16)+4),0x00000000,(EXTERMEN | HIGHPR | QUADLEN | INTENABLE | CHAINDISENABLE) };//无链式，中断
.align 4;
.var _jtag0_dma2[4]={0,0,0,0};//无效配置，补满16字


.align 4;
.var _jtag1_dma1[4]={SDRAM_ADDR,((WI_CS_LINKTX_LEN<<16)+4),0x00000000,(EXTERMEN | HIGHPR | QUADLEN | INTENABLE | CHAINENABLE | CHTG_LINKRX1 | (_jtag1_dma2>>2))};//主片,链式，中断
//.align 4;
//.var _jtag1_dma1[4]={_test1,((WI_CS_LINKTX_LEN<<16)+4),0x00000000,(INTERMEM | HIGHPR | QUADLEN | INTENABLE | CHAINENABLE | CHTG_LINKRX1 | (_jtag1_dma2>>2))};//主片,链式，中断
.align 4;
.var _jtag1_dma2[4]={LINKTOLINK_LINK2,((WI_CS_LINKTX_LEN<<16)+0),0x00000000,(LINK2LINK | HIGHPR | QUADLEN | INTDISENABLE | CHAINDISENABLE)};//主片,无链式，无中断,LINK TO LINK,LINKTX2
//.align 4;
//.var _jtag1_dma2[4]={_test2,((WI_CS_LINKTX_LEN<<16)+4),0x00000000,(INTERMEM | HIGHPR | QUADLEN | INTDISENABLE | CHAINDISENABLE)};//主片,无链式，无中断,LINK TO LINK,LINKTX2

.align 4;
.var _jtag2_dma1[4]={SDRAM_ADDR,((WI_CS_LINKTX_LEN<<16)+4),0x00000000,(EXTERMEN | HIGHPR | QUADLEN | INTENABLE | CHAINDISENABLE) };//无链式，中断
.align 4;
.var _jtag2_dma2[4]={0,0,0,0};//无效配置，补满16字



.align 4;
.var _jtag3_dma1[4]={SDRAM_ADDR,((WI_CS_LINKTX_LEN<<16)+4),0x00000000,(EXTERMEN | HIGHPR | QUADLEN | INTENABLE | CHAINENABLE | CHTG_LINKRX1 | (_jtag3_dma2>>2))};//主片,链式，中断
.align 4;
.var _jtag3_dma2[4]={LINKTOLINK_LINK2,((WI_CS_LINKTX_LEN<<16)+0),0x00000000,(LINK2LINK | HIGHPR | QUADLEN | INTDISENABLE | CHAINDISENABLE)};//主片,无链式，无中断,LINK TO LINK



.align 4;
.var _jtag4_dma1[4]={SDRAM_ADDR,((NA_BRIGEDATA_LEN<<16)+4),0x00000000,(EXTERMEN | HIGHPR | QUADLEN | INTENABLE | CHAINENABLE | CHTG_LINKRX1 | (_jtag4_dma2>>2))};//主片,链式，中断
.align 4;
.var _jtag4_dma2[4]={LINKTOLINK_LINK2,((NA_BRIGEDATA_LEN<<16)+0),0x00000000,(LINK2LINK | HIGHPR | QUADLEN | INTDISENABLE | CHAINDISENABLE)};//主片,无链式，无中断,LINK TO LINK


.align 4;
.var _jtag5_dma1[4]={SDRAM_ADDR,((NA_BRIGEDATA_LEN<<16)+4),0x00000000,(EXTERMEN | HIGHPR | QUADLEN | INTENABLE | CHAINDISENABLE)};//无链式，中断
.align 4;
.var _jtag5_dma2[4]={0,0,0,0};//无效配置，补满16字


.align 4;
.var _jtag6_dma1[4]={SDRAM_ADDR,((NA_BRIGEDATA_LEN<<16)+4),0x00000000,(EXTERMEN | HIGHPR | QUADLEN | INTENABLE | CHAINENABLE | CHTG_LINKRX1 | (_jtag6_dma2>>2))};//主片,链式，中断
.align 4;
.var _jtag6_dma2[4]={LINKTOLINK_LINK2,((NA_BRIGEDATA_LEN<<16)+0),0x00000000,(LINK2LINK | HIGHPR | QUADLEN | INTDISENABLE | CHAINDISENABLE)};//主片,无链式，无中断,LINK TO LINK



.align 4;
.var _jtag7_dma1[4]={SDRAM_ADDR,((NA_BRIGEDATA_LEN<<16)+4),0x00000000,(EXTERMEN | HIGHPR | QUADLEN | INTENABLE | CHAINDISENABLE)};//无链式，中断
.align 4;
.var _jtag7_dma2[4]={0,0,0,0};//无效配置，补满16字


//=========初始化各DSP的超分辨结果接收DMA

.align 4;
.var _result1_rx_tcb[4]={_result1_rx,((CFB_HEADDATA_LEN<<16)+4),0x00000000,(INTERMEM | HIGHPR | QUADLEN | INTENABLE | CHAINDISENABLE)};


.align 4;
.var _result2_rx_tcb[4]={_result2_rx,((CFB_HEADDATA_LEN<<16)+4),0x00000000,(INTERMEM | HIGHPR | QUADLEN | INTENABLE | CHAINDISENABLE)};


//=========初始化各DSP的超分辨结果发送DMA

.align 4;
.var _result_tx_tcb[4]={_result_tx,((CFB_HEADDATA_LEN<<16)+4),0x00000000,(INTERMEM | HIGHPR | QUADLEN | INTDISENABLE | CHAINDISENABLE)};


//=========初始化SDRAM读取tcb，每个脉冲一个，需提前算好读取地址
.align 4;
.var _sdram_rd_dcs01[4] = {SDRAM_ADDR,				  	      (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs02>>2))};
.var _sdram_rd_dcd01[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*0),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd02>>2))};
.align 4;
.var _sdram_rd_dcs02[4] = {SDRAM_ADDR,						  (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs03>>2))};
.var _sdram_rd_dcd02[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*1),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd03>>2))};
.align 4;
.var _sdram_rd_dcs03[4] = {SDRAM_ADDR,						  (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs04>>2))};
.var _sdram_rd_dcd03[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*2),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd04>>2))};
.align 4;
.var _sdram_rd_dcs04[4] = {SDRAM_ADDR,						  (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs05>>2))};
.var _sdram_rd_dcd04[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*3),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd05>>2))};
.align 4;
.var _sdram_rd_dcs05[4] = {SDRAM_ADDR,						  (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs06>>2))};
.var _sdram_rd_dcd05[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*4),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd06>>2))};
.align 4;
.var _sdram_rd_dcs06[4] = {SDRAM_ADDR,						  (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs07>>2))};
.var _sdram_rd_dcd06[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*5),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd07>>2))};
.align 4;
.var _sdram_rd_dcs07[4] = {SDRAM_ADDR,						  (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs08>>2))};
.var _sdram_rd_dcd07[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*6),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd08>>2))};
.align 4;
.var _sdram_rd_dcs08[4] = {SDRAM_ADDR,						  (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs09>>2))};
.var _sdram_rd_dcd08[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*7),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd09>>2))};
.align 4;
.var _sdram_rd_dcs09[4] = {SDRAM_ADDR,						  (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs10>>2))};
.var _sdram_rd_dcd09[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*8),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd10>>2))};
.align 4;
.var _sdram_rd_dcs10[4] = {SDRAM_ADDR,						  (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs11>>2))};
.var _sdram_rd_dcd10[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*9),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd11>>2))};
.align 4;
.var _sdram_rd_dcs11[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs12>>2))};
.var _sdram_rd_dcd11[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*10),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd12>>2))};
.align 4;
.var _sdram_rd_dcs12[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs13>>2))};
.var _sdram_rd_dcd12[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*11),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd13>>2))};
.align 4;
.var _sdram_rd_dcs13[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs14>>2))};
.var _sdram_rd_dcd13[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*12),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd14>>2))};
.align 4;
.var _sdram_rd_dcs14[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs15>>2))};
.var _sdram_rd_dcd14[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*13),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd15>>2))};
.align 4;
.var _sdram_rd_dcs15[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs16>>2))};
.var _sdram_rd_dcd15[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*14),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd16>>2))};
.align 4;
.var _sdram_rd_dcs16[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs17>>2))};
.var _sdram_rd_dcd16[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*15),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd17>>2))};
.align 4;
.var _sdram_rd_dcs17[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs18>>2))};
.var _sdram_rd_dcd17[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*16),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd18>>2))};
.align 4;
.var _sdram_rd_dcs18[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs19>>2))};
.var _sdram_rd_dcd18[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*17),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd19>>2))};
.align 4;
.var _sdram_rd_dcs19[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs20>>2))};
.var _sdram_rd_dcd19[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*18),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd20>>2))};
.align 4;
.var _sdram_rd_dcs20[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs21>>2))};
.var _sdram_rd_dcd20[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*19),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd21>>2))};
.align 4;
.var _sdram_rd_dcs21[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs22>>2))};
.var _sdram_rd_dcd21[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*20),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd22>>2))};
.align 4;
.var _sdram_rd_dcs22[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs23>>2))};
.var _sdram_rd_dcd22[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*21),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd23>>2))};
.align 4;
.var _sdram_rd_dcs23[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs24>>2))};
.var _sdram_rd_dcd23[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*22),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd24>>2))};
.align 4;
.var _sdram_rd_dcs24[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs25>>2))};
.var _sdram_rd_dcd24[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*23),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd25>>2))};
.align 4;
.var _sdram_rd_dcs25[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs26>>2))};
.var _sdram_rd_dcd25[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*24),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd26>>2))};
.align 4;
.var _sdram_rd_dcs26[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs27>>2))};
.var _sdram_rd_dcd26[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*25),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd27>>2))};
.align 4;
.var _sdram_rd_dcs27[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs28>>2))};
.var _sdram_rd_dcd27[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*26),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd28>>2))};
.align 4;
.var _sdram_rd_dcs28[4] = {SDRAM_ADDR,					       (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs29>>2))};
.var _sdram_rd_dcd28[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*27),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd29>>2))};
.align 4;
.var _sdram_rd_dcs29[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs30>>2))};
.var _sdram_rd_dcd29[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*28),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd30>>2))};
.align 4;
.var _sdram_rd_dcs30[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs31>>2))};
.var _sdram_rd_dcd30[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*29),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd31>>2))};
.align 4;
.var _sdram_rd_dcs31[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs32>>2))};
.var _sdram_rd_dcd31[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*30),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd32>>2))};
.align 4;
.var _sdram_rd_dcs32[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs33>>2))};
.var _sdram_rd_dcd32[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*31),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd33>>2))};
.align 4;
.var _sdram_rd_dcs33[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs34>>2))};
.var _sdram_rd_dcd33[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*32),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd34>>2))};
.align 4;
.var _sdram_rd_dcs34[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs35>>2))};
.var _sdram_rd_dcd34[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*33),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd35>>2))};
.align 4;
.var _sdram_rd_dcs35[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs36>>2))};
.var _sdram_rd_dcd35[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*34),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd36>>2))};
.align 4;
.var _sdram_rd_dcs36[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs37>>2))};
.var _sdram_rd_dcd36[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*35),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd37>>2))};
.align 4;
.var _sdram_rd_dcs37[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs38>>2))};
.var _sdram_rd_dcd37[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*36),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd38>>2))};
.align 4;
.var _sdram_rd_dcs38[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs39>>2))};
.var _sdram_rd_dcd38[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*37),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd39>>2))};
.align 4;
.var _sdram_rd_dcs39[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs40>>2))};
.var _sdram_rd_dcd39[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*38),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd40>>2))};
.align 4;
.var _sdram_rd_dcs40[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs41>>2))};
.var _sdram_rd_dcd40[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*39),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd41>>2))};
.align 4;
.var _sdram_rd_dcs41[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs42>>2))};
.var _sdram_rd_dcd41[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*40),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd42>>2))};
.align 4;
.var _sdram_rd_dcs42[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs43>>2))};
.var _sdram_rd_dcd42[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*41),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd43>>2))};
.align 4;
.var _sdram_rd_dcs43[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs44>>2))};
.var _sdram_rd_dcd43[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*42),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd44>>2))};
.align 4;
.var _sdram_rd_dcs44[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs45>>2))};
.var _sdram_rd_dcd44[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*43),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd45>>2))};
.align 4;
.var _sdram_rd_dcs45[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs46>>2))};
.var _sdram_rd_dcd45[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*44),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd46>>2))};
.align 4;
.var _sdram_rd_dcs46[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs47>>2))};
.var _sdram_rd_dcd46[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*45),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd47>>2))};
.align 4;
.var _sdram_rd_dcs47[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcs48>>2))};
.var _sdram_rd_dcd47[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*46),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTDISENABLE | CHAINENABLE |(_sdram_rd_dcd48>>2))};
.align 4;
.var _sdram_rd_dcs48[4] = {SDRAM_ADDR,						   (CFB_SDRAM_DMARD_LEN<<16)+1,0,(EXTERMEN | HIGHPR | NOMWORDLEN | INTENABLE | CHAINDISENABLE )};
.var _sdram_rd_dcd48[4] = {(sdram_data+CFB_SDRAM_DMARD_LEN*47),(CFB_SDRAM_DMARD_LEN<<16)+1,0,(INTERMEM | HIGHPR | NOMWORDLEN | INTENABLE | CHAINDISENABLE )};



.section data2b;
.align 4;
.var _head[HEAD_LEN];
.align 4;
.var _local_dsp_rsult[HEAD_LEN+CFB_DATA_LEN];	//本片测算出来的结果，每个PRI周期最多计算一次


//输出结果也设置乒乓
.section data4a;
.align 4;
.var sdram_data[CFB_SDRAM_DMARD_LEN*24*2];


.section data4b;
.var cfb_data[2*CS_CHS*48];		//


.section data6a;
.align 4;
.var _result1_rx[CFB_HEADDATA_LEN*CFBRESULT_MAXCNT];

.section data6b;
.align 4;
.var _result2_rx[CFB_HEADDATA_LEN*CFBRESULT_MAXCNT];

.section data8a;
.align 4;
.var _result_tx[CFB_RESULT_FACTTXLEN];//增加部分用来挤出FIFO

.section data8b;
.var _test1[32000];

.section data10a;


.section data10b;
.var _test2[32000];


.section reset;
// prepare cache
/*in the case of TS201, at the beginning of the program the 
cache must be enabled. The procedure is contained in the 
cache_enable macro that uses the refresh rate as input parameter
      -if CCLK=500MHz, refresh_rate=750
      -if CCLK=400MHz, refresh_rate=600
      -if CCLK=300MHz, refresh_rate=450
      -if CCLK=250MHz, refresh_rate=375
*/
// ~~~ 03-00-0359 WORK-AROUND ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
    MR1:0 += R1:0*R3:2;;
    R4 = R0 + R1;
    LBUFTX0 = XR3:0;;
    LBUFTX0 = YR3:0;;
    
// ~~~ 03-00-0358 WORK-AROUND ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
    YR1:0 = MR1:0;;
    
	cache_enable(750);
	jump _main (NP);;
		

.section program;
_main:
//***************** init ********************//	
/*
	j10 = sdram_data;;
	j11 = cfb_data;;
	
	k10 = sdram_data + CFB_RD_PULSE_CNT/2*CFB_SDRAM_DMARD_LEN;;
	k11 = cfb_data + 2*CS_CHS*CFB_RD_PULSE_CNT/2;;
	
	r24 = 0x0818;;
	r25 = 0x0810;;
	r26 = 0x1808;;
	r27 = 0x0018;;
	r28 = 0x1008;;
	r29 = 0x1010;;
	r30 = 0x0018;;
	

	lc0 = CFB_RD_PULSE_CNT/2/4;;//48 脉冲
_data_ana_loop:

	lc1 = 15;;
_data_ana_loop1:	
	xr3:0 = q[j10+=4];;
	yr3:0 = q[k10+=4];;
	xr7:4 = q[j10+=4];;
	yr7:4 = q[k10+=4];;
	xr11:8 = q[j10+=4];;
	yr11:8 = q[k10+=4];;
	
	r18 = fext r0 by r24 (se);;		//第一通道实部
	lr13:12 = rot r1:0 by -8;;	
	r19 = fext r13 by r24 (se);;	//第一通道虚部
	l[j11+=2] = xr19:18;;
	l[k11+=2] = yr19:18;;
	
	r0 = r2;;
	lr13:12 = rot r1:0 by 8;;
	r18 = fext r13 by r30(se);;		//第二通道实部				
	r19 = fext r2 by r27 (se);;		//第二通道虚部
	l[j11+=2] = xr19:18;;
	l[k11+=2] = yr19:18;;
	
	r2 = r4;;
	r18 = fext r3 by r24(se);;		//第三通道实部
	lr13:12 = rot r3:2 by 16;;
	r19 = fext r13 by r30 (se);;	//第三通道虚部
	l[j11+=2] = xr19:18;;
	l[k11+=2] = yr19:18;;
	
	lr13:12 = rot r5:4 by 8;;
	r18 = fext r12 by r27(se);;		//第四通道实部
	r19 = fext r5 by r30(se);;		//第四通道虚部
	l[j11+=2] = xr19:18;;
	l[k11+=2] = yr19:18;;
	
	r18 = fext r6 by r24(se);;		//第五通道实部
	lr13:12 = rot r7:6 by -8;;
	r19 = fext r13 by r24 (se);;	//第五通道虚部		
	l[j11+=2] = xr19:18;;
	l[k11+=2] = yr19:18;;
	
	
	r6 = r8;;
	lr13:12 = rot r7:6 by 8;;	
	r18 = fext r13 by r30 (se);;		//第六通道实部
	r19 = fext r8 by r27 (se);;		//第六通道虚部
	l[j11+=2] = xr19:18;;
	l[k11+=2] = yr19:18;;	

.align_code 4;
	if nlc1e,jump _data_ana_loop1;;		
	
.align_code 4;
	if nlc0e,jump _data_ana_loop;;
*/	
	
	call _Init(np);;				
	
//********************************************		
_wait:		
	xr0 = [j31+_Data_rxflag];;
	xr1 = 1;;
	xcomp(r0,r1);;
.align_code 4;
	if xaeq,jump _start;;
	nop;;nop;;nop;;nop;;
	nop;;nop;;nop;;nop;;
	nop;;nop;;nop;;nop;;
	nop;;nop;;nop;;nop;;
	nop;;nop;;nop;;nop;;
	nop;;nop;;nop;;nop;;
	nop;;nop;;nop;;nop;;
	nop;;nop;;nop;;nop;;
.align_code 4;
	jump _wait;;	
				
//=======主程序起始======= 					
_start:
	
//=======读取帧头
//	j10 = [j31 +_DATARXTCB_pointer];;
	j10 = [j31+_table_pointer];;
	j10 = [j31 + j10];;
	j11 = _head;;
	
	xr3:0 = q[j10+=4];;
	xr7:4 = q[j10+=4];;
	q[j11+=4] = xr3:0;;
	q[j11+=4] = xr7:4;;
	
	xr3:0 = q[j10+=4];;
	xr7:4 = q[j10+=4];;
	q[j11+=4] = xr3:0;;
	q[j11+=4] = xr7:4;;
	
	xr3:0 = q[j10+=4];;
	xr7:4 = q[j10+=4];;
	q[j11+=4] = xr3:0;;
	q[j11+=4] = xr7:4;;
	
	xr3:0 = q[j10+=4];;
	xr7:4 = q[j10+=4];;
	q[j11+=4] = xr3:0;;
	q[j11+=4] = xr7:4;;
	
	xr3:0 = q[j10+=4];;
	xr7:4 = q[j10+=4];;
	q[j11+=4] = xr3:0;;
	q[j11+=4] = xr7:4;;

	j10 = _head;;
	xr0 = [j31 + j10];;
	xr1 = 0xaaaaaaaa;;
	xcomp(r0,r1);;
.align_code 4;
	if nxaeq, jump _cmd_fresh_over;;
	
	xr0 = [j31 + _head + AZ_CODE_POSITON];;
	xr1 = 0x030d;;
			
	j0 = [j31+_table_pointer];;
	jb0 = _memory_table;;
	jl0 = CFB_STORAGEBLOCK*CFB_TABLESINGLLEN;;
	[j0+1] = xr0;;//方位更新
	j0 = j0 + CFB_TABLESINGLLEN(cb);;
	[j31+_table_pointer] = j0;;//更新table表指针
	xr0 = [j31 + j0];;	//新的接收地址
	j10 = [j31+_DATARXTCB_pointer];;
	[j31 + j10] = xr0;;	//更新接收SDRAM地址 
//=======更新CAN=======//	
	j4 = _head;;
	j5 = _ID;;
	j6 = _CAN;;	
	call _CFBCancmd;;
	
//====打桩自检
/*	xr0 = [j31+_testcnt];;
	xr0 = inc r0;;
	[j31+_testcnt] = xr0;;
	
	xr1 = 5000;;
	comp(r0,r1);;
.align_code 4;
	if nxaeq,jump _no_test_change;;
	xyr0 = l[j31 + _memory_table];;
	xr0 = lshift r0 by 16;;
	xr1 = 0x900;;
	xr0 = r0 or r1;;
	[j31 + _head + CFB_CMDAZ_POSITION] = xr0;;
*/	
	

	
_no_test_change:	
	
//======更新超分辨命令===//
	xr0 = [j31 + _head + CFB_CMDHEAD_POSITION];;
	xr1 = CFB_CMD_HEAD;;
	xcomp(r0,r1);;
.align_code 4;
	if nxaeq,jump _cmd_fresh_over;;
	
	xr0 = [j31 + _head + CFB_CMDTYPE_POSITION];;
	xr1 = CFB_CMD_TYPELEN;;
	xcomp(r0,r1);;
.align_code 4;
	if nxaeq,jump _cmd_fresh_over;;
	
	xr0 = [j31 + _head  + CFB_CMDCNT_POSITION];;
	xr1 = [j31 + _cfbcmd_cnt];;
	xcomp(r0,r1);;
.align_code 4;
	if xaeq,jump _cmd_fresh_over;;
	
	xr0 = [j31 + _head + CFB_CMDAZ_POSITION];;
	xr1 = 0xffff;;
	xr0 = r0 and r1;;
	xr1 = [j31 + _distant];;
	xr2 = [j31 + _distant +1];;
	xcomp(r0,r1);;
.align_code 4;
	if xalt,jump 	_cmd_fresh_over;;
	xcomp(r0,r2);;
.align_code 4;
	if nxale, jump 	_cmd_fresh_over;;
	
	xr0 = [j31 + _head + CFB_CMDPIHAO_POSITION];;
	xr1 = 0x1402;;
	xr0 = fext r0 by r1;;
//打桩	
//	xr0 = 2;;	
	xr1 = CFB_CMD_NAPULSE1;;
	xcomp(r0,r1);;
.align_code 4;
	if  xaeq ,jump _na1_type;;
	xr1 = CFB_CMD_NAPULSE2;;
	xcomp(r0,r1);;
.align_code 4;
	if xaeq,jump _na2_type;;
	xr1 = CFB_CMD_WIPULSE;;
	xcomp(r0,r1);;
.align_code 4;
	if xaeq,jump _wi_type;;
.align_code 4;
	jump _cmd_fresh_over;;
	
_na1_type:
	xr0 = [j31 + _ID + 2];;
	xr1 = 1;;
	xcomp(r0,r1);;
.align_code 4;
	if xaeq,jump _cmd_fresh_over;;
	
_na2_type:
	xr0 = [j31 + _ID + 2];;
	xr1 = 1;;
	xcomp(r0,r1);;
.align_code 4;
	if xaeq,jump _cmd_fresh_over;;
	
_wi_type:
	xr0 = [j31 + _ID + 2];;
	xr1 = 0;;
	xcomp(r0,r1);;
.align_code 4;
	if xaeq,jump _cmd_fresh_over;;					
					

//更新CFB命令
	xr0 = [j31 + _head  + CFB_CMDCNT_POSITION];;	
	[j31 + _cfbcmd_cnt] = xr0;;
		
	j2 = [j31 + _cfbcmd_wrpointer];;
	jb2 = _cfbcmd;;
	jl2 = CFBCMD_MAXCNT*CFBCMD_LENTH;;
	xr0 = [j31 + _head + CFB_CMDHEAD_POSITION];;
	xr1 = [j31 + _head + CFB_CMDTYPE_POSITION];;
	xr2 = [j31 + _head + CFB_CMDCNT_POSITION];;
	xr3 = [j31 + _head + CFB_CMDPIHAO_POSITION];;
	xr4 = [j31 + _head + CFB_CMDAZ_POSITION];;
	xr5 = [j31 + _head + CFB_CMDSPEED_POSITION];;
	cb q[j2+=4] = xr3:0;;
	xr6 = 0;;
	xr7 = 0;;
	cb q[j2+=4] = xr7:4;;
	xr0 = j2;;
	[j31 + _cfbcmd_wrpointer] = xr0;;		//[j31 + _cfbcmd_wrpointer] = j2;;(bug???)	

_cmd_fresh_over:
	







	

//判断是否有命令需要处理//
	j10 = _cfbcmd;;
	lc0 = CFBCMD_MAXCNT;;
	xr0 = CFB_CMD_HEAD;;
	xr2 = 0x00001fff;;
_cmd_find:
	xr1 = [j10 + 0];;
	xcomp(r0,r1);;
.align_code 4;	
	if nxaeq ,jump _next_cmd_find;;
	
.align_code 4;
	jump _cmd_fetch;;	
		
_next_cmd_find:	
	j10 = j10 + CFBCMD_LENTH;;
.align_code 4;
	if nlc0e,jump _cmd_find	;;
	
.align_code 4;
	 jump _no_cfb_cmd;;		

_cmd_fetch:
	xr3:0 = q[j10 + 0];;
	xr7:4 = q[j10 + 4];;
	q[j31 + _cmd + 0] = xr3:0;;
	q[j31 + _cmd + 4] = xr7:4;;
	xr0 = 0;;
	xr1 = 0;;
	xr2 = 0;;
	xr3 = 0;;
	q[j10 + 0] = xr3:0;;
	q[j10 + 4] = xr3:0;;
	
//找到对应的方位及距离及其对应的数据在SDRAM中的位置//
//只考虑顺时针转的情况//
//找前一个方位小于本方位，后一个方位大于本方位的方位值//
//如果没有这种情况，则判断本方位是否大于355°或者小于5°，可能存在过零问题
//如果是，则再次搜索，搜索的方位如果<5°，则加上360°
	xr0  = [j31 +_cmd + TARGET_POSITION_AZCODE];;
	xr1 = 0x1010;;
	xr0 = fext r0 by r1;;
	xr10 = 0x1f8e;;	//	355°
	xr11 = 0x0071;;  //	5°
	xr12 = 0x10000;;//360°
	j3 = [j31+_table_pointer];;
	jb3 = _memory_table;;
	jl3 = CFB_STORAGEBLOCK*CFB_TABLESINGLLEN;;
	
	lc0 = CFB_STORAGEBLOCK;;
_az_find_loop1:
	r1 = cb l[j3 += CFB_TABLESINGLLEN];;
	r2 = cb l[j3 += CFB_TABLESINGLLEN];;
	comp(r0,r1);;
.align_code 4;
	if xalt ,jump _no_right_order1;;
	xcomp(r0,r2);;
.align_code 4;
	if nxale,jump _no_right_order1;;
.align_code 4;
	jump _right_order;;		
		
_no_right_order1:	
.align_code 4;
	if nlc0e, jump 	_az_find_loop1;;	

_az_comp1:
	comp(r0,r10);;
.align_code 4;
	if nxale,jump _az_comp2;;	
.align_code 4;
	jump _end;;
_az_comp2:
	comp(r0,r11);;
.align_code 4;
	if xalt, jump _zero_find;;
.align_code 4;
	jump _end;;							
	
_zero_find://过零问题重新搜索
	xcomp(r0,r11);;
	if xalt;do,xr0 = r0 + r12;;	
	
	j3 = [j31+_table_pointer];;
	jb3 = _memory_table;;
	jl3 = CFB_STORAGEBLOCK*CFB_TABLESINGLLEN;;	
	
	lc0 = CFB_STORAGEBLOCK;;
_az_find_loop2:
	r1 = cb l[j3 += CFB_TABLESINGLLEN];;
	r2 = cb l[j3 += CFB_TABLESINGLLEN];;
	xcomp(r1,r11);;
	if xalt;do,xr1 = r1 + r12;;
	xcomp(r2,r11);;
	if xalt;do,xr2 = r2 + r12;;
	
	comp(r0,r1);;
.align_code 4;
	if xalt ,jump _no_right_order2;;
	xcomp(r0,r2);;
.align_code 4;
	if nxale,jump _no_right_order2;;
.align_code 4;
	jump _right_order;;		
		
_no_right_order2:	
.align_code 4;
	if nlc0e, jump 	_az_find_loop2;;	
	
.align_code 4;
	jump _end;;	
	
//得到正确的位置，然后计算48脉冲在SDRAM中的位置
		 
_right_order:

	xr0 = [j31+_ID + 2];;
	xr1 = 1;;
	xcomp(r0,r1);;
.align_code 4;
	if xaeq,jump _normal_addr;;	
	

_normal_addr:
	j3 = j3-CFB_TABLESINGLLEN*25(cb);;
	[j31 + _rd_para] = j3;;
	
	xr0  = [j31+_cmd + TARGET_POSITION_DISTANT];;
	xr1 = 0x00001fff;;
	xr0 = r0 and r1;;
	
	xr1 = [j31 + _distant ];;//取出进入数据起始
	xr2 = r0 - r1;;
	
	xr3 = CFB_SDRAM_1CH1DIS_LEN;;
	xr4 = r2 * r3 (ui);; 
	xr5 = HEAD_LEN;;
	xr4 = r4 + r5;;//读数据的起始地址
	
	[j31 + _rd_para + 1] = xr4;;
	
	j10 = _sdram_rd_dcs01;;
	j3 = [j31 +_rd_para];;
	jb3 = _memory_table;;
	jl3 = CFB_STORAGEBLOCK*CFB_TABLESINGLLEN;;	
	xr1 = [j31 +_rd_para+1];;//
		
	lc0 = 48;;
_dma_tcb_addr_fill:
	yxr4 = cb l[j3+=CFB_TABLESINGLLEN];;
	xr5 = r4 + r1;;
	[j10+=8] = xr5;;
.align_code 4;
	if nlc0e ,jump 	_dma_tcb_addr_fill;;		  	
	
//==读取DMA地址设置完成，启动链式DMA
	xr0 = 0;;
	[j31 + _Data_rdflag] = xr0;;
	xr3:0 = Q[j31 + _sdram_rd_dcs01];;				
	xr7:4 = Q[j31 + _sdram_rd_dcd01];;				
	DCS0 = xr3:0;;										
	DCD0 = xr7:4;;
	
	xr0 = 1;;
_wait_for_datard_end:
	nop;;nop;;nop;;nop;;
	nop;;nop;;nop;;nop;;
	nop;;nop;;nop;;nop;;
	nop;;nop;;nop;;nop;;
	xr1 = [j31 + _DATARDstack];;
	xcomp(r0,r1);;
.align_code 4;
	if nxaeq, jump 	_wait_for_datard_end;;
	

_data_rd_over:
//==========将拼接的数据还原成浮点数
//在数据缓存插件上，由FPGA和DSP共同完成数据的拼接
//拼接的顺序和输入顺序是由高到低拼接，45字顺序为
//1（第一通道的实部+第一通道的虚部高8位）
//2（第一通道的虚部低16位+第二通道的实部高16位）
//3（第二通道的实部低8位+第二通道的虚部）
//由此类推
//解析后数据结构为低字为实部，高字为虚部，
/*	
		j10 = sdram_data;;
	j11 = cfb_data;;
	k11 = cfb_data + 2*CS_CHS*CFB_RD_PULSE_CNT/2;;
	
	r24 = 0x0818;;
	r25 = 0x0810;;
	r26 = 0x1808;;
	r27 = 0x0018;;
	r28 = 0x1008;;
	r29 = 0x1010;;
	r30 = 0x0018;;
	

	lc0 = CFB_RD_PULSE_CNT/2/4;;//48 脉冲
_data_ana_loop:

	lc1 = 15;;
_data_ana_loop1:	
	xr3:0 = q[j10+=4];;
	yr3:0 = q[k10+=4];;
	xr7:4 = q[j10+=4];;
	yr7:4 = q[k10+=4];;
	xr11:8 = q[j10+=4];;
	yr11:8 = q[k10+=4];;
	
	r18 = fext r0 by r24 (se);;		//第一通道实部
	lr13:12 = rot r1:0 by -8;;	
	r19 = fext r13 by r24 (se);;	//第一通道虚部
	l[j11+=2] = xr19:18;;
	l[k11+=2] = yr19:18;;
	
	r0 = r2;;
	lr13:12 = rot r1:0 by 8;;
	r18 = fext r13 by r30(se);;		//第二通道实部				
	r19 = fext r2 by r27 (se);;		//第二通道虚部
	l[j11+=2] = xr19:18;;
	l[k11+=2] = yr19:18;;
	
	r2 = r4;;
	r18 = fext r3 by r24(se);;		//第三通道实部
	lr13:12 = rot r3:2 by 16;;
	r19 = fext r13 by r30 (se);;	//第三通道虚部
	l[j11+=2] = xr19:18;;
	l[k11+=2] = yr19:18;;
	
	lr13:12 = rot r5:4 by 8;;
	r18 = fext r12 by r27(se);;		//第四通道实部
	r19 = fext r5 by r30(se);;		//第四通道虚部
	l[j11+=2] = xr19:18;;
	l[k11+=2] = yr19:18;;
	
	r18 = fext r6 by r24(se);;		//第五通道实部
	lr13:12 = rot r7:6 by -8;;
	r19 = fext r13 by r24 (se);;	//第五通道虚部		
	l[j11+=2] = xr19:18;;
	l[k11+=2] = yr19:18;;
	
	
	r6 = r8;;
	lr13:12 = rot r7:6 by 8;;	
	r18 = fext r13 by r30 (se);;		//第六通道实部
	r19 = fext r8 by r27 (se);;		//第六通道虚部
	l[j11+=2] = xr19:18;;
	l[k11+=2] = yr19:18;;	
	
	r8 = r10;;
	r18 = fext r9 by r24 (se);;		//第七通道实部
	lr13:12 = rot r9:8 by 16;;
	r19 = fext r13 by r30(se);;		//第七通道虚部			
	l[j11+=2] = xr19:18;;
	l[k11+=2] = yr19:18;;
	
	lr13:12 = rot r11:10 by 8;;
	r18 = fext r12 by r27(se);;		//第八通道实部
	r19 = fext r11 by r30(se);;		//第八通道虚部
	l[j11+=2] = xr19:18;;
	l[k11+=2] = yr19:18;;

.align_code 4;
	if nlc1e,jump _data_ana_loop1;;		
	
.align_code 4;
	if nlc0e,jump _data_ana_loop;;
		
*/
	j10 = sdram_data;;
	j11 = _local_dsp_rsult + HEAD_LEN;;
	lc0 = CFB_DATA_LEN/4;;
_txdata_fill_loop:	
	XR3:0 = Q[j10+=4];;
	q[j11+=4] = xr3:0;;
.align_code 4;
	if nlc0e, jump 	_txdata_fill_loop;;
	

	j10 = [j31 + _rd_para];;
	j10 = [j31 + j10];;//第一个脉冲的sdram地址
	J10 = J10 +4;;
	j11 = _local_dsp_rsult +4;;
	lc0 = HEAD_LEN/4-1;;
_txhead_fill_loop:	
	xr3:0 = q[j10+=4];;
	q[j11+=4] = xr3:0;;
.align_code 4;
	if nlc0e,jump _txhead_fill_loop;;
	
	j11 = _local_dsp_rsult;;
	j10 = [j31 + _rd_para];;
	j10 = [j31 + j10];;//第一个脉冲的sdram地址	
	xr3:0 = q[j10+=4];;
	
	xr8 = 0;;
	xr9 = [j31 + _cmd + TARGET_POSITION_HEAD];;
	xr10 = [j31 + _cmd + TARGET_POSITION_TYPE];;
	xr11 = [j31 + _cmd + TARGET_POSITION_FRAMCNT];;
	q[j11 +8] = xr11:8;;
	xr8 = [j31 + _cmd + TARGET_POSITION_PIHAO];;
	xr9 = [j31 + _cmd + TARGET_POSITION_AZCODE];;
	xr10 = [j31 + _cmd + TARGET_POSITION_WORK];;
	xr11 = [j31 + _cmd + TARGET_POSITION_ANGLE];;
	q[j11+28] = xr11:8;;
	
	xr0 = 0xaaaaaaaa;;
	xr1 = 0x112c0011;;
	xr2 = 0;;
	q[j11+0] = xr3:0;;//最后填入aaaaaaa
_no_cfb_cmd:
.align_code 4;
	jump _end;;


_end:
	xr0 = 0;;
	[j31+_Data_rxflag] = xr0;;//清零接收数据标志	

     
//==========================	
.align_code 4;
	jump _wait;;
	

//=======================PRF标志清零

        
          			    


#include "EC_UserDef.h"
#define BOARD_ID 0x11
//j4 - _head j5_ id j6_ _can

.global _CFBCancmd;
//******************************************************************************
.section program;
_CFBCancmd:
//针头收到后
//CAN anlyse
	if nxaeq,jump _nocan;;
	xr0 = [j4+7];;
	xr2 = 0x1010;;
	xr1 = fext r0 by r2;;
	xr3 = 0x0401;;
	xcomp(r1,r3);;
.align_code 4;
	if nxaeq,jump _nocan;;
	xr3 = [j31 + j5];;
	xr2 = 0x0808;;
	xr1 = fext r0 by r2;;
	xcomp(r1,r3);;
.align_code 4;
	if nxaeq,jump _nocan;;
	
_nocan:
//******************************* Exit Routine	*****************************
.align_code 4;
	CJMP(ABS)(NP);;
	
_CFBCancmd.end:


ORWTPO ; SLC/STAFF Personal Preference - Order Checks ;5/1/01  12:27 [11/29/04 11:19am]
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**85,195**;Dec 17, 1997
 ;
GETOTHER(INFO,USER) ; from ORWTPP
 ; get user's other parameter settings
 S INFO=$$GET^XPAR("ALL^USR.`"_USER,"ORCH INITIAL TAB")
 S INFO=INFO_U_$$GET^XPAR("ALL^USR.`"_USER,"ORCH USE LAST TAB")
 S INFO=INFO_U_$$GET^XPAR("ALL^USR.`"_USER,"ORWOR AUTOSAVE NOTE")
 S INFO=INFO_U_$$GET^XPAR("ALL^USR.`"_USER,"ORWOR VERIFY NOTE TITLE")
 Q
 ;
SETOTHER(OK,INFO,USER) ; from ORWTPP
 ; save user's other parameter settings
 N AUTO,LAST,TAB,VER
 S OK=1
 S TAB=$P(INFO,U),LAST=$P(INFO,U,2),AUTO=$P(INFO,U,3),VER=$P(INFO,U,4)
 I $L(TAB) D EN^XPAR(USER_";VA(200,","ORCH INITIAL TAB",1,TAB)
 I $L(LAST) D EN^XPAR(USER_";VA(200,","ORCH USE LAST TAB",1,$S(LAST:"YES",1:"NO"))
 I $L(AUTO) D EN^XPAR(USER_";VA(200,","ORWOR AUTOSAVE NOTE",1,AUTO)
 I $L(VER) D EN^XPAR(USER_";VA(200,","ORWOR VERIFY NOTE TITLE",1,$S(VER:"YES",1:"NO"))
 Q
 ;
GETTABS(VALUES) ; RPC
 ; get tab names for patient chart
 K VALUES
 D PDSET^ORWTPUP("ORCH INITIAL TAB",.VALUES)
 Q
 ;
CSLABD(INFO) ; RPC
 ; get lab defaults
 N RNG
 S INFO=""
 F RNG="INPT","OUTPT" D
 .S INFO=INFO_$$GET^XPAR("DIV^SYS^PKG","ORQQLR DATE RANGE "_RNG,1,"I")_U
 Q
 ;
CSLAB(VAL,USER) ; from ORWTPP
 ; get user's lab date range defaults
 N RNG
 S VAL=""
 F RNG="INPT","OUTPT" D
 .S VAL=VAL_$$GET^XPAR("USR.`"_USER_"^DIV^SYS^PKG","ORQQLR DATE RANGE "_RNG,1,"I")_U
 Q
 ;
CSARNGD(INFO) ; RPC
 ; get start, stop defaults
 S INFO=$$GET^XPAR("DIV^SYS^PKG","ORQQCSDR CS RANGE START",1,"I")_U
 S INFO=INFO_$$GET^XPAR("DIV^SYS^PKG","ORQQCSDR CS RANGE STOP",1,"I")
 Q
 ;
CSARNG(VAL,USER) ; from ORWTPP
 ; get user's appt date range defaults
 N ORSRV
 S ORSRV=$G(^VA(200,DUZ,5)) I +ORSRV>0 S ORSRV=$P(ORSRV,U) ; Get S/S.
 S VAL=$$GET^XPAR("USR.`"_USER_"^SRV.`"_+$G(ORSRV)_"^DIV^SYS^PKG","ORQQCSDR CS RANGE START",1,"I")_U
 S VAL=VAL_$$GET^XPAR("USR.`"_USER_"^SRV.`"_+$G(ORSRV)_"^DIV^SYS^PKG","ORQQCSDR CS RANGE STOP",1,"I")
 Q
 ;
SAVECS(OK,INFO,USER) ; from ORWTPP
 ; save user's date range defaults
 N INPT,OUTPT,START,STOP
 S OK=1
 S START=+$P(INFO,U,3) S START=$S(START=0:"T",START<0:"T"_START,1:"T+"_START)
 S STOP=+$P(INFO,U,4) S STOP=$S(STOP=0:"T",STOP<0:"T"_STOP,1:"T+"_STOP)
 S INPT=+$P(INFO,U,1),INPT=$S('INPT:"@",1:INPT)
 S OUTPT=+$P(INFO,U,2),OUTPT=$S('OUTPT:"@",1:OUTPT)
 D EN^XPAR(USER_";VA(200,","ORQQCSDR CS RANGE START",1,START)
 D EN^XPAR(USER_";VA(200,","ORQQCSDR CS RANGE STOP",1,STOP)
 D EN^XPAR(USER_";VA(200,","ORQQLR DATE RANGE INPT",1,INPT)
 D EN^XPAR(USER_";VA(200,","ORQQLR DATE RANGE OUTPT",1,OUTPT)
 Q
GETIMGD(INFO) ; RPC
 S INFO=$$GET^XPAR("SRV.`"_+$G(ORSRV)_"^DIV^SYS^PKG","ORCH CONTEXT REPORTS")
 Q
 ;
GETIMG(INFO,USER) ; from ORWTPP
 ; get user's image report defaults
 S INFO=$$GET^XPAR("USR.`"_USER_"^SRV.`"_+$G(ORSRV)_"^DIV^SYS^PKG","ORCH CONTEXT REPORTS")
 Q
 ;
SETIMG(OK,MAX,START,STOP,USER) ; from ORWTPP
 ; save user's image report defaults
 N VALUE S OK=0
 I MAX'>0 Q
 S START=$S(START=0:"T",START<0:"T"_START,1:"T+"_START)
 S STOP=$S(STOP=0:"T",STOP<0:"T"_STOP,1:"T+"_STOP)
 S VALUE=START_";"_STOP_";;;"_MAX
 S OK=1
 D EN^XPAR(USER_";VA(200,","ORCH CONTEXT REPORTS",1,VALUE)
 Q
PRPFPUR1 ;CTB/ALTOONA  PURGE ONE PATIENT FUNDS RECORD ;7/15/97  9:55 AM
V ;;3.0;PATIENT FUNDS;**6,7**;JUNE 1, 1989
ONE(X) ;
 ;PURGE PATIENT FUNDS MASTER TRANSACTION FILE AND PATIENT TRANSACTION
 ;  MULTIPLE FOR ONE PATIENT THRU AND INCLUDING EDATE.
 ;DFN=INTERNAL REFERENCE FOR PATIENT
 ;EDATE=INTERNAL FM DATE, ALL TRANSACTIONS THRU AND INCLUDING THIS
 ;  DATE WILL BE SUMMARIZED AND DELETED.
 ;K ^TMP(UCIJOB,"PRPFPURGE",DFN)
 N DATE,ERROR,PBAL,GBAL,TRDA,TRNODE,MADA,MANODE,BAL,REC,MREC,MRECID,UCIJOB,DFN,EDATE
 S DFN=$P(X,",",1),EDATE=$P(X,",",2)
 X ^%ZOSF("UCI") S UCIJOB=Y_","_$J
 S (DATE,ERROR,PBAL,GBAL,BAL)=0
 F  S DATE=$O(^PRPF(470,DFN,3,"AC",DATE)) Q:DATE=""!(DATE>EDATE)!(ERROR)  D
 . S (TRDA,ERROR)=0
 . F  S TRDA=$O(^PRPF(470,DFN,3,"AC",DATE,TRDA)) Q:TRDA=""  D  Q:ERROR
 . . S ERROR=$$VERIFY(DFN,TRDA,DATE) Q:ERROR
 . . S ^TMP(UCIJOB,"PRPFPURGE",DFN,TRDA)=""
 . . QUIT
 . QUIT
 I ERROR S X="ERROR FOUND IN PROCESSING PURGE FOR "_$P(^DPT(DFN,0),"^",1)_".   <No Purge has occurred for this patient>" D MSG^PRPFU1 Q
 S TRDA=0,REC=0
 F  S TRDA=$O(^TMP(UCIJOB,"PRPFPURGE",DFN,TRDA)) Q:'TRDA  D
 . N TRNODE,TPAMT,TGAMT,TAMT,MADA,MID
 . S TRNODE=^PRPF(470,DFN,3,TRDA,0)
 . S TPAMT=$P(TRNODE,"^",4),TGAMT=$P(TRNODE,"^",5),TAMT=$P(TRNODE,"^",3),MADA=$P(TRNODE,"^",1),MID=$P(^PRPF(470.1,MADA,0),"^")
 . S PBAL=PBAL+TPAMT,GBAL=GBAL+TGAMT,BAL=BAL+TAMT
 . S REC=TRDA,MREC=MADA,MRECID=MID
 . D  ;DELETE MASTER TRANSACTION
 . . N NODE
 . . S NODE=$G(^PRPF(470.1,MADA,0)) Q:NODE=""
 . . I $P(NODE,"^",1)]"" K ^PRPF(470.1,"B",$P(NODE,"^",1),MADA)
 . . I $P(NODE,"^",5)]"" K ^PRPF(470.1,"AD",$P(NODE,"^",4),MADA)
 . . I $P(NODE,"^",6)]"" K ^PRPF(470.1,"AC",$P(NODE,"^",6),MADA)
 . . L +^PRPF(470.1,0):10 I $T S $P(^(0),"^",4)=$P(^PRPF(470.1,0),"^",4)-1 L -^PRPF(470.1,0)
 . . K ^PRPF(470.1,MADA)
 . . QUIT  ;DELETE MASTER TRANSACTION
 . D  ;DELETE PATIENT TRANSACTION
 . . N NODE
 . . S NODE=$G(^PRPF(470,DFN,3,TRDA,0)) Q:NODE=""
 . . I $P(NODE,"^",1)]"" K ^PRPF(470,DFN,3,"B",$P(NODE,"^",1),TRDA)
 . . I $P(NODE,"^",2)]"" K ^PRPF(470,DFN,3,"AC",$P(NODE,"^",2),TRDA)
 . . L +^PRPF(470,DFN,3,0):10 I $T S $P(^(0),"^",4)=$P(^PRPF(470,DFN,3,0),"^",4)-1 L -^PRPF(470,DFN,3,0)
 . . K ^PRPF(470,DFN,3,TRDA)
 . . QUIT  ;DELETE PATIENT TRANSACTION
 . QUIT
 ;ENTER BALANCE CARRIED FORWARD TRANSACTION
 Q:REC=0
 L +^PRPF
 S $P(^PRPF(470.1,0),"^",4)=$P(^PRPF(470.1,0),"^",4)+1
 S $P(^PRPF(470,DFN,3,0),"^",4)=$P(^PRPF(470,DFN,3,0),"^",4)+1
 S ^PRPF(470,DFN,3,REC,0)=MREC_"^"_EDATE_"^"_BAL_"^"_PBAL_"^"_GBAL_"^",^PRPF(470,DFN,3,"B",MREC,REC)="",^PRPF(470,DFN,3,"AC",EDATE,REC)=""
 S X=$O(^PRPF(470.2,"B","BALCARFWD",0))
 S MREC(0)=MRECID_"^"_DFN_"^"_REC_"^"_BAL_"^"_EDATE_"^"_EDATE_"^BALCARFWD^D^3^B^"_X_"^"_PBAL_"^"_GBAL_"^"_DUZ_"^^Balance Carried Forward - Purge"
 S MREC(1)=$P(^VA(200,DUZ,0),"^")
 S STRING=$$SUM^PRPFSIG(MREC_"^"_$P(MREC(0),"^",4,6))
 S $P(MREC(0),"^",15)=$$ENCODE^PRPFSIG(MREC(1),DUZ,STRING)
 S ^PRPF(470.1,MREC,0)=MREC(0),^(1)=MREC(1)
 S ^PRPF(470.1,"B",MRECID,MREC)="",^PRPF(470.1,"AD",EDATE,MREC)="",^PRPF(470.1,"AC",EDATE,MREC)=""
 L -^PRPF
 K ^TMP(UCIJOB,"PRPFPURGE")
 QUIT
 ;
VERIFY(DFN,TRDA,DATE) ;VERIFY INTEGRITY OF INDIVIDUAL PATIENT TRANSACTION
 ;   AND ASSOCIATED MASTER TRANSACTION.
 N TRNODE,ERROR,TDATE,MDATE,MAMT,MPAMT,MGAMT,TGAMT,TAMT,TPAMT,TBAL,MADA,MNODE
 S TRNODE=$G(^PRPF(470,DFN,3,TRDA,0)) I TRNODE="" S ERROR=1 D ERROR Q
 S TDATE=$P(TRNODE,"^",2),TAMT=$P(TRNODE,"^",3),TPAMT=$P(TRNODE,"^",4),TGAMT=$P(TRNODE,"^",5),TBAL=$P(TRNODE,"^",6),MADA=+TRNODE
 S MNODE=$G(^PRPF(470.1,+MADA,0)) I MNODE="" S ERROR=3 D ERROR Q 1
 S MDATE=$P(MNODE,"^",5),MAMT=$P(MNODE,"^",4),MPAMT=$P(MNODE,"^",12),MGAMT=$P(MNODE,"^",13)
 I TDATE=""!(TDATE'=$P(DATE,".")) S ERROR=1 D ERROR Q 1
 I (+TAMT'=+MAMT)!(+TPAMT'=+MPAMT)!(+TGAMT'=+MGAMT) S ERROR=4 D ERROR Q 1
 I MDATE'=TDATE S ERROR=2 D ERROR Q 1
 Q 0
ERROR S X=$P($T(ERROR+ERROR),";",3,99)_" "_TRDA D MSG^PRPFU1 W ! Q
 ;;INVALID 'AC' CROSS REFERENCE IN FILE 470, FIELD 30
 ;;DATE IN TRANSACTION MULTIPLE OF 470 DOES NOT MATCH CROSS REFERENCE
 ;;PATIENT TRANSACTION MULTIPLE POINTS TO INVALID MASTER RECORD
 ;;BALANCES ARE OUT OF DATE BETWEEN MASTER TRANSACTION FILE AND PATIENT TRANSACTION MULTIPLE

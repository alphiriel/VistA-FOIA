FSCFORMY ;SLC/STAFF-NOIS Format Utility Statistics ;1/11/98  15:49
 ;;1.1;NOIS;;Sep 06, 1998
 ;
SETUP(LISTNUM,CALLNUM,STYLE,LINECNT,TYPE) ; from FSCFORMX
 N COLUMN,LINE,MULT,MULTCNT,SECTION,VIDEO
 S STYLE=TYPE_STYLE
 S SECTION=0 F  S SECTION=$O(^TMP("FSC STAT FORMAT",$J,SECTION)) Q:SECTION<1  D
 .I '$L(^TMP("FSC STAT FORMAT",$J,SECTION)) D  Q
 ..F LINE=1:1 Q:$O(^TMP("FSC STAT FORMAT",$J,SECTION,LINE-.1))<1  D  ; formats non sequential lines
 ...S LINECNT=LINECNT+1,^TMP(STYLE,$J,LISTNUM,LINECNT,0)=$G(^TMP("FSC STAT FORMAT",$J,SECTION,LINE)) I (LINECNT#10)=0,'$G(FSCDEV) W "."
 ...S COLUMN=0 F  S COLUMN=$O(^TMP("FSC STAT FORMAT",$J,SECTION,LINE,COLUMN)) Q:COLUMN<1  D
 ....S VIDEO=^TMP("FSC STAT FORMAT",$J,SECTION,LINE,COLUMN) I $L(VIDEO),$D(VALMAR),$D(VALMCC) D CNTRL^VALM10(LINECNT,COLUMN,$P(VIDEO,U),$P(VIDEO,U,2),$P(VIDEO,U,3))
 .S MULT=^TMP("FSC STAT FORMAT",$J,SECTION),MULTCNT=0,LINE=$$START(CALLNUM,STYLE,MULT) F  S LINE=$O(@MULT@(LINE)) Q:LINE<1  D
 ..S MULTCNT=MULTCNT+1
 ..S LINECNT=LINECNT+1,^TMP(STYLE,$J,LISTNUM,LINECNT,0)=$G(@MULT@(LINE,0)) I (LINECNT#10)=0,'$G(FSCDEV) W "."
 S ^TMP(STYLE,$J,LISTNUM)="1^"_LINECNT ; used as VALMCNT for this style
 K ^TMP("FSC STAT FORMAT",$J)
 Q
 ;
VIEW(LISTNUM,CALLNUM,STYLE,LINECNT,TYPE) ; from FSCFORMX
 N COLUMN,LINE,MULT,MULTCNT,SECTION,VIDEO
 S STYLE=TYPE_STYLE
 S LINECNT=LINECNT+1
 S ^TMP(STYLE,$J,LINECNT,0)=$S(STYLE'["STAT":$G(^TMP("FSC LIST CALLS",$J,LISTNUM,0)),1:"COUNTS OF ITEMS")
 S ^TMP(STYLE,$J,"IDX",LISTNUM,LINECNT)=""
 S SECTION=0 F  S SECTION=$O(^TMP("FSC STAT FORMAT",$J,SECTION)) Q:SECTION<1  D
 .I '$L(^TMP("FSC STAT FORMAT",$J,SECTION)) D  Q
 ..F LINE=1:1 Q:$O(^TMP("FSC STAT FORMAT",$J,SECTION,LINE-.1))<1  D  ; formats non sequential lines
 ...S LINECNT=LINECNT+1,^TMP(STYLE,$J,LINECNT,0)=$G(^TMP("FSC STAT FORMAT",$J,SECTION,LINE)) I (LINECNT#10)=0,'$G(FSCDEV) W "."
 ...S COLUMN=0 F  S COLUMN=$O(^TMP("FSC STAT FORMAT",$J,SECTION,LINE,COLUMN)) Q:COLUMN<1  D
 ....S VIDEO=^TMP("FSC STAT FORMAT",$J,SECTION,LINE,COLUMN) I $L(VIDEO),$D(VALMAR),$D(VALMCC) D CNTRL^VALM10(LINECNT,COLUMN,$P(VIDEO,U),$P(VIDEO,U,2),$P(VIDEO,U,3))
 .S MULT=^TMP("FSC STAT FORMAT",$J,SECTION),MULTCNT=0,LINE=$$START(CALLNUM,STYLE,MULT) F  S LINE=$O(@MULT@(LINE)) Q:LINE<1  D
 ..S MULTCNT=MULTCNT+1
 ..S LINECNT=LINECNT+1,^TMP(STYLE,$J,LINECNT,0)=$G(@MULT@(LINE,0)) I (LINECNT#10)=0,'$G(FSCDEV) W "."
 S LINECNT=LINECNT+1,$P(^TMP(STYLE,$J,LINECNT,0),"=",80)=""
 K ^TMP("FSC STAT FORMAT",$J)
 Q
 ;
START(CALLNUM,STYLE,MULT) ; determines start of text
 I STYLE'["BRIEF" Q 0
 I MULT'[",50)" Q 0
 Q $P($G(^FSCD("CALL",CALLNUM,120)),U,6)-1 ; first line of last note
 ;
SETTEXT(SECTION,LINE,COLUMN,TEXT,ON,OFF) ; from FSCFORMX
 S ^TMP("FSC STAT FORMAT",$J,SECTION)="",^TMP("FSC STAT FORMAT",$J,SECTION,LINE)=$$SETSTR^VALM1(TEXT,$G(^TMP("FSC STAT FORMAT",$J,SECTION,LINE)),COLUMN,$L(TEXT))
 I $L($G(ON))!$L($G(OFF)) S ^TMP("FSC STAT FORMAT",$J,SECTION,LINE,COLUMN)=$L(TEXT)_U_$G(ON)_U_$G(OFF)
 Q
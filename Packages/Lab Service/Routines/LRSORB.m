LRSORB ;DALOI/RWF/RLM-SCAN PART OF LRSORA ;7/3/86 12:47 PM
 ;;5.2;LAB SERVICE;**272**;Sep 27, 1994
 ; Reference to $$FMTE^XLFDT supported by IA #10103
 ; Reference to $$NOW^XLFDT supported by IA #10103
 ; Reference to ^DPT supported by DBIA #10035
 ; Reference to ^%ZISC supported by IA #10089
 S LREND=0 G LRLONG:$D(LRLONG) U IO D HDR
DT F LRPDT=LREDT-.01:0 S LRPDT=$O(^LRO(69,LRPDT)) Q:LRPDT<LREDT!(LRPDT>LRSDT)  D LOC Q:LREND
 D ^%ZISC Q
LOC S LRLLOC="" F LRLOX=0:0 S LRLLOC=$O(^LRO(69,LRPDT,1,"AN",LRLLOC)) Q:LRLLOC=""  D PT Q:LREND
 Q
PT F LRDFN=0:0 S LRDFN=$O(^LRO(69,LRPDT,1,"AN",LRLLOC,LRDFN)) Q:LRDFN<1  D LRIDT Q:LREND
 Q
LRIDT F LRIDT=0:0 S LRIDT=$O(^LRO(69,LRPDT,1,"AN",LRLLOC,LRDFN,LRIDT)) Q:LRIDT<1  D LOOK Q:LREND
 Q
LOOK K V S L0=$S($D(^LR(LRDFN,"CH",LRIDT,0)):^(0),1:"") Q:L0=""
 F I=1:1:LRTEST X LRTEST(I) I $T S V(I)=@LRTEST(I,3)
 D PRINT:$O(V(0))'=""
 Q
PRINT S X=^LR(LRDFN,0),LRDPF=$P(X,U,2),DFN=$P(X,U,3) D PT^LRX
 S LRSPEC=+$P(L0,U,5)
 D HDR:$Y>IOSL Q:LREND  W !,PNM,?35,SSN," " W:LRDPF=2 $S($D(^DPT(DFN,.1)):^(.1),1:LRLLOC) W ?60,$P(L0,U,6)
 F I=0:0 S I=$O(V(I)) Q:I<1  W !,?5,LRTEST(I,1),?20," ",$J($P(V(I),U,1),8),$J($P(V(I),U,2),3),"  ",$S($D(^LAB(61,LRSPEC,0)):$P(^(0),U,1),1:"") D:$Y>(IOSL-7) HDR Q:LREND
 Q
HDR U IO D WAIT Q:LREND  W @IOF,"SPECIAL REPORT: SEARCHING FOR ",?30,LRTEST(1,1)," ",LRTEST(1,2)," ",$$FMTE^XLFDT($$NOW^XLFDT,"")
 I LRTEST>1 F I=2:1:LRTEST W:I>1 !,?25," or" W ?30,LRTEST(I,1)," ",LRTEST(I,2)
 D DASH^LRX
 Q
LRLONG U IO D HDR Q:LREND  S LRSDT=9999999-LRSDT,LREDT=9999999-LREDT
 F LRDFN=0:0 S LRDFN=$O(^LR(LRDFN)) Q:LRDFN<1  D NIDT Q:LREND
END K %H,%ZIS,DIC,DTOUT,I,L0,LAST,LRAA,LRAD,LRDFN,LRDPF,LREDT,LREND,LRFAN,LRIDT,LRLAN,LRLLOC,LRLONG,LRLOX,LRPDT,LRSB,LRSDT,LRSPEC,LRSTAR,LRTEST
 K ^TMP("LR",$J,"T"),LRTSTS,LRWDTL,PNM,POP,SSN,V,Y
 D ^%ZISC Q
NIDT F LRIDT=LRSDT:0 S LRIDT=$O(^LR(LRDFN,"CH",LRIDT)) Q:LRIDT=""!(LRIDT>LREDT)  S LRLLOC=$P(^(LRIDT,0),"^",11) D LOOK Q:LREND
 Q
WAIT Q:$E(IOST,1,2)'="C-"  W $C(7) R !!?20,"Press any key to continue, ""^"" to quit.",X:DTIME S:X["^" LREND=1
 Q

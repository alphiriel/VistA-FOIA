YSCEN36 ;DAL/DRF-MH Census Medication Lookup ;4/3/90  10:27 ;
 ;;5.01;MENTAL HEALTH;**37**;Dec 30, 1994
 ;
 ;  Called by routine YSCEN35
EN ;
 I '$D(^PS(55,YSDFN,"P",0)) W !!?23,"** No prescriptions on file **" Q
 D HEAD,EN1,CURRENT G OUT
 Q
EN1 ;
 S YSCRX=0,YSDRUG=0
 S ZZ=0 F  S ZZ=$O(^PS(55,YSDFN,"P",ZZ)) Q:'ZZ  S (YSRXNO,J)=+^(ZZ,0) I $D(^PSRX(YSRXNO,0)) S YSRXGL=^PSRX(YSRXNO,0),YSRXGL2=^(2),YSFDAT=+(^(3)) D STAT S (YSRXNO,J)=$P(YSRXGL,U) D:YSDRT=3 YSDRUG1 D:YSDRT=2 YSDRUG D:YSDRT=1 YSDRUG0
 Q
YSDRUG0 ;
 S X=-45,%DT="" D ^%DT S YSDAT=Y Q:YSFDAT<YSDAT  D YSDRUG
 Q
YSDRUG ;
 Q:ST'="Active"  D YSDRUG1
 Q
YSDRUG1 ;
 S YSRX1=$P(YSRXGL,U,6) Q:'YSRX1  S YSDRUG=$P(^PSDRUG(YSRX1,0),U),YSIG=$P(YSRXGL,U,10),YSQTY=$P(YSRXGL,U,7),YSREM=$P(YSRXGL,U,9)-$P($G(^PSRX(YSRXNO,1,0)),U,4) D YSDRUG2
 Q
YSDRUG2 ;
 S YSPHY=$P($P(^VA(200,($P(YSRXGL,U,4)),0),U),","),YSCF=$J(($P(YSRXGL,U,7)*($P(YSRXGL,U,17))),3,2),YSCF=" unavail" S:YSDRUG'=0 YSCRX=1 D YSDRUG3 ;"When drug cost accurate, remove YSCF=" unavail", replace with YSCF
 Q
YSDRUG3 ;
 D DATE S YSPYST0=$P(YSRXGL,U,3),YSPST=$S(YSPYST0="7":"Pass",YSPYST0="17":"Self",YSPYST0="1":"SC",YSPYST0="3":"SC<50%",YSPYST0="5":"OptNSC",YSPYST0="9":"Inpt",YSPYST0="11":"Reg D/C",YSPYST0="15":"AmbCare",1:"Z")
 I YSPST="Z" S YSPST=$S(YSPYST0="4":"PenNSC",YSPYST0="2":"A&A/WWI",YSPYST0="6":"OthFed",YSPYST0="8":"AA>96hr",YSPYST0="10":"Emplye",YSPYST0="12":"NBC",YSPYST0="13":"PBC",YSPYST0="14":"CNH",YSPYST0="18":"HB/HC",1:"Other")
 D WRITE
 Q
WRITE ;
 I (IOST["P-")&($Y>(IOSL-9)) W @IOF D HEAD
WRITE0 ;
 S (YSCNT,YSCTN)=0 W !,YSRXNO G:$L(YSDRUG)>30 DWRAP I YSCTN<1 W ?9,YSDRUG G WRITE1
 Q
WRITE1 ;
 W ?42,$E(YSPHY,1,10),?53,YSWDAT,?65,YSQTY,?70,YSPST,?77,YSREM G:YSCTN<1 WRITE2
 Q
WRITE2 ;
 G:$L(YSIG)>32 WRAP W !?2,"Sig: ",YSIG W:YSDRT=3 ?40,"RxStat: ",ST W ?59,"Cost/Fill: $",YSCF
 Q
HEAD ;
 W !!," RxNo" W:YSDRT=1 ?11,"Current Active Prescriptions" W:YSDRT=2 ?13,"Active Prescriptions" W:YSDRT=3 ?12,"Prescriptions on File" W ?43,"Phys",?52," Filldate",?63,"#Disp",?69,"Type",?76,"Rem"
HEAD1 W !,"-----" W:YSDRT=1 ?11,"----------------------------" W:YSDRT=2 ?13,"--------------------" W:YSDRT=3 ?12,"----------------------" W ?43,"----",?53,"--------",?63,"-----",?69,"----",?76,"---"
 Q
DATE ;
 S YSWDAT=$$FMTE^XLFDT(YSFDAT,"5ZD")
 Q
CURRENT ;
 I YSCRX=0 W:YSDRT=1 !!?10,"** No Current Active Prescriptions on File **" W:YSDRT=2 !!?10,"** No Active Prescriptions on File **" W:YSDRT=3 !!?10,"** No Prescriptions on File **"
 Q
OUT ;
 K YSCF,YSCHAR,YSCNT,YSCRX,Y,YSDRUG,YSDRUG2,YSFDAT,YSLDRUG,I,J,YSKK,YSLIG,YSLL,YSPHY,YSPST,YSQTY,YSDAT,YSIG,YSIG1,YSREM,YSRX1,YSRXGL,YSRXGL2,YSRXNO,ST,YST0,YSWDAT,X
 Q
STAT ;
 S YST0=$P(YSRXGL,U,15) D:YST0<12&($D(^PS(52.5,"B",J))) STAT1 S:YST0<12&(DT>$P(YSRXGL2,U,6)) YST0=11
 S ST=$P("Error^Active^Fill^Refill Fill^Hold^^Suspended^^^^^Done^Expired^Cancelled",U,YST0+2),YSRXGL=$P(YSRXGL_"^^^^^^^^^^^^",U,1,14)_U_YST0_U_$P(YSRXGL,U,16,99)
 Q
STAT1 ;
 I $O(^PS(52.5,"B",J,0)),$D(^PS(52.5,$O(^(0)),0)),'$D(^("P")) S YST0=5
 Q
WRAP ;
 S YSCNT=YSCNT+1,YSLIG=$L(YSIG),YSIG1="" F YSKK=1:1:YSLIG S YSCHAR=$E(YSIG,YSKK) Q:(YSCHAR=$C(32)&(YSKK>25))  S YSIG1=YSIG1_YSCHAR
 W:YSCNT=1 !?2,"Sig:" W:YSCNT>1 ! W ?7,YSIG1 W:(YSCNT=1)&(YSDRT=3) ?40,"RxStat: ",ST W:(YSCNT=1) ?59,"Cost/Fill: $",YSCF S YSIG=$E(YSIG,(YSKK+1),YSLIG) G:$L(YSIG)>32 WRAP W:$L(YSIG)'>32 !?7,YSIG
 Q
DWRAP ;
 S YSCTN=YSCTN+1 S YSLDRUG=$L(YSDRUG),YSDRUG2="" F YSLL=1:1:YSLDRUG S YSCHAR=$E(YSDRUG,YSLL) Q:(YSCHAR=$C(32)&(YSLL>22))  S YSDRUG2=YSDRUG2_YSCHAR
 W:YSCTN>1 ! W ?9,YSDRUG2 D:YSCTN=1 WRITE1 S YSDRUG=$E(YSDRUG,(YSLL+1),YSLDRUG) G:$L(YSDRUG)>30 DWRAP W:$L(YSDRUG)'>30 !?9,YSDRUG
 I YSCTN>0 G WRITE2
 Q

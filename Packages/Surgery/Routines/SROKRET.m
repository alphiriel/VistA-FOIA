SROKRET ;B'HAM ISC/MAM - KILL RETURNS, 'AL' X-REF ; [ 09/09/03  7:30 AM ]
 ;;3.0; Surgery ;**100**;24 Jun 93
 S SRET=0,DFN=$P(^SRF(DA,0),"^") F I=0:0 S SRET=$O(^SRF("B",DFN,SRET)) Q:'SRET  I $D(^SRF(SRET,29,DA,0)) K ^SRF(SRET,29,DA,0) D UPDATE
 K ^SRF("AL",DA)
 Q
UPDATE I '$O(^SRF(SRET,29,0)) K ^SRF(SRET,29) Q
 S CNT=0 F I=0:0 S CNT=$O(^SRF(SRET,29,CNT)) Q:'CNT  S SRET1=CNT
 S $P(^SRF(SRET,29,0),"^",3)=SRET1,$P(^SRF(SRET,29,0),"^",4)=$P(^(0),"^",4)-1
 Q
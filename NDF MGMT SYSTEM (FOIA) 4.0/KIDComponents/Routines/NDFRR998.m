NDFRR998 ;BIRM/WRT - Auto matching (mapping) between file #50.67,50.68 and file #50.628 (FDB file).; 06/03/03 15:12
 ;;4.0; NDF MANAGEMENT;**62**; 1 Jan 99
START ; Ask if want to do auto-match within NDF Management
 W ! S DIR("A")="Do you want to attempt an auto-match? "
 S DIR(0)="YA" D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) W "  No Auto-Match Attempted" H 1.75 S ASKHIM=0 Q
 I Y=0 S ASKHIM=Y Q
 S ASKHIM=Y W !!,"Attempting a match...",!
 D AUTONDFM W:'$G(AUTO) "  No Matches Found." H 1.75
 ; K IFN,IEN,REC,GCN,PREVGCN,NDCLINK,VAP,GCNO,DAT,DAT1,NDC,NDC1,SEQNO
 Q
AUTONDFM ;
 S IEN=$S($D(NDFNAME):$P(NDFNAME,"^"),1:"") I IEN S DAT=$P($G(^PS(50.68,IEN,7)),"^",3) I 'DAT!(DAT>DT) D NUPN
 Q
NUPN S FLAGIT=0,IFN=0 F  S IFN=$O(^PSNDF(50.68,"ANDC",IEN,IFN)) Q:'IFN  S DAT1=$P($G(^PSNDF(50.67,IFN,0)),"^",7) I 'DAT1!(DAT1>DT) S NDC=$P(^PSNDF(50.67,IFN,0),"^",2),NDC1=$E(NDC,2,12) D FDB
 Q
FDB Q:FLAGIT  I $D(^PS(50.628,"B",NDC1)) S REC=$O(^PS(50.628,"B",NDC1,0)),AMATCH=NDC,ASEQNO=$P(^PS(50.628,REC,0),"^",2),ANODE=^PS(50.628,REC,0),OGCN=$P($G(^PSNDF(50.68,IEN,1)),"^",6) D STUFF Q:FLAGIT
 Q
STUFF Q:FLAGIT  S ADESC=ASEQNO_" "_$P(ANODE,"^",3)_" "_$P(ANODE,"^",4)_" "_$P(ANODE,"^",5),AUTO=ASEQNO_"^"_REC_"^"_ADESC_"^"_AMATCH_"^"_OGCN S FLAGIT=1 Q
 Q
SHOW K ^TMP("NDFD",$J,"FDBLINK"),BILLWILL D SHOWEM,SHOWEM1
 Q
SHOWEM ; Come from new added NDCs
 I $G(^TMP("NDFD",$J,"NDFDIG")) S BILL=$P($G(^TMP("NDFD",$J,"NDFDIG")),"^") S NUM=0 F  S NUM=$O(^TMP("NDFD",$J,NUM)) Q:'NUM  S WILL=$P($G(^TMP("NDFD",$J,NUM,"NDF2DIG")),"^") S BILLWILL=BILL_WILL,BILLWILL=$E(BILLWILL,2,12) D SHOWDON
 Q
SHOWDON I $D(^PS(50.628,"B",BILLWILL)) S ITT=1 S RECRD=$O(^PS(50.628,"B",BILLWILL,0)) S FDB=^PS(50.628,RECRD,0) S ^TMP("NDFD",$J,"FDBLINK")=$P(FDB,"^")_" "_$P(FDB,"^",2)_" "_$P(FDB,"^",3)_" "_$P(FDB,"^",4)_" "_$P(FDB,"^",5)
 Q
SHOWEM1 I $G(^TMP("NDFD",$J)),'$G(^TMP("NDFD",$J,"NDFDIG")) S ITT=0,PPP=0 F  S PPP=$O(^TMP("NDFD",$J,PPP)) Q:PPP[","  S BILLWILL=$P($G(^TMP("NDFD",$J,PPP,"50.67,1")),"^"),BILLWILL=$E(BILLWILL,2,12) D SHOWDON Q:ITT
 Q

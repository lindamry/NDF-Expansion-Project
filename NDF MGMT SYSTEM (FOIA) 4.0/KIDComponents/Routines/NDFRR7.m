NDFRR7 ;BIR/RSB-NDC ENTER EDIT ; 06/03/03 15:07
 ;;4.0; NDF MANAGEMENT;**62**; 1 Jan 99
 ;
 ; prompt for NDC entry.
NDC ;
 K NDFNDC,NDFPCNT,NDFUPN D CLEAN^NDFRR10
NDC1 W @IOF K DIR S DIR(0)="FO",DIR("A")="Enter the 10 character NDC"
 K NDFGO,NDFUPN,NDFUPNI,NDFLIST,NDFEDIT2,NDFVAPD,^TMP("NDFD",$J)
 S DIR("?")="Enter the 10 character NDC number.  Enter ""UPN"" to enter a new UPN" D ^DIR K DIR Q:Y<0
 I $D(DTOUT)!($D(DUOUT)) Q
 I X="" Q
 I X="UPN" G ^NDFRR10 Q
 I X'?1.10N!($L(X)>10)!($L(X)<10) W !,"Answer must be a ten digit number or ""UPN""" H 1 G NDC1 Q
 ;
 S NDFPCNT=0,NDFGO=0
 S NDFNDC=X I $$BUILD2^NDFRR8 D  W !
 .S DIR(0)="SO^A:Add new NDCs;E:Edit existing NDCs" N X,Y D ^DIR Q:$D(DUOUT)!($D(DTOUT))!(Y=-1)
 .I Y="E" D EN^VALM("NDF RSB NDC A/E") S NDFGO=1
 .I $G(Y)="A" S NDFGO=2
 I $G(NDFGO)=1 G NDC
 I $$ADD^NDFRR1(X,"NDC") S (^TMP("NDFD",$J,"NDFDIG"),NDFNDC)=X ; record good 10 digit entry
 E  G NDC
 G 1
 ;
UPN ; ENTER NEW UPN
 S (NDFM,X)=$$GET^NDFRR1(50.67,2,$S($D(^TMP("NDFD",$J,NDFPCNT,"50.67,2")):^TMP("NDFD",$J,NDFPCNT,"50.67,2"),1:""),0,"UPN")
 I $D(NDFABORT)&('$D(NDFEDIT2)) Q
 I $D(NDFABORT)&($D(NDFEDIT2)) Q
 I NDFM=""&('$D(NDFNDC))&('$D(NDFEDIT2)) Q
 I NDFM=""&($D(NDFNDC)) G 5
 ;I NDFM=""&($D(NDFEDIT2)) Q
 I '$$CK^NDFRR1(50.67,2,NDFM) D HLP^NDFRR1(50.67,2) G UPN
 I $$CK^NDFRR1(50.67,2,NDFM) S (^TMP("NDFD",$J,NDFPCNT,"50.67,2"),NDFUPN)=NDFM G 5
 Q:$D(NDFEDIT2)
 ;
1 ; get 2 character package code
 K DIR S DIR(0)="NO",DIR("A")="Enter the 2 character package code"
 S DIR("?")="Enter the 2 character package code" D ^DIR K DIR Q:Y<0
 I $D(DTOUT)!($D(DUOUT)) G ^NDFRR7
 I X=""&($D(^TMP("NDFD",$J,1,"NDF2DIG"))) G 6
 I X=""&('$D(^TMP("NDFD",$J,1,"NDF2DIG"))) G NDC
 I X'?2N!($L(X)>2)!($L(X)<2) W !,"Answer must be a 2 digit number" G 1
 I $D(^PSNDF(50.67,"NDC",$G(NDFNDC)_X))!($D(NDFLIST(X))) W !,"Number already used!" G 1
 I $$ADD^NDFRR1(X,"PACKAGE CODE") S NDFPCNT=NDFPCNT+1 K ^TMP("NDFD",$J,NDFPCNT) S (NDFLIST(X),^TMP("NDFD",$J,NDFPCNT,"NDF2DIG"))=X ; record good 2 digit entry
 E  G 1
 Q:$D(NDFEDIT2)
 ;
2 ; get Package Size
 N NDFY
 S NDFC=$G(^TMP("NDFD",$J,"50.67,8")),NDFCC=(NDFC'["|NEW")
 S (NDFM,X)=$$GET^NDFRR1(50.609,.01,$S(NDFCC:$S($D(^TMP("NDFD",$J,NDFPCNT,"50.67,8")):$P(^PS(50.609,^TMP("NDFD",$J,NDFPCNT,"50.67,8"),0),"^"),1:""),1:$P(NDFC,"|")),1,"Package Size") K NDFC,NDFCC
 I $D(NDFABORT)&('$D(NDFEDIT2)) G ^NDFRR7
 I $D(NDFABORT)&($D(NDFEDIT2)) G EXIT^NDFRR2A
 I NDFM="" Q
 K DIC S DIC=50.609,DIC(0)="EMZ" D ^DIC
 I Y=-1 I '$$CK^NDFRR1(50.609,.01,NDFM) D HLP^NDFRR1(50.609,.01) G 2
 I Y=-1 S NDFY=$$ADD^NDFRR1(NDFM,"PACKAGE SIZE") I NDFY S ^TMP("NDFD",$J,NDFPCNT,"50.67,8")=NDFM_"|NEW"
 I $G(NDFY)=0 G 2
 I Y=-1&($G(NDFY)=0) G 2
 I +Y>0 S NDFM=$S(Y["^":+Y,1:Y) S ^TMP("NDFD",$J,NDFPCNT,"50.67,8")=NDFM
 ;
3 ; get Package Type
 N NDFY
 S NDFC=$G(^TMP("NDFD",$J,NDFPCNT,"50.67,9")),NDFCC=(NDFC?1.9N)
 S (NDFM,X)=$$GET^NDFRR1(50.608,.01,$S(NDFCC:$S($D(^TMP("NDFD",$J,NDFPCNT,"50.67,9")):$P(^PS(50.608,^TMP("NDFD",$J,NDFPCNT,"50.67,9"),0),"^"),1:""),1:NDFC),1,"Package Type") K NDFC,NDFCC
 I $D(NDFABORT)&('$D(NDFEDIT2)) G ^NDFRR7
 I $D(NDFABORT)&($D(NDFEDIT2)) G EXIT^NDFRR2A
 I NDFM="" Q
 K DIC S DIC=50.608,DIC(0)="EMZ" D ^DIC
 I Y=-1 I '$$CK^NDFRR1(50.608,.01,NDFM) D HLP^NDFRR1(50.608,.01) G 3
 I Y=-1 S NDFY=$$ADD^NDFRR1(NDFM,"PACKAGE TYPE") I NDFY S ^TMP("NDFD",$J,NDFPCNT,"50.67,9")=NDFM
 I $G(NDFY)=1 G 4
 I Y=-1&('$G(NDFY)) G 3
 I +Y>0 S NDFM=$S(Y["^":+Y,1:Y) S ^TMP("NDFD",$J,NDFPCNT,"50.67,9")=NDFM
 ;
4 ; prompt for UPN if NDC was entered
 I $D(NDFNDC) D UPN Q
 ;
5 ; get OTX/RX Indicator
 K DIR
 S:$D(^TMP("NDFD",$J,"50.67,10")) DIR("B")=$$EXTERNAL^DILFD(50.67,10,"",$G(^TMP("NDFD",$J,"50.67,10")))
 S DIR(0)="50.67,10" D ^DIR
 I $D(DTOUT)!($D(DUOUT))&(($D(NDFEDIT2))) G EXIT^NDFRR2A
 I $D(DTOUT)!($D(DUOUT))&(('$D(NDFEDIT2))) G ^NDFRR7
 ;I X="" W "  (Required)" G 17
 I Y>-1 S ^TMP("NDFD",$J,"50.67,10")=Y
 Q:$D(NDFEDIT2)
 ;
 G 1  ; ask for another 2 character package code
 ;
6 ; get Manufacturer
 I $D(NDFNDC) S NDFDEF=$O(^PS(55.95,"C",$E(NDFNDC,1,6),0))
 I $D(NDFNDC) S:NDFDEF NDFDEF=$P(^PS(55.95,+NDFDEF,0),"^")
 E  S NDFDEF=""
 S NDFC=$G(^TMP("NDFD",$J,"50.67,3")),NDFCC=(NDFC?1.9N)
 S (NDFM,X)=$$GET^NDFRR1(55.95,.01,$S(NDFCC:$P(^PS(55.95,^TMP("NDFD",$J,"50.67,3"),0),"^"),$L(NDFC)>1:$P(NDFC,"^"),$L(NDFDEF):NDFDEF,1:""),1,"Manufacturer") K NDFC,NDFCC,NDFDEF
 I $D(NDFABORT)&('$D(NDFEDIT2)) G ^NDFRR7
 I $D(NDFABORT)&($D(NDFEDIT2)) G EXIT^NDFRR2A
 I NDFM="" Q
 K DIC,NDFY S DIC=55.95,DIC(0)="EMZ" D ^DIC
 I Y=-1 I '$$CK^NDFRR1(55.95,.01,NDFM) D HLP^NDFRR1(55.95,.01) G 6
 I Y=-1 S NDFY=$$ADD^NDFRR1(NDFM,"MANUFACTURER") I NDFY S ^TMP("NDFD",$J,"50.67,3")=NDFM
 I $G(NDFY)=1 G 7
 I Y=-1&('$G(NDFY)) G 6
 I +Y>0 S NDFM=$S(Y["^":+Y,1:Y) S ^TMP("NDFD",$J,"50.67,3")=NDFM
 Q:$D(NDFEDIT2)
 G 8
 ;
7 ; prompt for NDC Identifier for new Manufacturer
 S (NDFM,X)=$$GET^NDFRR1(55.95,1,$E($G(NDFNDC),1,6),1,"NDC Identifier")
 I $D(NDFABORT)&('$D(NDFEDIT2)) G ^NDFRR7
 I $D(NDFABORT)&($D(NDFEDIT2)) G EXIT^NDFRR2A
 ;I NDFM=""&('$D(NDFEDIT2)) G 8
 ;I NDFM=""&($D(NDFEDIT2)) Q
 I '$$CK^NDFRR1(55.95,1,NDFM) D HLP^NDFRR1(55.95,1) G 7
 I $$CK^NDFRR1(55.95,1,NDFM) S $P(^TMP("NDFD",$J,"50.67,3"),"^",2)=NDFM
 Q:$D(NDFEDIT2)
 ;
8 ; get Trade Name
 S (NDFM,X)=$$GET^NDFRR1(50.67,4,$G(^TMP("NDFD",$J,"50.67,4")),0,"Trade Name")
 I $D(NDFABORT)&('$D(NDFEDIT2)) G ^NDFRR7
 I $D(NDFABORT)&($D(NDFEDIT2)) G EXIT^NDFRR2A
 ;I NDFM=""&('$D(NDFEDIT2)) G 8
 ;I NDFM=""&($D(NDFEDIT2)) Q
 I '$$CK^NDFRR1(50.67,4,NDFM) D HLP^NDFRR1(50.67,4) G 8
 I $$CK^NDFRR1(50.67,4,NDFM) S ^TMP("NDFD",$J,"50.67,4")=NDFM
 Q:$D(NDFEDIT2)
 ;
88      ;  Route of Administration
 S CNT=0
888 S (NDFM,X)=$$GET^NDFRR1(51.2,.01,"",0,"Route of Administration")
 I $D(NDFABORT)&('$D(NDFEDIT2)) G ^NDFRR7
 I $D(NDFABORT)&($D(NDFEDIT2)) G EXIT^NDFRR2A
 ;I NDFM=""&($D(^TMP("NDFR",$J,"50.6816,.01")))&('$D(NDFEDIT2)) G 9
 ;I NDFM=""&($D(^TMP("NDFR",$J,"50.6816,.01")))&($D(NDFEDIT2)) Q
 I NDFM=""&('$D(NDFEDIT2)) G 9
 I NDFM=""&($D(NDFEDIT2)) Q
 K DIC S DIC=51.2,DIC(0)="EMZ" D ^DIC
 I Y=-1 D  G 888
 .D HLP^NDFRR1(51.2,.01)
 S NDFM=Y(0,0),CNT=CNT+1 S ^TMP("NDFD",$J,"50.676,.01",CNT)=NDFM G 888
 I '$D(^TMP("NDFD",$J,"50.676,.01")) W "  (Required)" G 888
 G 888
 ;
9 ; get VA Product Name
 I $D(NDFNDC) D FIND
 ; D SHOWEM^NDFRR998
 D ^NDFRR2
 I $D(NDFABORT) Q
 I '$D(^TMP("NDFD",$J,"50.67,5")) G 9
 D EN^VALM("NDF RSB NDC A/E") G NDC
 Q
 ;
FIND ;
 S NDFL=NDFNDC,NDFX=NDFL_"00" F  S NDFX=$O(^PSNDF(50.67,"NDC",NDFX)) Q:NDFX=""!($E(NDFX,1,10)'=NDFL)  D
 .F NDF1=0:0 S NDF1=$O(^PSNDF(50.67,"NDC",NDFX,NDF1)) Q:'NDF1!($D(NDFVAPD))  D
 ..S NDFVAPD=$P(^PSNDF(50.67,NDF1,0),"^",6)
 ..S NDFVAPD=$P(^PSNDF(50.68,+NDFVAPD,0),"^")
 Q
 ;
E ; edit multiple package codes
 ;
 W ! K DIR
 S DIR("A",1)="Only "_$S($D(NDFNDC):"Product Codes",1:"UPNs")_" that have just been entered may be deleted."
 S DIR("A")="Do you wish to Edit or Delete Package Code: "_$S($D(^TMP("NDFD",$J,NDFANS,"NDF2DIG")):^TMP("NDFD",$J,NDFANS,"NDF2DIG"),1:$E(^TMP("NDFD",$J,NDFANS,"50.67,1"),11,12))_" ?"
 S DIR(0)="SBOM^E:Edit entries;D:Delete entries" D ^DIR K DIR
 I Y="E" D 2^NDFRR9 Q
 I Y="D" D EDEL Q
 Q
EDEL ;
 I $D(^TMP("NDFD",$J,NDFANS,"50.67,SEQ")) W !,"Can't be deleted from file." H .6 Q
 K ^TMP("NDFD",$J,NDFANS) W !?15," (Deleted)" H .6
 Q
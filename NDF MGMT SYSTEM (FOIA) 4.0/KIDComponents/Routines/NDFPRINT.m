NDFPRINT ;BIR/DMA-VA FileMan print and search from files 50.67 & 50.68 ; 09 Aug 2006  9:06 AM
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
 ;
PRINT ;
 S DIR(0)="SA^G:VA GENERIC;P:VA PRODUCT;N:NDC/UPN",DIR("A")="Print from VA Generic (G) VA Product (P) or NDC/UPN (N) " D ^DIR G END:$D(DIRUT)
 S DIC=$S(Y="P":"^PSNDF(50.68,",Y="N":"^PSNDF(50.67,",1:"^PSNDF(50.6,"),L=0,DIASKHD="" D EN1^DIP G END
 ;
SEARCH ;
 S DIR(0)="SA^G:VA GENERIC;P:VA PRODUCT;N:NDC/UPN",DIR("A")="Search (G) VA Generic VA Product (P) or NDC/UPN (N) " D ^DIR G END:$D(DIRUT)
 S DIC=$S(Y="P":"^PSNDF(50.68,",Y="N":"^PSNDF(50.67,",1:"^PSNDF(50.6,") D EN^DIS
 ;
END K DIASKHD,DIR,DIC,L,X,Y Q
 ;
 ;
INT ;PRINT INTERACTIONS
 D EN^XUTMDEVQ("ENP^NDFPRINT","PRINT INTERACTIONS") Q
 ;
ENP ;QUEUED ENTRY FOR INTERACTIONS
 S PAGE=1,TODAY=$$HTE^XLFDT(+$H) D HEAD
 S NA="" F  S NA=$O(^PS(56,"B",NA)),DA=0 Q:NA=""  F  S DA=$O(^PS(56,"B",NA,DA)) Q:'DA  S X=^PS(56,DA,0),A=$P(X,"^"),IN=$P(X,"^",7),Y=$P(X,"^",4),C=$P(^DD(56,3,0),"^",2) D Y^DIQ D
 .S ENT="",EN1=$O(^DIA(56,"B",DA,0)) I EN1 S X=^DIA(56,EN1,0) I $P(X,"^",5)="A" S ENT=$P(X,"^",2)\1
 .W !,A,?55,$E(Y,1,4),?60,$J($$FMTE^XLFDT(ENT,2),9),?68," ",$J($$FMTE^XLFDT(IN,2),9) I $Y+4>IOSL D HEAD
 K PAGE,TODAY,NA,DA,X,Y,A,C,EN1,ENT D ^%ZISC Q
 ;
HEAD W:$Y @IOF W !,?20,"INTERACTIONS",?IOM-11," Page ",PAGE,!,"Printed on ",TODAY,!,?5,"INGREDIENTS",?56,"SEV",?62,"ENTER",?72,"INACT",! S PAGE=PAGE+1 Q
 ;
PRODP ;PRINT PRODUCTS AND RESTRICTIONS
 D EN^XUTMDEVQ("ENP1^NDFPRINT","PRINT VA PRODUCTS") Q
 ;
ENP1 ;QUEUED ENTRY FOR PRODUCTS
 K ^TMP($J) S DA=0 F  S DA=$O(^PS(51.7,DA)) Q:'DA  S A=$P(^(DA,0),"^"),T=^(2,1,0),^TMP($J,T)=A
 ;
 S PAGE=1,TODAY=$$HTE^XLFDT(+$H) D HEAD1
 S NA="" F  S NA=$O(^PSNDF(50.68,"B",NA)),DA=0 Q:NA=""  F  S DA=$O(^PSNDF(50.68,"B",NA,DA)) Q:'DA  S A=$P(^PSNDF(50.68,DA,0),"^"),B=$G(^(5)),C=$G(^(6,1,0)) D
 .S T="" I C]"" S T=$G(^TMP($J,C))
 .W ?5,A,?70,B,?90,T,! I $Y+4>IOSL D HEAD1
 K DA,A,T,PAGE,TODAY,NA,DA,A,B,C,^TMP($J) D ^%ZISC Q
 ;
HEAD1 W:$Y @IOF W !,?25,"VA PRODUCTS",?IOM-15,"Page ",PAGE,!,"Printed on ",TODAY,!,?20,"PRODUCT",?66,"INDICATOR",?88,"RESTRICTION",!! S PAGE=PAGE+1 Q
 ;
NEW ;FILEMAN PRINT OF NEW PRODUCTS
 ;S DIC=5000.506,L="LIST OF NEW PRODUCTS",BY=.01,FR="",TO="",FLDS="[DON PRINT]" D EN1^DIP Q
 D ^NDFNPRT
 Q
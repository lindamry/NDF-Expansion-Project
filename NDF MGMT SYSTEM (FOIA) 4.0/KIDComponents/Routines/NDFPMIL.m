NDFPMIL ;BIR/DMA-LIST PRODUCTS AND PMIS ; 26 Nov 2007  1:34 PM
 ;;4.0; NDF MANAGEMENT;****; 1 Jan 99
 N DA,GNC,NA,NDC,PM
 D ^%ZIS Q:POP
 S DA=0 F  S DA=$O(^PSNDF(50.68,DA)) Q:'DA  S NDC=$P($G(^(DA,1)),"^",7) I NDC]"" S NA=$P(^(0),"^") D
 .S GNC=$O(^PS(50.628,"B",$E(NDC,2,12),0)) I GNC]"" S PM=$P(^PS(50.628,GNC,0),"^",3) I $P(NA," ")'=$P(PM," ") W !,NA,!,?8,PM,!
 K DA,GNC,NA,NDC,PM Q

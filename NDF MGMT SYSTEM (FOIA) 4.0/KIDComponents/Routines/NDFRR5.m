NDFRR5 ;BIR/RSB - VA Product Enter/Edit ; 23 Jun 2009  9:14 AM
 ;;4.0;NDF MANAGEMENT;**62,70,108,262**; 1 Jan 99
 ;
EDIT ;
 S VALMBCK="R"
 K NDFY N NDFN,Q,NDFB1
EFA ;
 K NDFE S NDFY="" R !!,"Select FIELDS TO EDIT: ",NDFX:DTIME E  W $C(7) S NDFX="^" Q
 I "^"[NDFX Q
 I NDFX="??" D FULL^VALM1,H2 G EFA
 I NDFX?1."?" D FULL^VALM1,H2 G EFA
 ;I  G FDONE
 S NDFB1=NDFX
 I NDFB1["," F NDFN=1:1:$L(NDFB1,",") S NDFX=$P(NDFB1,",",NDFN) Q:'NDFX!(NDFX="")  D  Q:$D(NDFE)
 .I $E(NDFX,1,2)="12" S NDFX=+NDFX
 .I NDFX'=+NDFX!(NDFX>26)!(NDFX<1) W " ??" S NDFE=1 H .3
 G:$D(NDFE) EFA
 I NDFB1["," F NDFN=1:1:$L(NDFB1,",") S NDFX=$P(NDFB1,",",NDFN) Q:'NDFX!(NDFX="")  D FDONE
 Q:NDFB1[","
 S NDFX=NDFB1
 I $E(NDFX,1,2)="12" S NDFX=+NDFX
 I NDFX'=+NDFX!(NDFX>26)!(NDFX<1) W " ??" S NDFE=1 H .3 G EFA
 D FDONE
 Q
 ;
FDONE   ;
 S NDFY=NDFX D EDIT1
 Q
H2 ;
 W !,"Enter the field to edit (1-26) or multiple fields separated by commas.",!," Example: 4,5,20" Q
EDIT1 ;
 D FULL^VALM1
 ;W ! N NDFX F Q=1:1 S Q1=$P(NDFY,",",Q) Q:'Q1  S NDFX=$P($T(@(Q1)),";;",2) D @NDFX
 W ! N NDFX S NDFX=$P($T(@(NDFY)),";;",2) D @NDFX
 Q
 ;
FIELDS ;
1 ;;199^NDFRR2A
2 ;;5^NDFRR2
3 ;;6^NDFRR2
4 ;;7^NDFRR2
5 ;;8^NDFRR2
6 ;;9^NDFRR2
7 ;;10^NDFRR2
8 ;;11^NDFRR2
9 ;;13^NDFRR22
10 ;;12^NDFRR22
11 ;;14^NDFRR22
12 ;;ING^NDFRR2A
13 ;;15^NDFRR2A
14 ;;CLASS^NDFRR2A
15 ;;17^NDFRR2A
16 ;;18^NDFRR2A
17 ;;19^NDFRR2A
18 ;;20^NDFRR2A
19 ;;22^NDFRR2A
20 ;;23^NDFRR2A
21 ;;24^NDFRR2A
22 ;;25^NDFRR2A
23 ;;30^NDFRR2A
24 ;;31^NDFRR2A
25 ;;100^NDFRR2A
26 ;;40^NDFRR2A

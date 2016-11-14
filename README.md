# Expansion of the National Drug File to Include Non-US Drugs
This paper is funded by Electronic Health Solutions LLC from the Hashemite
Kingdom of Jordan.

Released under CC-BY 4.0. https://creativecommons.org/licenses/by/4.0/
Code accompanying this paper is all in the public domain. 

## Purpose of this Paper
This paper is intended to describe a possible path to the addition of
non-US medicines to the National Drug Files in VistA. Addition to the National
Drug Files is a pre-requisite to being able to have allergy, drug-interaction,
and duplicate therapy order checks for medicines that are available in Jordan but
are not available in the United States. It will also help when having to resolve
data from one VistA system to another VistA system.

This is necessary because medicines are not standardized across all
of the world. Thus, medicines marketed in one country may not be marketed in
another, and even if marketed, there is no guarantee that the medicines will be
in the same dosage form or the same strength as the US medicines.

## What is the NDF?
NDF is an acronym for "National Drug File". This is misleading, it really
consists of 19 files, as follows in this table:

| File Number | File Name | Global Location |
| ----------- | --------- | --------------- |
| 50.416      | DRUG INGREDIENTS | ^PS(50.416) |
| 50.6        | VA GENERIC | ^PSNDF(50.6)   |
| 50.605      | VA DRUG CLASS | ^PS(50.605) |
| 50.606      | DOSAGE FORM | ^PS(50.606)   |
| 50.607      | DRUG UNITS | ^PS(50.607)    |
| 50.608      | PACKAGE TYPE | ^PS(50.608)  |
| 50.609      | PACKAGE SIZE | ^PS(50.609)  |
| \*50.621      | PMI-ENGLISH      | ^PS(50.621) |
| \*50.622      | PMI-SPANISH      | ^PS(50.622) |
| \*50.623      | PMI MAP-ENGLISH  | ^PS(50.623)
| \*50.625      | WARNING LABEL-ENGLISH | ^PS(50.625)
| \*50.626      | WARNING LABEL-SPANISH | ^PS(50.626)
| \*50.627      | WARNING LABEL MAP | ^PS(50.627)
| 50.64       | VA DISPENSE UNIT | ^PSNDF(50.64) |
| 50.67       | NDC/UPN    | ^PSNDF(50.67)  |
| 50.68       | VA PRODUCT | ^PSNDF(50.68)  |
| 51.2        | MEDICATION ROUTES | ^PS(51.2) |
| 55.95       | DRUG MANUFACTURER | ^PS(55.95) |
| \#56          | DRUG INTERACTION | ^PS(56)  |

Files with a asterisk next to their number are not maintained by the VA. They
are loaded directly from First Databank (FDB) data. Files with a hash next to their number are
not used in the VA anymore; but are still maintained for Indian Health Service.

Looking at the list of the above files does not help with knowing what's
important and what isn't. The VA PRODUCT file is the center of
NDF. Drugs are tied to a VA PRODUCT, and by virtue of that, may be able to
be used in Drug Interaction, Duplicate Therapy, and Allergy/ADR checks.
The VA PRODUCT in turn points to all other files. Here's a map produced by
Fileman's 'MAP POINTER RELATIONS' option. Note that all of the pointers are
forward pointers (one VA PRODUCT to one relationship), with the exception of NDC/UPN
(50.67), which has a backwards pointer (many to one VA PRODUCT relationship). 

```
   File/Package: VA PRODUCT POINTERS                                                        Date: NOV 9,2016

  FILE (#)                                                                    POINTER           (#) FILE
   POINTER FIELD                                                               TYPE           POINTER FIELD              FILE POINTED TO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
          L=Laygo      S=File not in set      N=Normal Ref.      C=Xref.
          *=Truncated      m=Multiple           v=Variable Pointer

                                                                                          -------------------------------
  DRUG (#50)                                                                              |                             |
    PSNDF VA PRODUCT NAME ENTRY ............................................  (N S C L)-> |  50.68 VA PRODUCT           |
  NATIONAL DRUG TRANSL (#50.612)                                                          |                             |
    VA PRODUCT NAME DA .....................................................  (N S L)->   |   VA GENERIC NAME           |-> VA GENERIC
  NDC/UPN (#50.67)                                                                        |                             |
    VA PRODUCT NAME ........................................................  (N S )->    |   DOSAGE FORM               |-> DOSAGE FORM
  BCMA EXTRACT (#727.833)                                                                 |                             |
    DRUG IEN ...............................................................  (N S )->    |   UNITS                     |-> DRUG UNITS
                                                                                          |                             |
                                                                                          |   VA DISPENSE UNIT          |-> VA DISPENSE UNIT
                                                                                          |   PRIMARY VA DRUG CLASS     |-> VA DRUG CLASS
                                                                                          |   ACTIVE INGR:ACTIVE INGR*  |-> DRUG INGREDIENTS
                                                                                          |   ACTIVE INGREDIENTS:UNITS  |-> DRUG UNITS
                                                                                          | m SECONDARY V:SECONDARY V*  |-> VA DRUG CLASS
                                                                                          -------------------------------
```
## How is the NDF Maintained?
The NDF was maintained using the National Drug File Management System (NDFMS),
a VistA application running on a standalone system. The NDF was maintained by
four pharmacists [1] who monitored FDB, the United States Food and Drug Administration (FDA), and user input, then made
changes to the NDF as a result. After each month was over, a "cut" of the
changes was created by looking at the Audit Fileman Global since the last time
an update was sent. This cut is installed at the destination VistA systems
to update the NDF at each site using VistA. Of note, none of the internal
entry numbers (IENs) of the files are resolved at the destination system; they are all
sent as is. In other words, there is no pointer resolution, all files are
assumed to be in an identical static state across all VistA sites.

Since 2013, the VA has transitioned to a Web Application called Pharmacy
Product System - National (PPS-N). This application provides similar capabilites
to NDFMS, but includes extra functionality, especially with regards to querying
external data sources. The application interfaces with the NDFMS via remote
procedures. NDFMS is still responsible for making the "cut" to send to
destination VistA systems. As of today (Nov 9th 2016), the KIDS builds that
are applied to the NDFMS to communicate to PPS-N are not
available. A Freedom of Information Act (FOIA) request has been placed to obtain them.

All available documentation for NDFMS is supplied with this paper. A KIDS build of the NDFMS code will also be supplied.
Documentation for PPS-N can be found at http://www.va.gov/vdl/application.asp?appid=202 [2]. 
Source code for the two future versions (unreleased) of PPS-N can be found at
http://hdl.handle.net/10909/11003 [3] and http://hdl.handle.net/10909/11163 [4]. The source code for v1.0 
is not available.

## Proposed Process for Adding Non-US drugs to the NDF
### Activation of Previously Inactive Entries
An easy fix for many products is that they may exist already in the NDF, but
are inactive. If that is so, it's easy to activate them by reversing the action
of the menu option [NDF INACTIVATE PRODUCT] found in the NDFMS system.
### Adding New Entries
Due to the fact that IENs are static at the client sites--i.e., they are what
the source NDFMS supplies, it is a feasible proposition to have non-US drugs
at higher numbers. I do not know if NDF patches from the VA will continue
working as is or if they will need some modifications. As far as I am able to tell,
everything in the VA NDF patch is entered into the VistA system using static
IENs.
### Making the Patch
I think this may be the hardest: making a Jordan specific NDF patch. The
reason is that the NDFMS system needs initial configuration and data entry in
files in the 5000 range which it distrubutes. However, there is no documentation
to do that.

## Estimatated Timeline if I Were to Develop This
 * 100 hours to get NDFMS running
 * 100 hours to get Jordan specific numbering running
 * I can't estimate porting effort for PPS-N as I have no expertise in porting
   Java applications that run on IBM WebLogic. I don't think it's necessary
   for this project. PPS-N may provide a convenient way to enter data--but as
   usual, there are a lot of data sources it taps into which are not applicable in
   Jordan.

## Technical Details for Reverse Engineering the NDF process
This section is intended for the programmers who will do the work. It describes
some of my findings that are pertinent to this project.

### Post Install for NDF Data Update Patches
In this package, under the folder PSN_4.0_466, you will find a file
called PSN466D.m. I annotated this file for interested readers.

It reads the KIDS transport global referenced in XPDGREF, and looks first at
subscript DATANT, which contain the .01 entries for all new and changed entries.
Of note, FILE^DICN is called with the exact number of the IEN to enter using the
variable DINUM.

Next, subscript DATAN is examined. It contains the .01's for the multiples.
Again, the IENs are maintained, this time by sending the "IEN" subscripted
variable with the desired IENs to UPDATE^DIE. Any changes to active ingredients
are cached into a ^TMP global.

Next, subscript DATAO contains the rest of the data. It's filed using FILE^DIE.

Next, cached changes to active ingredients are sent over to the Drug Ingredients
file.

Next, two email messages are sent. The email messages are NOT generated on the
fly; rather they are inside of the transport global.

Next, find VA PRODUCTs that just got inactivated by this or any other patch;
for each found one, delete the NDF node ("ND") and the doses (possible and
local possible). For any drugs that have the "ND" node left, update the
National Formulary Indicator and the VA Class.

Next, the unmatched drugs email message is sent.

### NDF Management System Details
The NDF Management System's main menu is called "NDF MANAGER". It contains:

 * NDF ENTER EDIT
 * NDF REPORTS
 * NDF MISCELLANEOUS
 * NDF INQUIRY
 * NDFPBM (calls a ZZ routine)
 * NDFRTE (calls a ZZ routine)

We only care right now about NDF ENTER EDIT and NDF MISCELLANEOUS. Here's NDF
ENTER EDIT:

 * NDF VA PRODUCT
 * NDF VA GENERIC
 * NDF MANUFACTURERS
 * NDF DOSAGE FORM
 * NDF DRUG UNITS
 * NDF VA CLASS
 * NDF PACKAGE TYPE
 * NDF PACKAGE SIZE
 * NDF DISPENSE UNIT
 * NDF ROUTE
 * NDF INGREDIENT
 * NDF INTERACTIONS

All of these reference simple code in routine NDFENTER; with the exception of
NDF VA PRODUCT, which goes through a long list of questions and checks starting
from NDFRR2.

Here's NDF MISCELLANEOUS:

 * NDF INACTIVATE NDC
 * NDF INACTIVATE PRODUCT
 * NDF MESSAGE
 * NDF PURGE
 * NDF INACTIVATE INTERACTION
 * NDF ENTER RESTRICTIONS
 * NDF PATCH EDIT REPORT
 * NDF EXLCUSIONS

The first two reference NDFDEACT.

NDFPRE generates the NDF data patch. You will find a reference to it in any
data build as the pre-transport routine.

Last but not least, every entry needs to have a VUID assigned. I haven't dug
into this process, but it's certain that you will need to establish your own
unique numbering system for that field too.

# Attachments
Along with this report, I am sending patch PSN\*4.0\*466 as an example NDF
Data patch, as well the FOIA copy of the NDF Management System. All routines
referenced anywhere in this document can be found in either of these two folders.

# Footnotes
[1] Personal conversation with Don Lees, April, 2010, Manager of the NDF at Pharmacy Benefits Management Services, VA.
[2] http://www.va.gov/vdl/application.asp?appid=202
[3] http://hdl.handle.net/10909/11003
[4] http://hdl.handle.net/10909/11163

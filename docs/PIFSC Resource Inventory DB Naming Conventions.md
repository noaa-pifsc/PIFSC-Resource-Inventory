# PIFSC Resource Inventory Database Naming Conventions

## Overview:
When developing a database it is important to use consistent naming conventions so that database objects and associated fields are easily understandable. Consistent prefixes can be used to differentiate between the core data objects being managed in the database and the data objects for the various modules installed. Consistent object suffixes indicate what each object represents and what type of data each field contains. Oracle requires object names and field names to have a maximum of 30 characters so abbreviations are required to keep the length within the acceptable range, consistent abbreviations improve the usability of the database. The underscore character should be used to separate the various abbreviations for objects/fields. The [PIFSC-ITS DB naming and coding standards](https://drive.google.com/file/d/1KCOST_uNqcBVuw3GV3Wz0BuzBGKPvDwD/view?usp=sharing) defines database naming standards for PIFSC. This document defines the database naming conventions for the Template Project database. All objects included in the PIFSC Resource Inventory (PRI) Database are from custom PIFSC modules listed in the [PRI Database Documentation](PIFSC%20Resource%20Inventory%20Database%20Documentation.md), the object naming conventions are defined in the corresponding module's documentation.

## Naming Conventions:
-   ### Object Prefixes:
    -   PRI: PIFSC Resource Inventory
-   ### Object Suffixes:
    -   BRI: Before Row Insert (for triggers)
    -   BRU: Before Row Update (for triggers)
    -   FN: Function
    -   SEQ: Sequence
    -   SP: Stored Procedure
    -   V: View
-   ### Field Suffixes:
    -   CODE: Code field
    -   DTM: Date/Time field
    -   DESC: Description field
    -   ID: Primary/foreign keys (e.g. LOC_ID, SPECIES_ID)
    -   YN: Yes/No field (Boolean)
-   ### Abbreviations:
    -   ASSOC: Associated
    -   CD: Comma-Delimited
    -   CURR: Current
    -   CONV: (Naming) Convention
    -   HTTP: Hypertext Transfer Protocol
    -   IMP: Implemented
    -   MAX: Maximum
    -   MSG: Message
    -   NUM: Number
    -   PROJ: Project
    -   RES: Resource
    -   SSH: Secure Shell Protocol
    -   SUM: Summary
    -   URL: Uniform Resource Locator
    -   VC: Version Control
    -   VERS: Version

# Oracle Database 19c to Oracle AI Database 26ai Upgrade Lab

## Overview

This repository demonstrates a complete enterprise database upgrade:

Oracle Database 19c  
to  
Oracle AI Database 26ai

using:

- AutoUpgrade Utility
- Oracle Multitenant Architecture
- DBMS_PDB Migration
- Oracle Linux Upgrade
- Enterprise DBA Best Practices


## Source Environment

| Component | Version |
|---|---|
| OS | Oracle Linux 7.9 |
| Database | Oracle Database 19c |
| Architecture | Non-CDB |
| DB Name | NEXUS |
| Storage | File System |


## Target Environment


| Component | Version |
|---|---|
| OS | Oracle Linux 8.10 |
| Database | Oracle AI Database 26ai |
| Architecture | CDB/PDB |
| CDB | NEXUSCDB |
| PDB | NEXUS |


## Upgrade Phases


### Phase 1
Oracle Linux Upgrade

OL7.9 → OL8.10


### Phase 2
Database Architecture Conversion

NON-CDB → PDB


### Phase 3

Oracle AI Database 26ai Installation


### Phase 4

AutoUpgrade Execution

Modes:

- Analyze
- Fixups
- Deploy



## Rollback Strategy

Implemented using:

- VM Snapshot
- RMAN Backup
- Guaranteed Restore Point


## Author

Jesus Bastidas

Enterprise Database Architect
Oracle DBA
OCI Certified Professional

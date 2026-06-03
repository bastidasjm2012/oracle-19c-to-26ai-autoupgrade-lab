# Project Overview

This project documents an end-to-end enterprise-style upgrade from Oracle Database 19c to Oracle AI Database 26ai using AutoUpgrade.

The lab follows six controlled phases:

1. Prechecks, backup and baseline
2. Oracle Linux 7.9 to 8.10 using Leapp
3. Oracle 19c Non-CDB to CDB/PDB conversion
4. Oracle AI Database 26ai software-only installation
5. AutoUpgrade execution
6. Final documentation, dashboard, troubleshooting and packaging

The design is based on a maintenance-window approach with rollback points, evidence collection and GO/NO-GO checkpoints.

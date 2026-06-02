# OS Upgrade Snapshot Checklist

Before running Leapp:

## VM / Infrastructure

- [ ] VM Snapshot created
- [ ] Snapshot name documented
- [ ] Rollback tested
- [ ] Storage healthy


## Oracle Database

- [ ] Database OPEN READ WRITE
- [ ] RMAN FULL backup completed
- [ ] Backup validated
- [ ] Listener running


## OS

- [ ] Root access validated
- [ ] / has free space
- [ ] /boot has free space
- [ ] yum repositories working
- [ ] No pending OS errors


GO / NO-GO:

APPROVED: _______

DATE: _______

DBA: _______

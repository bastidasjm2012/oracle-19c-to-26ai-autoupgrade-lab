#!/bin/bash

echo "================================"
echo " Fixing common Leapp inhibitors"
echo "================================"


echo
echo "### Remove old kernels"


rpm -qa | grep kernel-devel


echo
echo "Remove manually if duplicated:"


echo "
yum remove kernel-devel-OLD_VERSION
"


echo
echo "### PAM pkcs11 inhibitor"


leapp answer \
--section remove_pam_pkcs11_module_check.confirm=True


echo
echo "### Verify answers"


cat /var/log/leapp/answerfile


echo
echo "Run again:"
echo "leapp preupgrade"

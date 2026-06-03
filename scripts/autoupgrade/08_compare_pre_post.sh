#!/bin/bash


diff -y \
/u01/stage/26ai/DB_capture_pre_19c.txt \
/u01/stage/26ai/DB_capture_post_26ai.txt \
> /u01/stage/26ai/pre_post_comparison.txt


cat /u01/stage/26ai/pre_post_comparison.txt

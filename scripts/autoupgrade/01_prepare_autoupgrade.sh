#!/bin/bash

AUTO_DIR=/u01/app/oracle/autoupgrade

mkdir -p $AUTO_DIR


echo "Copy AutoUpgrade jar"

cp /u01/stage/26ai/autoupgrade.jar \
$AUTO_DIR


chmod 755 $AUTO_DIR


echo "Validate Java"


/u01/app/oracle/product/26ai/dbhome_1/jdk/bin/java \
-version


echo


echo "Validate AutoUpgrade"


/u01/app/oracle/product/26ai/dbhome_1/jdk/bin/java \
-jar $AUTO_DIR/autoupgrade.jar \
-version


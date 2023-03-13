#! /usr/bin/sh
# echo "load the oracle environment variables"
source /usr/src/ODS/config/oracle_env
# execute the ODS generator script
/opt/remi/php81/root/usr/bin/php /usr/src/GIM/retrieve_gitlab_info.php

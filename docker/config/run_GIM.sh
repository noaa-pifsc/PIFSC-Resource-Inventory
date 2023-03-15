#! /usr/bin/sh
# echo "load the oracle environment variables"
source /usr/src/PRI/config/oracle_env
# execute the GIM retrieve_gitlab_info script
/opt/remi/php81/root/usr/bin/php /usr/src/PRI/GIM/retrieve_gitlab_info.php

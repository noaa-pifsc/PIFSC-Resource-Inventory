<?php

	ini_set("date.timezone", 'Pacific/Honolulu');

    //define application resource paths:
	define ("APPLICATION_INCLUDE_PATH", "/usr/src/PRI/GIM/includes/");
    define ("SHARED_LIBRARY_INCLUDE_PATH", "/usr/src/PRI/php-shared-library/");

    //define the hostname for the destination gitlab server
    define ("GITLAB_HOST_NAME", "picgitlab.nmfs.local");
	
	//logging directory
	define ("LOG_FILE_DIR", "/usr/src/PRI/logs/");

	//define the project source for the GitLab script to indicate the source of the information is the PIFSC GitLab server (DATA_SOURCE_CODE = 'PGL')
	define ("PROJ_SOURCE", "PGL");

	//include the gitlab API key:
	include_once (APPLICATION_INCLUDE_PATH."gitlab_config.php");

?>

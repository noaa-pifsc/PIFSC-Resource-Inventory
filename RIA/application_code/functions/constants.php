<?php

    ini_set('date.timezone', "Pacific/Honolulu");

    //define application resource paths:
    define ("APPLICATION_INCLUDE_PATH", "/usr/src/PRI/RIA/includes/");
    define ("SHARED_LIBRARY_INCLUDE_PATH", "/usr/src/PRI/php-shared-library/");

    //define the js, css include paths for the shared library
    define ("SHARED_LIBRARY_CLIENT_PATH", "./php-shared-library/");

	//include the application instance configuration file:
	include_once (APPLICATION_INCLUDE_PATH."app_instance_config.php");
?>

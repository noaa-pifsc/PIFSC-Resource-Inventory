<?php

    ini_set("display_errors", "On");
    ini_set('date.timezone', "Pacific/Honolulu");

    //define application resource paths:
    define ("APPLICATION_INCLUDE_PATH", "/usr/src/RIA/includes/");
    define ("SHARED_LIBRARY_INCLUDE_PATH", "/usr/src/php-shared-library/");

    //define the js, css include paths for the shared library
    define ("SHARED_LIBRARY_CLIENT_PATH", "./php-shared-library/");

		//define which app instance this is
		define ("APP_INSTANCE", "dev");

?>

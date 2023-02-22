<?php


    //define application resource paths:
		define ("APPLICATION_INCLUDE_PATH", "/usr/src/PRI/GIM/includes/");
    define ("SHARED_LIBRARY_INCLUDE_PATH", "/usr/src/PRI/php-shared-library/");

    //define the hostname for the destination gitlab server
    define ("GITLAB_HOST_NAME", "picgitlab.nmfs.local");
    //define the API key for an administrator account on the source gitlab server to allow the Gitlab instance to be queried while having all projects visible:
    define ("GITLAB_API_KEY", "glpat-UL9qXHZih4hkWadkLHZ4");

		//define the project source for the GitLab script to indicate the source of the information is the PIFSC GitLab server (DATA_SOURCE_CODE = 'PGL')
		define ("PROJ_SOURCE", "PGL");

?>

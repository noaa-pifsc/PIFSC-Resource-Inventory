<?php


    //define application resource paths:
    define ("APPLICATION_INCLUDE_PATH", "C:/Users/jesse.abdul/Documents/Version Control/Git/pifsc-resource-inventory/GIM/application_code/functions/");
    define ("SHARED_LIBRARY_INCLUDE_PATH", "C:/Users/jesse.abdul/Documents/Version Control/Git/php-shared-library/");

    //define the hostname for the destination gitlab server
    define ("GITLAB_HOST_NAME", "picgitlab.nmfs.local");
    //define the API key for an administrator account on the source gitlab server to allow the Gitlab instance to be queried while having all projects visible:
    define ("GITLAB_API_KEY", "");

		//define the project source for the GitLab script to indicate the source of the information is the PIFSC GitLab server
		define ("PROJ_SOURCE", "PIFSC GitLab");

?>

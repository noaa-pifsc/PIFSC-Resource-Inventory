<?php


//Note: example usage: php convert_download_package_to_bagit.php
include_once ("constants.php");

//include the PRI_gitlab class definition file:
include_once(APPLICATION_INCLUDE_PATH."PRI_gitlab.php");

$PRI_gitlab = new PRI_gitlab ("retrieve_gitlab_info_".date("Ymd_H_i").".log", 'retrieve_gitlab_info.php');


echo $PRI_gitlab -> add_message ("running retrieve_gitlab_info.php - GITLAB_HOST_NAME: ".GITLAB_HOST_NAME, 3);

$PRI_gitlab -> refresh_projects();

?>

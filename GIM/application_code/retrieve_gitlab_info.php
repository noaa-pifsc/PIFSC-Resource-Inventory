<?php


//Note: example usage: php convert_download_package_to_bagit.php
include_once ("/usr/src/PRI/GIM/constants.php");

//include the PRI_gitlab class definition file:
include_once(APPLICATION_INCLUDE_PATH."PRI_gitlab.php");

if ((empty(GITLAB_HOST_NAME)) || (empty(APPLICATION_INCLUDE_PATH)) || (empty(SHARED_LIBRARY_INCLUDE_PATH)) || (empty(LOG_FILE_DIR)) || (empty(PROJ_SOURCE)))
{
	echo date("Ymd h:i:s A")."\tThe required PHP constants are not defined, update the constants.php file with the appropriate values and try again\r\n";
}
else if (empty(GITLAB_API_KEY))
{
	echo date("Ymd h:i:s A")."\tThe GITLAB_API_KEY was not defined, update the gitlab_config.php file with a valid API key and try again\r\n";
}
else
{

	//save the start time so it can be used to calculate the total processing time for this script
	$start_time = time();

	$PRI_gitlab = new PRI_gitlab ("retrieve_gitlab_info_".date("Ymd_H_i").".log", 'retrieve_gitlab_info.php');


	$PRI_gitlab -> add_message ($temp_message = "Update the project and resource information - GITLAB_HOST_NAME: ".GITLAB_HOST_NAME, 1);

	echo date("Ymd h:i:s A")."\t".$temp_message."\r\n";

	//refresh user information from GitLab server
	$PRI_gitlab -> refresh_users();

	//refresh project information from GitLab server
	$PRI_gitlab -> refresh_projects();

	//calculate the time difference between the start time and end time of the script:
	$elapsed_time_sec = time() - $start_time;


	$PRI_gitlab -> add_message($summary_message = "The project and resource information update process has completed, the entire process took ".round (($elapsed_time_sec / 60), 1)." minutes", 1);

	echo date("Ymd h:i:s A")."\t".$summary_message."\r\n";
}
?>

<?php

	include_once ("constants.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."html_page.php");
	include_once (APPLICATION_INCLUDE_PATH."RIA_template_page.php");
	include_once (APPLICATION_INCLUDE_PATH."RIA_template_page.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."output_message.php");
  include_once (APPLICATION_INCLUDE_PATH."project.php");
	include_once (APPLICATION_INCLUDE_PATH."db_connection_info.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."find_array_pos.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."sanitize_values.php");

  //create the new project object
  $project = new project("PIFSC_view_project_".date("Ymd_H_i").".log", $_SERVER["SCRIPT_FILENAME"]);

  //return the $oracle_db resource so it can be used to query the DB:
  $oracle_db = $project->return_oracle_db();

	//create the initial log message for the request
//	echo $project->add_message("page request to ".$_SERVER["SCRIPT_FILENAME"]." from IP address: ".$_SERVER['REMOTE_ADDR']." with arguments: ".var_export($_REQUEST, true), 3);


	//initialize the variable used to construct the HTML content in the body of the page:
	$string_buffer = '';


	//define a variable in the javascript to indicate the application instance
	$inline_javascript = "var app_instance = '".APP_INSTANCE."';";

  //define the css include files for the initial HTML page content
  $css_include = array("./css/template.css", "./css/RIA_project.css", "./css/tooltip.css", "./css/ajax_load.css", "./css/display_card.css", SHARED_LIBRARY_CLIENT_PATH."css/smoothness/jquery-ui-1.12.1.min.css", );

	//define the javascript include files for the initial HTML page content:
	$javascript_include = array("./js/dev_test_bg_image.js");

  //generate the javascript include files with the "defer" keyword
  $priority_header_content = external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery-1.7.2.min.js").external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery.tablescroll.js").external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery-ui-1.12.1.min.js")."<script type=\"text/javascript\" defer=\"defer\" src=\"./js/RIA.js\"></script><script type=\"text/javascript\" defer=\"defer\" src=\"./js/projects.js\"></script><script type=\"text/javascript\" defer=\"defer\" src=\"./js/RIA_tooltips.js\"></script>";


  //generate the main HTML content:


	//check if the "PROJ_ID" parameter has been specified for the page request:
	if (isset($_REQUEST['PROJ_ID']))
	{
    //the PROJ_ID parameter is defined, check if the project record exists in the DB:




		//check if the oracle database connection was successful:
		if (!$oracle_db->is_connected($error_info))
		{
			//the database connection was unsuccessful:
			echo $project->add_message("database connection was unsuccessful, oci_error(): ".var_export($error_info, true));

			//send back the HTML content to indicate the failed DB connection:
			$string_buffer .= b_tag("Could not connect to the database, please try again later");

		}
		else
		{
			//the database connection was successful, continue generating the initial page content:


      //define the SQL for the query to retrieve the specified project:
      $SQL = "SELECT PROJ_ID, PROJ_NAME, PROJ_DESC, VC_WEB_URL, NVL(RES_NAME_LINK_BR_LIST, 'N/A') RES_NAME_LINK_BR_LIST, NVL(NUM_RES, 0) NUM_RES, NVL(CURR_VERS_COUNT, 0) CURR_VERS_COUNT, NVL(OLD_VERS_COUNT, 0) OLD_VERS_COUNT, NVL(TOTAL_IMPL_RES, 0) TOTAL_IMPL_RES, NVL(IMPL_RES_LINK_BR_LIST, 'N/A') IMPL_RES_LINK_BR_LIST, AVATAR_URL, DATA_SOURCE_NAME, PROJ_VISIBILITY, README_URL, VC_COMMIT_COUNT, FORMAT_VC_REPO_SIZE_MB, NVL(OWNER_USER_NAME, 'N/A') OWNER_USER_NAME, OWNER_AVATAR_URL, OWNER_WEB_URL, NVL(CREATOR_USER_NAME, 'N/A') CREATOR_USER_NAME, CREATOR_AVATAR_URL, CREATOR_WEB_URL, TO_CHAR(PROJ_REFRESH_DATE, 'MM/DD/YYYY HH24:MI:SS') PROJ_REFRESH_DATE, TO_CHAR(PROJ_CREATE_DTM, 'MM/DD/YYYY HH24:MI:SS') PROJ_CREATE_DTM, TO_CHAR(PROJ_UPDATE_DTM, 'MM/DD/YYYY HH24:MI:SS') PROJ_UPDATE_DTM from PRI.PRI_PROJ_RES_TAG_MAX_SUM_ALL_V where PROJ_ID = :PROJ_ID";

      //initialize $dummy_id variable for the query:
      $dummy_id = null;

      //execue the SQL query:
      if ($oracle_db->query($SQL, $stid, $dummy_id, array(array(":PROJ_ID", $_REQUEST['PROJ_ID']))))
      {
        //the query was successful:


        //loop through result set:
        if ($row = $oracle_db->fetch($stid))
        {
          //the project exists, generate the page content and display it:

          $string_buffer .= $project->generate_project_display_card($row);

        }
        else
        {
          //the project does not exist
          $string_buffer .= b_tag("The specified project does not exist, please reload the previous page and click on the project link again");

          $project->add_message("The specified project does not exist (PROJ_ID: ".$_REQUEST['PROJ_ID'].")");

        }
      }
      else
      {
        //the project information could not be queried successfully:
        $string_buffer .= b_tag("There was a problem with the database and your request could not be processed, please try again later");

        $project->add_message("The project query failed");

      }


		}

	}
  else
  {
    //the PROJ_ID variable was not specified, show an error message


    $string_buffer .= b_tag("There was no project specified, please reload the previous page and try the project link again.");

    $project->add_message("There was no project specified, PROJ_ID was not defined");

  }

	//generate the main HTML content:
	$string_buffer = RIA_template_page("View Project", $string_buffer, "view_project.php");

  //output the HTML page content with $string_buffer in the <body> tag:
  echo html_page ('View Project', $string_buffer, array(), $inline_javascript, $javascript_include, '', $css_include, false, array(), array(), $priority_header_content);

?>

<?php

	include_once ("constants.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."html_page.php");
	include_once (APPLICATION_INCLUDE_PATH."RIA_template_page.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."output_message.php");
  include_once (APPLICATION_INCLUDE_PATH."resource.php");
	include_once (APPLICATION_INCLUDE_PATH."db_connection_info.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."find_array_pos.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."sanitize_values.php");

  //create the new resource object
  $resource = new resource("PIFSC_view_resource_".date("Ymd_H_i").".log", $_SERVER["SCRIPT_FILENAME"]);

  //return the $oracle_db resource so it can be used to query the DB:
  $oracle_db = $resource->return_oracle_db();

	//create the initial log message for the request
//	echo $resource->add_message("page request to ".$_SERVER["SCRIPT_FILENAME"]." from IP address: ".$_SERVER['REMOTE_ADDR']." with arguments: ".var_export($_REQUEST, true), 3);


	//initialize the variable used to construct the HTML content in the body of the page:
	$string_buffer = '';


	//define a variable in the javascript to indicate the application instance
	$inline_javascript = "var app_instance = '".APP_INSTANCE."';";

  //define the css include files for the initial HTML page content
  $css_include = array("./res/css/template.css", "./res/css/RIA_resource.css", "./res/css/tooltip.css", "./res/css/ajax_load.css", "./res/css/display_card.css", SHARED_LIBRARY_CLIENT_PATH."css/smoothness/jquery-ui-1.12.1.min.css", );

	//define the javascript include files for the initial HTML page content:
	$javascript_include = array("./res/js/template.js", "./res/js/tooltip.js");

  //generate the javascript include files with the "defer" keyword
  $priority_header_content = external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery-1.7.2.min.js").external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery.tablescroll.js").external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery-ui-1.12.1.min.js")."<script type=\"text/javascript\" defer=\"defer\" src=\"./res/js/RIA.js\"></script><script type=\"text/javascript\" defer=\"defer\" src=\"./res/js/resources.js\"></script><script type=\"text/javascript\" defer=\"defer\" src=\"./res/js/RIA_tooltips.js\"></script>";



	//check if the "RES_ID" parameter has been specified for the page request:
	if (isset($_REQUEST['RES_ID']))
	{
    //the RES_ID parameter is defined, check if the resource record exists in the DB:




		//check if the oracle database connection was successful:
		if (!$oracle_db->is_connected($error_info))
		{
			//the database connection was unsuccessful:
			echo $resource->add_message("database connection was unsuccessful, oci_error(): ".var_export($error_info, true));

			//send back the HTML content to indicate the failed DB connection:
			$string_buffer .= b_tag("Could not connect to the database, please try again later");

		}
		else
		{
			//the database connection was successful, continue generating the initial page content:


      //define the SQL for the query to retrieve the specified resource:
      $SQL = "SELECT PROJ_ID, PROJ_NAME, PROJ_DESC, DATA_SOURCE_NAME, PROJ_VISIBILITY, README_URL, AVATAR_URL, VC_WEB_URL, RES_ID, RES_NAME, RES_MAX_VERS_NUM, NVL(CURR_VERS_COUNT, 0) CURR_VERS_COUNT, NVL(OLD_VERS_COUNT, 0) OLD_VERS_COUNT, NVL(TOTAL_IMPL_PROJ, 0) TOTAL_IMPL_PROJ, NVL(ASSOC_PROJ_LINK_BR_LIST, 'N/A') ASSOC_PROJ_LINK_BR_LIST, RES_CATEGORY, RES_URL, RES_SCOPE_NAME, RES_TYPE_NAME, RES_DESC, RES_DEMO_URL, VC_COMMIT_COUNT, FORMAT_VC_REPO_SIZE_MB, NVL(OWNER_USER_NAME, 'N/A') OWNER_USER_NAME, OWNER_AVATAR_URL, OWNER_WEB_URL, NVL(CREATOR_USER_NAME, 'N/A') CREATOR_USER_NAME, CREATOR_AVATAR_URL, CREATOR_WEB_URL, TO_CHAR(PROJ_REFRESH_DATE, 'MM/DD/YYYY HH24:MI:SS') PROJ_REFRESH_DATE, TO_CHAR(PROJ_CREATE_DTM, 'MM/DD/YYYY HH24:MI:SS') PROJ_CREATE_DTM, TO_CHAR(PROJ_UPDATE_DTM, 'MM/DD/YYYY HH24:MI:SS') PROJ_UPDATE_DTM from PRI.PRI_RES_PROJ_TAG_MAX_SUM_ALL_V where RES_ID = :res_id";

      //initialize $dummy_id variable for the query:
      $dummy_id = null;

      //execue the SQL query:
      if ($oracle_db->query($SQL, $stid, $dummy_id, array(array(":res_id", $_REQUEST['RES_ID']))))
      {
        //the query was successful:


        //loop through result set:
        if ($row = $oracle_db->fetch($stid))
        {
          //the resource exists, generate the page content and display it:

          $string_buffer .= $resource->generate_resource_display_card($row);

        }
        else
        {
          //the resource does not exist
          $string_buffer .= b_tag("The specified resource does not exist, please reload the previous page and click on the resource link again");

          $resource->add_message("The specified resource does not exist (RES_ID: ".$_REQUEST['RES_ID'].")");

        }
      }
      else
      {
        //the resource information could not be queried successfully:
        $string_buffer .= b_tag("There was a problem with the database and your request could not be processed, please try again later");

        $resource->add_message("The query failed");

      }


		}

	}
  else
  {
    //the RES_ID variable was not specified, show an error message


    $string_buffer .= b_tag("There was no resource specified, please reload the previous page and try the resource link again.");

    $resource->add_message("There was no resource specified, RES_ID was not defined");

  }

	//generate the main HTML content:
	$string_buffer = RIA_template_page("View Resource", $string_buffer, "view_resource.php");

  //output the HTML page content with $string_buffer in the <body> tag:
  echo html_page ('View Resource', $string_buffer, array(), $inline_javascript, $javascript_include, '', $css_include, false, array(), array(), $priority_header_content);

?>

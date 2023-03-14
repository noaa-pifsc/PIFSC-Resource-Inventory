<?php

	include_once ("constants.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."html_page.php");
	include_once (APPLICATION_INCLUDE_PATH."RIA_template_page.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."output_message.php");
  include_once (APPLICATION_INCLUDE_PATH."project.php");
	include_once (APPLICATION_INCLUDE_PATH."db_connection_info.php");
	//include_once (APPLICATION_INCLUDE_PATH."PRI_generate_html.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."find_array_pos.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."sanitize_values.php");


  //create the new project object:
  $project = new project("PIFSC_view_all_projects_".date("Ymd_H_i").".log", $_SERVER["SCRIPT_FILENAME"]);

  //return the $oracle_db resource so it can be used to query the DB:
  $oracle_db = $project->return_oracle_db();



	//initialize the variable used to construct the HTML content in the body of the page:
	$string_buffer = '';


	//check if the "req" parameter has been specified for the page request:
	if (!isset($_POST['req']))
	{
		//the current request does not have the "req" parameter defined, this is an initial page request:
//		echo $project->add_message("There is no request parameters, respond with full HTML page content", 3);

		//define a variable in the javascript to indicate the application instance
		$inline_javascript = "var app_instance = '".APP_INSTANCE."';";

		//initialize the html_page parameters
		$css_include = array();
		$javascript_include = array();
		$priority_header_content = '';
//		$inline_javascript = '';

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

			//no arguments were passed to the page, this is the initial html page content request:

			//define the css include files for the initial HTML page content
			$css_include = array("./res/css/template.css", "./res/css/tooltip.css", "./res/css/RIA_project.css", "./res/css/tooltip.css", "./res/css/ajax_load.css", "./res/css/display_card.css", SHARED_LIBRARY_CLIENT_PATH."css/smoothness/jquery-ui-1.12.1.min.css");

			//define the javascript include files for the initial HTML page content:
			$javascript_include = array("./res/js/template.js", "./res/js/tooltip.js");

			//generate the javascript include files with the "defer" keyword
			$priority_header_content = external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery-1.7.2.min.js").external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery.tablescroll.js").external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery-ui-1.12.1.min.js")."<script type=\"text/javascript\" defer=\"defer\" src=\"./res/js/RIA.js\"></script><script type=\"text/javascript\" defer=\"defer\" src=\"./res/js/projects.js\"></script><script type=\"text/javascript\" defer=\"defer\" src=\"./res/js/RIA_tooltips.js\"></script>";


      //initialize the array to store the data_source_id and data_source_name to populate the select element:
      $data_source_array = array(array(), array());

      //define the SQL for the query to retrieve all of the resource scopes:
      $SQL = "SELECT data_source_id, data_source_name from PRI.PRI_DATA_SOURCES
      order by UPPER(data_source_name)";

      //initialize $dummy_id variable for the query:
      $dummy_id = null;

      //execue the SQL query:
      if ($oracle_db->query($SQL, $stid, $dummy_id))
      {
        //the query was successful:


        //loop through result set:
        while ($row = $oracle_db->fetch($stid))
        {

          //convert HTML special characters to their corresponding HTML entities to protect against XSS attacks that could originate from the database query (no exceptions are specified on the sanitize_values() function call):
          $row = sanitize_values($row, false, false, false, true);


          //add the data source record information:
          $data_source_array[0][] = $row['DATA_SOURCE_ID'];
          $data_source_array[1][] = $row['DATA_SOURCE_NAME'];
        }




  			//define the SQL for the query to retrieve all of the non-private projects:
  			$SQL = "SELECT PROJ_ID, PROJ_NAME, PROJ_DESC, VC_WEB_URL, NVL(RES_NAME_LINK_BR_LIST, 'N/A') RES_NAME_LINK_BR_LIST, NVL(NUM_RES, 0) NUM_RES, NVL(CURR_VERS_COUNT, 0) CURR_VERS_COUNT, NVL(OLD_VERS_COUNT, 0) OLD_VERS_COUNT, NVL(TOTAL_IMPL_RES, 0) TOTAL_IMPL_RES, NVL(IMPL_RES_LINK_BR_LIST, 'N/A') IMPL_RES_LINK_BR_LIST, AVATAR_URL, DATA_SOURCE_NAME, PROJ_VISIBILITY, README_URL, VC_COMMIT_COUNT, FORMAT_VC_REPO_SIZE_MB, NVL(OWNER_USER_NAME, 'N/A') OWNER_USER_NAME, OWNER_AVATAR_URL, OWNER_WEB_URL, NVL(CREATOR_USER_NAME, 'N/A') CREATOR_USER_NAME, CREATOR_AVATAR_URL, CREATOR_WEB_URL, TO_CHAR(PROJ_REFRESH_DATE, 'MM/DD/YYYY HH24:MI:SS') PROJ_REFRESH_DATE, TO_CHAR(PROJ_CREATE_DTM, 'MM/DD/YYYY HH24:MI:SS') PROJ_CREATE_DTM, TO_CHAR(PROJ_UPDATE_DTM, 'MM/DD/YYYY HH24:MI:SS') PROJ_UPDATE_DTM FROM PRI.PRI_PROJ_RES_TAG_MAX_SUM_ALL_V WHERE PROJ_VISIBILITY <> 'private' order by UPPER(PROJ_NAME_SPACE)";

  			//initialize $dummy_id variable for the query:
  			$dummy_id = null;

  			//execue the SQL query:
  			if ($oracle_db->query($SQL, $stid, $dummy_id))
  			{
  				//the query was successful:




          //create the div tag for the filtering form container:
          $string_buffer .= "<div class=\"form_container\">";

          $form_string = a_tag("#", 'Project Source', array("class=\"tooltip filter_field\"", "title=\"Select one or more Project Sources to filter the Resources, the results will be filtered to include any of the selected Project Sources\"")).": ".select_tag('data_source_id[]', -1, $data_source_array[0], $data_source_array[1], array("multiple=\"multiple\"", "class=\"filter_field\"", "size=\"".(count($data_source_array[0]) < 4 ? count($data_source_array[0]) : 4)."\"", "id=\"data_source_select_id\""));

          $form_string .= a_tag("#", 'Text Search', array("class=\"tooltip filter_field\"", "title=\"Type in a search phrase to find in the Project Name or Description, the results will be filtered to include the entered search phrase\"")).": ".text_field ('search_phrase', '', array("class=\"filter_field\""));


          //construct the filter projects button for the filtering form:
          $form_string .= " ".a_tag("#", "Filter Projects", array("class=\"tooltip link_button filter_field_button\"", "onclick=\"request_projects();\"", "title=\"Click the button to refresh the Projects displayed in the page\""));

          //add the HTML markup for the accordion widget that will allow filtering of Projects and add the $form_string content for the form elements:
          $string_buffer .= div_tag(h3_tag("Report Filter", array("class=\"tooltip\"", "title=\"Click the arrow to expand the Report Filter to search for Projects\"")).div_tag($form_string), array("id=\"accordion_filter\""));

          //close the form container div:
          $string_buffer.= "</div>";


          //create the div tag for the project information container:
          $string_buffer .= "<div id=\"project_container_id\">";

  				//initialize the string used to generate the table content (tr and td for all data returned by query)
  				$table_string = '';


  				//loop through result set:
  				while ($row = $oracle_db->fetch($stid))
  				{
  					//convert HTML special characters to their corresponding HTML entities to protect against XSS attacks that could originate from the database query (no exceptions are specified on the sanitize_values() function call):

            $string_buffer .= $project->generate_project_display_card($row);

  				}

          //end the div tag for the project information container:
          $string_buffer .= "<!-- End tag for the project information container --></div>";


  			}
  			else
  			{
  				//the database query was not successfully executed

  				//send back the HTML content to indicate the DB query failed:
  				$string_buffer .= b_tag("There was a problem with the database and your request could not be processed, please try again later");

  				//log the failed database query:
  				echo $project->add_message("The PIFSC Projects query was not successful");

  				//define the html page arguments for the page so the error can be displayed (no need to load the js and css because the content request failed):
//  				$inline_javascript = '';
  				$javascript_include = array();
  				$css_include = array();
  			}




      }
      else
      {
        //the data source information could not be queried successfully:
        $string_buffer .= b_tag("There was a problem with the database and your request could not be processed, please try again later");

        $resource->add_message("The data source query failed");

        //close the main_content_div
//        $string_buffer .= "</div>";

      }


		}

		//generate the main HTML content:
		$string_buffer = RIA_template_page("All Projects", $string_buffer, "view_all_projects.php");



		//output the HTML page content with $string_buffer in the <body> tag:
		echo html_page ('All Projects', $string_buffer, array(), $inline_javascript, $javascript_include, '', $css_include, false, array(), array(), $priority_header_content);

	}
  else
  {
      //there was at least one parameter defined for the request:


      //check if the oracle database connection was successful:
      if (!$oracle_db->is_connected($error_info))
      {
        //the oracle connection was unsuccessful

        //log the unsuccessful database connection:
        echo $project->add_message("database connection was unsuccessful, oci_error(): ".var_export($error_info, true));

        //send back the JSON response for the unsuccessful query:
        $json_array = array("RETURN_CODE"=>1, "SUCCESS_CODE"=>-1, "ERROR_MESSAGE"=>"Could not connect to the database, please try again later");

        //return the encoded json content:
        echo json_encode($json_array);
      }
      else
      {
        //the database connection was successful

        //this request contained arguments, check the type of request
        if ($_POST['req'] == 'filter')
        {
          //this is a filter request:
  //  				echo $project->add_message("This is a filter resources request", 3);

          //additional where clause for the query based on request parameters:
          $SQL_where = '';

          //variable to define bind variables for the SQL query:
          $bind_array = array();


          //variable to store the where clauses from the filter parameters
          $where_array = array();

          //initialize variable to detect if there were any invalid parameters:
  				$invalid_parameters = false;


          //check if the data_source_id parameter is defined if there were no invalid parameters found:
          if (isset($_POST['data_source_id']))
          {
            //a data_source_id parameter was defined:
//            echo $project->add_message("one or more data_source_id parameters were specified: ".var_export($_POST['data_source_id'], true), 3);

            $project->process_filter_id_values ($_POST['data_source_id'], 'data_source_id', $invalid_parameters, $where_array, $bind_array);
          }


          //check if the search_phrase parameter is defined:
          if ((!$invalid_parameters) && (isset($_POST['search_phrase'])))
          {
            //a search_phrase parameter was defined:

            $where_array[] = "(UPPER(PROJ_NAME) LIKE '%'||UPPER(:search_phrase1)||'%' OR UPPER(PROJ_DESC) LIKE '%'||UPPER(:search_phrase2)||'%')";

            $bind_array[] = array(":search_phrase1", trim($_POST['search_phrase']));
            $bind_array[] = array(":search_phrase2", trim($_POST['search_phrase']));
          }


          //check if there were any invalid parameters
          if ($invalid_parameters)
          {
            //there was one or more invalid parameters:

            //log the error condition
            echo $resource->add_message("there were one or more invalid parameters sent with the request, the request is invalid");


            //construct the JSON response for the invalid parameters:
            $json_array = array("RETURN_CODE"=>1, "SUCCESS_CODE"=>-1, "ERROR_MESSAGE"=>"There were one or more invalid parameters that were sent with the request, please reload the page and try again");

            //return the encoded json content:
            echo json_encode($json_array);


          }
          else
          {
            //the parameters were valid, execute the query:


            //check if any parameters were specified
            if (count($where_array) > 0)
            {
                $where_clause = " AND ".implode(" AND ", $where_array);

            }
            else
            {
                $where_clause = '';
            }


            //generate the query for all Projects including the WHERE clause for any parameters provided with the request
            $SQL = "SELECT PROJ_ID, PROJ_NAME, PROJ_DESC, VC_WEB_URL, NVL(RES_NAME_LINK_BR_LIST, 'N/A') RES_NAME_LINK_BR_LIST, NVL(NUM_RES, 0) NUM_RES, NVL(CURR_VERS_COUNT, 0) CURR_VERS_COUNT, NVL(OLD_VERS_COUNT, 0) OLD_VERS_COUNT, NVL(TOTAL_IMPL_RES, 0) TOTAL_IMPL_RES, NVL(IMPL_RES_LINK_BR_LIST, 'N/A') IMPL_RES_LINK_BR_LIST, AVATAR_URL, DATA_SOURCE_NAME, PROJ_VISIBILITY, README_URL, VC_COMMIT_COUNT, FORMAT_VC_REPO_SIZE_MB, NVL(OWNER_USER_NAME, 'N/A') OWNER_USER_NAME, OWNER_AVATAR_URL, OWNER_WEB_URL, NVL(CREATOR_USER_NAME, 'N/A') CREATOR_USER_NAME, CREATOR_AVATAR_URL, CREATOR_WEB_URL, TO_CHAR(PROJ_REFRESH_DATE, 'MM/DD/YYYY HH24:MI:SS') PROJ_REFRESH_DATE, TO_CHAR(PROJ_CREATE_DTM, 'MM/DD/YYYY HH24:MI:SS') PROJ_CREATE_DTM, TO_CHAR(PROJ_UPDATE_DTM, 'MM/DD/YYYY HH24:MI:SS') PROJ_UPDATE_DTM FROM PRI.PRI_PROJ_RES_TAG_MAX_SUM_ALL_V WHERE PROJ_VISIBILITY <> 'private'".$where_clause." order by UPPER(PROJ_NAME_SPACE)";

            //log the valid parameters
//            echo $project->add_message("The request parameters are valid, execute the resource query: ".$SQL.", with bind vars: ".var_export($bind_array, true), 3);

            //initialize $dummy_id variable for the query:
            $dummy_id = null;

            //execute the Project query:
            if ($oracle_db->query($SQL, $stid, $dummy_id, $bind_array))
            {
              //the query was successful:
            //  						echo $project->add_message("The database query was successful", 3);

              //construct the json array for the successful request
              $json_array = array("RETURN_CODE"=>1, "SUCCESS_CODE"=>1, "PROJECTS"=>array());

              //loop through result set and define the values in the json array for each Project:
              while ($row = $oracle_db->fetch($stid))
              {
                //construct the json array values for the current Project and add it to json_array
                $json_array['PROJECTS'][] = array("proj_id"=>$row['PROJ_ID'], "proj_name"=>$row['PROJ_NAME'], "proj_desc"=>$row['PROJ_DESC'], "data_source_name"=>$row['DATA_SOURCE_NAME'], "proj_visibility"=>$row['PROJ_VISIBILITY'], "readme_url"=>$row['README_URL'], "avatar_url"=>$row['AVATAR_URL'], "vc_web_url"=>$row['VC_WEB_URL'],  "curr_vers_count"=>$row['CURR_VERS_COUNT'], "old_vers_count"=>$row['OLD_VERS_COUNT'], "total_impl_res"=>$row['TOTAL_IMPL_RES'], "num_res"=>$row['NUM_RES'], "res_name_link_br_list"=>$row['RES_NAME_LINK_BR_LIST'], "impl_res_link_br_list"=>$row['IMPL_RES_LINK_BR_LIST'], "vc_commit_count"=>$row['VC_COMMIT_COUNT'], "format_vc_repo_size_mb"=>$row['FORMAT_VC_REPO_SIZE_MB'], "owner_user_name"=>$row['OWNER_USER_NAME'], "owner_avatar_url"=>$row['OWNER_AVATAR_URL'], "owner_web_url"=>$row['OWNER_WEB_URL'], "creator_user_name"=>$row['CREATOR_USER_NAME'], "creator_avatar_url"=>$row['CREATOR_AVATAR_URL'], "creator_web_url"=>$row['CREATOR_WEB_URL'], "proj_refresh_date"=>$row['PROJ_REFRESH_DATE'], "proj_create_dtm"=>$row['PROJ_CREATE_DTM'], "proj_update_dtm"=>$row['PROJ_UPDATE_DTM']);
              }

            //  						echo $project->add_message("output the JSON data for the filtered resources", 3);

              //the query was successful, respond with a JSON array of values (the str_replace() call is to handle a bug with the way that PHP encodes JSON by escaping forward slashes):
              echo str_replace('\\/', '/', json_encode($json_array));
            }
            else
            {
              //query was unsuccessful:

              //log the error information for the database query:
              echo $project->add_message("The database query was unsuccessful, error: ".var_export(oci_error($stid), true));

              //send back the JSON response for the unsuccessful query:
              $json_array = array("RETURN_CODE"=>1, "SUCCESS_CODE"=>-1, "ERROR_MESSAGE"=>"The database query for the filtered Projects was unsuccessful, please try again later");

              echo $project->add_message("output the JSON data for the Projects", 3);

              //return the encoded json content:
              echo json_encode($json_array);
            }

          }

        }
        else
        {
          //this is an invalid request, the parameters sent with the request are not acceptable parameters:
          echo $project->add_message("This is an invalid request, the parameters for the request are: ".var_export($_REQUEST, true));
          //send back the JSON response for the unsuccessful query:
          $json_array = array("RETURN_CODE"=>1, "SUCCESS_CODE"=>-1, "ERROR_MESSAGE"=>"The request contained invalid parameters, please reload the page and try again");
          //return the encoded json content:
          echo json_encode($json_array);
        }
      }
    }
?>

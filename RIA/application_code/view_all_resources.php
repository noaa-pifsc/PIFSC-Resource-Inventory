<?php

	include_once ("constants.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."html_page.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."output_message.php");
  include_once (APPLICATION_INCLUDE_PATH."resource.php");
	include_once (APPLICATION_INCLUDE_PATH."db_connection_info.php");
//	include_once (APPLICATION_INCLUDE_PATH."PRI_generate_html.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."find_array_pos.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."sanitize_values.php");

  //create the new resource object
  $resource = new resource("PIFSC_view_all_resources_".date("Ymd_H_i").".log", $_SERVER["SCRIPT_FILENAME"]);

  //return the $oracle_db resource so it can be used to query the DB:
  $oracle_db = $resource->return_oracle_db();

	//create the initial log message for the request
//	echo $resource->add_message("page request to ".$_SERVER["SCRIPT_FILENAME"]." from IP address: ".$_SERVER['REMOTE_ADDR']." with arguments: ".var_export($_REQUEST, true), 3);


	//initialize the variable used to construct the HTML content in the body of the page:
	$string_buffer = '';


	//check if the "req" parameter has been specified for the page request:
	if (!isset($_POST['req']))
	{
		//the current request does not have the "req" parameter defined, this is an initial page request:
//		echo $resource->add_message("There is no request parameters, respond with full HTML page content", 3);

		//initialize the html_page parameters
		$css_include = array();
		$javascript_include = array();
		$priority_header_content = '';
		$inline_javascript = '';

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

			//no arguments were passed to the page, this is the initial html page content request:

			//define the css include files for the initial HTML page content
			$css_include = array("./css/template.css", "./css/RIA_resource.css", "./css/tooltip.css", "./css/ajax_load.css", "./css/display_card.css", SHARED_LIBRARY_CLIENT_PATH."css/smoothness/jquery-ui-1.12.1.min.css", );

			//define the javascript include files for the initial HTML page content:
			$javascript_include = array();

			//generate the javascript include files with the "defer" keyword
			$priority_header_content = external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery-1.7.2.min.js").external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery.tablescroll.js").external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery-ui-1.12.1.min.js")."<script type=\"text/javascript\" defer=\"defer\" src=\"./js/RIA.js\"></script><script type=\"text/javascript\" defer=\"defer\" src=\"./js/resources.js\"></script><script type=\"text/javascript\" defer=\"defer\" src=\"./js/RIA_tooltips.js\"></script>";


			//generate the main HTML content:

			//this is the disabled_content_overlay div, this is used to disable the user interface when the application is working on an AJAX request or the original javascript code is being executed
			$string_buffer .= "<div id=\"disabled_content_overlay\" style=\"display:none;\"></div>";

			//this is the HTML for the loading graphic when the user interface is disabled:
			$string_buffer .= "<div id=\"ajax_loading_graphic\"><strong>Please Wait...</strong></div>";

      //this is the page heading content:
      $string_buffer .= "<div class=\"navigation_menu\">
      <a href=\"./view_all_projects.php\">View All Projects</a> <span>View All Resources</span>
      </div>";

      //fixed background image div
      $string_buffer .= "<div id=\"bg\">
        <img src=\"./images/app_background.jpg\" alt=\"NOAA background image\">
      </div>";

			//this is the page heading content:
			$string_buffer .= div_tag(h1_tag("All Resources", array("class=\"page_heading\"")), array("class=\"page_heading_div\""));



			//define the main content div (display:none to address the flash of unstyled content problem - hide the content until the javascript code has finished executing)
			$string_buffer .= "<div class=\"main_content_div\" style=\"display:none;\">";


      //initialize the array to store the res_scope_id and res_scope_name to populate the select element:
      $scope_array = array(array(), array());

      //initialize the array to store the res_type_id and res_type_name to populate the select element:
      $type_array = array(array(), array());

      //initialize the array to store the data_source_id and data_source_name to populate the select element:
      $data_source_array = array(array(), array());

      //define the SQL for the query to retrieve all of the resource scopes:
			$SQL = "SELECT res_scope_id, res_scope_name from PRI.PRI_RES_SCOPES
			order by UPPER(res_scope_name)";

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


					//the current cruise ID was not added to the list of cruises, add it now
					$scope_array[0][] = $row['RES_SCOPE_ID'];
					$scope_array[1][] = $row['RES_SCOPE_NAME'];
				}



        //define the SQL for the query to retrieve all of the resource types:
  			$SQL = "SELECT res_type_id, res_type_name from PRI.PRI_RES_TYPES
  			order by UPPER(res_type_name)";

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


//            echo var_export($row, true)."<BR>";

  					//the current cruise ID was not added to the list of cruises, add it now
  					$type_array[0][] = $row['RES_TYPE_ID'];
  					$type_array[1][] = $row['RES_TYPE_NAME'];
  				}



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





      			//define the SQL for the query to retrieve all of the non-private Resources:
      			$SQL = "SELECT PROJ_ID, PROJ_NAME, PROJ_DESC, DATA_SOURCE_NAME, PROJ_VISIBILITY, README_URL, AVATAR_URL, VC_WEB_URL, RES_ID, RES_NAME, RES_MAX_VERS_NUM, NVL(CURR_VERS_COUNT, 0) CURR_VERS_COUNT, NVL(OLD_VERS_COUNT, 0) OLD_VERS_COUNT, NVL(TOTAL_IMPL_PROJ, 0) TOTAL_IMPL_PROJ, NVL(ASSOC_PROJ_LINK_BR_LIST, 'N/A') ASSOC_PROJ_LINK_BR_LIST, RES_CATEGORY, RES_URL, RES_SCOPE_NAME, RES_TYPE_NAME, RES_DESC, RES_DEMO_URL, VC_COMMIT_COUNT, FORMAT_VC_REPO_SIZE_MB, NVL(OWNER_USER_NAME, 'N/A') OWNER_USER_NAME, OWNER_AVATAR_URL, OWNER_WEB_URL, NVL(CREATOR_USER_NAME, 'N/A') CREATOR_USER_NAME, CREATOR_AVATAR_URL, CREATOR_WEB_URL, TO_CHAR(PROJ_REFRESH_DATE, 'MM/DD/YYYY HH24:MI:SS') PROJ_REFRESH_DATE, TO_CHAR(PROJ_CREATE_DTM, 'MM/DD/YYYY HH24:MI:SS') PROJ_CREATE_DTM, TO_CHAR(PROJ_UPDATE_DTM, 'MM/DD/YYYY HH24:MI:SS') PROJ_UPDATE_DTM FROM PRI.PRI_RES_PROJ_TAG_MAX_SUM_ALL_V WHERE PROJ_VISIBILITY <> 'private' order by UPPER(PROJ_NAME), UPPER(RES_NAME)";

      			//initialize $dummy_id variable for the query:
      			$dummy_id = null;

      			//execue the SQL query:
      			if ($oracle_db->query($SQL, $stid, $dummy_id))
      			{
      				//the query was successful:



              //create the div tag for the filtering form container:
              $string_buffer .= "<div class=\"form_container\">";

              //construct the form elements (multiple select item and filter button) and the field label as a tooltip:
              $form_string = a_tag("#", 'Resource Scope', array("class=\"tooltip filter_field\"", "title=\"Select one or more Resource Scopes to filter the Resources, the results will be filtered to include any of the selected Resource Scopes\"")).": ".select_tag('res_scope_id[]', -1, $scope_array[0], $scope_array[1], array("multiple=\"multiple\"", "class=\"filter_field\"", "size=\"".(count($scope_array[0]) < 4 ? count($scope_array[0]) : 4)."\"", "id=\"res_scope_select_id\""));


              $form_string .= a_tag("#", 'Resource Type', array("class=\"tooltip filter_field\"", "title=\"Select one or more Resource Types to filter the Resources, the results will be filtered to include any of the selected Resource Types\"")).": ".select_tag('res_type_id[]', -1, $type_array[0], $type_array[1], array("multiple=\"multiple\"", "class=\"filter_field\"", "size=\"".(count($type_array[0]) < 4 ? count($type_array[0]) : 4)."\"", "id=\"res_type_select_id\""));

              $form_string .= a_tag("#", 'Project Source', array("class=\"tooltip filter_field\"", "title=\"Select one or more Project Sources to filter the Resources, the results will be filtered to include any of the selected Project Sources\"")).": ".select_tag('data_source_id[]', -1, $data_source_array[0], $data_source_array[1], array("multiple=\"multiple\"", "class=\"filter_field\"", "size=\"".(count($data_source_array[0]) < 4 ? count($data_source_array[0]) : 4)."\"", "id=\"data_source_select_id\""));


              $form_string .= a_tag("#", 'Text Search', array("class=\"tooltip filter_field\"", "title=\"Type in a search phrase to find in the Project/Resource Name, Description, and Category, the results will be filtered to include the entered search phrase\"")).": ".text_field ('search_phrase', '', array("class=\"filter_field\""));


              //construct the filter resources button for the filtering form:
              $form_string .= " ".a_tag("#", "Filter Resources", array("class=\"tooltip link_button filter_field_button\"", "onclick=\"request_resources();\"", "title=\"Click the button to refresh the Resources displayed in the page\""));

              //add the HTML markup for the accordion widget that will allow filtering of Resources and add the $form_string content for the form elements:
              $string_buffer .= div_tag(h3_tag("Report Filter", array("class=\"tooltip\"", "title=\"Click the arrow to expand the Report Filter to search for Resources\"")).div_tag($form_string), array("id=\"accordion_filter\""));

              //close the form container div:
              $string_buffer.= "</div>";


              //create the div tag for the resource information container:
              $string_buffer .= "<div id=\"resource_container_id\">";


      				//loop through result set:
      				while ($row = $oracle_db->fetch($stid))
      				{

                //convert HTML special characters to their corresponding HTML entities to protect against XSS attacks that could originate from the database query (no exceptions are specified on the sanitize_values() function call):
      //          $row = sanitize_values($row, false, false, false, true);

                //generate the resource display card HTML:
                $string_buffer .= $resource->generate_resource_display_card($row);
      				}


              //end the div tag for the resource information container:
              $string_buffer .= "<!-- End tag for the resource information container --></div>";

      			}
      			else
      			{
      				//the database query was not successfully executed

      				//send back the HTML content to indicate the DB query failed:
      				$string_buffer .= b_tag("There was a problem with the database and your request could not be processed, please try again later");

      				//log the failed database query:
      				echo $resource->add_message("The PIFSC Resources query was not successful");

      				//define the html page arguments for the page so the error can be displayed (no need to load the js and css because the content request failed):
      				$inline_javascript = '';
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
            $string_buffer .= "</div>";

          }

        }
        else
        {
          //the resource type information could not be queried successfully:
          $string_buffer .= b_tag("There was a problem with the database and your request could not be processed, please try again later");

          $resource->add_message("The resource type query failed");

          //close the main_content_div
          $string_buffer .= "</div>";

        }


      }
      else
      {
        //the resource scope information could not be queried successfully:
        $string_buffer .= b_tag("There was a problem with the database and your request could not be processed, please try again later");

        $resource->add_message("The resource scope query failed");

        //close the main_content_div
        $string_buffer .= "</div>";


      }



		}

		//output the HTML page content with $string_buffer in the <body> tag:
		echo html_page ('All Resources', $string_buffer, array(), $inline_javascript, $javascript_include, '', $css_include, false, array(), array(), $priority_header_content);

	}
  else
  {
      //there was at least one parameter defined for the request:

      //		echo "This is a request with a parameter";
//  		echo $resource->add_message("This is a request with a parameter", 3);

  		//check if the oracle database connection was successful:
  		if (!$oracle_db->is_connected($error_info))
  		{
  			//the oracle connection was unsuccessful

  			//log the unsuccessful database connection:
  			echo $resource->add_message("database connection was unsuccessful, oci_error(): ".var_export($error_info, true));

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
//  				echo $resource->add_message("This is a filter resources request", 3);

  				//additional where clause for the query based on request parameters:
  				$SQL_where = '';

  				//variable to define bind variables for the SQL query:
  				$bind_array = array();


          //variable to store the where clauses from the filter parameters
          $where_array = array();

  				//initialize variable to detect if there were any invalid parameters:
  				$invalid_parameters = false;

  				//check if the res_scope_id parameter is defined:
  				if (isset($_POST['res_scope_id']))
  				{
            //a res_scope_id parameter was defined:
//            echo $resource->add_message("one or more res_scope_id parameters were specified: ".var_export($_POST['res_scope_id'], true), 3);

            $resource->process_filter_id_values ($_POST['res_scope_id'], 'res_scope_id', $invalid_parameters, $where_array, $bind_array);

  				}


          //check if the res_type_id parameter is defined if there were no invalid parameters found:
          if ((!$invalid_parameters) && (isset($_POST['res_type_id'])))
          {
            //a res_type_id parameter was defined:
//            echo $resource->add_message("one or more res_type_id parameters were specified: ".var_export($_POST['res_type_id'], true), 3);

            $resource->process_filter_id_values ($_POST['res_type_id'], 'res_type_id', $invalid_parameters, $where_array, $bind_array);
          }


          //check if the data_source_id parameter is defined if there were no invalid parameters found:
          if ((!$invalid_parameters) && (isset($_POST['data_source_id'])))
          {
            //a data_source_id parameter was defined:
//            echo $resource->add_message("one or more data_source_id parameters were specified: ".var_export($_POST['data_source_id'], true), 3);

            $resource->process_filter_id_values ($_POST['data_source_id'], 'data_source_id', $invalid_parameters, $where_array, $bind_array);
          }

          //check if the res_type_id parameter is defined if there were no invalid parameters found:
          if ((!$invalid_parameters) && (isset($_POST['search_phrase'])))
          {
            //a search_phrase parameter was defined:

            $where_array[] = "(UPPER(RES_NAME) LIKE '%'||UPPER(:search_phrase1)||'%' OR UPPER(RES_DESC) LIKE '%'||UPPER(:search_phrase2)||'%' OR UPPER(PROJ_NAME) LIKE '%'||UPPER(:search_phrase3)||'%' OR UPPER(PROJ_DESC) LIKE '%'||UPPER(:search_phrase4)||'%' OR UPPER(RES_CATEGORY) LIKE '%'||UPPER(:search_phrase5)||'%')";

            $bind_array[] = array(":search_phrase1", trim($_POST['search_phrase']));
            $bind_array[] = array(":search_phrase2", trim($_POST['search_phrase']));
            $bind_array[] = array(":search_phrase3", trim($_POST['search_phrase']));
            $bind_array[] = array(":search_phrase4", trim($_POST['search_phrase']));
            $bind_array[] = array(":search_phrase5", trim($_POST['search_phrase']));
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
  					//the parameters are valid, execute the Resource query:


            //check if any parameters were specified
            if (count($where_array) > 0)
            {
                $where_clause = " AND ".implode(" AND ", $where_array);

            }
            else
            {
                $where_clause = '';
            }

  					//generate the query for all Resources including the WHERE clause for any parameters provided with the request
  					$SQL = "SELECT PROJ_ID, PROJ_NAME, PROJ_DESC, DATA_SOURCE_NAME, PROJ_VISIBILITY, README_URL, AVATAR_URL, VC_WEB_URL, RES_ID, RES_NAME, RES_MAX_VERS_NUM, NVL(CURR_VERS_COUNT, 0) CURR_VERS_COUNT, NVL(OLD_VERS_COUNT, 0) OLD_VERS_COUNT, NVL(TOTAL_IMPL_PROJ, 0) TOTAL_IMPL_PROJ, NVL(ASSOC_PROJ_LINK_BR_LIST, 'N/A') ASSOC_PROJ_LINK_BR_LIST, RES_CATEGORY, RES_URL, RES_SCOPE_NAME, RES_TYPE_NAME, RES_DESC, RES_DEMO_URL, VC_COMMIT_COUNT, FORMAT_VC_REPO_SIZE_MB, NVL(OWNER_USER_NAME, 'N/A') OWNER_USER_NAME, OWNER_AVATAR_URL, OWNER_WEB_URL, NVL(CREATOR_USER_NAME, 'N/A') CREATOR_USER_NAME, CREATOR_AVATAR_URL, CREATOR_WEB_URL, TO_CHAR(PROJ_REFRESH_DATE, 'MM/DD/YYYY HH24:MI:SS') PROJ_REFRESH_DATE, TO_CHAR(PROJ_CREATE_DTM, 'MM/DD/YYYY HH24:MI:SS') PROJ_CREATE_DTM, TO_CHAR(PROJ_UPDATE_DTM, 'MM/DD/YYYY HH24:MI:SS') PROJ_UPDATE_DTM FROM PRI.PRI_RES_PROJ_TAG_MAX_SUM_ALL_V WHERE PROJ_VISIBILITY <> 'private'".$where_clause." order by UPPER(PROJ_NAME), UPPER(RES_NAME)";

  					//log the valid parameters
//  					echo $resource->add_message("The request parameters are valid, execute the resource query: ".$SQL.", with bind vars: ".var_export($bind_array, true), 3);

  					//initialize $dummy_id variable for the query:
  					$dummy_id = null;

  					//execute the Resource query:
  					if ($oracle_db->query($SQL, $stid, $dummy_id, $bind_array))
  					{
  						//the query was successful:
//  						echo $resource->add_message("The database query was successful", 3);

  						//construct the json array for the successful request
  						$json_array = array("RETURN_CODE"=>1, "SUCCESS_CODE"=>1, "RESOURCES"=>array());

  						//loop through result set and define the values in the json array for each Resource:
  						while ($row = $oracle_db->fetch($stid))
  						{
  							//construct the json array values for the current Resource and add it to json_array
  							$json_array['RESOURCES'][] = array("proj_id"=>$row['PROJ_ID'], "proj_name"=>$row['PROJ_NAME'], "proj_desc"=>$row['PROJ_DESC'], "data_source_name"=>$row['DATA_SOURCE_NAME'], "proj_visibility"=>$row['PROJ_VISIBILITY'], "readme_url"=>$row['README_URL'], "avatar_url"=>$row['AVATAR_URL'], "vc_web_url"=>$row['VC_WEB_URL'], "res_id"=>$row['RES_ID'], "res_name"=>$row['RES_NAME'], "res_max_vers_num"=>$row['RES_MAX_VERS_NUM'], "curr_vers_count"=>$row['CURR_VERS_COUNT'], "old_vers_count"=>$row['OLD_VERS_COUNT'], "total_impl_proj"=>$row['TOTAL_IMPL_PROJ'], "assoc_proj_link_br_list"=>$row['ASSOC_PROJ_LINK_BR_LIST'], "res_category"=>$row['RES_CATEGORY'], "res_url"=>$row['RES_URL'], "res_scope_name"=>$row['RES_SCOPE_NAME'], "res_type_name"=>$row['RES_TYPE_NAME'], "res_desc"=>$row['RES_DESC'], "res_demo_url"=>$row['RES_DEMO_URL'], "vc_commit_count"=>$row['VC_COMMIT_COUNT'], "format_vc_repo_size_mb"=>$row['FORMAT_VC_REPO_SIZE_MB'], "owner_user_name"=>$row['OWNER_USER_NAME'], "owner_avatar_url"=>$row['OWNER_AVATAR_URL'], "owner_web_url"=>$row['OWNER_WEB_URL'], "creator_user_name"=>$row['CREATOR_USER_NAME'], "creator_avatar_url"=>$row['CREATOR_AVATAR_URL'], "creator_web_url"=>$row['CREATOR_WEB_URL'], "proj_refresh_date"=>$row['PROJ_REFRESH_DATE'], "proj_create_dtm"=>$row['PROJ_CREATE_DTM'], "proj_update_dtm"=>$row['PROJ_UPDATE_DTM']);
  						}

//  						echo $resource->add_message("output the JSON data for the filtered resources", 3);

  						//the query was successful, respond with a JSON array of values (the str_replace() call is to handle a bug with the way that PHP encodes JSON by escaping forward slashes):
  						echo str_replace('\\/', '/', json_encode($json_array));
  					}
  					else
  					{
  						//query was unsuccessful:

  						//log the error information for the database query:
  						echo $resource->add_message("The database query was unsuccessful, error: ".var_export(oci_error($stid), true));

  						//send back the JSON response for the unsuccessful query:
  						$json_array = array("RETURN_CODE"=>1, "SUCCESS_CODE"=>-1, "ERROR_MESSAGE"=>"The database query for the filtered Resources was unsuccessful, please try again later");

  						echo $resource->add_message("output the JSON data for the Resources", 3);

  						//return the encoded json content:
  						echo json_encode($json_array);
  					}
  				}
  			}
  			else
  			{
  				//this is an invalid request, the parameters sent with the request are not acceptable parameters:
  				echo $resource->add_message("This is an invalid request, the parameters for the request are: ".var_export($_REQUEST, true));
  				//send back the JSON response for the unsuccessful query:
  				$json_array = array("RETURN_CODE"=>1, "SUCCESS_CODE"=>-1, "ERROR_MESSAGE"=>"The request contained invalid parameters, please reload the page and try again");
  				//return the encoded json content:
  				echo json_encode($json_array);
  			}
  		}



  }
?>

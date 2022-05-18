<?php

        ini_set("display_errors", "On");
        ini_set('date.timezone', "Pacific/Honolulu");

	include_once ("constants.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."html_page.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."output_message.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."oracle_db.php");
	include_once (APPLICATION_INCLUDE_PATH."db_connection_info.php");
	include_once (APPLICATION_INCLUDE_PATH."PRI_generate_html.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."find_array_pos.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."sanitize_values.php");

	//connect to the database (do not exit on failure automatically):
	$oracle_db = new oracle_db(DB_USER, DB_PASS, DB_HOST, false);

	//create the new $output_message object to log information about the application
	$output_message = new output_message("PIFSC_resource_inventory_".date("Ymd_H_i").".log", 2, true, $oracle_db, $_SERVER["SCRIPT_FILENAME"], 'PRI');

	//create the initial log message for the request
	echo $output_message->add_message("page request to ".$_SERVER["SCRIPT_FILENAME"]." from IP address: ".$_SERVER['REMOTE_ADDR']." with arguments: ".var_export($_REQUEST, true), 3);


	//initialize the variable used to construct the HTML content in the body of the page:
	$string_buffer = '';


	//check if the "req" parameter has been specified for the page request:
	if (!isset($_POST['req']))
	{
		//the current request does not have the "req" parameter defined, this is an initial page request:
		echo $output_message->add_message("There is no request parameters, respond with full HTML page content", 3);

		//initialize the html_page parameters
		$css_include = array();
		$javascript_include = array();
		$priority_header_content = '';
		$inline_javascript = '';

		//check if the oracle database connection was successful:
		if (!$oracle_db->is_connected($error_info))
		{
			//the database connection was unsuccessful:
			echo $output_message->add_message("database connection was unsuccessful, oci_error(): ".var_export($error_info, true));

			//send back the HTML content to indicate the failed DB connection:
			$string_buffer .= b_tag("Could not connect to the database, please try again later");
		}
		else
		{
			//the database connection was successful, continue generating the initial page content:

			//no arguments were passed to the page, this is the initial html page content request:

			//define the css include files for the initial HTML page content
			$css_include = array("./css/RIA_project.css", "./css/tooltip.css", "./css/ajax_load.css", "./css/display_card.css", SHARED_LIBRARY_CLIENT_PATH."css/smoothness/jquery-ui-1.12.1.min.css", );

			//define the javascript include files for the initial HTML page content:
			$javascript_include = array();

			//generate the javascript include files with the "defer" keyword
			$priority_header_content = external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery-1.7.2.min.js").external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery.tablescroll.js").external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery-ui-1.12.1.min.js")."<script type=\"text/javascript\" defer=\"defer\" src=\"./js/RIA.js\"></script>";


			//generate the main HTML content:

			//this is the disabled_content_overlay div, this is used to disable the user interface when the application is working on an AJAX request or the original javascript code is being executed
			$string_buffer .= "<div id=\"disabled_content_overlay\" style=\"display:none;\"></div>";

			//this is the HTML for the loading graphic when the user interface is disabled:
			$string_buffer .= "<div id=\"ajax_loading_graphic\"><strong>Please Wait...</strong></div>";

			//this is the page heading content:
			$string_buffer .= div_tag(h1_tag("All Projects", array("class=\"page_heading\"")), array("class=\"page_heading_div\""));

			//define the main content div (display:none to address the flash of unstyled content problem - hide the content until the javascript code has finished executing)
			$string_buffer .= "<div class=\"main_content_div\" style=\"display:none;\">";



			//define the SQL for the query to retrieve all of the non-private projects:
			$SQL = "SELECT PROJ_ID, PROJ_NAME, PROJ_DESC, HTTP_URL, RES_NAME_LINK_BR_LIST, NVL(NUM_RES, 0) NUM_RES, NVL(CURR_VERS_COUNT, 0) CURR_VERS_COUNT, NVL(OLD_VERS_COUNT, 0) OLD_VERS_COUNT, NVL(TOTAL_IMPL_RES, 0) TOTAL_IMPL_RES, IMPL_RES_LINK_BR_LIST, HTTP_URL, AVATAR_URL, PROJ_NAME_SPACE, PROJ_SOURCE, PROJ_VISIBILITY, README_URL FROM PRI.PRI_PROJ_RES_TAG_MAX_SUM_ALL_V WHERE PROJ_VISIBILITY <> 'private' order by UPPER(PROJ_NAME_SPACE)";

			//initialize $dummy_id variable for the query:
			$dummy_id = null;

			//execue the SQL query:
			if ($oracle_db->query($SQL, $stid, $dummy_id))
			{
				//the query was successful:

				//initialize the string used to generate the table content (tr and td for all data returned by query)
				$table_string = '';

				//initialize string to define all survey locations so they can be programmatically added to Google Maps
//				$inline_javascript = "var markers = [];\n";

				//initialize integer to keep track of which database result set row this is (used in view survey links as well as JavaScript markers variable definition)
				$current_pos = 0;

				//initialize the array to store the cruise_id and cruise_name to populate the select element:
				$cruise_array = array(array(), array());

				//loop through result set:
				while ($row = $oracle_db->fetch($stid))
				{
					//convert HTML special characters to their corresponding HTML entities to protect against XSS attacks that could originate from the database query (no exceptions are specified on the sanitize_values() function call):



          $table_string .= "<article class=\"card_parent\">
            <div class=\"content\">
              <div class=\"proj_name_div card_container\">
                <div class=\"card_label tooltip\" title=\"The name of the Project.  Clicking the Project icon or name will open a new tab to the Project page.  Clicking the external link window will open the project resource in a new browser tab.\">Project</div>
                <div class=\"card_avatar_name\">
                    <div class=\"card_name_container\">
                      <a href=\"".$row['HTTP_URL']."\" target=\"_blank\" class=\"proj_name_link\"><img
                      class=\"avatar\"
                      src=\"".((empty($row['AVATAR_URL'])) ? "./images/no image.png" : $row['AVATAR_URL'])."\"
                      alt=\"Project Avatar\"
                      /></a>
                      <div class=\"card_value\"><a href=\"./project.php?PROJ_ID=".$row['PROJ_ID']."\">".$row['PROJ_NAME']."</a> <a href=\"".$row['HTTP_URL']."\" target=\"_blank\"><span class=\"ui-icon ui-icon-extlink\"></span></a></div>
                    </div>
                </div>
                <div class=\"card_desc_container\">
                  <div class=\"card_label tooltip\" title=\"The description for the Project\">Description</div>
                  <div class=\"card_value\">".$row['PROJ_DESC']."</div>
                </div>
              </div>
              <div class=\"spacer\"></div>
              <div class=\"proj_info_div card_container\">
                  <div class=\"card_label tooltip\" title=\"The source of the project record (e.g. PIFSC GitLab, GitHub, manual entry)\">Project Source</div>
                  <div class=\"card_value\">".$row['PROJ_SOURCE']."</div>
                  <div class=\"card_label tooltip\" title=\"The visibility of the Project (private, internal, public)\">Visibility</div>
                  <div class=\"card_value\">".$row['PROJ_VISIBILITY']."</div>
                  <div class=\"card_label tooltip\" title=\"Link to the Project's README file (if defined)\">README Link</div>
                  <div class=\"card_value\">".((empty($row['README_URL'])) ? "N/A": " <a href=\"".$row['README_URL']."\" target=\"_blank\">README</a>")."</div>
                  <div class=\"card_label tooltip\" title=\"The number of Resources defined within the Project\"># Project Resources</div>
                  <div class=\"card_value\">".$row['NUM_RES']."</div>
              </div>
              <div class=\"spacer\"></div>
              <div class=\"proj_res_div card_container\">
                  <div class=\"card_label tooltip\" title=\"The list of Project Resources and associated highest version number defined within the project that provides links to the associated Resources\">Project Resources</div>
                  <div class=\"card_value\">".$row['RES_NAME_LINK_BR_LIST']."</div>
              </div>
              <div class=\"spacer\"></div>
              <div class=\"proj_impl_res_info_div card_container\">
                  <div class=\"card_label tooltip\" title=\"The total number of implemented external Resources for the Project\"># Implemented Resources</div>
                  <div class=\"card_value\">".$row['TOTAL_IMPL_RES']."</div>
                  <div class=\"card_label tooltip\" title=\"The number of implemented external Resources for the Project that are the same as the current version of the Resource\"># Current Version</div>
                  <div class=\"card_value\">".$row['CURR_VERS_COUNT']."</div>
                  <div class=\"card_label tooltip\" title=\"The number of implemented external Resources for the Project that are not the same as the current version of the Resource\"># Old Version</div>
                  <div class=\"card_value\">".$row['OLD_VERS_COUNT']."</div>
              </div>
              <div class=\"spacer\"></div>
              <div class=\"proj_impl_res_div card_container\">
                  <div class=\"card_label tooltip\" title=\"The list of implemented external Resources and associated highest version number for the Project that provides links to the associated Resources.  If the current version of the Resource implemented in the Project is the same as the current version of the Resource the Resource name is preceded by a &quot;(*CV)&quot; prefix to indicate it is the current version and if not the &quot;(*UA)&quot; prefix is used to indicate there is an update available\">Implemented Resources</div>
                  <div class=\"card_value\">".$row['IMPL_RES_LINK_BR_LIST']."</div>
              </div>
            </div>
          </article>";
				}

        $string_buffer .= $table_string;


			}
			else
			{
				//the database query was not successfully executed

				//send back the HTML content to indicate the DB query failed:
				$string_buffer .= b_tag("There was a problem with the database and your request could not be processed, please try again later");

				//log the failed database query:
				echo $output_message->add_message("The PIFSC Projects query was not successful");

				//define the html page arguments for the page so the error can be displayed (no need to load the js and css because the content request failed):
				$inline_javascript = '';
				$javascript_include = array();
				$css_include = array();
			}
		}

		//output the HTML page content with $string_buffer in the <body> tag:
		echo html_page ('All Projects', $string_buffer, array(), $inline_javascript, $javascript_include, '', $css_include, false, array(), array(), $priority_header_content);

	}
?>

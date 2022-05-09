<?php

	//connect to the database (do not exit on failure automatically):
	$oracle_db = new oracle_db(DB_USER, DB_PASS, DB_HOST, false);

	//create the new $output_message object to log information about the application
	$output_message = new output_message("PIFSC_resource_inventory_".date("Ymd_H_i").".log", 2, true, $oracle_db, $_SERVER["SCRIPT_FILENAME"]);

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
			$css_include = array(SHARED_LIBRARY_CLIENT_PATH."css/tablescroll.css", SHARED_LIBRARY_CLIENT_PATH."css/smoothness/jquery-ui-1.12.1.min.css");

			//define the javascript include files for the initial HTML page content:
			$javascript_include = array();

			//generate the javascript include files with the "defer" keyword
			$priority_header_content = external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery-1.7.2.min.js").external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery.tablescroll.js").external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery-ui-1.12.1.min.js");


			//generate the main HTML content:

			//this is the disabled_content_overlay div, this is used to disable the user interface when the application is working on an AJAX request or the original javascript code is being executed
			$string_buffer .= "<div id=\"disabled_content_overlay\" style=\"display:none;\"></div>";

			//this is the HTML for the loading graphic when the user interface is disabled:
			$string_buffer .= "<div id=\"ajax_loading_graphic\"><strong>Please Wait...</strong></div>";

			//this is the page heading content:
			$string_buffer .= div_tag(div_tag("MOUSS Video App", array("class=\"page_heading\"")), array("class=\"page_heading_div\""));

			//define the main content div (display:none to address the flash of unstyled content problem - hide the content until the javascript code has finished executing)
			$string_buffer .= "<div class=\"main_content_div\" style=\"display:none;\">";



			//define the SQL for the query to retrieve all of the MOUSS surveys:
			$SQL = "SELECT cruise_id, cruise_name, format_cruise_start_date, format_cruise_end_date, mouss_survey_id, format_survey_date, survey_name, lat_dd, lon_dd, depth_m, temp_deg_c, inport_url, youtube_url from mouss_cruise_surveys_v
			order by survey_date";

			//initialize $dummy_id variable for the query:
			$dummy_id = null;

			//execue the SQL query:
			if ($oracle_db->query($SQL, $stid, $dummy_id))
			{
				//the query was successful:

				//initialize the string used to generate the table content (tr and td for all data returned by query)
				$table_string = '';

				//initialize string to define all survey locations so they can be programmatically added to Google Maps
				$inline_javascript = "var markers = [];\n";

				//initialize integer to keep track of which database result set row this is (used in view survey links as well as JavaScript markers variable definition)
				$current_pos = 0;

				//initialize the array to store the cruise_id and cruise_name to populate the select element:
				$cruise_array = array(array(), array());

				//loop through result set:
				while ($row = $oracle_db->fetch($stid))
				{
					//convert HTML special characters to their corresponding HTML entities to protect against XSS attacks that could originate from the database query (no exceptions are specified on the sanitize_values() function call):
					$row = sanitize_values($row, false, false, false, true);

					//generate the HTML table row for the current result set row:
					$table_string .= tr_tag(td_tag($row['CRUISE_NAME']).td_tag($row['SURVEY_NAME']).td_tag($row['FORMAT_SURVEY_DATE']).td_tag($row['LAT_DD']).td_tag($row['LON_DD']).td_tag($row['DEPTH_M']).td_tag($row['TEMP_DEG_C']).td_tag(a_tag ("#", "View Survey", array("onclick=\"view_survey(".$current_pos.");\""))).td_tag(a_tag($row['INPORT_URL'], "View Metadata", array("target=\"_blank\""))).td_tag(a_tag($row['YOUTUBE_URL'], "YouTube", array("target=\"_blank\""))));


					//generate the javascript content to define the Google Maps marker information for the current result set row:
					$inline_javascript .= "markers[$current_pos] = {lat: ".$row['LAT_DD'].", lon: ".$row['LON_DD'].", survey_name: \"".$row['SURVEY_NAME']."\", info_window_content: ".generate_info_window($row)."};\n";

					//check if the current cruise ID was already added to the list of cruises
					if (!find_array_pos($row['CRUISE_ID'], $cruise_array[0], $pos))
					{
						//the current cruise ID was not added to the list of cruises, add it now
						$cruise_array[0][] = $row['CRUISE_ID'];
						$cruise_array[1][] = $row['CRUISE_NAME']." (".$row['FORMAT_CRUISE_START_DATE']." - ".$row['FORMAT_CRUISE_END_DATE'].")";
					}
					//increment the current position of the survey (used in view survey links as well as JavaScript markers variable definition)
					$current_pos ++;
				}

				//now that the $table_string has been constructed generate the table container and add the $table_string:
				if (generate_table_container($tooltip_info, $table_container_content, $table_string))
				{
					//the table container was generated successfully:

					//free the memory used to store the row HTML content now that the full HTML table content is generated:
					unset($table_string);



					//create the div tag for the error message for any problematic user interface errors:
					$string_buffer .= div_tag(p_tag("", array("id=\"error_message\"")), array("id=\"dialog_id\"", "title=\"Error\"", "style=\"display:none;\""));

					//create the div tag for the Google Maps plugin:
					$string_buffer .= div_tag("", array("id=\"map\""));

					//create the div tag for the filtering form container:
					$string_buffer .= "<div class=\"form_container\">";

					//construct the form elements (multiple select item and filter button) and the field label as a tooltip:
					$form_string = a_tag("#", $tooltip_info['mouss_cruises_select']['display_value'], array("class=\"tooltip\"", "title=\"".$tooltip_info['mouss_cruises_select']['tooltip_content']."\"")).": ".select_tag('cruise_id[]', -1, $cruise_array[0], $cruise_array[1], array("multiple=\"multiple\"", "size=\"".(count($cruise_array[0]) < 4 ? count($cruise_array[0]) : 4)."\"", "id=\"cruise_select_id\""));

					//construct the filter surveys button for the filtering form:
					$form_string .= " ".a_tag("#", $tooltip_info['filter_surveys_button']['display_value'], array("class=\"tooltip link_button\"", "onclick=\"request_surveys();\"", "title=\"".$tooltip_info['filter_surveys_button']['tooltip_content']."\""));

					//add the HTML markup for the accordion widget that will allow filtering of MOUSS surveys and add the $form_string content for the form elements:
					$string_buffer .= div_tag(h3_tag($tooltip_info['filter_container']['display_value'], array("class=\"tooltip\"", "title=\"".$tooltip_info['filter_container']['tooltip_content']."\"")).div_tag($form_string), array("id=\"accordion_filter\""));

					//close the form container div:
					$string_buffer.= "</div>";

					//define the container div for the MOUSS survey table
					$string_buffer .= "<div class=\"MOUSS_survey_table\">";


					//this is the content that will be replaced in the DOM when a filter request is made:

					//create the label for the MOUSS survey table with a font tag element that can be changed when the AJAX response is received from filter requests:
					$string_buffer .= div_tag("MOUSS Surveys (".font_tag($current_pos, array("id=\"number_surveys_id\""))." Shown)", array("class=\"MOUSS_table_label\""));
					//generate the MOUSS survey table template and add the constructed $table_string as the row content:
					$string_buffer .= $table_container_content;

					//close the MOUSS survey table container div
					$string_buffer .= " </div>";

					//close the main content div:
					$string_buffer .= "</div>";
				}
				else
				{
					//the column headings could not be generated successfully, provide the user an error and advise them to try again later:
					$string_buffer .= b_tag("There was a problem with the database and your request could not be processed, please try again later");

					$output_message->add_message("The generate_table_container() function failed, the user was provided a non-descriptive database error and did not serve any dynamic content");

					//close the main_content_div
					$string_buffer .= "</div>";
				}
			}
			else
			{
				//the database query was not successfully executed

				//send back the HTML content to indicate the DB query failed:
				$string_buffer .= b_tag("There was a problem with the database and your request could not be processed, please try again later");

				//log the failed database query:
				echo $output_message->add_message("The MOUSS survey database query was not successful");

				//define the html page arguments for the page so the error can be displayed (no need to load the js and css because the content request failed):
				$inline_javascript = '';
				$javascript_include = array();
				$css_include = array();
			}
		}

		//output the HTML page content with $string_buffer in the <body> tag:
		echo html_page ('MOUSS Video App', $string_buffer, array(), $inline_javascript, $javascript_include, '', $css_include, false, array(), array(), $priority_header_content);

	}
?>

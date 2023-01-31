<?php

	include_once ("constants.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."html_page.php");
	include_once (APPLICATION_INCLUDE_PATH."RIA_template_page.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."output_message.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."oracle_db.php");
	include_once (APPLICATION_INCLUDE_PATH."db_connection_info.php");
	include_once (SHARED_LIBRARY_INCLUDE_PATH."sanitize_values.php");


  //return the $oracle_db resource so it can be used to query the DB:
  $oracle_db = new oracle_db();

	//create the initial log message for the request
//	echo $resource->add_message("page request to ".$_SERVER["SCRIPT_FILENAME"]." from IP address: ".$_SERVER['REMOTE_ADDR']." with arguments: ".var_export($_REQUEST, true), 3);


	//initialize the variable used to construct the HTML content in the body of the page:
	$string_buffer = '';


	//define a variable in the javascript to indicate the application instance
	$inline_javascript = "var app_instance = '".APP_INSTANCE."';";

  //define the css include files for the initial HTML page content
  $css_include = array("./css/template.css", "./css/tooltip.css", SHARED_LIBRARY_CLIENT_PATH."css/smoothness/jquery-ui-1.12.1.min.css", "./css/index.css");

	//define the javascript include files for the initial HTML page content:
	$javascript_include = array("./js/template.js", "./js/index.js", "./js/tooltip.js", "./js/RIA_tooltips.js");

  //generate the javascript include files with the "defer" keyword
  $priority_header_content = external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery-1.7.2.min.js").external_javascript(SHARED_LIBRARY_CLIENT_PATH."js/jquery-ui-1.12.1.min.js");



		//check if the oracle database connection was successful:
		if (!$oracle_db->is_connected($error_info))
		{
			//the database connection was unsuccessful:
//			echo $resource->add_message("database connection was unsuccessful, oci_error(): ".var_export($error_info, true));

			//send back the HTML content to indicate the failed DB connection:
			$string_buffer .= b_tag("Could not connect to the database, please try again later");

		}
		else
		{
			//the database connection was successful, continue generating the initial page content:


      //define the SQL for the query to retrieve the specified resource:
      $SQL = "select PROJ_VISIBILITY, count(*) NUM_PROJECTS from pri_proj where PROJ_VISIBILITY <> 'private' group by PROJ_VISIBILITY order by PROJ_VISIBILITY";

      //initialize $dummy_id variable for the query:
      $dummy_id = null;

      //execue the SQL query:
      if ($oracle_db->query($SQL, $stid, $dummy_id, array()))
      {
        //the query was successful:

				$table_buffer = thead_tag(tr_tag(th_tag("Visibility", array("class=\"tooltip\"", "title=\"Project visibility\"")).th_tag("# Projects", array("class=\"tooltip\"", "title=\"Number of projects\""))));

        //loop through result set:
        while ($row = $oracle_db->fetch($stid))
        {
          //the resource exists, generate the page content and display it:

          $table_buffer .= tr_tag(td_tag($row['PROJ_VISIBILITY']).td_tag($row['NUM_PROJECTS']));

        }
				$string_buffer .= div_tag(table_tag($table_buffer, array("class=\"report_table\"")), array("class=\"report_table_container\""));

				unset ($table_buffer);

      }
      else
      {
        //the resource information could not be queried successfully:
        $string_buffer .= b_tag("There was a problem with the database and your request could not be processed, please try again later");

//        $resource->add_message("The query failed");

      }


		}

	//generate the main HTML content:
	$string_buffer = RIA_template_page("Summary Reports", $string_buffer, "index.php");

  //output the HTML page content with $string_buffer in the <body> tag:
  echo html_page ('Summary Reports', $string_buffer, array(), $inline_javascript, $javascript_include, '', $css_include, false, array(), array(), $priority_header_content);

?>

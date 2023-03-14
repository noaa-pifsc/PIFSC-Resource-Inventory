<?php

	//this function returns the formatted template content for the given RIA page
	function RIA_template_page ($page_title, $content, $current_page = null)
	{
		$return_string = "<div id=\"disabled_content_overlay\" style=\"display:none;\"></div>";

		//this is the HTML for the loading graphic when the user interface is disabled:
		$return_string .= "<div id=\"ajax_loading_graphic\"><strong>Please Wait...</strong></div>";

		$return_string .= navigation_menu($current_page);



		//fixed background image div
		$return_string .= "<div id=\"bg\">
			<img src=\"./res/images/app_background.jpg\" alt=\"NOAA background image\">
		</div>";

		//fixed dev/test background image div
		$return_string .= "<div class=\"devtest_bg_image\">
		</div>";

		//this is the page heading content:
		$return_string .= div_tag(h1_tag($page_title, array("class=\"page_heading\"")), array("class=\"page_heading_div\""));



		//define the main content div (display:none to address the flash of unstyled content problem - hide the content until the javascript code has finished executing)
		$return_string .= "<div class=\"main_content_div\" style=\"display:none;\">";

		$return_string .= $content;

		$return_string .= "</div> <!--end of main_content_div-->";

		return $return_string;
	}


	//generate the HTML content for the navigation menu
	function navigation_menu ($current_page = null)
	{
		//this is the page heading content:
		$return_string = "<div class=\"navigation_menu\">";

		$return_string .= div_tag("PIFSC Resource Inventory App (RIA)", array("class=\"page_header\""));


		$menu_string = '';

		if ($current_page == 'index.php')
			$menu_string .= "<span>Summary Reports</span> ";
		else
			$menu_string .= "<a href=\"./index.php\">Summary Reports</a> ";

		if ($current_page == 'view_all_projects.php')
			$menu_string .= "<span>View All Projects</span> ";
		else
			$menu_string .= "<a href=\"./view_all_projects.php\">View All Projects</a> ";

		if ($current_page == 'view_all_resources.php')
			$menu_string .= "<span>View All Resources</span> ";
		else
			$menu_string .= "<a href=\"./view_all_resources.php\">View All Resources</a> ";
		$menu_string .= "</div>";

		$return_string .= div_tag($menu_string, array("class=\"menu_link_container\""));

		return $return_string;
	}

?>

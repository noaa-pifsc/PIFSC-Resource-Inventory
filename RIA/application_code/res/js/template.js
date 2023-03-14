//this is the main custom javascript include file for the PIFSC Resource Inventory application, it contains variables and functions used to implement the client-side user-interface


		//variable to track if the page is disabled (waiting for Ajax response)
		var disabled_page = false;

		//variable to track if the debug_console() function should output information to the browser using debug_console (debug_mode = false when in production)
		var debug_mode = true;



		//this function adds the disabled content overlay to disable all elements below the layer:
		function activate_disabled_content_overlay ()
		{
			debug_console('running activate_disabled_content_overlay()');

			//the data form is now disabled, set the global variable:
			disabled_page = true;

			//set the css styles to show the content overlay to make the content appear "grayed out"
			$('#disabled_content_overlay').css({"display": "block", opacity: 0.5, "width":documentWidth()+"px","height":documentHeight()+"px"});

			//show the loading graphic and message
			$('#ajax_loading_graphic').css({"display": "block"});

		}

		//this function removes the disabled content overlay to re-enable all of the data form elements:
		function deactivate_disabled_content_overlay ()
		{
			debug_console('running deactivate_disabled_content_overlay()');

			//the data form is now enabled again, set the global variable:
			disabled_page = false;

			//set the css to hide the content overlay:
			$('#disabled_content_overlay').css({"display": "none"});

			//hide the loading graphic
			$('#ajax_loading_graphic').css({"display": "none"});
		}


		//function to return the browser window width:
		function pageWidth()
		{
			return $(window).width();
		}

		//function to return the browser window height:
		function pageHeight()
		{
			return $(window).height();
		}

		//function to return the browser document width:
		function documentWidth()
		{
			return $(document).width();
		}

		//function to return the browser document height:
		function documentHeight()
		{
			return $(document).height();
		}



		//this function resizes the disabled content overlay:
		function resize_disabled_overlay()
		{
			debug_console('running resize_disabled_overlay()');

			//check if the page is currently disabled:
			if (disabled_page)
			{
				//the page is currently disabled, resize the disabled content overlay to 1 X 1 so the content can be measured accurately:
				$('#disabled_content_overlay').css({"width":"1px","height":"1px"});

				//resize the disabled content overlay to the size of the actual HTML content:
				$('#disabled_content_overlay').css({"width":pageWidth()+"px","height":documentHeight()+"px"});
			}
		}


		//function that outputs debugging comments/info to the web browser console:
		function debug_console(text)
		{
			if (debug_mode)
			{
					if (!($.browser.msie))
				console.log(text);
			}
		}

		//depending on the value of app_instance show the dev/test or no background:
		function dev_test_bg_image()
		{

			//check to see which APEX server instance this code is running on (based on hostname):
			if (app_instance == 'dev')	//this is the development server instance
			{
				//this is the development server, use the development background image and append a string to the header logo to indicate it is the development server

				//set the background image to the development background
				$("div.devtest_bg_image").css("background-image", 'url("./res/images/Dev Background.png")');

				//append the " (DEVELOPMENT VERSION)" string to the end of the logo content
				$("div.navigation_menu h3.page_header").append(" (DEVELOPMENT VERSION)");

			}
			else if (app_instance == 'test')	//this is the test server instance
			{
				//this is the test server, use the test background image and append a string to the header logo to indicate it is the test server

				//set the background image to the test background
				$("div.devtest_bg_image").css("background-image", 'url("./res/images/Dev Background.png")');

				//append the " (TEST VERSION)" string to the end of the logo content
				$("div.navigation_menu h3.page_header").append(" (TEST VERSION)");

			}
		}

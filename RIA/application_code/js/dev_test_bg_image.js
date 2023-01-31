//depending on the value of app_instance show the dev/test or no background:
function dev_test_bg_image()
{

	//check to see which APEX server instance this code is running on (based on hostname):
	if (app_instance == 'dev')	//this is the development server instance
	{
		//this is the development server, use the development background image and append a string to the header logo to indicate it is the development server

		//set the background image to the development background
		$("div.devtest_bg_image").css("background-image", 'url("./images/Dev Background.png")');

		//append the " (DEVELOPMENT VERSION)" string to the end of the logo content
		$("div.navigation_menu h3.page_header").append(" (DEVELOPMENT VERSION)");

	}
	else if (app_instance == 'test')	//this is the test server instance
	{
		//this is the test server, use the test background image and append a string to the header logo to indicate it is the test server

		//set the background image to the test background
		$("div.devtest_bg_image").css("background-image", 'url("./images/Dev Background.png")');

		//append the " (TEST VERSION)" string to the end of the logo content
		$("div.navigation_menu h3.page_header").append(" (TEST VERSION)");

	}
}

//code to run as soon as the js code is loaded:
$(function()
{
	//depending on the value of app_instance show the dev/test or no background:
	dev_test_bg_image();

  register_tooltips();

  //the main content has been rendered show the main content div:
  $("div.main_content_div").show();

	//the map plugin has finished loading, re-enable the application:
  deactivate_disabled_content_overlay();

});

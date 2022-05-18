//this is the main custom javascript include file for the MOUSS video application, it contains variables and functions used to implement the client-side user-interface


    //variable to track if the page is disabled (waiting for Ajax response)
    var disabled_page = false;

    //variable to track if the debug_console() function should output information to the browser using debug_console (debug_mode = false when in production)
    var debug_mode = true;




    //code to run as soon as the js code is loaded:
    $(function()
    {

//      debug_console('running the $function() code');

      //activate the disabled content overlay while the js code runs (scrolling table and maps API):
      activate_disabled_content_overlay();



//      debug_console('initialize jquery UI widgets');

      //initialize the jQuery UI button widget
//      $("a.link_button").button({disable: false});


      //register the div labels tooltips (display tooltip content above the tooltip calling element)
      $ ("div.tooltip").tooltip({
      position: {
        my: "center bottom",
        at: "center top-10",
        using: tooltip_arrows
      }
      });

      debug_console('the main content has been rendered show the main content div');

      //the main content has been rendered show the main content div:
      $("div.main_content_div").show();

      //the map plugin has finished loading, re-enable the application:
      deactivate_disabled_content_overlay();
    });

    //function to handle positioning for the tooltips when they are created (referenced in the using: clause of the tooltip constructor) - this was pulled directly from the jQuery UI working example (https://jqueryui.com/tooltip/#custom-style)
    function tooltip_arrows ( position, feedback )
    {
      $( this ).css( position );
      $( "<div>" )
    	.addClass( "arrow" )
    	.addClass( feedback.vertical )
    	.addClass( feedback.horizontal )
    	.appendTo( this );
    }




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

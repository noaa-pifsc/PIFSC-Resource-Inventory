//this is the main custom javascript include file for the MOUSS video application, it contains variables and functions used to implement the client-side user-interface


    //variable to track if the page is disabled (waiting for Ajax response)
    var disabled_page = false;

    //variable to track if the debug_console() function should output information to the browser using debug_console (debug_mode = false when in production)
    var debug_mode = true;

    //maximum length that the parameter string can be for validation purposes:
    var parameter_strlen_limit = 2000;



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



        //function that retrieves all form values and generates a formatted argument string to send with an Ajax request
        function serialize_filter_form(filter_array)
        {
    	  debug_console('running serialize_filter_form('+filter_array+')');
    	  var default_filter = 'button';
    	  var form_arg_string = '';

    	  //initialize the counter (add one for the extra "&" character that is being measured:
    	  var current_strlen_remaining = parameter_strlen_limit + 1;

    	  var argument_array = new Array();
    	  //loop through each value and construct the argument string manually:
    	  $(":input:not("+default_filter+","+filter_array.join()+")").each(function()
    	  {
    		  debug_console($(this));
          //			debug_console('the current element visible property is: '+$(this).is(":visible"));
    		  debug_console('the value of the current input element ('+$(this)['context']['name']+' - '+$(this)['context']['type']+')is: '+$(this).val());


    		  //check if this is a radio button:
    		  if ($(this)['context']['type'] == 'radio')
    		  {
    //				debug_console('this is a radio button, checked is: '+$(this)['context']['checked']);
    			  if ($(this)['context']['checked'])
    			  {
    				  argument_array[argument_array.length] = encodeURIComponent($(this)['context']['name'])+"="+encodeURIComponent($(this).val());

    				  //subtract the length of the current parameter name/value pair from the remaining length of the maximum string length (adding one extra character for the &):
    				  current_strlen_remaining -= (argument_array[(argument_array.length - 1)].length + 1);
    			  }
    		  }
    		  else if ($(this)['context']['type'] == 'select-multiple')
    		  {
    			  //only check visible select elements
    			  if ($(this).is(":visible"))
    			  {

    				  //this is not a radio button, add the current form value to the array:
    				  if ($(this).val() != null)
    				  {
      //					debug_console($(this).val());

    					  for (var i = 0; i < $(this).val().length; i++)
    					  {
    						  //the element has a non-null value:
    						  argument_array[argument_array.length] = encodeURIComponent($(this)['context']['name'])+"="+encodeURIComponent($(this).val()[i]);

    						  //subtract the length of the current parameter name/value pair from the remaining length of the maximum string length (adding one extra character for the &):
    						  current_strlen_remaining -= (argument_array[(argument_array.length - 1)].length + 1);

    						  //check if the current parameter string has already exceeded the maximum defined length:
    						  if (current_strlen_remaining < 0)
    						  {
    							  debug_console('there were too many select options selected (detected by serialize_filter_form())');
    							  //this parameter string has already gone over the defined parameter_strlen_limit
    							  return false;

    						  }

    					  }
    				  }
    			  }
    		  }
    		  else
    		  {
    			  //do not check this field if it is a hidden text field, otherwise check all fields (including hidden input fields):
    			  if ((($(this)['context']['type'] == 'text') && ($(this).is(":visible"))) || ($(this)['context']['type'] != 'text'))
    			  {


    				  //this is not a radio button, add the current form value to the array:
    				  //the element has a non-null value:
    				  argument_array[argument_array.length] = encodeURIComponent($(this)['context']['name'])+"="+encodeURIComponent($(this).val());

    				  //subtract the length of the current parameter name/value pair from the remaining length of the maximum string length (adding one extra character for the &):
    				  current_strlen_remaining -= (argument_array[(argument_array.length - 1)].length + 1);
    			  }
    		  }

    		  if (current_strlen_remaining < 0)
    		  {
    			  //this parameter string has already gone over the defined parameter_strlen_limit
    			  return false;

    		  }

    	  });

    	  debug_console('the serialize_filter_form() function is done looping through the form elements, the value of current_strlen_remaining is: '+current_strlen_remaining);

    	  if (current_strlen_remaining < 0)
    	  {
    		  //the constructed parameter string is too long:

    		  debug_console('returning false from serialize_filter_form()');
    		  return false;
    	  }
    	  else
    	  {
    		  //the constructed parameter string is not too long



    		  form_arg_string = argument_array.join("&");
      //		debug_console('the manually constructed argument string is: '+form_arg_string);


    		  debug_console('returning: '+form_arg_string);
    		  return form_arg_string;
    	  }
        }


    //maximum length that the parameter string can be for validation purposes:
    var parameter_strlen_limit = 2000;


    //function that retrieves all form values and generates a formatted argument string to send with an Ajax request
    function serialize_filter_form()
    {
//	  debug_console('running serialize_filter_form()');
//	  var default_filter = '';
	  var form_arg_string = '';

	  //initialize the counter (add one for the extra "&" character that is being measured:
	  var current_strlen_remaining = parameter_strlen_limit + 1;

	  var argument_array = new Array();
	  //loop through each value and construct the argument string manually:
	  $(":input").each(function()
	  {
//		  debug_console($(this));
//		  debug_console($(this)[0]);
      //			debug_console('the current element visible property is: '+$(this).is(":visible"));
//		  debug_console('the value of the current input element ('+$(this)[0]['name']+' - '+$(this)[0]['type']+')is: '+$(this).val());


		  //check if this is a radio button:
		  if ($(this)[0]['type'] == 'radio')
		  {
//				debug_console('this is a radio button, checked is: '+$(this)[0]['checked']);
			  if ($(this)[0]['checked'])
			  {
				  argument_array[argument_array.length] = encodeURIComponent($(this)[0]['name'])+"="+encodeURIComponent($(this).val());

				  //subtract the length of the current parameter name/value pair from the remaining length of the maximum string length (adding one extra character for the &):
				  current_strlen_remaining -= (argument_array[(argument_array.length - 1)].length + 1);
			  }
		  }
		  else if ($(this)[0]['type'] == 'select-multiple')
		  {
//				debug_console('this is a select multiple element');
				
			  //only check visible select elements
			  if ($(this).is(":visible"))
			  {

				//check if the value of the select element is not null:
				  if ($(this).val() != null)
				  {
					  //the value of the select element is not null, iterate through the option values and if they are selected add them to the argument_array:
//					debug_console($(this).val());

					  for (var i = 0; i < $(this).val().length; i++)
					  {
						  //the element has a non-null value:
						  argument_array[argument_array.length] = encodeURIComponent($(this)[0]['name'])+"="+encodeURIComponent($(this).val()[i]);

						  //subtract the length of the current parameter name/value pair from the remaining length of the maximum string length (adding one extra character for the &):
						  current_strlen_remaining -= (argument_array[(argument_array.length - 1)].length + 1);

						  //check if the current parameter string has already exceeded the maximum defined length:
						  if (current_strlen_remaining < 0)
						  {
//							  debug_console('there were too many select options selected (detected by serialize_filter_form())');
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
			  if ((($(this)[0]['type'] == 'text') && ($(this).is(":visible"))) || ($(this)[0]['type'] != 'text'))
			  {


				  //this is not a radio button, add the current form value to the array:
				  //the element has a non-null value:
				  argument_array[argument_array.length] = encodeURIComponent($(this)[0]['name'])+"="+encodeURIComponent($(this).val());

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

//	  debug_console('the serialize_filter_form() function is done looping through the form elements, the value of current_strlen_remaining is: '+current_strlen_remaining);

	  if (current_strlen_remaining < 0)
	  {
		  //the constructed parameter string is too long:

//		  debug_console('returning false from serialize_filter_form()');
		  return false;
	  }
	  else
	  {
		  //the constructed parameter string is not too long



		  form_arg_string = argument_array.join("&");
  //		debug_console('the manually constructed argument string is: '+form_arg_string);


//		  debug_console('returning: '+form_arg_string);
		  return form_arg_string;
	  }
    }

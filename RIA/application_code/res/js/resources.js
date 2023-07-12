//code to run as soon as the js code is loaded:
$(function()
{
  debug_console('running the $function() code');


  //activate the disabled content overlay while the js code runs (scrolling table and maps API):
  activate_disabled_content_overlay();

	//depending on the value of app_instance show the dev/test or no background:
	dev_test_bg_image();

  //initialize the jQuery UI button widget
  $("a.link_button").button({disable: false});


  register_tooltips();


  debug_console('the main content has been rendered show the main content div');

  //the main content has been rendered show the main content div:
  $("div.main_content_div").show();

  //initialize the accordion widget for the MOUSS survey filtering form
  $("#accordion_filter").accordion({
           collapsible: true,
           active: false
  });


  //the map plugin has finished loading, re-enable the application:
  deactivate_disabled_content_overlay();
});






    //this function executes when the filter button is clicked, it sends the Ajax request to the PHP listener page
    function request_resources ()
    {
      //retrieve parameters from form fields and encode them and send an Ajax request:
      debug_console('running request_resources()');


      //disable application window until response is received and show the loading graphic
      activate_disabled_content_overlay();

      //retrieve the form values so they can be sent to the listener page as parameters for filtering the MOUSS surveys
      var form_values = serialize_filter_form([]);

      debug_console("the value of form_values is: "+form_values);

      //send ajax request for index.php with the form parameters, define the load_resources function as the handler for the Ajax response
       $.post("./view_all_resources.php", "req=filter"+(form_values.length > 0 ? "&"+form_values: ''), load_resources);
    }





    //function to load the resource information from the Ajax request JSON response and update the DOM_representation accordingly:
    //Expected return values (in JSON format):
    //['RETURN_CODE'] = 1/0 for success/error respectively
    //['SUCCESS_CODE'] = 1/-1 for success/error respectively
    //['RESOURCES'] contains an array of associative arrays that contains information about all resources:
    //['RESOURCES'][x]['proj_id'] is Primary key for the PRI_PROJ table
    //['RESOURCES'][x]['proj_name'] is Name of the project
    //['RESOURCES'][x]['proj_desc'] is description for the project
    //['RESOURCES'][x]['data_source_name'] is the source of the project record (e.g. PIFSC GitLab, GitHub, manual entry)
    //['RESOURCES'][x]['proj_visibility'] is The visibility for the project (public, internal, private)
    //['RESOURCES'][x]['readme_url'] is the Readme URL for the project
    //['RESOURCES'][x]['avatar_url'] is the Avatar URL for the project
    //['RESOURCES'][x]['vc_web_url'] is the HTTP URL for the project
    //['RESOURCES'][x]['res_id'] is the Primary key for the PRI_PROJ_RES table
    //['RESOURCES'][x]['res_name'] is the name of the project resource
    //['RESOURCES'][x]['res_max_vers_num'] is The parsed version number for the maximum installed version of the given resource
    //['RESOURCES'][x]['curr_vers_count'] is The number of projects that have implemented the given resource that are the same as the current version
    //['RESOURCES'][x]['old_vers_count'] is The number of projects that have implemented the given resource that are not the same as the current version
    //['RESOURCES'][x]['total_impl_proj'] is the total number of projects that have implemented the given resource
    //['RESOURCES'][x]['assoc_proj_link_br_list'] is a web line-break-delimited (<BR>) list of projects and associated highest version number in a formatted hyperlink with a relative path to the given Resource Inventory App project that has implemented the given resource.  If the current version implemented is the same as the current version of the resource the project name is preceded by a "*CV" prefix to indicate it is the current version and if not the "*UA" prefix is used to indicate there is an update available
    //['RESOURCES'][x]['res_category'] is the resource category (free form text) - examples values include Development Tool, Data Management Tool, Centralized Database Applications
    //['RESOURCES'][x]['res_url'] is the URL for the project resource (this is blank when the repository URL is the same as the resource URL)
    //['RESOURCES'][x]['res_scope_name'] is the Name of the given Resource Scope
    //['RESOURCES'][x]['res_type_name'] is the Name of the given Resource Type
    //['RESOURCES'][x]['res_desc'] is the description for the project resource
    //['RESOURCES'][x]['res_demo_url'] is the live demonstration URL for the project resource
    //['RESOURCES'][x]['vc_commit_count'] is The total number of commits for the project in the given version control system
    //['RESOURCES'][x]['format_vc_repo_size_mb'] is The total repository size in MB for the project in the given version control system formatted as a string with a leading zero for values < 1
    //['RESOURCES'][x]['owner_user_name'] is Name of the project owner's user account in the version control system
    //['RESOURCES'][x]['owner_avatar_url'] is Avatar URL for the project owner's user account in the version control system
    //['RESOURCES'][x]['owner_web_url'] is Web URL for the project owner's user account in the version control system
    //['RESOURCES'][x]['creator_user_name'] is Name of the project creator's user account in the version control system
    //['RESOURCES'][x]['creator_avatar_url'] is Avatar URL for the project creator's user account in the version control system
    //['RESOURCES'][x]['creator_web_url'] is Web URL for the project creator's user account in the version control system
    //['RESOURCES'][x]['proj_refresh_date'] is The date of the last time the project information was refreshed in the database
    //['RESOURCES'][x]['proj_create_dtm'] is The date/time the project was created
    //['RESOURCES'][x]['proj_update_dtm'] is The date/time the project was last updated
    function load_resources (data)
    {
      debug_console('running load_resources()');

      //parse the JSON response and store the json data in the data variable so it can be processed
//      data = jQuery.parseJSON(data)

      debug_console ("the value of data['RETURN_CODE'] is: "+data['RETURN_CODE']);

      //check the RETURN_CODE
      if (data['RETURN_CODE'] == "0")
      {
          //the ajax response was invalid:

    	  //display the error message to the user:
    	  display_error("The response was invalid");

    	  //the ajax response has been processed, re-enable the page functionality
    	  deactivate_disabled_content_overlay();
      }
      else
      {
    	  //the return code was valid:

    	  debug_console ("the value of data['SUCCESS_CODE'] is: "+data['SUCCESS_CODE']);


    	  //check if this is a successful response or not:
    	  if (data['SUCCESS_CODE'] == "-1")
    	  {
    	    //this was unsuccessful, display the error message to the user:
    	    display_error(data['ERROR_MESSAGE']);

    	    //the ajax response has been processed, re-enable the page functionality
    	    deactivate_disabled_content_overlay();
    	  }
    	  else
    	  {
    	    //this was a successful request, return the response content

    	    debug_console ('the response was valid');

    	    //rollback the scrolling table changes to the DOM so the tbody content can be easily replaced (this is more efficient than passing the table template back and forth via Ajax)
//    	    $("#scrolling_table_id").tableScroll("undo");

    	    //remove all resource div content so the new content can be entered via DOM commands:
    	    $("#resource_container_id").empty();


    	    //initialize the table_string that will be used to construct the MOUSS survey table content
    	    var table_string = '';

          if (data['RESOURCES'].length > 0)
          {


      	    //loop through each of the surveys and construct the necessary html table based on the results in data['RESOURCES']
      	    for (var i = 0; i < data['RESOURCES'].length; i++)
      	    {
              console.log (data['RESOURCES'][i]);
          		//generate the table row for the current survey
          		table_string = table_string + generate_resource_content(data['RESOURCES'][i]);
      	    }

          }
          else
          {
              //there were no results, show the message to indicate there were no matching resources:
              table_string = "<p class=\"no_search_results\">There were no resources that match your search criteria, please refine your search parameters</p>";
          }


          //add the generated table row content to the display table via DOM
          $("#resource_container_id").html(table_string);

          //initialize the tooltips:
          register_tooltips();

          //the ajax response has been processed, re-enable the page functionality
          deactivate_disabled_content_overlay();

    	  }
      }
    }



    //this function generates the resource content for the given data_array_array
    function generate_resource_content (data_array)
    {
      debug_console ('running generate_resource_content()');

      var string_buffer = '';


      string_buffer = "<article class=\"card_parent\">"+
        "<div class=\"content\">"+
          "<div class=\"res_info_div card_container\">"+
            "<div class=\"card_desc_container\">"+
              "<div class=\"card_label tooltip\" title=\"The name of the Resource.  Clicking the Resource Name will redirect the user to the Resource page.  Clicking the external link window will open the project resource in a new browser tab\">Resource</div>"+
              "<div class=\"card_value_lj\"><a href=\"./view_resource.php?RES_ID="+data_array['res_id']+"\">"+data_array['res_name']+"</a> <a href=\""+data_array['res_url']+"\" target=\"_blank\"><span class=\"ui-icon ui-icon-extlink\"></span></a></div>"+
              "<div class=\"card_label tooltip\" title=\"The resource category (free form text) - examples values include Development Tool, Data Management Tool, Centralized Database Applications\">Category</div>"+
              "<div class=\"card_value\">"+data_array['res_category']+"</div>"+
              "<div class=\"card_label tooltip\" title=\"The description for the Resource\">Description</div>"+
              "<div class=\"card_value_lj\">"+data_array['res_desc']+"</div>"+
            "</div>"+
          "</div>"+
          "<div class=\"spacer\"></div>"+
          "<div class=\"impl_proj_info_div card_container\">"+
              "<div class=\"card_label tooltip\" title=\"The scope of the Resource\">Scope</div>"+
              "<div class=\"card_value\">"+data_array['res_scope_name']+"</div>"+
              "<div class=\"card_label tooltip\" title=\"The type of Resource\">Type</div>"+
              "<div class=\"card_value\">"+data_array['res_type_name']+"</div>"+
              "<div class=\"card_label tooltip\" title=\"The Resource's current version\">Current Resource Version</div>"+
              "<div class=\"card_value\">"+data_array['res_max_vers_num']+"</div>"+
              "<div class=\"card_label tooltip\" title=\"The total number of Projects that have implemented the given Resource\"># Implemented Projects</div>"+
              "<div class=\"card_value\">"+data_array['total_impl_proj']+"</div>"+
              "<div class=\"card_label tooltip\" title=\"The number of Projects that have implemented the given Resource that are the same as the current version\"># Current Version</div>"+
              "<div class=\"card_value\">"+data_array['curr_vers_count']+"</div>"+
              "<div class=\"card_label tooltip\" title=\"The number of Projects that have implemented the given Resource that are not the same as the current version\"># Old Version</div>"+
              "<div class=\"card_value\">"+data_array['old_vers_count']+"</div>"+
              "<div class=\"card_label tooltip\" title=\"The live demonstration URL for the Project Resource\">Live Demo</div>"+
              "<div class=\"card_value\">"+((data_array['res_demo_url'] != null) ? "<a href=\""+data_array['res_demo_url']+"\" target=\"_blank\">Live Demo</a>": "N/A")+"</div>"+
          "</div>"+
          "<div class=\"spacer\"></div>"+
          "<div class=\"res_proj_div card_container card_desc_container\">"+
            "<div class=\"card_label tooltip\" title=\"A list of projects and associated highest version number that have implemented the given resource that provides links to the associated Projects.  If the current version implemented is the same as the current version of the resource the project name is preceded by a &quot;(*CV)&quot; prefix to indicate it is the current version and if not the &quot;(*UA)&quot; prefix is used to indicate there is an update available\">Implemented Projects</div>"+
            "<div class=\"card_value_lj\">"+data_array['assoc_proj_link_br_list']+"</div>"+
          "</div>"+
          "<div class=\"spacer\"></div>"+
          "<div class=\"proj_info_div card_container\">"+
          "<div class=\"card_label tooltip\" title=\"The name of the Resource's associated Project.  Clicking the Project icon or name will open a new tab to the Project page. Clicking the external link window will open the project resource in a new browser tab.\">Project</div>"+
            "<div class=\"card_avatar_name\">"+
              "<div class=\"card_name_container\">"+
                "<a href=\""+data_array['vc_web_url']+"\" target=\"_blank\" class=\"proj_name_link\"><img class=\"avatar\" src=\""+((data_array['avatar_url'] == null) ? "./res/images/no image.png" : data_array['avatar_url'])+"\" alt=\"Project Avatar\"/></a>"+
                "<div class=\"card_value_lj\"><a href=\"./view_project.php?PROJ_ID="+data_array['proj_id']+"\">"+data_array['proj_name']+"</a> <a href=\""+data_array['vc_web_url']+"\" target=\"_blank\"><span class=\"ui-icon ui-icon-extlink\"></span></a></div>"+
              "</div>"+
            "</div>"+
            "<div class=\"card_desc_container\">"+
            "<div class=\"card_label tooltip\" title=\"The source of the project record (e.g. PIFSC GitLab, GitHub, manual entry)\">Project Source</div>"+
            "<div class=\"card_value\">"+data_array['data_source_name']+"</div>"+
            "<div class=\"card_label tooltip\" title=\"The visibility of the Project (private, internal, public)\">Visibility</div>"+
            "<div class=\"card_value\">"+data_array['proj_visibility']+"</div>"+
            "<div class=\"card_label tooltip\" title=\"Link to the Project's README file (if defined)\">README Link</div>"+
            "<div class=\"card_value\">"+((data_array['readme_url'] == null) ? "N/A": " <a href=\""+data_array['readme_url']+"\" target=\"_blank\">README</a>")+"</div>"+
            "<div class=\"card_label tooltip\" title=\"The description for the Project\">Description</div>"+
            "<div class=\"card_value_lj\">"+((data_array['proj_desc'] == null) ? '' : data_array['proj_desc'])+"</div>"+
            "</div>"+
          "</div>"+
          "<div class=\"spacer\"></div>"+
          "<div class=\"proj_det_info_div card_container\">"+
            "<div class=\"card_label tooltip\" title=\"The creator of the Project.  Clicking the creator icon or name will open a new tab to the creator's user page.\">Creator</div>"+
            "<div class=\"card_avatar_name\">"+
              "<div class=\"card_name_container\">"+
                "<a href=\""+data_array['creator_web_url']+"\" target=\"_blank\" class=\"proj_name_link\"><img class=\"avatar\" src=\""+(((data_array['creator_avatar_url']) == null) ? "./res/images/no image.png" : data_array['creator_avatar_url'])+"\" alt=\"Creator Avatar\"/></a>"+
                "<div class=\"card_value\"><a href=\""+data_array['creator_web_url']+"\" target=\"_blank\">"+data_array['creator_user_name']+"</a> <a href=\""+data_array['creator_web_url']+"\" target=\"_blank\"></a></div>"+
              "</div>"+
            "</div>"+
            "<div class=\"card_label tooltip\" title=\"The owner of the Project.  Clicking the owner icon or name will open a new tab to the owner's user page.\">Owner</div>"+
            "<div class=\"card_avatar_name\">"+
              "<div class=\"card_name_container\">"+
                ((data_array['owner_web_url'] == null) ? "": "<a href=\""+data_array['owner_web_url']+"\" target=\"_blank\" class=\"proj_name_link\">")+"<img class=\"avatar\" src=\""+((data_array['owner_avatar_url'] == null) ? "./res/images/no image.png" : data_array['owner_avatar_url'])+"\" alt=\"Owner Avatar\" />"+((data_array['owner_web_url'] == null) ? "" : "</a>")+
                "<div class=\"card_value\">"+((data_array['owner_web_url'] == null) ? "": "<a href=\""+data_array['owner_web_url']+"\" target=\"_blank\">")+data_array['owner_user_name']+((data_array['owner_web_url'] == null) ? "": "</a>")+"</div>"+
              "</div>"+
            "</div>"+
          "</div>"+
          "<div class=\"spacer\"></div>"+
          "<div class=\"res_det_info_div card_container\">"+

            "<div class=\"card_label tooltip\" title=\"The total number of commits for the project\"># Commits</div>"+
            "<div class=\"card_value\">"+data_array['vc_commit_count']+"</div>"+
            "<div class=\"card_label tooltip\" title=\"The total size of the project's repository (in MB)\">Repository Size</div>"+
            "<div class=\"card_value\">"+data_array['format_vc_repo_size_mb']+" MB</div>"+


            "<div class=\"card_label tooltip\" title=\"The Date/Time the Project was created (in MM/DD/YYYY HH24:MI:SS format)\">Created</div>"+
            "<div class=\"card_value\">"+data_array['proj_create_dtm']+"</div>"+
            "<div class=\"card_label tooltip\" title=\"The Date/Time the Project was last updated (in MM/DD/YYYY HH24:MI:SS format)\">Last Update</div>"+
            "<div class=\"card_value\">"+data_array['proj_update_dtm']+"</div>"+
            "<div class=\"card_label tooltip\" title=\"The date/time the project information was refreshed in the database (in MM/DD/YYYY HH24:MI:SS format)\">Refresh Date</div>"+
            "<div class=\"card_value\">"+data_array['proj_refresh_date']+"</div>"+

          "</div>"+
        "</div>"+
      "</article>";

      //return the generated content
      return string_buffer;

    }

<?php

include_once(APPLICATION_INCLUDE_PATH."db_connection_info.php");

include_once (SHARED_LIBRARY_INCLUDE_PATH."oracle_db.php");

include_once (SHARED_LIBRARY_INCLUDE_PATH."output_message.php");


//this class is the parent class of all project/resource classes
class RIA_data
{

  //oracle DB connection object:
  public $oracle_db;



  //class constructor
  function __construct($log_file_name, $log_source_name)
  {
    //connect to the database (do not exit on failure automatically):
    $this->oracle_db = new oracle_db();

    //creat the new output_message variable
    $this->output_message = new output_message($log_file_name, 0, true, $this->oracle_db, $log_source_name, "PRI");
  }

  //class destructor
  function __destruct()
  {
    unset ($this->oracle_db);
    unset ($this->output_message);
  }


  function return_oracle_db ()
  {
      return $this->oracle_db;

  }

  //wrapper function to execute the add_message() method of the $this->output_message variable:
  function add_message($string, $message_code = 2)
  {
    return $this->output_message->add_message($string, $message_code);
  }


  //this function accepts the argument $post_array that contains numeric array element values.  $filter_field_name contains the numeric field name that is being filtered. The $invalid_parameters variable will be false if there was an invalid parameter value found and true if there was not.  $where_array will have a SQL WHERE clause added as an element if there are no invalid parameters.  $bind_array will have key/value pairs added for each id parameter so they can be used to bind the SELECT query
  function process_filter_id_values ($post_array, $filter_field_name, &$invalid_parameters, &$where_array, &$bind_array)
  {

      //variable containing all bind variables that is used to construct the IN () clause using the implode() function
      $bind_var_array = array();

      //a res_scope_id parameter was defined:
  //        echo $this->add_message("one or more $filter_field_name parameters were specified: ".var_export($post_array, true), 3);


      //there were res_scope_id parameter values, loop through each one and validate them
      for ($i = 0; ((!$invalid_parameters) && ($i < count($post_array))); $i++)
      {
        //validate that each parameter is numeric, if so then add the placeholder and define the corresponding bind variable
        if (is_numeric($post_array[$i]))
        {
          //the current res_scope_id parameter is numeric, it is valid:

          //define the bind variable and corresponding value (convert to int because this is supposed to be an integer for the primary key)
          $bind_array[] = array($bind_var = ":".$filter_field_name.strval($i), intval($post_array[$i]));

          //add the bind variable so it can be used in the WHERE clause:
          $bind_var_array[] = $bind_var;
        }
        else
        {
          //the current parameter was not numeric (invalid - should only be res_scope_id numeric values)

          //log the problematic parameter
          echo $this->add_message("the current parameter is invalid (\$post_array[$i] = \"".$post_array[$i]."\"), the $filter_field_name parameter should be numeric");

          //indicate that one or more of the parameters is invalid:
          $invalid_parameters = true;
        }
      }

      //check if any invalid parameters were found:
      if (!$invalid_parameters)
      {
        $where_array[] = "$filter_field_name IN (".implode(", ", $bind_var_array).")";
      }

  }

}

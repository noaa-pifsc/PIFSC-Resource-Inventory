<?php

	include_once(SHARED_LIBRARY_INCLUDE_PATH."curl_request.inc");

	include_once(APPLICATION_INCLUDE_PATH."db_connection_info.php");

	include_once (SHARED_LIBRARY_INCLUDE_PATH."oracle_db.php");

	include_once (SHARED_LIBRARY_INCLUDE_PATH."output_message.php");


	//class that handles gitlab procedures for the PRI:
	class PRI_gitlab
	{
		//oracle DB connection object:
		public $oracle_db;

		//public class property to log information in the file system and database
		public $output_message;


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

		//wrapper function to execute the add_message() method of the $this->output_message variable:
		function add_message($string, $message_code)
		{
			return $this->output_message->add_message($string, $message_code);
		}

		//class method to refresh the PRI project inventory with the GitLab information:
		function refresh_projects ()
		{
			echo $this-> add_message("running refresh_projects(), Request all of the projects from the gitlab server", 3);

			//parse the JSON and loop through the return values to insert the DB records
			$found_last_projects = false;

			//initialize the page counter variable:
			$page_counter = 0;

			echo $this->add_message("loop through each list of projects until there are none remaining (only allows 100 per page)", 3);

			//request all Gitlab users accounts via v4 API:
			for ($i = 0; (!$found_last_projects); $i++)
			{

				echo $this->add_message("send the request for page #".($page_counter + 1)." of the gitlab projects", 3);


				//request all Gitlab users accounts via v4 API:
				if ($content = curl_request("https://".GITLAB_HOST_NAME."/api/v4/projects?per_page=100&page=".(++$page_counter)."&private_token=".GITLAB_API_KEY))
				{
					//the user request was successful:

					echo $this->add_message("the request for the list of projects was successful", 3);

					echo $this->add_message($content, 3);



					//convert the string into a JSON array for processing:
					$data = json_decode($content, true);

					echo "The value of \$data is: " . var_export($data, true)."\r\n";

					//free the content string from memory:
					$content = null;

					//check if there were any projects returned by the API call:
					if (count($data) == 0)
					{
						//there are no projects returned by the API request, stop processing the projects:
						$found_last_projects = true;

						echo $this->add_message("there are no projects returned by the API request, stop processing the projects", 3);

					}
					else
					{
						//there was at least one project returned by the API request:


						echo $this->add_message("loop through each of the Gitlab projects and insert/update them in the database", 3);

						//loop through each of the Gitlab projects and insert them into the database:
						for ($i = 0; $i < count($data); $i++)
						{

							echo $this->add_message("the current project name is: ".$data[$i]['name'], 3);

							echo $this->add_message(var_export($data[$i], true), 3);

							//check if the PRI_PROJ record already exists:
							$SQL = "SELECT PROJ_ID FROM PRI.PRI_PROJ WHERE VC_PROJ_ID = :id and PROJ_SOURCE = :proj_source";
							$bind_array = array(array(':id', $data[$i]['id']), array(':proj_source', ($temp = PROJ_SOURCE)));

							if ($rc = $this->oracle_db->query($SQL, $result, $dummy, $bind_array, OCI_NO_AUTO_COMMIT))
							{
								//query was successful
								echo $this->add_message("The select project query was executed successfully", 3);

				        if ($row = $this->oracle_db->fetch($result))
				        {
									//the PRI_PROJ already exists:

									echo $this->add_message("the PRI_PROJ already exists (".$row['PROJ_ID'].")", 3);

									//the PRI_PROJ does not already exist:
									$SQL = "UPDATE PRI.PRI_PROJ SET VC_PROJ_ID = :vc_proj_id, PROJ_NAME = :proj_name, PROJ_DESC = :proj_desc, SSH_URL = :ssh_url, HTTP_URL = :http_url, README_URL = :readme_url, AVATAR_URL = :avatar_url, PROJ_CREATE_DTM = TO_DATE(REGEXP_SUBSTR(:proj_create_dtm, '([0-9]{4}\-[0-9]{2}\-[0-9]{2})T[0-9]{2}\:[0-9]{2}\:[0-9]{2}(\.[0-9]{3})?Z', 1, 1, 'i', 1) || ' ' ||REGEXP_SUBSTR(:proj_create_dtm, '[0-9]{4}\-[0-9]{2}\-[0-9]{2}T([0-9]{2}\:[0-9]{2}\:[0-9]{2})(\.[0-9]{3})?Z', 1, 1, 'i', 1), 'YYYY-MM-DD HH24:MI:SS'), PROJ_UPDATE_DTM = (CASE WHEN :proj_update_dtm IS NOT NULL THEN TO_DATE(REGEXP_SUBSTR(:proj_update_dtm, '([0-9]{4}\-[0-9]{2}\-[0-9]{2})T[0-9]{2}\:[0-9]{2}\:[0-9]{2}(\.[0-9]{3})?Z', 1, 1, 'i', 1) || ' ' ||REGEXP_SUBSTR(:proj_update_dtm, '[0-9]{4}\-[0-9]{2}\-[0-9]{2}T([0-9]{2}\:[0-9]{2}\:[0-9]{2})(\.[0-9]{3})?Z', 1, 1, 'i', 1), 'YYYY-MM-DD HH24:MI:SS') ELSE NULL END), PROJ_VISIBILITY = :proj_visibility, PROJ_NAME_SPACE = :proj_name_space, PROJ_SOURCE = :proj_source WHERE PROJ_ID = :proj_id";

									$bind_array = array(array(":vc_proj_id", $data[$i]['id']), array(':proj_name', $data[$i]['name']), array(':proj_desc', $data[$i]['description']), array(':ssh_url', $data[$i]['ssh_url_to_repo']), array(':http_url', $data[$i]['http_url_to_repo']), array(':readme_url', $data[$i]['readme_url']), array(':avatar_url', $data[$i]['avatar_url']), array(':proj_create_dtm', $data[$i]['created_at']), array(':proj_update_dtm', $data[$i]['last_activity_at']), array(':proj_visibility', $data[$i]['visibility']), array(':proj_name_space', $data[$i]['path_with_namespace']), array(':proj_source', ($temp = PROJ_SOURCE)), array(':proj_id', $row['PROJ_ID']));

									if ($rc = $this->oracle_db->query($SQL, $result, $dummy, $bind_array, OCI_NO_AUTO_COMMIT))
									{
										//query was successful
										echo $this->add_message("The existing project record was updated successfully for the current gitlab project: ".$data[$i]['name'], 3);

										//replace the existing project tags with the current information in GitLab:
										if ($this-> replace_project_tags($row['PROJ_ID'], $data[$i]['id']))
										{
											//replace project tags function failed:
											echo $this->add_message("The project tags were refreshed successfully (PROJ_ID: ".$row['PROJ_ID'].")", 3);

											//commit the transaction
											$this->oracle_db->commit();

										}
										else
										{

											//replace project tags function failed:
											echo $this->add_message("The project tags could not be refreshed successfully (PROJ_ID: ".$row['PROJ_ID'].")", 2);

											//rollback the transaction
											$this->oracle_db->rollback();

										}

									}
									else
									{
										//query was NOT successful
										echo $this->add_message("The existing project record was NOT created successfully for the current gitlab project: ".$data[$i]['name'], 2);

										//rollback the transaction
										$this->oracle_db->rollback();

									}
								}
								else
								{
									//the PRI_PROJ does not already exist:

									echo $this->add_message("The project record does not exist, create a new project record", 3);

									$SQL = "INSERT INTO PRI.PRI_PROJ (VC_PROJ_ID, PROJ_NAME, PROJ_DESC, SSH_URL, HTTP_URL, README_URL, AVATAR_URL, PROJ_CREATE_DTM, PROJ_UPDATE_DTM, PROJ_VISIBILITY, PROJ_NAME_SPACE, PROJ_SOURCE) VALUES (:vc_proj_id, :proj_name, :proj_desc, :ssh_url, :http_url, :readme_url, :avatar_url, TO_DATE(REGEXP_SUBSTR(:proj_create_dtm, '([0-9]{4}\-[0-9]{2}\-[0-9]{2})T[0-9]{2}\:[0-9]{2}\:[0-9]{2}(\.[0-9]{3})?Z', 1, 1, 'i', 1) || ' ' ||REGEXP_SUBSTR(:proj_create_dtm, '[0-9]{4}\-[0-9]{2}\-[0-9]{2}T([0-9]{2}\:[0-9]{2}\:[0-9]{2})(\.[0-9]{3})?Z', 1, 1, 'i', 1), 'YYYY-MM-DD HH24:MI:SS'), (CASE WHEN :proj_update_dtm IS NOT NULL THEN  TO_DATE(REGEXP_SUBSTR(:proj_update_dtm, '([0-9]{4}\-[0-9]{2}\-[0-9]{2})T[0-9]{2}\:[0-9]{2}\:[0-9]{2}(\.[0-9]{3})?Z', 1, 1, 'i', 1) || ' ' ||REGEXP_SUBSTR(:proj_update_dtm, '[0-9]{4}\-[0-9]{2}\-[0-9]{2}T([0-9]{2}\:[0-9]{2}\:[0-9]{2})(\.[0-9]{3})?Z', 1, 1, 'i', 1), 'YYYY-MM-DD HH24:MI:SS') ELSE NULL END), :proj_visibility, :proj_name_space, :proj_source) RETURNING PROJ_ID INTO :RETURN_ID";
									$bind_array = array(array(":vc_proj_id", $data[$i]['id']), array(':proj_name', $data[$i]['name']), array(':proj_desc', $data[$i]['description']), array(':ssh_url', $data[$i]['ssh_url_to_repo']), array(':http_url', $data[$i]['http_url_to_repo']), array(':readme_url', $data[$i]['readme_url']), array(':avatar_url', $data[$i]['avatar_url']), array(':proj_create_dtm', $data[$i]['created_at']), array(':proj_update_dtm', $data[$i]['last_activity_at']), array(':proj_visibility', $data[$i]['visibility']), array(':proj_name_space', $data[$i]['path_with_namespace']), array(':proj_source', ($temp = PROJ_SOURCE)), array(":RETURN_ID", $return_id = null));

									if ($rc = $this->oracle_db->query($SQL, $result, $return_id, $bind_array, OCI_NO_AUTO_COMMIT))
									{
										//query was successful
										echo $this->add_message("The new project record was created successfully for the current gitlab project: ".$data[$i]['name'].", new proj_id is: ".$return_id, 3);

										//insert the project tags for the new project:
										if ($this-> replace_project_tags ($return_id, $data[$i]['id'], false))
										{
											//the project tags were added successfully:

											echo $this->add_message("The new project tags were created successfully for the current gitlab project, commit the transaction", 3);

											//commit the transaction
											$this->oracle_db->commit();
										}
										else
										{
											//the project tags were NOT added successfully:
											echo $this->add_message("The new project tags were NOT created successfully for the current gitlab project", 2);

											//rollback the transaction
											$this->oracle_db->rollback();

										}
									}
									else
									{
										//query was NOT successful
										echo $this->add_message("The new project record was NOT created successfully for the current gitlab project: ".$data[$i]['name'], 2);

										//rollback the transaction
										$this->oracle_db->rollback();
									}

								}
							}
							else
							{
								//query was NOT successful
								echo $this->add_message("The select project query was NOT successful", 2);
							}
						}
					}
				}
				else
				{
					//projects could not be retrieved successfully:
					echo $this->add_message("the request failed for the list of projects from the source gitlab server: ".GITLAB_HOST_NAME, 2);
				}
			}


		}

		//method to replace the project tags for a given project identified by the PRI_PROJ.PROJ_ID value: $project_id.  $gitlab_project_id will be used to query the GitLab server for the corresponding project tags.  If $existing_project is true then the associated tags will be removed, otherwise they will not be removed since it is a new project record
		function replace_project_tags ($project_id, $gitlab_project_id, $existing_project = true)
		{
			//initialize the return_val variable that will be returned from the function
			$return_val = true;

			echo $this->add_message("running replace_project_tags ($project_id, $gitlab_project_id, $existing_project)", 3);


			//delete all existing tags from the existing project so they can be replaced
			$SQL = "DELETE FROM PRI.PRI_PROJ_TAGS WHERE PROJ_ID = :proj_id";
			$bind_array = array(array(":proj_id", $project_id));

			//if this is not an existing project then do not remove the existing tags, if the project does exist then remove the existing tags:
			if ((!$existing_project) || (($existing_project) && ($rc = $this->oracle_db->query($SQL, $result, $dummy, $bind_array, OCI_NO_AUTO_COMMIT))))
			{
				//the delete query was successful or it was not an existing project:


				echo $this->add_message("the delete query was successful or it was not an existing project", 3);


				//initialize the boolean to determine if more tags need to be requested:
				$found_last_projects = false;

				//initialize the page counter variable:
				$page_counter = 0;

				echo $this->add_message("loop through each list of project tags until there are none remaining (only allows 100 per page)", 3);

				//request all Gitlab project tags via v4 API:
				for ($i = 0; (!$found_last_projects); $i++)
				{

					echo $this->add_message("send the request for page #".($page_counter + 1)." of the gitlab project tags", 3);


					//request all tags and loop through and insert them.  On error rollback, on success commit and move on to the next one.
					//request all Gitlab users accounts via v4 API:
					if ($content = curl_request("https://".GITLAB_HOST_NAME."/api/v4/projects/".$gitlab_project_id."/repository/tags?per_page=100&page=".(++$page_counter)."&private_token=".GITLAB_API_KEY))
					{
						echo $this->add_message("The existing project record's tags were requested successfully", 3);

						//the tag request was successful:

						//convert the string into a JSON array for processing:
						$data = json_decode($content, true);

						echo $this->add_message("The value of \$data is: " . var_export($data, true), 3);

						//free the content string from memory:
						$content = null;

						//check if there were any projects returned by the API call:
						if (count($data) == 0)
						{
							//there are no project tags returned by the API request, do nothing:
							echo $this->add_message("there are no project tags returned by the API request, stop processing them", 3);

							//there are no projects returned by the API request, stop processing the projects:
							$found_last_projects = true;

						}
						else
						{
							echo $this->add_message("there are one or more project tags, loop through each of the Gitlab project tags and insert them into the database", 3);

							//construct insert statement:
							$SQL = "INSERT INTO PRI.PRI_PROJ_TAGS (PROJ_ID, TAG_NAME, TAG_MSG, TAG_COMMIT_AUTHOR, TAG_COMMIT_DTM) VALUES (:proj_id, :tag_name, :tag_msg, :tag_author, TO_DATE(REGEXP_SUBSTR(:tag_dtm, '^([0-9]{4}\-[0-9]{2}\-[0-9]{2})T[0-9]{2}\:[0-9]{2}\:[0-9]{2}', 1, 1, 'i', 1) || ' ' ||REGEXP_SUBSTR(:tag_dtm, '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}T([0-9]{2}\:[0-9]{2}\:[0-9]{2})', 1, 1, 'i', 1), 'YYYY-MM-DD HH24:MI:SS'))";

							//loop through each of the Gitlab project tags and insert them into the database:
							for ($i = 0; $i < count($data); $i++)
							{

								//construct the bind variable array for the current tag:
								$bind_array = array(array(":proj_id", $project_id), array(":tag_name", $data[$i]['name']), array(":tag_msg", $data[$i]['message']), array(":tag_author", $data[$i]['commit']['author_name']), array(":tag_dtm", $data[$i]['commit']["authored_date"]));

								if ($rc = $this->oracle_db->query($SQL, $result, $dummy, $bind_array, OCI_NO_AUTO_COMMIT))
								{
									//query was successful
									echo $this->add_message("The new tag was inserted successfully (".$data[$i]['name'].")", 3);

								}
								else
								{
									//the query failed, stop the processing and retun false

									echo $this->add_message("The new tag was NOT inserted successfully (".$data[$i]['name'].")", 2);
									$return_val = false;

									//stop the project tag processing:
									break;

								}


							}
						}
					}
					else
					{
						//the GitLab request failed:

						echo $this->add_message("The GitLab project tag request was NOT successful", 2);

						$return_val = false;

					}
				}


			}
			else
			{

				//query was NOT successful
				echo $this->add_message("The existing project tags were not deleted successfully", 2);

				//set the return value to false:
				$return_val = false;


			}


			//return the $return_val
			return $return_val;
		}

		//method to retrieve the PRI.config file from the GitLab server and parse it to insert/replace the given project's configuration (identified by the PRI_PROJ.PROJ_ID value: $project_id).  $gitlab_project_id will be used to query the GitLab server for the corresponding configuration file (if it exists).
		function retrieve_project_resource_config ($project_id, $gitlab_project_id)
		{
			//initialize the return_val variable that will be returned from the function
			$return_val = true;

			echo $this->add_message("running retrieve_project_resource_config ($project_id, $gitlab_project_id)", 3);


			//delete all existing tags from the existing project so they can be replaced
			$SQL = "DELETE FROM PRI.PRI_PROJ_RES WHERE PROJ_ID = :proj_id";
			$bind_array = array(array(":proj_id", $project_id));

			//if this is not an existing project then do not remove the existing tags, if the project does exist then remove the existing tags:
			if ($rc = $this->oracle_db->query($SQL, $result, $dummy, $bind_array, OCI_NO_AUTO_COMMIT))
			{
				//the delete query was successful:


				echo $this->add_message("the delete query was successful or it was not an existing project", 3);



				echo $this->add_message("send the CURL request: https://".GITLAB_HOST_NAME."/api/v4/projects/".$gitlab_project_id."/repository/files/PRI.config?ref=branch_dev_GIM_app_v0.3&private_token=".GITLAB_API_KEY, 3);

				//request all tags and loop through and insert them.  On error rollback, on success commit and move on to the next one.
				//request all Gitlab users accounts via v4 API:
				if ($content = curl_request("https://".GITLAB_HOST_NAME."/api/v4/projects/".$gitlab_project_id."/repository/files/PRI.config?ref=branch_dev_GIM_app_v0.3&private_token=".GITLAB_API_KEY))
				{



					echo $this->add_message("The existing project record's PRI resource configuration file was requested successfully", 3);

					//the tag request was successful:

					echo $this->add_message("The value of \$content is: " . var_export($content, true), 3);

					//convert the string into a JSON array for processing:
					$data = json_decode($content, true);

					echo $this->add_message("The value of \$data is: " . var_export($data, true), 3);

					//free the content string from memory:
					$content = null;

					//The file was not found in the GitLab project:
					if (count($data) == 0)
					{
						//there are no project tags returned by the API request, do nothing:
						echo $this->add_message("The PRI custom resource configuration file was not found, stop processing", 3);

						//there are no projects returned by the API request, stop processing the projects:
						$found_last_projects = true;

					}
					else
					{
						//the file was found, convert the base 64 content to .txt and then parse as a json file to retrieve the custom configuration:

						echo $this->add_message("convert the content and parse as JSON to get the resource configuration information ", 3);

						//convert the base64 data to .txt (JSON file)
						$json_content = base64_decode($data["content"]);

						echo $this->add_message("\$json_content is: ".$json_content, 3);

						//parse the JSON so each resource can be processed:
						$data = json_decode($json_content, true);

						echo $this->add_message("\$data is: ".var_export($data, true), 3);

						//switch to the PRI_config element that contains all of the resource information
						$data = $data['PRI_config'];

						//delete all existing tags from the existing project so they can be replaced
						$SQL = "INSERT INTO PRI.PRI_PROJ_RES (PROJ_ID, RES_CATEGORY, RES_SCOPE_ID, RES_TYPE_ID, RES_TAG_CONV, RES_NAME, RES_COLOR_CODE, RES_URL, RES_DESC) VALUES (:proj_id, :res_category, (SELECT RES_SCOPE_ID FROM PRI.PRI_RES_SCOPES WHERE UPPER(RES_SCOPE_CODE) = UPPER(TRIM(:res_scope_id))), (SELECT RES_TYPE_ID FROM PRI.PRI_RES_TYPES WHERE UPPER(RES_TYPE_CODE) = UPPER(TRIM(:res_type_id))), :res_tag_conv, :res_name, :res_color_code, :res_url, :res_desc)";

						//loop through each of the resources in the JSON data and insert them into the database:
						for ($i = 0; $i < count($data); $i++)
						{



							//construct the bind variable array for the current tag:
							$bind_array = array(array(":proj_id", $project_id), array(":res_category", $data[$i]['resource_category']), array(":res_scope_id", $data[$i]['resource_scope']), array(":res_type_id", $data[$i]['resource_type']), array(":res_tag_conv", $data[$i]['tag_naming_convention']), array(":res_name", $data[$i]['resource_name']), array(":res_color_code", $data[$i]['project_color']), array(":res_url", $data[$i]['resource_url']), array(":res_desc", $data[$i]['resource_description']));

							if ($rc = $this->oracle_db->query($SQL, $result, $dummy, $bind_array, OCI_NO_AUTO_COMMIT))
							{
								//query was successful
								echo $this->add_message("The new project resource was inserted successfully (".$data[$i]['resource_name'].")", 3);

							}
							else
							{
								//the query failed, stop the processing and retun false

								echo $this->add_message("The new project resource was NOT inserted successfully (".$data[$i]['resource_name'].")", 2);
								$return_val = false;

								//stop the project tag processing:
								break;

							}


						}


					}
				}
				else
				{
					//the GitLab request failed:

					echo $this->add_message("The GitLab project PRI configuration file request was NOT successful", 2);

					$return_val = false;

				}


			}
			else
			{

				//query was NOT successful
				echo $this->add_message("The existing project tags were not deleted successfully", 2);

				//set the return value to false:
				$return_val = false;


			}


			//return the $return_val
			return $return_val;
		}


	}

?>

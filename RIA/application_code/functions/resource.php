<?php

  include_once(APPLICATION_INCLUDE_PATH."RIA_data.php");

  class resource extends RIA_data
  {


    //this function accepts an associative array $data that contains the values of a result set row so it can be displayed
    function generate_resource_display_card ($data)
    {
      //generate the formatted HTML for the resource display card:
      $return_string = "<article class=\"card_parent\">
        <div class=\"content\">
          <div class=\"res_info_div card_container\">
            <div class=\"card_desc_container\">
              <div class=\"card_label tooltip\" title=\"The name of the Resource.  Clicking the Resource Name will redirect the user to the Resource page.  Clicking the external link window will open the project resource in a new browser tab\">Resource</div>
              <div class=\"card_value_lj\"><a href=\"./view_resource.php?RES_ID=".$data['RES_ID']."\">".$data['RES_NAME']."</a> <a href=\"".$data['RES_URL']."\" target=\"_blank\"><span class=\"ui-icon ui-icon-extlink\"></span></a></div>
              <div class=\"card_label tooltip\" title=\"The resource category (free form text) - examples values include Development Tool, Data Management Tool, Centralized Database Applications\">Category</div>
              <div class=\"card_value\">".$data['RES_CATEGORY']."</div>
              <div class=\"card_label tooltip\" title=\"The description for the Resource\">Description</div>
              <div class=\"card_value_lj\">".$data['RES_DESC']."</div>
            </div>
          </div>
          <div class=\"spacer\"></div>
          <div class=\"impl_proj_info_div card_container\">
              <div class=\"card_label tooltip\" title=\"The scope of the Resource\">Scope</div>
              <div class=\"card_value\">".$data['RES_SCOPE_NAME']."</div>
              <div class=\"card_label tooltip\" title=\"The type of Resource\">Type</div>
              <div class=\"card_value\">".$data['RES_TYPE_NAME']."</div>
              <div class=\"card_label tooltip\" title=\"The Resource's current version\">Current Resource Version</div>
              <div class=\"card_value\">".$data['RES_MAX_VERS_NUM']."</div>
              <div class=\"card_label tooltip\" title=\"The total number of Projects that have implemented the given Resource\"># Implemented Projects</div>
              <div class=\"card_value\">".$data['TOTAL_IMPL_PROJ']."</div>
              <div class=\"card_label tooltip\" title=\"The number of Projects that have implemented the given Resource that are the same as the current version\"># Current Version</div>
              <div class=\"card_value\">".$data['CURR_VERS_COUNT']."</div>
              <div class=\"card_label tooltip\" title=\"The number of Projects that have implemented the given Resource that are not the same as the current version\"># Old Version</div>
              <div class=\"card_value\">".$data['OLD_VERS_COUNT']."</div>
              <div class=\"card_label tooltip\" title=\"The live demonstration URL for the Project Resource\">Live Demo</div>
              <div class=\"card_value\">".((!empty($data['RES_DEMO_URL'])) ? "<a href=\"".$data['RES_DEMO_URL']."\" target=\"_blank\">Live Demo</a>": "N/A")."</div>
          </div>
          <div class=\"spacer\"></div>
          <div class=\"res_proj_div card_container card_desc_container\">
            <div class=\"card_label tooltip\" title=\"A list of projects and associated highest version number that have implemented the given resource that provides links to the associated Projects.  If the current version implemented is the same as the current version of the resource the project name is preceded by a &quot;(*CV)&quot; prefix to indicate it is the current version and if not the &quot;(*UA)&quot; prefix is used to indicate there is an update available\">Implemented Projects</div>
            <div class=\"card_value_lj\">".$data['ASSOC_PROJ_LINK_BR_LIST']."</div>
          </div>
          <div class=\"spacer\"></div>
          <div class=\"proj_info_div card_container\">
          <div class=\"card_label tooltip\" title=\"The name of the Resource's associated Project.  Clicking the Project icon or name will open a new tab to the Project page. Clicking the external link window will open the project resource in a new browser tab.\">Project</div>
            <div class=\"card_avatar_name\">
              <div class=\"card_name_container\">
                <a href=\"".$data['VC_WEB_URL']."\" target=\"_blank\" class=\"proj_name_link\"><img
                class=\"avatar\"
                src=\"".((empty($data['AVATAR_URL'])) ? "./res/images/no image.png" : $data['AVATAR_URL'])."\"
                alt=\"Project Avatar\"
                /></a>
                <div class=\"card_value_lj\"><a href=\"./view_project.php?PROJ_ID=".$data['PROJ_ID']."\">".$data['PROJ_NAME']."</a> <a href=\"".$data['VC_WEB_URL']."\" target=\"_blank\"><span class=\"ui-icon ui-icon-extlink\"></span></a></div>
              </div>
            </div>
            <div class=\"card_desc_container\">
            <div class=\"card_label tooltip\" title=\"The source of the project record (e.g. PIFSC GitLab, GitHub, manual entry)\">Project Source</div>
            <div class=\"card_value\">".$data['DATA_SOURCE_NAME']."</div>
            <div class=\"card_label tooltip\" title=\"The visibility of the Project (private, internal, public)\">Visibility</div>
            <div class=\"card_value\">".$data['PROJ_VISIBILITY']."</div>
            <div class=\"card_label tooltip\" title=\"Link to the Project's README file (if defined)\">README Link</div>
            <div class=\"card_value\">".((empty($data['README_URL'])) ? "N/A": " <a href=\"".$data['README_URL']."\" target=\"_blank\">README</a>")."</div>
            <div class=\"card_label tooltip\" title=\"The description for the Project\">Description</div>
            <div class=\"card_value_lj\">".$data['PROJ_DESC']."</div>
            </div>
          </div>
          <div class=\"spacer\"></div>
          <div class=\"proj_det_info_div card_container\">
            <div class=\"card_label tooltip\" title=\"The creator of the Project.  Clicking the creator icon or name will open a new tab to the creator's user page.\">Creator</div>
            <div class=\"card_avatar_name\">
              <div class=\"card_name_container\">
                <a href=\"".$data['CREATOR_WEB_URL']."\" target=\"_blank\" class=\"proj_name_link\"><img
                class=\"avatar\"
                src=\"".((empty($data['CREATOR_AVATAR_URL'])) ? "./res/images/no image.png" : $data['CREATOR_AVATAR_URL'])."\"
                alt=\"Creator Avatar\"
                /></a>
                <div class=\"card_value\"><a href=\"".$data['CREATOR_WEB_URL']."\" target=\"_blank\">".$data['CREATOR_USER_NAME']."</a> <a href=\"".$data['CREATOR_WEB_URL']."\" target=\"_blank\"></a></div>
              </div>
            </div>
            <div class=\"card_label tooltip\" title=\"The owner of the Project.  Clicking the owner icon or name will open a new tab to the owner's user page.\">Owner</div>
            <div class=\"card_avatar_name\">
              <div class=\"card_name_container\">
                ".((is_null($data['OWNER_WEB_URL'])) ? "": "<a href=\"".$data['OWNER_WEB_URL']."\" target=\"_blank\" class=\"proj_name_link\">")."<img
                class=\"avatar\"
                src=\"".((empty($data['OWNER_AVATAR_URL'])) ? "./res/images/no image.png" : $data['OWNER_AVATAR_URL'])."\"
                alt=\"Owner Avatar\"
                />".((is_null($data['OWNER_WEB_URL'])) ? "" : "</a>")."

                <div class=\"card_value\">".((is_null($data['OWNER_WEB_URL'])) ? "": "<a href=\"".$data['OWNER_WEB_URL']."\" target=\"_blank\">").$data['OWNER_USER_NAME'].((is_null($data['OWNER_WEB_URL'])) ? "": "</a>")."</div>

              </div>
            </div>


          </div>
          <div class=\"spacer\"></div>
          <div class=\"res_det_info_div card_container\">

            <div class=\"card_label tooltip\" title=\"The total number of commits for the project\"># Commits</div>
            <div class=\"card_value\">".$data['VC_COMMIT_COUNT']."</div>
            <div class=\"card_label tooltip\" title=\"The total size of the project's repository (in MB)\">Repository Size</div>
            <div class=\"card_value\">".$data['FORMAT_VC_REPO_SIZE_MB']." MB</div>


            <div class=\"card_label tooltip\" title=\"The Date/Time the Project was created (in MM/DD/YYYY HH24:MI:SS format)\">Created</div>
            <div class=\"card_value\">".$data['PROJ_CREATE_DTM']."</div>
            <div class=\"card_label tooltip\" title=\"The Date/Time the Project was last updated (in MM/DD/YYYY HH24:MI:SS format)\">Last Update</div>
            <div class=\"card_value\">".$data['PROJ_UPDATE_DTM']."</div>
            <div class=\"card_label tooltip\" title=\"The date/time the project information was refreshed in the database (in MM/DD/YYYY HH24:MI:SS format)\">Refresh Date</div>
            <div class=\"card_value\">".$data['PROJ_REFRESH_DATE']."</div>

          </div>
        </div>
      </article>";

      return $return_string;

    }


  }


?>

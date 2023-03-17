<?php

  include_once(APPLICATION_INCLUDE_PATH."RIA_data.php");

  class project extends RIA_data
  {

    //this function accepts an associative array $data that contains the values of a result set row so it can be displayed
    function generate_project_display_card ($data)
    {
      //generate the formatted HTML for the project display card:
      $return_string = "<article class=\"card_parent\">
        <div class=\"content\">
          <div class=\"proj_name_div card_container\">
            <div class=\"card_label tooltip\" title=\"The name of the Project.  Clicking the Project icon or name will open a new tab to the Project page.  Clicking the external link window will open the project resource in a new browser tab.\">Project</div>
            <div class=\"card_avatar_name\">
                <div class=\"card_name_container\">
                  <a href=\"".$data['VC_WEB_URL']."\" target=\"_blank\" class=\"proj_name_link\"><img
                  class=\"avatar\"
                  src=\"".((empty($data['AVATAR_URL'])) ? "./res/images/no image.png" : $data['AVATAR_URL'])."\"
                  alt=\"Project Avatar\"
                  /></a>
                  <div class=\"card_value\"><a href=\"./view_project.php?PROJ_ID=".$data['PROJ_ID']."\">".$data['PROJ_NAME']."</a> <a href=\"".$data['VC_WEB_URL']."\" target=\"_blank\"><span class=\"ui-icon ui-icon-extlink\"></span></a></div>
                </div>
            </div>
            <div class=\"card_desc_container\">
              <div class=\"card_label tooltip\" title=\"The description for the Project\">Description</div>
              <div class=\"card_value_lj\">".$data['PROJ_DESC']."</div>
            </div>
          </div>
          <div class=\"spacer\"></div>
          <div class=\"proj_info_div card_container\">
              <div class=\"card_label tooltip\" title=\"The source of the project record (e.g. PIFSC GitLab, GitHub, manual entry)\">Project Source</div>
              <div class=\"card_value\">".$data['DATA_SOURCE_NAME']."</div>
              <div class=\"card_label tooltip\" title=\"The visibility of the Project (private, internal, public)\">Visibility</div>
              <div class=\"card_value\">".$data['PROJ_VISIBILITY']."</div>
              <div class=\"card_label tooltip\" title=\"Link to the Project's README file (if defined)\">README Link</div>
              <div class=\"card_value\">".((empty($data['README_URL'])) ? "N/A": " <a href=\"".$data['README_URL']."\" target=\"_blank\">README</a>")."</div>
              <div class=\"card_label tooltip\" title=\"The number of Resources defined within the Project\"># Project Resources</div>
              <div class=\"card_value\">".$data['NUM_RES']."</div>
          </div>
          <div class=\"spacer\"></div>
          <div class=\"proj_res_div card_container\">
              <div class=\"card_label tooltip\" title=\"The list of Project Resources and associated highest version number defined within the project that provides links to the associated Resources\">Project Resources</div>
              <div class=\"card_value_lj\">".$data['RES_NAME_LINK_BR_LIST']."</div>
          </div>
          <div class=\"spacer\"></div>
          <div class=\"proj_impl_res_info_div card_container\">
              <div class=\"card_label tooltip\" title=\"The total number of implemented external Resources for the Project\"># Implemented Resources</div>
              <div class=\"card_value\">".$data['TOTAL_IMPL_RES']."</div>
              <div class=\"card_label tooltip\" title=\"The number of implemented external Resources for the Project that are the same as the current version of the Resource\"># Current Version</div>
              <div class=\"card_value\">".$data['CURR_VERS_COUNT']."</div>
              <div class=\"card_label tooltip\" title=\"The number of implemented external Resources for the Project that are not the same as the current version of the Resource\"># Old Version</div>
              <div class=\"card_value\">".$data['OLD_VERS_COUNT']."</div>
          </div>
          <div class=\"spacer\"></div>
          <div class=\"proj_impl_res_div card_container\">
              <div class=\"card_label tooltip\" title=\"The list of implemented external Resources and associated highest version number for the Project that provides links to the associated Resources.  If the current version of the Resource implemented in the Project is the same as the current version of the Resource the Resource name is preceded by a &quot;(*CV)&quot; prefix to indicate it is the current version and if not the &quot;(*UA)&quot; prefix is used to indicate there is an update available\">Implemented Resources</div>
              <div class=\"card_value_lj\">".$data['IMPL_RES_LINK_BR_LIST']."</div>
          </div>
          <div class=\"spacer\"></div>
          <div class=\"proj_user_div card_container\">
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
          <div class=\"proj_auditing_info_div card_container\">

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

select user_tab_privs.owner "Owner Schema", all_objects.object_type "Object Type", user_tab_privs.table_name "Object Name", LISTAGG(PRIVILEGE, ', ') WITHIN GROUP (ORDER BY PRIVILEGE) as "Granted Privileges" from user_tab_privs
inner join all_objects ON user_tab_privs.table_name = all_objects.object_name
AND all_objects.owner = user_tab_privs.owner
AND all_objects.object_type <> 'PACKAGE BODY'
where GRANTEE = sys_context( 'userenv', 'current_schema' )
group by user_tab_privs.owner, user_tab_privs.table_name, all_objects.object_type
order by user_tab_privs.owner, all_objects.object_type, table_name;

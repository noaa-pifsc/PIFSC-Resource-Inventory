select owner||'.'||table_name TABLE_NAME, comments from all_tab_comments where table_type = 'VIEW' and OWNER IN (sys_context('userenv','current_schema')) order by TABLE_NAME

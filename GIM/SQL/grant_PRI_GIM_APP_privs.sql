grant select, insert, update on PRI_PROJ to PRI_GIM_APP;
grant select, insert, update on PRI_VC_USERS to PRI_GIM_APP;

grant select, insert, update, delete on PRI_PROJ_RES to PRI_GIM_APP;
grant select, insert, delete on PRI_PROJ_TAGS to PRI_GIM_APP;
grant select on PRI_RES_TYPES TO PRI_GIM_APP;
grant select on PRI_RES_SCOPES TO PRI_GIM_APP;
grant select on PRI_DATA_SOURCES TO PRI_GIM_APP;

grant execute on DB_LOG_PKG to PRI_GIM_APP;

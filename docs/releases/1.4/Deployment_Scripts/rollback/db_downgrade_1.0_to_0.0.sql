--drop all objects to restore schema to a blank schema:
DROP TABLE DB_LOG_ENTRIES cascade constraints PURGE;
DROP SEQUENCE DB_LOG_ENTRIES_SEQ;
DROP VIEW DB_LOG_ENTRIES_V;
DROP TABLE DB_LOG_ENTRY_TYPES cascade constraints PURGE;
DROP SEQUENCE DB_LOG_ENTRY_TYPES_SEQ;
DROP PACKAGE DB_LOG_PKG;
DROP TABLE DB_UPGRADE_LOGS cascade constraints PURGE;
DROP SEQUENCE DB_UPGRADE_LOGS_SEQ;
DROP VIEW DB_UPGRADE_LOGS_V;
DROP VIEW DVM_CRITERIA_V;
DROP TABLE DVM_DATA_STREAMS cascade constraints PURGE;
DROP TABLE DVM_DATA_STREAMS_HIST cascade constraints PURGE;
DROP SEQUENCE DVM_DATA_STREAMS_HIST_SEQ;
DROP SEQUENCE DVM_DATA_STREAMS_SEQ;
DROP VIEW DVM_DATA_STREAMS_V;
DROP VIEW DVM_DS_PTA_RULE_SETS_HIST_V;
DROP VIEW DVM_DS_PTA_RULE_SETS_V;
DROP TABLE DVM_ISSUES cascade constraints PURGE;
DROP TABLE DVM_ISSUES_HIST cascade constraints PURGE;
DROP SEQUENCE DVM_ISSUES_HIST_SEQ;
DROP SEQUENCE DVM_ISSUES_SEQ;
DROP TABLE DVM_ISS_RES_TYPES cascade constraints PURGE;
DROP TABLE DVM_ISS_RES_TYPES_HIST cascade constraints PURGE;
DROP SEQUENCE DVM_ISS_RES_TYPES_HIST_SEQ;
DROP SEQUENCE DVM_ISS_RES_TYPES_SEQ;
DROP TABLE DVM_ISS_SEVERITY cascade constraints PURGE;
DROP TABLE DVM_ISS_SEVERITY_HIST cascade constraints PURGE;
DROP SEQUENCE DVM_ISS_SEVERITY_HIST_SEQ;
DROP SEQUENCE DVM_ISS_SEVERITY_SEQ;
DROP TABLE DVM_ISS_TYPES cascade constraints PURGE;
DROP TABLE DVM_ISS_TYPES_HIST cascade constraints PURGE;
DROP SEQUENCE DVM_ISS_TYPES_HIST_SEQ;
DROP SEQUENCE DVM_ISS_TYPES_SEQ;
DROP TABLE DVM_ISS_TYP_ASSOC cascade constraints PURGE;
DROP SEQUENCE DVM_ISS_TYP_ASSOC_SEQ;
DROP PACKAGE DVM_PKG;
DROP TABLE DVM_PTA_ISSUES cascade constraints PURGE;
DROP SEQUENCE DVM_PTA_ISSUES_SEQ;
DROP VIEW DVM_PTA_ISSUES_V;
DROP VIEW DVM_PTA_ISS_TYPES_V;
DROP TABLE DVM_PTA_RULE_SETS cascade constraints PURGE;
DROP TABLE DVM_PTA_RULE_SETS_HIST cascade constraints PURGE;
DROP VIEW DVM_PTA_RULE_SETS_HIST_RPT_V;
DROP SEQUENCE DVM_PTA_RULE_SETS_HIST_SEQ;
DROP VIEW DVM_PTA_RULE_SETS_HIST_V;
DROP VIEW DVM_PTA_RULE_SETS_RPT_V;
DROP SEQUENCE DVM_PTA_RULE_SETS_SEQ;
DROP VIEW DVM_PTA_RULE_SETS_V;
DROP VIEW DVM_QC_MSG_MISS_FIELDS_V;
DROP TABLE DVM_QC_OBJECTS cascade constraints PURGE;
DROP TABLE DVM_QC_OBJECTS_HIST cascade constraints PURGE;
DROP SEQUENCE DVM_QC_OBJECTS_HIST_SEQ;
DROP SEQUENCE DVM_QC_OBJECTS_SEQ;
DROP TABLE DVM_RULE_SETS cascade constraints PURGE;
DROP VIEW DVM_RULE_SETS_RPT_V;
DROP SEQUENCE DVM_RULE_SETS_SEQ;
DROP VIEW DVM_RULE_SETS_V;
DROP VIEW DVM_STD_QC_ACT_RULE_SETS_V;
DROP VIEW DVM_STD_QC_ALL_RPT_V;
DROP VIEW DVM_STD_QC_DS_V;
DROP VIEW DVM_STD_QC_DS_VIEWS_V;
DROP VIEW DVM_STD_QC_IND_FIELDS_V;
DROP VIEW DVM_STD_QC_ISS_TEMPL_V;
DROP VIEW DVM_STD_QC_MISS_CONFIG_V;
DROP VIEW DVM_STD_QC_VIEW_V;
DROP TABLE PRI_DATA_SOURCES cascade constraints PURGE;
DROP SEQUENCE PRI_DATA_SOURCES_SEQ;
DROP PACKAGE PRI_PKG;
DROP TABLE PRI_PROJ cascade constraints PURGE;
DROP TABLE PRI_PROJ_RES cascade constraints PURGE;
DROP SEQUENCE PRI_PROJ_RES_SEQ;
DROP VIEW PRI_PROJ_RES_TAG_MAX_SUM_ALL_V;
DROP VIEW PRI_PROJ_RES_TAG_MAX_SUM_V;
DROP VIEW PRI_PROJ_RES_TAG_MAX_V;
DROP SEQUENCE PRI_PROJ_SEQ;
DROP TABLE PRI_PROJ_TAGS cascade constraints PURGE;
DROP SEQUENCE PRI_PROJ_TAGS_SEQ;
DROP VIEW PRI_PROJ_TAGS_V;
DROP VIEW PRI_PROJ_V;
DROP VIEW PRI_RES_PROJ_TAG_MAX_SUM_ALL_V;
DROP VIEW PRI_RES_PROJ_TAG_MAX_SUM_V;
DROP VIEW PRI_RES_PROJ_TAG_MAX_V;
DROP TABLE PRI_RES_SCOPES cascade constraints PURGE;
DROP SEQUENCE PRI_RES_SCOPES_SEQ;
DROP VIEW PRI_RES_TAG_MAX_VERS_V;
DROP VIEW PRI_RES_TAG_VERS_V;
DROP TABLE PRI_RES_TYPES cascade constraints PURGE;
DROP SEQUENCE PRI_RES_TYPES_SEQ;
DROP VIEW PRI_RES_V;
DROP TABLE PRI_VC_USERS cascade constraints PURGE;
DROP SEQUENCE PRI_VC_USERS_SEQ;
DROP VIEW PRI_VC_USERS_V;
--------------------------------------------------------
--------------------------------------------------------
--Database Name: Data Validation Module
--Database Description: This module was developed to perform systematic data quality control (QC) on a given set of data tables so the data issues can be stored in a single table and easily reviewed to identify and resolve/annotate data issues
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--version 0.11 updates:
--------------------------------------------------------



CREATE TABLE DVM_PTA_RULE_SETS_HIST
(
  H_SEQNUM NUMBER(10, 0) NOT NULL
, PTA_RULE_SET_ID NUMBER NOT NULL
, H_TYPE_OF_CHANGE VARCHAR2(10 BYTE) NOT NULL
, H_DATE_OF_CHANGE DATE NOT NULL
, H_USER_MAKING_CHANGE VARCHAR2(30 BYTE) NOT NULL
, H_OS_USER VARCHAR2(30 BYTE) NOT NULL
, H_CHANGED_COLUMN VARCHAR2(30 BYTE)
, H_OLD_DATA VARCHAR2(4000 BYTE)
, H_NEW_DATA VARCHAR2(4000 BYTE)
)
;
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST.H_SEQNUM IS 'A unique number for this record in the history table';
 COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST.PTA_RULE_SET_ID IS 'Primary key column of the data table';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST.H_TYPE_OF_CHANGE IS 'The type of change is INSERT, UPDATE or DELETE';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST.H_DATE_OF_CHANGE IS 'The date and time the change was made to the data';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST.H_USER_MAKING_CHANGE IS 'The person (Oracle username) making the change to the record';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST.H_OS_USER IS 'The OS username of the person making the change to the record';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST.H_CHANGED_COLUMN IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST.H_OLD_DATA IS 'The data that has been updated';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST.H_NEW_DATA IS 'The updated column data';
COMMENT ON TABLE DVM_PTA_RULE_SETS IS 'History tracking table for DVM_PTA_RULE_SETS implemented using the DSC.DSC_CRE_HIST_OBJS_PKG package';

CREATE SEQUENCE DVM_PTA_RULE_SETS_HIST_SEQ INCREMENT BY 1 START WITH 1;

create or replace TRIGGER trg_DVM_PTA_RULE_SETS_hist
AFTER DELETE OR INSERT OR UPDATE
ON DVM_PTA_RULE_SETS
REFERENCING OLD AS old NEW AS new
FOR EACH ROW
DECLARE
  os_user VARCHAR2(30) := dsc.dsc_utilities_pkg.os_user;

  PROCEDURE insert_data(
    p_type_of_change IN VARCHAR2,
    p_changed_column IN VARCHAR2 DEFAULT NULL,
    p_old_data       IN VARCHAR2 DEFAULT NULL,
    p_new_data       IN VARCHAR2 DEFAULT NULL ) IS
  BEGIN
    INSERT INTO DVM_PTA_RULE_SETS_hist (
      h_seqnum, PTA_RULE_SET_ID, h_type_of_change, h_user_making_change, h_os_user,
      h_date_of_change, h_changed_column, h_old_data, h_new_data)
    VALUES(
      DVM_PTA_RULE_SETS_hist_seq.NEXTVAL, :old.PTA_RULE_SET_ID, p_type_of_change, user, os_user,      SYSDATE, p_changed_column, p_old_data, p_new_data);
  END;

  PROCEDURE check_update(
    p_changed_column IN VARCHAR2,
    p_old_data       IN VARCHAR2,
    p_new_data       IN VARCHAR2 ) IS
  BEGIN
    IF p_old_data <> p_new_data
    OR (p_old_data IS NULL AND p_new_data IS NOT NULL)
    OR (p_new_data IS NULL AND p_old_data IS NOT NULL) THEN
      insert_data('UPDATE', p_changed_column, p_old_data, p_new_data);
    END IF;
  END;
BEGIN
  IF INSERTING THEN
    INSERT INTO DVM_PTA_RULE_SETS_hist (
      h_seqnum, PTA_RULE_SET_ID, h_type_of_change, h_user_making_change, h_os_user, h_date_of_change)
    VALUES (
      DVM_PTA_RULE_SETS_hist_seq.NEXTVAL, :new.PTA_RULE_SET_ID,
      'INSERT', user, os_user, SYSDATE);
  ELSIF DELETING THEN
    insert_data('DELETE');
    insert_data('DELETE', 'rule_set_id', :old.rule_set_id);
    insert_data('DELETE', 'pta_iss_id', :old.pta_iss_id);
    insert_data('DELETE', 'first_eval_date', 'MM/DD/YYYY HH24:MI:SS');
    insert_data('DELETE', 'last_eval_date', 'MM/DD/YYYY HH24:MI:SS');
  ELSE
    NULL;
    check_update('RULE_SET_ID', :old.rule_set_id, :new.rule_set_id);
    check_update('PTA_ISS_ID', :old.pta_iss_id, :new.pta_iss_id);
    check_update('FIRST_EVAL_DATE', TO_CHAR(:old.first_eval_date, 'MM/DD/YYYY HH24:MI:SS'), TO_CHAR(:new.first_eval_date, 'MM/DD/YYYY HH24:MI:SS'));
    check_update('LAST_EVAL_DATE', TO_CHAR(:old.last_eval_date, 'MM/DD/YYYY HH24:MI:SS'), TO_CHAR(:new.last_eval_date, 'MM/DD/YYYY HH24:MI:SS'));
  END IF;
END;
/



--cruise DVM rules report:
CREATE OR REPLACE View

DVM_PTA_RULE_SETS_RPT_V
AS
select
DVM_PTA_RULE_SETS_V.PTA_RULE_SET_ID,
DVM_PTA_RULE_SETS_V.PTA_ISS_ID,
DVM_PTA_RULE_SETS_V.FORMAT_FIRST_EVAL_DATE,
DVM_PTA_RULE_SETS_V.FORMAT_LAST_EVAL_DATE,
DVM_PTA_RULE_SETS_V.RULE_SET_ID,
DVM_PTA_RULE_SETS_V.RULE_SET_ACTIVE_YN,
DVM_PTA_RULE_SETS_V.FORMAT_RULE_SET_CREATE_DATE,
DVM_PTA_RULE_SETS_V.RULE_SET_CREATE_DATE,
DVM_PTA_RULE_SETS_V.FORMAT_RULE_SET_INACTIVE_DATE,
DVM_PTA_RULE_SETS_V.RULE_SET_INACTIVE_DATE,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_CODE,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_NAME,
DVM_PTA_RULE_SETS_V.ISS_TYPE_NAME,
DVM_PTA_RULE_SETS_V.ISS_TYPE_DESC,
DVM_PTA_RULE_SETS_V.ISS_SEVERITY_CODE,
DVM_PTA_RULE_SETS_V.ISS_SEVERITY_NAME

FROM
DVM_PTA_RULE_SETS_V
order by DVM_PTA_RULE_SETS_V.PTA_ISS_ID,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_NAME,
DVM_PTA_RULE_SETS_V.RULE_SET_CREATE_DATE,
DVM_PTA_RULE_SETS_V.RULE_SET_ID,
DVM_PTA_RULE_SETS_V.ISS_TYPE_NAME;


COMMENT ON TABLE DVM_PTA_RULE_SETS_RPT_V IS 'DVM PTA Rule Sets Report (View)

This view returns the parent issue record information and their associated validation rule sets and corresponding validation rules.  This standard report query can be combined with data set-specific information to generate a standard validation rule report that can be included with the data set metadata or as an internal report to provide the specific data quality control criteria that was used to validate each parent record if that level of detail is desired';

COMMENT ON COLUMN DVM_PTA_RULE_SETS_RPT_V.PTA_RULE_SET_ID IS 'The primary key field for the DVM_PTA_RULE_SETS table';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_RPT_V.PTA_ISS_ID IS 'Primary Key for the DVM_PTA_ISSUES table';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_RPT_V.FORMAT_FIRST_EVAL_DATE IS 'The formatted date/time the rule set was first evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_RPT_V.FORMAT_LAST_EVAL_DATE IS 'The formatted date/time the rule set was most recently evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_RPT_V.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_RPT_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).  Only one rule set can be active at any given time';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_RPT_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_RPT_V.RULE_SET_CREATE_DATE IS 'The date/time that the given rule set was created';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_RPT_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_RPT_V.RULE_SET_INACTIVE_DATE IS 'The date/time that the given rule set was deactivated (due to a change in active rules)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_RPT_V.RULE_DATA_STREAM_CODE IS 'The code for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_RPT_V.RULE_DATA_STREAM_NAME IS 'The name for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_RPT_V.ISS_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_RPT_V.ISS_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_RPT_V.ISS_SEVERITY_CODE IS 'The code for the given issue severity';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_RPT_V.ISS_SEVERITY_NAME IS 'The name for the given issue severity';





CREATE OR REPLACE VIEW
DVM_DS_PTA_RULE_SETS_HIST_V
AS


select
PTA_RULE_SET_ID,
RULE_SET_ID,
PTA_ISS_ID,
DATA_STREAM_ID,
DATA_STREAM_CODE,
DATA_STREAM_NAME,
DATA_STREAM_DESC,
FORMAT_EVAL_DATE,
EVAL_DATE
FROM
(select
DVM_DS_PTA_RULE_SETS_V.PTA_RULE_SET_ID,
DVM_DS_PTA_RULE_SETS_V.RULE_SET_ID,
DVM_DS_PTA_RULE_SETS_V.PTA_ISS_ID,
DVM_DS_PTA_RULE_SETS_V.DATA_STREAM_ID,
DVM_DS_PTA_RULE_SETS_V.DATA_STREAM_CODE,
DVM_DS_PTA_RULE_SETS_V.DATA_STREAM_NAME,
DVM_DS_PTA_RULE_SETS_V.DATA_STREAM_DESC,
DVM_PTA_RULE_SETS_HIST.H_NEW_DATA FORMAT_EVAL_DATE,
TO_DATE(DVM_PTA_RULE_SETS_HIST.H_NEW_DATA, 'MM/DD/YYYY HH24:MI:SS') EVAL_DATE
FROM DVM_DS_PTA_RULE_SETS_V
INNER JOIN
DVM_PTA_RULE_SETS_HIST
ON DVM_DS_PTA_RULE_SETS_V.PTA_RULE_SET_ID = DVM_PTA_RULE_SETS_HIST.PTA_RULE_SET_ID
AND DVM_PTA_RULE_SETS_HIST.H_TYPE_OF_CHANGE = 'UPDATE'
AND H_CHANGED_COLUMN = 'LAST_EVAL_DATE'
UNION ALL
SELECT
DVM_DS_PTA_RULE_SETS_V.PTA_RULE_SET_ID,
DVM_DS_PTA_RULE_SETS_V.RULE_SET_ID,
DVM_DS_PTA_RULE_SETS_V.PTA_ISS_ID,
DVM_DS_PTA_RULE_SETS_V.DATA_STREAM_ID,
DVM_DS_PTA_RULE_SETS_V.DATA_STREAM_CODE,
DVM_DS_PTA_RULE_SETS_V.DATA_STREAM_NAME,
DVM_DS_PTA_RULE_SETS_V.DATA_STREAM_DESC,
TO_CHAR(DVM_DS_PTA_RULE_SETS_V.FIRST_EVAL_DATE, 'MM/DD/YYYY HH24:MI:SS') FORMAT_EVAL_DATE,
DVM_DS_PTA_RULE_SETS_V.FIRST_EVAL_DATE EVAL_DATE
FROM
DVM_DS_PTA_RULE_SETS_V)
ORDER BY PTA_ISS_ID, DATA_STREAM_CODE, EVAL_DATE;

COMMENT ON TABLE DVM_DS_PTA_RULE_SETS_HIST_V IS 'DVM Validation Rule Set Evaluation History (View)

This view returns the date/time for each time the DVM was processed (FORMAT_EVAL_DATE) on a given parent record and associated data stream.  This query can be combined with data set-specific information to generate a standard DVM evaluation report that can be included with the data set metadata or as an internal report to provide the DVM rule set evaluation history for each parent record if that level of detail is desired';


COMMENT ON COLUMN DVM_DS_PTA_RULE_SETS_HIST_V.PTA_RULE_SET_ID IS 'The primary key field for the DVM_PTA_RULE_SETS table';
COMMENT ON COLUMN DVM_DS_PTA_RULE_SETS_HIST_V.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';
COMMENT ON COLUMN DVM_DS_PTA_RULE_SETS_HIST_V.PTA_ISS_ID IS 'Foreign key reference to the PTA Issue record associated validation rule set (DVM_PTA_ISSUES)';
COMMENT ON COLUMN DVM_DS_PTA_RULE_SETS_HIST_V.DATA_STREAM_ID IS 'Primary Key for the DVM_DATA_STREAMS table';
COMMENT ON COLUMN DVM_DS_PTA_RULE_SETS_HIST_V.DATA_STREAM_CODE IS 'The code for the given data stream';
COMMENT ON COLUMN DVM_DS_PTA_RULE_SETS_HIST_V.DATA_STREAM_NAME IS 'The name for the given data stream';
COMMENT ON COLUMN DVM_DS_PTA_RULE_SETS_HIST_V.DATA_STREAM_DESC IS 'The description for the given data stream';
COMMENT ON COLUMN DVM_DS_PTA_RULE_SETS_HIST_V.FORMAT_EVAL_DATE IS 'The formatted date/time the given parent record was evaluated using the DVM for the associated data stream (in SYYYY-MM-DD HH24:MI:SS format)';
COMMENT ON COLUMN DVM_DS_PTA_RULE_SETS_HIST_V.EVAL_DATE IS 'The date/time the given parent record was evaluated using the DVM for the associated data stream';





CREATE OR REPLACE VIEW
DVM_PTA_RULE_SETS_HIST_V
AS


select
PTA_RULE_SET_ID,
PTA_ISS_ID,
RULE_SET_ID,
RULE_SET_ACTIVE_YN,
RULE_SET_CREATE_DATE,
FORMAT_RULE_SET_CREATE_DATE,
RULE_SET_INACTIVE_DATE,
FORMAT_RULE_SET_INACTIVE_DATE,
RULE_DATA_STREAM_ID,
RULE_DATA_STREAM_CODE,
RULE_DATA_STREAM_NAME,
RULE_DATA_STREAM_DESC,
RULE_DATA_STREAM_PAR_TABLE,
ISS_TYP_ASSOC_ID,
QC_OBJECT_ID,
OBJECT_NAME,
QC_OBJ_ACTIVE_YN,
QC_SORT_ORDER,
ISS_TYPE_ID,
ISS_TYPE_NAME,
ISS_TYPE_COMMENT_TEMPLATE,
ISS_TYPE_DESC,
IND_FIELD_NAME,
APP_LINK_TEMPLATE,
ISS_SEVERITY_ID,
ISS_SEVERITY_CODE,
ISS_SEVERITY_NAME,
ISS_SEVERITY_DESC,
DATA_STREAM_ID,
DATA_STREAM_CODE,
DATA_STREAM_NAME,
DATA_STREAM_DESC,
DATA_STREAM_PAR_TABLE,
ISS_TYPE_ACTIVE_YN,
FORMAT_EVAL_DATE,
EVAL_DATE
FROM
(select
DVM_PTA_RULE_SETS_V.PTA_RULE_SET_ID,
DVM_PTA_RULE_SETS_V.PTA_ISS_ID,
DVM_PTA_RULE_SETS_V.RULE_SET_ID,
DVM_PTA_RULE_SETS_V.RULE_SET_ACTIVE_YN,
DVM_PTA_RULE_SETS_V.RULE_SET_CREATE_DATE,
DVM_PTA_RULE_SETS_V.FORMAT_RULE_SET_CREATE_DATE,
DVM_PTA_RULE_SETS_V.RULE_SET_INACTIVE_DATE,
DVM_PTA_RULE_SETS_V.FORMAT_RULE_SET_INACTIVE_DATE,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_ID,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_CODE,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_NAME,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_DESC,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_PAR_TABLE,
DVM_PTA_RULE_SETS_V.ISS_TYP_ASSOC_ID,
DVM_PTA_RULE_SETS_V.QC_OBJECT_ID,
DVM_PTA_RULE_SETS_V.OBJECT_NAME,
DVM_PTA_RULE_SETS_V.QC_OBJ_ACTIVE_YN,
DVM_PTA_RULE_SETS_V.QC_SORT_ORDER,
DVM_PTA_RULE_SETS_V.ISS_TYPE_ID,
DVM_PTA_RULE_SETS_V.ISS_TYPE_NAME,
DVM_PTA_RULE_SETS_V.ISS_TYPE_COMMENT_TEMPLATE,
DVM_PTA_RULE_SETS_V.ISS_TYPE_DESC,
DVM_PTA_RULE_SETS_V.IND_FIELD_NAME,
DVM_PTA_RULE_SETS_V.APP_LINK_TEMPLATE,
DVM_PTA_RULE_SETS_V.ISS_SEVERITY_ID,
DVM_PTA_RULE_SETS_V.ISS_SEVERITY_CODE,
DVM_PTA_RULE_SETS_V.ISS_SEVERITY_NAME,
DVM_PTA_RULE_SETS_V.ISS_SEVERITY_DESC,
DVM_PTA_RULE_SETS_V.DATA_STREAM_ID,
DVM_PTA_RULE_SETS_V.DATA_STREAM_CODE,
DVM_PTA_RULE_SETS_V.DATA_STREAM_NAME,
DVM_PTA_RULE_SETS_V.DATA_STREAM_DESC,
DVM_PTA_RULE_SETS_V.DATA_STREAM_PAR_TABLE,
DVM_PTA_RULE_SETS_V.ISS_TYPE_ACTIVE_YN,
DVM_PTA_RULE_SETS_HIST.H_NEW_DATA FORMAT_EVAL_DATE,
TO_DATE(DVM_PTA_RULE_SETS_HIST.H_NEW_DATA, 'MM/DD/YYYY HH24:MI:SS') EVAL_DATE
from DVM_PTA_RULE_SETS_V
INNER JOIN
DVM_PTA_RULE_SETS_HIST
ON DVM_PTA_RULE_SETS_V.PTA_RULE_SET_ID = DVM_PTA_RULE_SETS_HIST.PTA_RULE_SET_ID
AND DVM_PTA_RULE_SETS_HIST.H_TYPE_OF_CHANGE = 'UPDATE'
AND H_CHANGED_COLUMN = 'LAST_EVAL_DATE'
UNION ALL
select
DVM_PTA_RULE_SETS_V.PTA_RULE_SET_ID,
DVM_PTA_RULE_SETS_V.PTA_ISS_ID,
DVM_PTA_RULE_SETS_V.RULE_SET_ID,
DVM_PTA_RULE_SETS_V.RULE_SET_ACTIVE_YN,
DVM_PTA_RULE_SETS_V.RULE_SET_CREATE_DATE,
DVM_PTA_RULE_SETS_V.FORMAT_RULE_SET_CREATE_DATE,
DVM_PTA_RULE_SETS_V.RULE_SET_INACTIVE_DATE,
DVM_PTA_RULE_SETS_V.FORMAT_RULE_SET_INACTIVE_DATE,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_ID,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_CODE,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_NAME,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_DESC,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_PAR_TABLE,
DVM_PTA_RULE_SETS_V.ISS_TYP_ASSOC_ID,
DVM_PTA_RULE_SETS_V.QC_OBJECT_ID,
DVM_PTA_RULE_SETS_V.OBJECT_NAME,
DVM_PTA_RULE_SETS_V.QC_OBJ_ACTIVE_YN,
DVM_PTA_RULE_SETS_V.QC_SORT_ORDER,
DVM_PTA_RULE_SETS_V.ISS_TYPE_ID,
DVM_PTA_RULE_SETS_V.ISS_TYPE_NAME,
DVM_PTA_RULE_SETS_V.ISS_TYPE_COMMENT_TEMPLATE,
DVM_PTA_RULE_SETS_V.ISS_TYPE_DESC,
DVM_PTA_RULE_SETS_V.IND_FIELD_NAME,
DVM_PTA_RULE_SETS_V.APP_LINK_TEMPLATE,
DVM_PTA_RULE_SETS_V.ISS_SEVERITY_ID,
DVM_PTA_RULE_SETS_V.ISS_SEVERITY_CODE,
DVM_PTA_RULE_SETS_V.ISS_SEVERITY_NAME,
DVM_PTA_RULE_SETS_V.ISS_SEVERITY_DESC,
DVM_PTA_RULE_SETS_V.DATA_STREAM_ID,
DVM_PTA_RULE_SETS_V.DATA_STREAM_CODE,
DVM_PTA_RULE_SETS_V.DATA_STREAM_NAME,
DVM_PTA_RULE_SETS_V.DATA_STREAM_DESC,
DVM_PTA_RULE_SETS_V.DATA_STREAM_PAR_TABLE,
DVM_PTA_RULE_SETS_V.ISS_TYPE_ACTIVE_YN,
TO_CHAR(DVM_PTA_RULE_SETS_V.FIRST_EVAL_DATE, 'MM/DD/YYYY HH24:MI:SS') FORMAT_EVAL_DATE,
DVM_PTA_RULE_SETS_V.FIRST_EVAL_DATE EVAL_DATE
FROM
DVM_PTA_RULE_SETS_V)
ORDER BY PTA_ISS_ID, DATA_STREAM_CODE, EVAL_DATE, ISS_SEVERITY_CODE, ISS_TYPE_NAME;

COMMENT ON TABLE DVM_PTA_RULE_SETS_HIST_V IS 'DVM PTA Validation Rule Evaluation History (View)

This view returns PTA rule sets and associated validation rule sets and corresponding specific validation rules and data stream information for each date/time the DVM was processed (EVAL_DATE) on a given parent record.  This standard detailed report query can be combined with data set-specific information to generate a standard detailed DVM evaluation report that can be included with the data set metadata or as an internal report to provide information about each time the DVM was evaluated for which specific validation rules on a given parent record for each data stream if that level of detail is desired';

COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.PTA_RULE_SET_ID IS 'The primary key field for the DVM_PTA_RULE_SETS table';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.PTA_ISS_ID IS 'Foreign key reference to the PTA Issue record associated validation rule set (DVM_PTA_ISSUES)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).  Only one rule set can be active at any given time';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.RULE_SET_CREATE_DATE IS 'The date/time that the given rule set was created';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.RULE_SET_INACTIVE_DATE IS 'The date/time that the given rule set was deactivated (due to a change in active rules)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.RULE_DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the rule set''s data stream for the given DVM rule set';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.RULE_DATA_STREAM_CODE IS 'The code for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.RULE_DATA_STREAM_NAME IS 'The name for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.RULE_DATA_STREAM_DESC IS 'The description for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.RULE_DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name for the given validation rule set (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.ISS_TYP_ASSOC_ID IS 'Primary Key for the DVM_ISS_TYP_ASSOC table';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.QC_OBJECT_ID IS 'The Data QC Object that the issue type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB issue)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.ISS_TYPE_ID IS 'The issue type for the given issue';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.ISS_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.ISS_TYPE_COMMENT_TEMPLATE IS 'The template for the specific issue description that exists in the specific issue condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.ISS_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current issue type has been identified.  A ''Y'' value indicates that the given issue condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current issue type';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.APP_LINK_TEMPLATE IS 'The template for the specific application link to resolve the given data issue.  This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the APP_ID and APP_SESSION at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.ISS_SEVERITY_ID IS 'The Severity of the given issue type criteria.  These indicate the status of the given issue (e.g. warnings, data issues, violations of law, etc.)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.ISS_SEVERITY_CODE IS 'The code for the given issue severity';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.ISS_SEVERITY_NAME IS 'The name for the given issue severity';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.ISS_SEVERITY_DESC IS 'The description for the given issue severity';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the issue type''s data stream for the given DVM rule set';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.DATA_STREAM_CODE IS 'The code for the given issue type''s data stream';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.DATA_STREAM_NAME IS 'The name for the given issue type''s data stream';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.DATA_STREAM_DESC IS 'The description for the given issue type''s data stream';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.ISS_TYPE_ACTIVE_YN IS 'Flag to indicate if the given issue type criteria is active';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.FORMAT_EVAL_DATE IS 'The formatted date/time the given parent record was evaluated using the DVM for the associated data stream (in MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_V.EVAL_DATE IS 'The date/time the given parent record was evaluated using the DVM for the associated data stream';


CREATE OR REPLACE VIEW
DVM_PTA_RULE_SETS_HIST_RPT_V
AS


select
DVM_PTA_RULE_SETS_HIST_V.PTA_RULE_SET_ID,
DVM_PTA_RULE_SETS_HIST_V.PTA_ISS_ID,
DVM_PTA_RULE_SETS_HIST_V.RULE_SET_ID,
DVM_PTA_RULE_SETS_HIST_V.RULE_SET_ACTIVE_YN,
DVM_PTA_RULE_SETS_HIST_V.RULE_SET_CREATE_DATE,
DVM_PTA_RULE_SETS_HIST_V.FORMAT_RULE_SET_CREATE_DATE,
DVM_PTA_RULE_SETS_HIST_V.RULE_SET_INACTIVE_DATE,
DVM_PTA_RULE_SETS_HIST_V.FORMAT_RULE_SET_INACTIVE_DATE,
DVM_PTA_RULE_SETS_HIST_V.RULE_DATA_STREAM_CODE,
DVM_PTA_RULE_SETS_HIST_V.RULE_DATA_STREAM_NAME,
DVM_PTA_RULE_SETS_HIST_V.ISS_TYPE_NAME,
DVM_PTA_RULE_SETS_HIST_V.ISS_TYPE_DESC,
DVM_PTA_RULE_SETS_HIST_V.ISS_SEVERITY_CODE,
DVM_PTA_RULE_SETS_HIST_V.ISS_SEVERITY_NAME,
DVM_PTA_RULE_SETS_HIST_V.FORMAT_EVAL_DATE,
DVM_PTA_RULE_SETS_HIST_V.EVAL_DATE
FROM
DVM_PTA_RULE_SETS_HIST_V
ORDER BY DVM_PTA_RULE_SETS_HIST_V.PTA_ISS_ID, DVM_PTA_RULE_SETS_HIST_V.DATA_STREAM_CODE, DVM_PTA_RULE_SETS_HIST_V.EVAL_DATE, DVM_PTA_RULE_SETS_HIST_V.ISS_SEVERITY_CODE, DVM_PTA_RULE_SETS_HIST_V.ISS_TYPE_NAME;

COMMENT ON TABLE DVM_PTA_RULE_SETS_HIST_RPT_V IS 'DVM PTA Validation Rule Evaluation History Report (View)

This view returns a subset of fields from the PTA rule sets and associated validation rule sets and corresponding specific validation rules and data stream information for each date/time the DVM was processed (EVAL_DATE) on a given parent record.  This standard detailed report query can be combined with data set-specific information to generate a standard detailed DVM evaluation report that can be included with the data set metadata or as an internal report to provide information about each time the DVM was evaluated for which specific validation rules on a given parent record for each data stream if that level of detail is desired';

COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_RPT_V.PTA_RULE_SET_ID IS 'The primary key field for the DVM_PTA_RULE_SETS table';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_RPT_V.PTA_ISS_ID IS 'Foreign key reference to the PTA Issue record associated validation rule set (DVM_PTA_ISSUES)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_RPT_V.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_RPT_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).  Only one rule set can be active at any given time';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_RPT_V.RULE_SET_CREATE_DATE IS 'The date/time that the given rule set was created';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_RPT_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_RPT_V.RULE_SET_INACTIVE_DATE IS 'The date/time that the given rule set was deactivated (due to a change in active rules)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_RPT_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_RPT_V.RULE_DATA_STREAM_CODE IS 'The code for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_RPT_V.RULE_DATA_STREAM_NAME IS 'The name for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_RPT_V.ISS_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_RPT_V.ISS_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_RPT_V.ISS_SEVERITY_CODE IS 'The code for the given issue severity';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_RPT_V.ISS_SEVERITY_NAME IS 'The name for the given issue severity';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_RPT_V.FORMAT_EVAL_DATE IS 'The formatted date/time the given parent record was evaluated using the DVM for the associated data stream (in MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_HIST_RPT_V.EVAL_DATE IS 'The date/time the given parent record was evaluated using the DVM for the associated data stream';










--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Data Validation Module', '0.11', TO_DATE('24-JUL-20', 'DD-MON-YY'), 'Implemented the data history package on the DVM_PTA_RULE_SETS table to allow the validation rule evaluations to be tracked over time.  The DVM_PTA_RULE_SETS_RPT_V view was modified to remove two unnecssary fields for the report query.  A new DVM_DS_PTA_RULE_SETS_HIST_V view was developed to query the update history for the DVM_PTA_RULE_SETS table and combine it with the execution information to provide users with a complete history of DVM evaluations for a given parent record for each data stream for auditing/documentation purposes.  A new DVM_PTA_RULE_SETS_HIST_V view as developed to return the validation rule sets and corresponding specific validation rules and data stream information for each date/time the DVM was processed (EVAL_DATE) on a given parent record.  A new DVM_PTA_RULE_SETS_HIST_RPT_V view was developed to retrieve a subset of the fields in DVM_PTA_RULE_SETS_HIST_V for reporting purposes.');

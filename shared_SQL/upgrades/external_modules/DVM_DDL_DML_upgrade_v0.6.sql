--------------------------------------------------------
--------------------------------------------------------
--Database Name: Data Validation Module
--Database Description: This module was developed to perform systematic data quality control (QC) on a given set of data tables so the data issues can be stored in a single table and easily reviewed to identify and resolve/annotate data issues
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--version 0.6 updates:
--------------------------------------------------------

--renamed DVM_ERR_RES_TYPES table to DVM_ISS_RES_TYPES:

ALTER TABLE DVM_ERR_RES_TYPES
RENAME TO DVM_ISS_RES_TYPES;

ALTER TABLE DVM_ISS_RES_TYPES RENAME COLUMN ERR_RES_TYPE_ID TO ISS_RES_TYPE_ID;

ALTER TABLE DVM_ISS_RES_TYPES RENAME COLUMN ERR_RES_TYPE_CODE TO ISS_RES_TYPE_CODE;

ALTER TABLE DVM_ISS_RES_TYPES RENAME COLUMN ERR_RES_TYPE_NAME TO ISS_RES_TYPE_NAME;

ALTER TABLE DVM_ISS_RES_TYPES RENAME COLUMN ERR_RES_TYPE_DESC TO ISS_RES_TYPE_DESC;

ALTER INDEX DVM_ERR_RES_TYPES_PK
RENAME TO DVM_ISS_RES_TYPES_PK;

ALTER INDEX DVM_ERR_RES_TYPES_U1
RENAME TO DVM_ISS_RES_TYPES_U1;

ALTER INDEX DVM_ERR_RES_TYPES_U2
RENAME TO DVM_ISS_RES_TYPES_U2;

ALTER TABLE DVM_ISS_RES_TYPES
RENAME CONSTRAINT DVM_ERR_RES_TYPES_PK TO DVM_ISS_RES_TYPES_PK;

ALTER TABLE DVM_ISS_RES_TYPES
RENAME CONSTRAINT DVM_ERR_RES_TYPES_U1 TO DVM_ISS_RES_TYPES_U1;

ALTER TABLE DVM_ISS_RES_TYPES
RENAME CONSTRAINT DVM_ERR_RES_TYPES_U2 TO DVM_ISS_RES_TYPES_U2;

COMMENT ON TABLE DVM_ISS_RES_TYPES IS 'Issue Resolution Types

This is a reference table that defines all issue resolutions types that will be used to define the status of a given QC data validation issue.  When an issue is marked as resolved it will have an annotation to explain the resolution of the issue.  The types of issue resolutions include no data available, manually reviewed and accepted, no resolution can be reached yet.  Certain issue resolutions types will cause an issue to be filtered out from the standard issue reports.';

COMMENT ON COLUMN DVM_ISS_RES_TYPES.ISS_RES_TYPE_ID IS 'Primary Key for the DVM_ISS_RES_TYPES table';

COMMENT ON COLUMN DVM_ISS_RES_TYPES.ISS_RES_TYPE_CODE IS 'The Issue Resolution Type code';

COMMENT ON COLUMN DVM_ISS_RES_TYPES.ISS_RES_TYPE_NAME IS 'The Issue Resolution Type name';

COMMENT ON COLUMN DVM_ISS_RES_TYPES.ISS_RES_TYPE_DESC IS 'The Issue Resolution Type description';



--renamed DVM_ISS_SEVERITY table to DVM_ISS_SEVERITY:


ALTER TABLE DVM_ERR_SEVERITY
RENAME TO DVM_ISS_SEVERITY;

ALTER TABLE DVM_ISS_SEVERITY RENAME COLUMN ERR_SEVERITY_ID TO ISS_SEVERITY_ID;

ALTER TABLE DVM_ISS_SEVERITY RENAME COLUMN ERR_SEVERITY_CODE TO ISS_SEVERITY_CODE;

ALTER TABLE DVM_ISS_SEVERITY RENAME COLUMN ERR_SEVERITY_NAME TO ISS_SEVERITY_NAME;

ALTER TABLE DVM_ISS_SEVERITY RENAME COLUMN ERR_SEVERITY_DESC TO ISS_SEVERITY_DESC;

ALTER INDEX DVM_ERR_SEVERITY_PK
RENAME TO DVM_ISS_SEVERITY_PK;

ALTER INDEX DVM_ERR_SEVERITY_U1
RENAME TO DVM_ISS_SEVERITY_U1;

ALTER INDEX DVM_ERR_SEVERITY_U2
RENAME TO DVM_ISS_SEVERITY_U2;

ALTER TABLE DVM_ISS_SEVERITY
RENAME CONSTRAINT DVM_ERR_SEVERITY_PK TO DVM_ISS_SEVERITY_PK;

ALTER TABLE DVM_ISS_SEVERITY
RENAME CONSTRAINT DVM_ERR_SEVERITY_U1 TO DVM_ISS_SEVERITY_U1;

ALTER TABLE DVM_ISS_SEVERITY
RENAME CONSTRAINT DVM_ERR_SEVERITY_U2 TO DVM_ISS_SEVERITY_U2;

COMMENT ON TABLE DVM_ISS_SEVERITY IS 'Issue Severity

This is a reference table that defines all issue severities for issue type definition.  This indicates the status of the given issue type criteria (e.g. warnings, data errors, violations of law, etc.)';

COMMENT ON COLUMN DVM_ISS_SEVERITY.ISS_SEVERITY_ID IS 'Primary Key for the DVM_ISS_SEVERITY table';

COMMENT ON COLUMN DVM_ISS_SEVERITY.ISS_SEVERITY_CODE IS 'The code for the given issue severity';

COMMENT ON COLUMN DVM_ISS_SEVERITY.ISS_SEVERITY_NAME IS 'The name for the given issue severity';

COMMENT ON COLUMN DVM_ISS_SEVERITY.ISS_SEVERITY_DESC IS 'The description for the given issue severity';

--renamed DVM_ERROR_TYPES table to DVM_ISS_TYPES:


ALTER TABLE DVM_ERROR_TYPES
RENAME TO DVM_ISS_TYPES;

ALTER TABLE DVM_ISS_TYPES RENAME COLUMN ERROR_TYPE_ID TO ISS_TYPE_ID;

ALTER TABLE DVM_ISS_TYPES RENAME COLUMN ERR_TYPE_NAME TO ISS_TYPE_NAME;

ALTER TABLE DVM_ISS_TYPES RENAME COLUMN ERR_TYPE_DESC TO ISS_TYPE_DESC;

ALTER TABLE DVM_ISS_TYPES RENAME COLUMN ERR_SEVERITY_ID TO ISS_SEVERITY_ID;

ALTER TABLE DVM_ISS_TYPES RENAME COLUMN ERR_TYPE_ACTIVE_YN TO ISS_TYPE_ACTIVE_YN;

ALTER TABLE DVM_ISS_TYPES RENAME COLUMN ERR_TYPE_COMMENT_TEMPLATE TO ISS_TYPE_COMMENT_TEMPLATE;

ALTER INDEX DVM_ERROR_TYPES_I1
RENAME TO DVM_ISS_TYPES_I1;

ALTER INDEX DVM_ERROR_TYPES_I2
RENAME TO DVM_ISS_TYPES_I2;

ALTER INDEX DVM_ERROR_TYPES_I3
RENAME TO DVM_ISS_TYPES_I3;

ALTER INDEX DVM_ERROR_TYPES_PK
RENAME TO DVM_ISS_TYPES_PK;

ALTER INDEX DVM_ERROR_TYPES_U1
RENAME TO DVM_ISS_TYPES_U1;

ALTER TABLE DVM_ISS_TYPES
RENAME CONSTRAINT DVM_ERROR_TYPES_PK TO DVM_ISS_TYPES_PK;

ALTER TABLE DVM_ISS_TYPES
RENAME CONSTRAINT DVM_ERROR_TYPES_U1 TO DVM_ISS_TYPES_U1;

ALTER TABLE DVM_ISS_TYPES
RENAME CONSTRAINT DVM_ERROR_TYPES_FK1 TO DVM_ISS_TYPES_FK1;

ALTER TABLE DVM_ISS_TYPES
RENAME CONSTRAINT DVM_ERROR_TYPES_FK2 TO DVM_ISS_TYPES_FK2;

ALTER TABLE DVM_ISS_TYPES
RENAME CONSTRAINT DVM_ERROR_TYPES_FK3 TO DVM_ISS_TYPES_FK3;

COMMENT ON TABLE DVM_ISS_TYPES IS 'Data Issue Types

This is a reference table that defines the different QC Data Issue Types that indicate how to identify QC issues and report them to end-users for resolution.  Each Data Issue will have a corresponding Data Issue Type.';

COMMENT ON COLUMN DVM_ISS_TYPES.ISS_TYPE_ID IS 'Primary Key for the DVM_ISS_TYPES table';

COMMENT ON COLUMN DVM_ISS_TYPES.QC_OBJECT_ID IS 'The Data QC Object that the issue type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';

COMMENT ON COLUMN DVM_ISS_TYPES.ISS_TYPE_DESC IS 'The description for the given QC validation issue type';

COMMENT ON COLUMN DVM_ISS_TYPES.ISS_SEVERITY_ID IS 'The Severity of the given issue type criteria.  These indicate the status of the given issue (e.g. warnings, data errors, violations of law, etc.)';

COMMENT ON COLUMN DVM_ISS_TYPES.DATA_STREAM_ID IS 'The Category for the given issue type criteria.  This is used to filter validation issue criteria based on the given context of the validation (e.g. eTunaLog XML data import, tracking QC, etc.)';

COMMENT ON COLUMN DVM_ISS_TYPES.ISS_TYPE_ACTIVE_YN IS 'Flag to indicate if the given issue type criteria is active';

COMMENT ON COLUMN DVM_ISS_TYPES.ISS_TYPE_COMMENT_TEMPLATE IS 'The template for the specific issue description that exists in the specific validation issue condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when QC_OBJECT_ID is NULL';



--renamed DVM_ERRORS table to DVM_ISSUES:

ALTER TABLE DVM_ERRORS
RENAME TO DVM_ISSUES;

ALTER TABLE DVM_ISSUES RENAME COLUMN ERROR_ID TO ISS_ID;

ALTER TABLE DVM_ISSUES RENAME COLUMN PTA_ERROR_ID TO PTA_ISS_ID;

ALTER TABLE DVM_ISSUES RENAME COLUMN ERROR_TYPE_ID TO ISS_TYPE_ID;

ALTER TABLE DVM_ISSUES RENAME COLUMN ERROR_NOTES TO ISS_NOTES;

ALTER TABLE DVM_ISSUES RENAME COLUMN ERR_RES_TYPE_ID TO ISS_RES_TYPE_ID;

ALTER TABLE DVM_ISSUES RENAME COLUMN ERROR_DESCRIPTION TO ISS_DESC;

ALTER INDEX DVM_ERRORS_I1
RENAME TO DVM_ISSUES_I1;

ALTER INDEX DVM_ERRORS_I2
RENAME TO DVM_ISSUES_I2;

ALTER INDEX DVM_ERRORS_I3
RENAME TO DVM_ISSUES_I3;

ALTER INDEX DVM_ERRORS_PK
RENAME TO DVM_ISSUES_PK;

ALTER TABLE DVM_ISSUES
RENAME CONSTRAINT DVM_ERRORS_PK TO DVM_ISSUES_PK;

ALTER TABLE DVM_ISSUES
RENAME CONSTRAINT DVM_ERRORS_FK1 TO DVM_ISSUES_FK1;

ALTER TABLE DVM_ISSUES
RENAME CONSTRAINT DVM_ERRORS_FK2 TO DVM_ISSUES_FK2;

ALTER TABLE DVM_ISSUES
RENAME CONSTRAINT DVM_ERRORS_FK3 TO DVM_ISS_FK3;

COMMENT ON TABLE DVM_ISSUES IS 'Data Validation Issues

This is an issue table that represents any specific data validation issue instances that a given data table/entity contains (e.g. SPT_VESSEL_TRIPS, SPT_UL_TRANSACTIONS, SPT_APP_XML_FILES, etc.).  These records will be used to communicate issues to the data entry and data management staff';

COMMENT ON COLUMN DVM_ISSUES.ISS_ID IS 'Primary Key for the DVM_ISSUES table';

COMMENT ON COLUMN DVM_ISSUES.PTA_ISS_ID IS 'The PTA Issue record the issue corresponds to, this indicates which parent record for the given data stream the issues are associated with';

COMMENT ON COLUMN DVM_ISSUES.ISS_TYPE_ID IS 'The Issue Type for the given issue';

COMMENT ON COLUMN DVM_ISSUES.ISS_NOTES IS 'Manually entered notes for the corresponding data issue';

COMMENT ON COLUMN DVM_ISSUES.ISS_RES_TYPE_ID IS 'Foreign key reference to the Issue Resolution Types reference table.  A non-null value indicates that the given issue is inactive and has been resolved/will be resolved';

COMMENT ON COLUMN DVM_ISSUES.ISS_DESC IS 'The description of the given validation issue';

COMMENT ON COLUMN DVM_ISSUES.APP_LINK_URL IS 'The generated specific application link URL to resolve the given data issue.  This is generated at runtime of the DVM based on the values returned by the corresponding QC query and by the related DVM_ISS_TYPES record''s APP_LINK_TEMPLATE value';



--rename table from DVM_PTA_ERRORS to DVM_PTA_ISSUES
ALTER TABLE DVM_PTA_ERRORS
RENAME TO DVM_PTA_ISSUES;

ALTER TABLE DVM_PTA_ISSUES RENAME COLUMN PTA_ERROR_ID TO PTA_ISS_ID;

ALTER INDEX DVM_PTA_ERRORS_PK
RENAME TO DVM_PTA_ISSUES_PK;

ALTER TABLE DVM_PTA_ISSUES
RENAME CONSTRAINT DVM_PTA_ERRORS_PK TO DVM_PTA_ISSUES_PK;

COMMENT ON TABLE DVM_PTA_ISSUES IS 'Issue Parent Record (PTA)

This table represents a generalized intersection table that allows multiple Issue and Validation Rule Sets records to reference this consolidated table that allows multiple Issues and Issue Types to be associated with the given parent table record (e.g. SPT_VESSEL_TRIPS, SPT_UL_TRANSACTIONS, SPT_CANN_TRANSACTIONS, etc.).';

COMMENT ON COLUMN DVM_PTA_ISSUES.PTA_ISS_ID IS 'Primary Key for the DVM_PTA_ISSUES table';




--Update DVM_PTA_RULE_SETS to change ERROR to ISS:
ALTER TABLE DVM_PTA_RULE_SETS RENAME COLUMN PTA_ERROR_ID TO PTA_ISS_ID;

COMMENT ON TABLE DVM_PTA_RULE_SETS IS 'DVM PTA Rule Sets

This table defines the relationship between validation rule sets (DVM_RULE_SETS) and the individual PTA parent issue record (DVM_PTA_ISSUES) that is associated with a given parent record.  This table is used to track which rule sets were used to evaluate which parent records.';

COMMENT ON COLUMN DVM_PTA_RULE_SETS.PTA_ISS_ID IS 'Foreign key reference to the PTA Issue record associated validation rule set (DVM_PTA_ISSUES)';

COMMENT ON COLUMN DVM_PTA_RULE_SETS.FIRST_EVAL_DATE IS 'The date/time the rule set was first evaluated for the given parent issue record';

COMMENT ON COLUMN DVM_PTA_RULE_SETS.LAST_EVAL_DATE IS 'The date/time the rule set was most recently evaluated for the given parent issue record';




COMMENT ON COLUMN DVM_QC_OBJECTS.QC_OBJECT_ID IS 'Primary Key for the DVM_QC_OBJECTS table';




ALTER TABLE DVM_ISS_TYP_ASSOC RENAME COLUMN ERROR_TYPE_ID TO ISS_TYPE_ID;

COMMENT ON COLUMN DVM_ISS_TYP_ASSOC.ISS_TYPE_ID IS 'Foreign key reference to the Data Issue Types table that indicates a given Data Issue Type was active for a given data table (depends on related Issue Data Category) at the time it was added to the database';




--update sequences and sequence names while maintaining the current values:


set serveroutput on;
DECLARE

	v_temp_SQL VARCHAR2(2000);

BEGIN

v_temp_SQL := 'DROP SEQUENCE DVM_ERRORS_SEQ';
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);
EXECUTE IMMEDIATE v_temp_SQL;


v_temp_SQL := 'SELECT ''CREATE SEQUENCE DVM_ISSUES_SEQ NOCACHE INCREMENT BY 1 START WITH ''||(dest_max_id + 1) from (select nvl(max(dest.ISS_ID), 0) dest_max_id from DVM_ISSUES dest)';
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

EXECUTE IMMEDIATE v_temp_SQL into v_temp_SQL;
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

--create the new sequence:
EXECUTE IMMEDIATE v_temp_SQL;



v_temp_SQL := 'DROP SEQUENCE DVM_ERROR_TYPES_SEQ';
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);
EXECUTE IMMEDIATE v_temp_SQL;


v_temp_SQL := 'SELECT ''CREATE SEQUENCE DVM_ISS_TYPES_SEQ NOCACHE INCREMENT BY 1 START WITH ''||(dest_max_id + 1) from (select nvl(max(dest.ISS_TYPE_ID), 0) dest_max_id from DVM_ISS_TYPES dest)';
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

EXECUTE IMMEDIATE v_temp_SQL into v_temp_SQL;
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

--create the new sequence:
EXECUTE IMMEDIATE v_temp_SQL;



v_temp_SQL := 'DROP SEQUENCE DVM_ERR_RES_TYPES_SEQ';
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);
EXECUTE IMMEDIATE v_temp_SQL;


v_temp_SQL := 'SELECT ''CREATE SEQUENCE DVM_ISS_RES_TYPES_SEQ NOCACHE INCREMENT BY 1 START WITH ''||(dest_max_id + 1) from (select nvl(max(dest.ISS_RES_TYPE_ID), 0) dest_max_id from DVM_ISS_RES_TYPES dest)';
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

EXECUTE IMMEDIATE v_temp_SQL into v_temp_SQL;
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

--create the new sequence:
EXECUTE IMMEDIATE v_temp_SQL;




v_temp_SQL := 'DROP SEQUENCE DVM_ERR_SEVERITY_SEQ';
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);
EXECUTE IMMEDIATE v_temp_SQL;


v_temp_SQL := 'SELECT ''CREATE SEQUENCE DVM_ISS_SEVERITY_SEQ NOCACHE INCREMENT BY 1 START WITH ''||(dest_max_id + 1) from (select nvl(max(dest.ISS_SEVERITY_ID), 0) dest_max_id from DVM_ISS_SEVERITY dest)';
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

EXECUTE IMMEDIATE v_temp_SQL into v_temp_SQL;
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

--create the new sequence:
EXECUTE IMMEDIATE v_temp_SQL;




v_temp_SQL := 'DROP SEQUENCE DVM_PTA_ERRORS_SEQ';
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);
EXECUTE IMMEDIATE v_temp_SQL;


v_temp_SQL := 'SELECT ''CREATE SEQUENCE DVM_PTA_ISSUES_SEQ NOCACHE INCREMENT BY 1 START WITH ''||(dest_max_id + 1) from (select nvl(max(dest.PTA_ISS_ID), 0) dest_max_id from DVM_PTA_ISSUES dest)';
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

EXECUTE IMMEDIATE v_temp_SQL into v_temp_SQL;
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

--create the new sequence:
EXECUTE IMMEDIATE v_temp_SQL;


END;
/





--drop old triggers:
drop trigger DVM_ERR_RES_TYPES_AUTO_BRI;
drop trigger DVM_ERR_RES_TYPES_AUTO_BRU;
drop trigger DVM_ERR_SEVERITY_AUTO_BRI;
drop trigger DVM_ERR_SEVERITY_AUTO_BRU;
drop trigger DVM_ERROR_TYPES_AUTO_BRI;
drop trigger DVM_ERROR_TYPES_AUTO_BRU;
drop trigger DVM_ERRORS_AUTO_BRI;
drop trigger DVM_ERRORS_AUTO_BRU;
drop trigger DVM_PTA_ERRORS_AUTO_BRI;






--replace with the new triggers with the updated sequence/table names:
create or replace TRIGGER DVM_ISSUES_AUTO_BRI
before insert on DVM_ISSUES
for each row
begin
  select DVM_ISSUES_SEQ.nextval into :new.ISS_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER DVM_ISSUES_AUTO_BRU BEFORE
  UPDATE
    ON DVM_ISSUES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

create or replace TRIGGER DVM_ISS_RES_TYPES_AUTO_BRI
before insert on DVM_ISS_RES_TYPES
for each row
begin
  select DVM_ISS_RES_TYPES_SEQ.nextval into :new.ISS_RES_TYPE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER DVM_ISS_RES_TYPES_AUTO_BRU BEFORE
  UPDATE
    ON DVM_ISS_RES_TYPES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

create or replace TRIGGER DVM_ISS_SEVERITY_AUTO_BRI
before insert on DVM_ISS_SEVERITY
for each row
begin
  select DVM_ISS_SEVERITY_SEQ.nextval into :new.ISS_SEVERITY_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER DVM_ISS_SEVERITY_AUTO_BRU BEFORE
  UPDATE
    ON DVM_ISS_SEVERITY FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

create or replace TRIGGER DVM_ISS_TYPES_AUTO_BRI
before insert on DVM_ISS_TYPES
for each row
begin
  select DVM_ISS_TYPES_SEQ.nextval into :new.ISS_TYPE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER DVM_ISS_TYPES_AUTO_BRU BEFORE
  UPDATE
    ON DVM_ISS_TYPES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

create or replace TRIGGER
DVM_PTA_ISSUES_AUTO_BRI
before insert on DVM_PTA_ISSUES
for each row
begin
  select DVM_PTA_ISSUES_SEQ.nextval into :new.PTA_ISS_ID from dual;
end;
/



ALTER TABLE DVM_ERR_RES_TYPES_HIST
RENAME TO DVM_ISS_RES_TYPES_HIST;

ALTER TABLE DVM_ISS_RES_TYPES_HIST RENAME COLUMN ERR_RES_TYPE_ID TO ISS_RES_TYPE_ID;

COMMENT ON TABLE DVM_ISS_RES_TYPES_HIST IS 'Issue Resolution Types (history table)

This history table was implemented using the data history tracking package (svn://badfish.pifsc.gov/Oracle/DSC/trunk/apps/db/dsc/dsc_pkgs) to track changes to the Issue Resolution Types (DVM_ISS_RES_TYPES) table';



ALTER TABLE DVM_ERR_SEVERITY_HIST
RENAME TO DVM_ISS_SEVERITY_HIST;

ALTER TABLE DVM_ISS_SEVERITY_HIST RENAME COLUMN ERR_SEVERITY_ID TO ISS_SEVERITY_ID;

COMMENT ON TABLE DVM_ISS_SEVERITY_HIST IS 'Issue Severity (history table)

This history table was implemented using the data history tracking package (svn://badfish.pifsc.gov/Oracle/DSC/trunk/apps/db/dsc/dsc_pkgs) to track changes to the Issue Severity (DVM_ISS_RES_TYPES) table';



ALTER TABLE DVM_ERROR_TYPES_HIST
RENAME TO DVM_ISS_TYPES_HIST;

ALTER TABLE DVM_ISS_TYPES_HIST RENAME COLUMN ERROR_TYPE_ID TO ISS_TYPE_ID;

COMMENT ON TABLE DVM_ISS_TYPES_HIST IS 'Data Issue Types (history table)

This history table was implemented using the data history tracking package (svn://badfish.pifsc.gov/Oracle/DSC/trunk/apps/db/dsc/dsc_pkgs) to track changes to the Issue Types (DVM_ISS_TYPES) table';


ALTER TABLE DVM_ERRORS_HIST
RENAME TO DVM_ISSUES_HIST;

ALTER TABLE DVM_ISSUES_HIST RENAME COLUMN ERROR_ID TO ISS_ID;

COMMENT ON TABLE DVM_ISSUES_HIST IS 'Data Issues (history table)

This history table was implemented using the data history tracking package (svn://badfish.pifsc.gov/Oracle/DSC/trunk/apps/db/dsc/dsc_pkgs) to track changes to the Data Issues  (DVM_ISSUES) table';



drop trigger TRG_DVM_ERR_RES_TYPES_HIST;
drop trigger TRG_DVM_ERR_SEVERITY_HIST;
drop trigger TRG_DVM_ERROR_TYPES_HIST;
drop trigger TRG_DVM_ERRORS_HIST;







--redo the sequences for the modified history tables:

drop sequence DVM_ERR_RES_TYPES_HIST_SEQ;
drop sequence DVM_ERR_SEVERITY_HIST_SEQ;
drop sequence DVM_ERROR_TYPES_HIST_SEQ;
drop sequence DVM_ERRORS_HIST_SEQ;





--update sequences and sequence names while maintaining the current values:


set serveroutput on;
DECLARE

	v_temp_SQL VARCHAR2(2000);

BEGIN

--DVM_ISS_RES_TYPES_HIST_SEQ sequence update
v_temp_SQL := 'SELECT ''CREATE SEQUENCE DVM_ISS_RES_TYPES_HIST_SEQ NOCACHE INCREMENT BY 1 START WITH ''||(dest_max_id + 1) from (select nvl(max(dest.h_seqnum), 0) dest_max_id from DVM_ISS_RES_TYPES_HIST dest)';
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

EXECUTE IMMEDIATE v_temp_SQL into v_temp_SQL;
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

--create the new sequence:
EXECUTE IMMEDIATE v_temp_SQL;




--DVM_ISS_SEVERITY_HIST_SEQ sequence update
v_temp_SQL := 'SELECT ''CREATE SEQUENCE DVM_ISS_SEVERITY_HIST_SEQ NOCACHE INCREMENT BY 1 START WITH ''||(dest_max_id + 1) from (select nvl(max(dest.h_seqnum), 0) dest_max_id from DVM_ISS_SEVERITY_HIST dest)';
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

EXECUTE IMMEDIATE v_temp_SQL into v_temp_SQL;
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

--create the new sequence:
EXECUTE IMMEDIATE v_temp_SQL;



--DVM_ISS_TYPES_HIST_SEQ sequence update
v_temp_SQL := 'SELECT ''CREATE SEQUENCE DVM_ISS_TYPES_HIST_SEQ NOCACHE INCREMENT BY 1 START WITH ''||(dest_max_id + 1) from (select nvl(max(dest.h_seqnum), 0) dest_max_id from DVM_ISS_TYPES_HIST dest)';
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

EXECUTE IMMEDIATE v_temp_SQL into v_temp_SQL;
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

--create the new sequence:
EXECUTE IMMEDIATE v_temp_SQL;





--DVM_ISSUES_HIST_SEQ sequence update
v_temp_SQL := 'SELECT ''CREATE SEQUENCE DVM_ISSUES_HIST_SEQ NOCACHE INCREMENT BY 1 START WITH ''||(dest_max_id + 1) from (select nvl(max(dest.h_seqnum), 0) dest_max_id from DVM_ISSUES_HIST dest)';
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

EXECUTE IMMEDIATE v_temp_SQL into v_temp_SQL;
dbms_output.put_line('the value of v_temp_SQL is: '||v_temp_SQL);

--create the new sequence:
EXECUTE IMMEDIATE v_temp_SQL;

END;
/





--redo history triggers based on the table names

create or replace TRIGGER "TRG_DVM_ISS_RES_TYPES_HIST"
AFTER DELETE OR INSERT OR UPDATE
ON "DVM_ISS_RES_TYPES"
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
    INSERT INTO DVM_ISS_RES_TYPES_hist (
      h_seqnum, iss_RES_TYPE_ID, h_type_of_change, h_user_making_change, h_os_user,
      h_date_of_change, h_changed_column, h_old_data, h_new_data)
    VALUES(
      DVM_ISS_RES_TYPES_hist_seq.NEXTVAL, :old.iss_RES_TYPE_ID, p_type_of_change, user, os_user,      SYSDATE, p_changed_column, p_old_data, p_new_data);
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
    INSERT INTO DVM_iss_RES_TYPES_hist (
      h_seqnum, iss_RES_TYPE_ID, h_type_of_change, h_user_making_change, h_os_user, h_date_of_change)
    VALUES (
      DVM_iss_RES_TYPES_hist_seq.NEXTVAL, :new.iss_RES_TYPE_ID,
      'INSERT', user, os_user, SYSDATE);
  ELSIF DELETING THEN
    insert_data('DELETE');
    insert_data('DELETE', 'iss_res_type_code', :old.iss_res_type_code);
    insert_data('DELETE', 'iss_res_type_name', :old.iss_res_type_name);
    insert_data('DELETE', 'iss_res_type_desc', :old.iss_res_type_desc);
  ELSE
    check_update('iss_RES_TYPE_CODE', :old.iss_res_type_code, :new.iss_res_type_code);
    check_update('iss_RES_TYPE_NAME', :old.iss_res_type_name, :new.iss_res_type_name);
    check_update('iss_RES_TYPE_DESC', :old.iss_res_type_desc, :new.iss_res_type_desc);
  END IF;
END;
/


create or replace TRIGGER "TRG_DVM_ISS_SEVERITY_HIST"
AFTER DELETE OR INSERT OR UPDATE
ON "DVM_ISS_SEVERITY"
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
    INSERT INTO DVM_iss_SEVERITY_hist (
      h_seqnum, iss_SEVERITY_ID, h_type_of_change, h_user_making_change, h_os_user,
      h_date_of_change, h_changed_column, h_old_data, h_new_data)
    VALUES(
      DVM_iss_SEVERITY_hist_seq.NEXTVAL, :old.iss_SEVERITY_ID, p_type_of_change, user, os_user,      SYSDATE, p_changed_column, p_old_data, p_new_data);
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
    INSERT INTO DVM_iss_SEVERITY_hist (
      h_seqnum, iss_SEVERITY_ID, h_type_of_change, h_user_making_change, h_os_user, h_date_of_change)
    VALUES (
      DVM_iss_SEVERITY_hist_seq.NEXTVAL, :new.iss_SEVERITY_ID,
      'INSERT', user, os_user, SYSDATE);
  ELSIF DELETING THEN
    insert_data('DELETE');
    insert_data('DELETE', 'iss_severity_code', :old.iss_severity_code);
    insert_data('DELETE', 'iss_severity_name', :old.iss_severity_name);
    insert_data('DELETE', 'iss_severity_desc', :old.iss_severity_desc);
  ELSE
    check_update('iss_SEVERITY_CODE', :old.iss_severity_code, :new.iss_severity_code);
    check_update('iss_SEVERITY_NAME', :old.iss_severity_name, :new.iss_severity_name);
    check_update('iss_SEVERITY_DESC', :old.iss_severity_desc, :new.iss_severity_desc);
  END IF;
END;
/



create or replace TRIGGER "TRG_DVM_ISS_TYPES_HIST"
AFTER DELETE OR INSERT OR UPDATE
ON "DVM_ISS_TYPES"
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
    INSERT INTO DVM_ISS_TYPES_hist (
      h_seqnum, ISS_TYPE_ID, h_type_of_change, h_user_making_change, h_os_user,
      h_date_of_change, h_changed_column, h_old_data, h_new_data)
    VALUES(
      DVM_ISS_TYPES_hist_seq.NEXTVAL, :old.ISS_TYPE_ID, p_type_of_change, user, os_user,      SYSDATE, p_changed_column, p_old_data, p_new_data);
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
    INSERT INTO DVM_ISS_TYPES_hist (
      h_seqnum, ISS_TYPE_ID, h_type_of_change, h_user_making_change, h_os_user, h_date_of_change)
    VALUES (
      DVM_ISS_TYPES_hist_seq.NEXTVAL, :new.ISS_TYPE_ID,
      'INSERT', user, os_user, SYSDATE);
  ELSIF DELETING THEN
    insert_data('DELETE');
    insert_data('DELETE', 'iss_type_name', :old.iss_type_name);
    insert_data('DELETE', 'qc_object_id', :old.qc_object_id);
    insert_data('DELETE', 'iss_type_desc', :old.iss_type_desc);
    insert_data('DELETE', 'ind_field_name', :old.ind_field_name);
    insert_data('DELETE', 'iss_severity_id', :old.iss_severity_id);
    insert_data('DELETE', 'data_stream_id', :old.data_stream_id);
    insert_data('DELETE', 'iss_type_active_yn', :old.iss_type_active_yn);
    insert_data('DELETE', 'APP_LINK_TEMPLATE', :old.APP_LINK_TEMPLATE);
  ELSE
    check_update('iss_TYPE_NAME', :old.iss_type_name, :new.iss_type_name);
    check_update('QC_OBJECT_ID', :old.qc_object_id, :new.qc_object_id);
    check_update('iss_TYPE_DESC', :old.iss_type_desc, :new.iss_type_desc);
    check_update('IND_FIELD_NAME', :old.ind_field_name, :new.ind_field_name);
    check_update('iss_SEVERITY_ID', :old.iss_severity_id, :new.iss_severity_id);
    check_update('DATA_STREAM_ID', :old.data_stream_id, :new.data_stream_id);
    check_update('iss_TYPE_ACTIVE_YN', :old.iss_type_active_yn, :new.iss_type_active_yn);
    check_update('APP_LINK_TEMPLATE', :old.APP_LINK_TEMPLATE, :new.APP_LINK_TEMPLATE);
  END IF;
END;
/



create or replace TRIGGER "TRG_DVM_ISSUES_HIST"
AFTER DELETE OR INSERT OR UPDATE
ON "DVM_ISSUES"
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
    INSERT INTO DVM_ISSUES_HIST (
      h_seqnum, ISS_ID, h_type_of_change, h_user_making_change, h_os_user,
      h_date_of_change, h_changed_column, h_old_data, h_new_data)
    VALUES(
      DVM_issueS_hist_seq.NEXTVAL, :old.ISS_ID, p_type_of_change, user, os_user,      SYSDATE, p_changed_column, p_old_data, p_new_data);
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
    INSERT INTO DVM_ISSUES_hist (
      h_seqnum, ISS_ID, h_type_of_change, h_user_making_change, h_os_user, h_date_of_change)
    VALUES (
      DVM_issueS_hist_seq.NEXTVAL, :new.ISS_ID,
      'INSERT', user, os_user, SYSDATE);
  ELSIF DELETING THEN
    insert_data('DELETE');
    insert_data('DELETE', 'pta_ISS_id', :old.pta_ISS_id);
    insert_data('DELETE', 'ISS_type_id', :old.ISS_type_id);
    insert_data('DELETE', 'ISS_notes', :old.ISS_notes);
    insert_data('DELETE', 'iss_res_type_id', :old.iss_res_type_id);
    insert_data('DELETE', 'APP_LINK_URL', :old.APP_LINK_URL);
  ELSE
    check_update('PTA_ISS_ID', :old.pta_ISS_id, :new.pta_ISS_id);
    check_update('ISS_TYPE_ID', :old.ISS_type_id, :new.ISS_type_id);
    check_update('ISS_NOTES', :old.ISS_notes, :new.ISS_notes);
    check_update('iss_RES_TYPE_ID', :old.iss_res_type_id, :new.iss_res_type_id);
    check_update('APP_LINK_URL', :old.APP_LINK_URL, :new.APP_LINK_URL);
  END IF;
END;
/



--re-define the views for the renamed tables/fields:
  CREATE OR REPLACE VIEW DVM_CRITERIA_V AS
  SELECT
  DVM_QC_OBJECTS.QC_OBJECT_ID,
  DVM_QC_OBJECTS.OBJECT_NAME,
  DVM_QC_OBJECTS.QC_OBJ_ACTIVE_YN,
  DVM_QC_OBJECTS.QC_SORT_ORDER,
  DVM_ISS_TYPES.ISS_TYPE_ID,
  DVM_ISS_TYPES.ISS_TYPE_NAME,
  DVM_ISS_TYPES.ISS_TYPE_COMMENT_TEMPLATE,
  DVM_ISS_TYPES.ISS_TYPE_DESC,
  DVM_ISS_TYPES.IND_FIELD_NAME,
  DVM_ISS_TYPES.APP_LINK_TEMPLATE,
  DVM_ISS_TYPES.ISS_SEVERITY_ID,
  DVM_ISS_SEVERITY.ISS_SEVERITY_CODE,
  DVM_ISS_SEVERITY.ISS_SEVERITY_NAME,
  DVM_ISS_SEVERITY.ISS_SEVERITY_DESC,
  DVM_ISS_TYPES.DATA_STREAM_ID,
  DVM_DATA_STREAMS_V.DATA_STREAM_CODE,
  DVM_DATA_STREAMS_V.DATA_STREAM_NAME,
  DVM_DATA_STREAMS_V.DATA_STREAM_DESC,
  DVM_DATA_STREAMS_V.DATA_STREAM_PK_FIELD,
  DVM_ISS_TYPES.ISS_TYPE_ACTIVE_YN
FROM
  DVM_ISS_TYPES
INNER JOIN DVM_ISS_SEVERITY
ON
  DVM_ISS_SEVERITY.ISS_SEVERITY_ID = DVM_ISS_TYPES.ISS_SEVERITY_ID
INNER JOIN DVM_DATA_STREAMS_V
ON
  DVM_DATA_STREAMS_V.DATA_STREAM_ID = DVM_ISS_TYPES.DATA_STREAM_ID
INNER JOIN DVM_QC_OBJECTS
ON
  DVM_QC_OBJECTS.QC_OBJECT_ID = DVM_ISS_TYPES.QC_OBJECT_ID
ORDER BY

DVM_QC_OBJECTS.QC_SORT_ORDER, OBJECT_NAME, ISS_SEVERITY_CODE, ISS_TYPE_NAME;

   COMMENT ON COLUMN "DVM_CRITERIA_V"."QC_OBJECT_ID" IS 'The Data QC Object that the issue type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."OBJECT_NAME" IS 'The name of the object that is used in the given QC validation criteria';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."QC_OBJ_ACTIVE_YN" IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."QC_SORT_ORDER" IS 'Relative sort order for the QC object to be executed in';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."ISS_TYPE_ID" IS 'The Issue Type for the given error';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."ISS_TYPE_NAME" IS 'The name of the given QC validation criteria';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."ISS_TYPE_COMMENT_TEMPLATE" IS 'The template for the specific issue description that exists in the specific issue condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."ISS_TYPE_DESC" IS 'The description for the given QC validation issue type';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."IND_FIELD_NAME" IS 'The field in the result set that indicates if the current issue type has been identified.  A ''Y'' value indicates that the given issue condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current issue type';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."ISS_SEVERITY_ID" IS 'The Severity of the given issue type criteria.  These indicate the status of the given issue (e.g. warnings, data errors, violations of law, etc.)';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."APP_LINK_TEMPLATE" IS 'The template for the specific application link to resolve the given data issue.  This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the APP_ID and APP_SESSION at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';



   COMMENT ON COLUMN "DVM_CRITERIA_V"."ISS_SEVERITY_CODE" IS 'The code for the given issue severity';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."ISS_SEVERITY_NAME" IS 'The name for the given issue severity';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."ISS_SEVERITY_DESC" IS 'The description for the given issue severity';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."DATA_STREAM_ID" IS 'Primary Key for the DVM_DATA_STREAMS table';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."DATA_STREAM_CODE" IS 'The code for the given data stream';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."DATA_STREAM_NAME" IS 'The name for the given data stream';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."DATA_STREAM_DESC" IS 'The description for the given data stream';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."DATA_STREAM_PK_FIELD" IS 'The Data stream''s parent record''s primary key field (used when evaluating QC validation criteria to specify a given parent record)';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."ISS_TYPE_ACTIVE_YN" IS 'Flag to indicate if the given issue type criteria is active';
   COMMENT ON TABLE "DVM_CRITERIA_V"  IS 'Data Validation QC Criteria (View)

This View returns all QC Criteria (Issue Types) defined in the database and their associated QC Object, Issue Severity, and Issue Category.  This query is used to define all PTA Issue Types when a data stream is first entered into the database';








CREATE OR REPLACE View
DVM_RULE_SETS_V
AS
select
DVM_RULE_SETS.RULE_SET_ID,
DVM_RULE_SETS.RULE_SET_ACTIVE_YN,

DVM_RULE_SETS.RULE_SET_CREATE_DATE,
TO_CHAR(DVM_RULE_SETS.RULE_SET_CREATE_DATE, 'MM/DD/YYYY HH24:MI:SS') FORMAT_RULE_SET_CREATE_DATE,
DVM_RULE_SETS.RULE_SET_INACTIVE_DATE,
TO_CHAR(DVM_RULE_SETS.RULE_SET_INACTIVE_DATE, 'MM/DD/YYYY HH24:MI:SS') FORMAT_RULE_SET_INACTIVE_DATE,
DVM_RULE_SETS.DATA_STREAM_ID RULE_DATA_STREAM_ID,
DVM_DATA_STREAMS.DATA_STREAM_CODE RULE_DATA_STREAM_CODE,
DVM_DATA_STREAMS.DATA_STREAM_NAME RULE_DATA_STREAM_NAME,
DVM_DATA_STREAMS.DATA_STREAM_DESC RULE_DATA_STREAM_DESC,
DVM_DATA_STREAMS.DATA_STREAM_PAR_TABLE RULE_DATA_STREAM_PAR_TABLE,

dvm_iss_typ_assoc.ISS_TYP_ASSOC_ID,

DVM_CRITERIA_V.QC_OBJECT_ID,
DVM_CRITERIA_V.OBJECT_NAME,
DVM_CRITERIA_V.QC_OBJ_ACTIVE_YN,
DVM_CRITERIA_V.QC_SORT_ORDER,
DVM_CRITERIA_V.ISS_TYPE_ID,
DVM_CRITERIA_V.ISS_TYPE_NAME,
DVM_CRITERIA_V.ISS_TYPE_COMMENT_TEMPLATE,
DVM_CRITERIA_V.ISS_TYPE_DESC,
DVM_CRITERIA_V.IND_FIELD_NAME,
DVM_CRITERIA_V.APP_LINK_TEMPLATE,
DVM_CRITERIA_V.ISS_SEVERITY_ID,
DVM_CRITERIA_V.ISS_SEVERITY_CODE,
DVM_CRITERIA_V.ISS_SEVERITY_NAME,
DVM_CRITERIA_V.ISS_SEVERITY_DESC,
DVM_CRITERIA_V.DATA_STREAM_ID,
DVM_CRITERIA_V.DATA_STREAM_CODE,
DVM_CRITERIA_V.DATA_STREAM_NAME,
DVM_CRITERIA_V.DATA_STREAM_DESC,
DVM_CRITERIA_V.DATA_STREAM_PK_FIELD,
DVM_CRITERIA_V.ISS_TYPE_ACTIVE_YN
from

DVM_RULE_SETS
INNER JOIN
DVM_DATA_STREAMS
ON
DVM_DATA_STREAMS.DATA_STREAM_ID = DVM_RULE_SETS.DATA_STREAM_ID


inner join
dvm_iss_typ_assoc on
DVM_RULE_SETS.rule_set_id = dvm_iss_typ_assoc.rule_set_id
inner join
DVM_CRITERIA_V

 on
DVM_CRITERIA_V.iss_type_id = dvm_iss_typ_assoc.iss_type_id
order by
DVM_RULE_SETS.RULE_SET_CREATE_DATE, DVM_CRITERIA_V.QC_SORT_ORDER, DVM_CRITERIA_V.ISS_SEVERITY_CODE, DVM_CRITERIA_V.ISS_TYPE_NAME
;


COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';
COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).  Only one rule set can be active at any given time';
COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_SET_CREATE_DATE IS 'The date/time that the given rule set was created';
COMMENT ON COLUMN DVM_RULE_SETS_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_SET_INACTIVE_DATE IS 'The date/time that the given rule set was deactivated (due to a change in active rules)';
COMMENT ON COLUMN DVM_RULE_SETS_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the rule set''s data stream for the given DVM rule set';
COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_DATA_STREAM_CODE IS 'The code for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_DATA_STREAM_NAME IS 'The name for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_DATA_STREAM_DESC IS 'The description for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name for the given validation rule set (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN DVM_RULE_SETS_V.ISS_TYP_ASSOC_ID IS 'Primary Key for the DVM_ISS_TYP_ASSOC table';
COMMENT ON COLUMN DVM_RULE_SETS_V.QC_OBJECT_ID IS 'The Data QC Object that the issue type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB issue)';
COMMENT ON COLUMN DVM_RULE_SETS_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';
COMMENT ON COLUMN DVM_RULE_SETS_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
COMMENT ON COLUMN DVM_RULE_SETS_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';
COMMENT ON COLUMN DVM_RULE_SETS_V.ISS_TYPE_ID IS 'The issue type for the given issue';
COMMENT ON COLUMN DVM_RULE_SETS_V.ISS_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN DVM_RULE_SETS_V.ISS_TYPE_COMMENT_TEMPLATE IS 'The template for the specific issue description that exists in the specific issue condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
COMMENT ON COLUMN DVM_RULE_SETS_V.ISS_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN DVM_RULE_SETS_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current issue type has been identified.  A ''Y'' value indicates that the given issue condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current issue type';
COMMENT ON COLUMN DVM_RULE_SETS_V.APP_LINK_TEMPLATE IS 'The template for the specific application link to resolve the given data issue.  This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the APP_ID and APP_SESSION at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';
COMMENT ON COLUMN DVM_RULE_SETS_V.ISS_SEVERITY_ID IS 'The Severity of the given issue type criteria.  These indicate the status of the given issue (e.g. warnings, data issues, violations of law, etc.)';
COMMENT ON COLUMN DVM_RULE_SETS_V.ISS_SEVERITY_CODE IS 'The code for the given issue severity';
COMMENT ON COLUMN DVM_RULE_SETS_V.ISS_SEVERITY_NAME IS 'The name for the given issue severity';
COMMENT ON COLUMN DVM_RULE_SETS_V.ISS_SEVERITY_DESC IS 'The description for the given issue severity';
COMMENT ON COLUMN DVM_RULE_SETS_V.DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the issue type''s data stream for the given DVM rule set';
COMMENT ON COLUMN DVM_RULE_SETS_V.DATA_STREAM_CODE IS 'The code for the given issue type''s data stream';
COMMENT ON COLUMN DVM_RULE_SETS_V.DATA_STREAM_NAME IS 'The name for the given issue type''s data stream';
COMMENT ON COLUMN DVM_RULE_SETS_V.DATA_STREAM_DESC IS 'The description for the given issue type''s data stream';
COMMENT ON COLUMN DVM_RULE_SETS_V.DATA_STREAM_PK_FIELD IS 'The Data stream''s parent table name for the given issue type (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN DVM_RULE_SETS_V.ISS_TYPE_ACTIVE_YN IS 'Flag to indicate if the given issue type criteria is active';

COMMENT ON TABLE DVM_RULE_SETS_V IS 'Data Validation Rule Sets (View)

This View returns all Data Validation Rule Sets and associated validation criteria';




drop view DVM_PTA_ISSUE_TYPES_V;


  CREATE OR REPLACE VIEW DVM_PTA_ISS_TYPES_V AS
  SELECT
  DVM_PTA_ISSUES.PTA_ISS_ID,
  DVM_PTA_ISSUES.CREATE_DATE,
  TO_CHAR(DVM_PTA_ISSUES.CREATE_DATE, 'MM/DD/YYYY HH24:MI') FORMATTED_CREATE_DATE,

	DVM_PTA_RULE_SETS.PTA_RULE_SET_ID,
	DVM_PTA_RULE_SETS.FIRST_EVAL_DATE,
	TO_CHAR(DVM_PTA_RULE_SETS.FIRST_EVAL_DATE, 'MM/DD/YYYY HH24:MI') FORMAT_FIRST_EVAL_DATE,
	DVM_PTA_RULE_SETS.LAST_EVAL_DATE,
	TO_CHAR(DVM_PTA_RULE_SETS.LAST_EVAL_DATE, 'MM/DD/YYYY HH24:MI') FORMAT_LAST_EVAL_DATE,




	DVM_RULE_SETS_V.RULE_SET_ID,
	DVM_RULE_SETS_V.RULE_SET_ACTIVE_YN,
	DVM_RULE_SETS_V.RULE_SET_CREATE_DATE,
	DVM_RULE_SETS_V.FORMAT_RULE_SET_CREATE_DATE,
	DVM_RULE_SETS_V.RULE_SET_INACTIVE_DATE,
	DVM_RULE_SETS_V.FORMAT_RULE_SET_INACTIVE_DATE,
	DVM_RULE_SETS_V.RULE_DATA_STREAM_ID,
	DVM_RULE_SETS_V.RULE_DATA_STREAM_CODE,
	DVM_RULE_SETS_V.RULE_DATA_STREAM_NAME,
	DVM_RULE_SETS_V.RULE_DATA_STREAM_DESC,
	DVM_RULE_SETS_V.RULE_DATA_STREAM_PAR_TABLE,
	DVM_RULE_SETS_V.ISS_TYP_ASSOC_ID,
	DVM_RULE_SETS_V.QC_OBJECT_ID,
	DVM_RULE_SETS_V.OBJECT_NAME,
	DVM_RULE_SETS_V.QC_OBJ_ACTIVE_YN,
	DVM_RULE_SETS_V.QC_SORT_ORDER,
	DVM_RULE_SETS_V.ISS_TYPE_ID,
	DVM_RULE_SETS_V.ISS_TYPE_NAME,
	DVM_RULE_SETS_V.ISS_TYPE_COMMENT_TEMPLATE,
	DVM_RULE_SETS_V.ISS_TYPE_DESC,
	DVM_RULE_SETS_V.IND_FIELD_NAME,
	DVM_RULE_SETS_V.APP_LINK_TEMPLATE,
	DVM_RULE_SETS_V.ISS_SEVERITY_ID,
	DVM_RULE_SETS_V.ISS_SEVERITY_CODE,
	DVM_RULE_SETS_V.ISS_SEVERITY_NAME,
	DVM_RULE_SETS_V.ISS_SEVERITY_DESC,
	DVM_RULE_SETS_V.DATA_STREAM_ID,
	DVM_RULE_SETS_V.DATA_STREAM_CODE,
	DVM_RULE_SETS_V.DATA_STREAM_NAME,
	DVM_RULE_SETS_V.DATA_STREAM_DESC,
	DVM_RULE_SETS_V.DATA_STREAM_PK_FIELD,
	DVM_RULE_SETS_V.ISS_TYPE_ACTIVE_YN

FROM
  DVM_PTA_ISSUES
INNER JOIN DVM_PTA_RULE_SETS ON
DVM_PTA_ISSUES.PTA_ISS_ID = DVM_PTA_RULE_SETS.PTA_ISS_ID
INNER JOIN DVM_RULE_SETS_V
ON
DVM_PTA_RULE_SETS.RULE_SET_ID =
DVM_RULE_SETS_V.RULE_SET_ID
ORDER BY DVM_PTA_ISSUES.PTA_ISS_ID, DVM_RULE_SETS_V.QC_SORT_ORDER, DVM_RULE_SETS_V.OBJECT_NAME, DVM_RULE_SETS_V.ISS_SEVERITY_CODE, DVM_RULE_SETS_V.ISS_TYPE_NAME;

   COMMENT ON COLUMN "DVM_PTA_ISS_TYPES_V"."PTA_ISS_ID" IS 'Primary Key for the DVM_PTA_ISSUES table';
   COMMENT ON COLUMN "DVM_PTA_ISS_TYPES_V"."CREATE_DATE" IS 'The date on which this record was created in the database';
   COMMENT ON COLUMN "DVM_PTA_ISS_TYPES_V"."FORMATTED_CREATE_DATE" IS 'The formatted date/time on which this record was created in the database (MM/DD/YYYY HH24:MI)';

COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.RULE_SET_ID IS 'Primary key for the DVM_PTA_RULE_SETS table';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).  Only one rule set can be active at any given time';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.RULE_SET_CREATE_DATE IS 'The date/time that the given rule set was created';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.RULE_SET_INACTIVE_DATE IS 'The date/time that the given rule set was deactivated (due to a change in active rules)';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.RULE_DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the rule set''s data stream for the given DVM rule set';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.RULE_DATA_STREAM_CODE IS 'The code for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.RULE_DATA_STREAM_NAME IS 'The name for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.RULE_DATA_STREAM_DESC IS 'The description for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.RULE_DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name for the given validation rule set (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.ISS_TYP_ASSOC_ID IS 'Primary Key for the DVM_ISS_TYP_ASSOC table';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.QC_OBJECT_ID IS 'The Data QC Object that the issue type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB issue)';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.ISS_TYPE_ID IS 'The issue type for the given issue';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.ISS_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.ISS_TYPE_COMMENT_TEMPLATE IS 'The template for the specific issue description that exists in the specific issue condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.ISS_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current issue type has been identified.  A ''Y'' value indicates that the given issue condition has been identified.  When QC_OBJECT_ID is NULL this is the constant name that is used to refer to the current issue type';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.APP_LINK_TEMPLATE IS 'The template for the specific application link to resolve the given data issue.  This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the APP_ID and APP_SESSION at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.ISS_SEVERITY_ID IS 'The Severity of the given issue type criteria.  These indicate the status of the given issue (e.g. warnings, data issues, violations of law, etc.)';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.ISS_SEVERITY_CODE IS 'The code for the given issue severity';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.ISS_SEVERITY_NAME IS 'The name for the given issue severity';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.ISS_SEVERITY_DESC IS 'The description for the given issue severity';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the issue type''s data stream for the given DVM rule set';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.DATA_STREAM_CODE IS 'The code for the given issue type''s data stream';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.DATA_STREAM_NAME IS 'The name for the given issue type''s data stream';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.DATA_STREAM_DESC IS 'The description for the given issue type''s data stream';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.DATA_STREAM_PK_FIELD IS 'The Data stream''s parent table name for the given issue type (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.ISS_TYPE_ACTIVE_YN IS 'Flag to indicate if the given issue type criteria is active';




COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.PTA_RULE_SET_ID IS 'The primary key field for the DVM_PTA_RULE_SETS table';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.FIRST_EVAL_DATE IS 'The date/time the rule set was first evaluated for the given parent issue record';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.FORMAT_FIRST_EVAL_DATE IS 'The formatted date/time the rule set was first evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.LAST_EVAL_DATE IS 'The date/time the rule set was most recently evaluated for the given parent issue record';
COMMENT ON COLUMN DVM_PTA_ISS_TYPES_V.FORMAT_LAST_EVAL_DATE IS 'The formatted date/time the rule set was most recently evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';



   COMMENT ON TABLE "DVM_PTA_ISS_TYPES_V"  IS 'PTA Issue Types (View)

This View returns all Issue Types associated with a given PTA Issue Type record.  The PTA Issue Type record is defined the first time the given data stream is first entered into the database, all active Issue Types at this point in time are saved and associated with a new PTA Issue Type record and this is referenced by a given parent record of a given data stream (e.g. SPT_VESSEL_TRIPS for RPL data).  Each associated date/time is provided as a standard formatted date in MM/DD/YYYY HH24:MI format.  This relationship is used to determine the Issue Types that were associated with the a data stream when the given parent record is first entered into the database.  ';



  CREATE OR REPLACE VIEW DVM_PTA_ISSUES_V
AS
  SELECT
  DVM_PTA_ISSUES.PTA_ISS_ID,
  DVM_PTA_ISSUES.CREATE_DATE,
  TO_CHAR(DVM_PTA_ISSUES.CREATE_DATE, 'MM/DD/YYYY HH24:MI') FORMATTED_CREATE_DATE,

	DVM_ISSUES.ISS_ID,
  DVM_ISSUES.ISS_DESC,
  DVM_ISSUES.ISS_NOTES,
  DVM_ISSUES.ISS_RES_TYPE_ID,
	DVM_ISS_RES_TYPES.ISS_RES_TYPE_CODE,
  DVM_ISS_RES_TYPES.ISS_RES_TYPE_NAME,
  DVM_ISS_RES_TYPES.ISS_RES_TYPE_DESC,
  DVM_ISSUES.APP_LINK_URL,
  DVM_ISSUES.ISS_TYPE_ID,


	DVM_CRITERIA_V.QC_OBJECT_ID,
	DVM_CRITERIA_V.OBJECT_NAME,
	DVM_CRITERIA_V.QC_OBJ_ACTIVE_YN,
	DVM_CRITERIA_V.QC_SORT_ORDER,
	DVM_CRITERIA_V.ISS_TYPE_NAME,
	DVM_CRITERIA_V.ISS_TYPE_COMMENT_TEMPLATE,
	DVM_CRITERIA_V.ISS_TYPE_DESC,
	DVM_CRITERIA_V.IND_FIELD_NAME,
	DVM_CRITERIA_V.APP_LINK_TEMPLATE,
	DVM_CRITERIA_V.ISS_SEVERITY_ID,
	DVM_CRITERIA_V.ISS_SEVERITY_CODE,
	DVM_CRITERIA_V.ISS_SEVERITY_NAME,
	DVM_CRITERIA_V.ISS_SEVERITY_DESC,
	DVM_CRITERIA_V.DATA_STREAM_ID,
	DVM_CRITERIA_V.DATA_STREAM_CODE,
	DVM_CRITERIA_V.DATA_STREAM_NAME,
	DVM_CRITERIA_V.DATA_STREAM_DESC,
	DVM_CRITERIA_V.DATA_STREAM_PK_FIELD,
	DVM_CRITERIA_V.ISS_TYPE_ACTIVE_YN,



DVM_PTA_RULE_SETS.FIRST_EVAL_DATE,
TO_CHAR(DVM_PTA_RULE_SETS.FIRST_EVAL_DATE, 'MM/DD/YYYY HH24:MI:SS') FORMAT_FIRST_EVAL_DATE,
DVM_PTA_RULE_SETS.LAST_EVAL_DATE,
TO_CHAR(DVM_PTA_RULE_SETS.LAST_EVAL_DATE, 'MM/DD/YYYY HH24:MI:SS') FORMAT_LAST_EVAL_DATE,
DVM_ISS_TYP_ASSOC.ISS_TYP_ASSOC_ID,
DVM_RULE_SETS.RULE_SET_ID,
DVM_RULE_SETS.RULE_SET_ACTIVE_YN,
DVM_RULE_SETS.RULE_SET_CREATE_DATE,
TO_CHAR(DVM_RULE_SETS.RULE_SET_CREATE_DATE, 'MM/DD/YYYY HH24:MI:SS') FORMAT_RULE_SET_CREATE_DATE,
DVM_RULE_SETS.RULE_SET_INACTIVE_DATE,
TO_CHAR(DVM_RULE_SETS.RULE_SET_INACTIVE_DATE, 'MM/DD/YYYY HH24:MI:SS') FORMAT_RULE_SET_INACTIVE_DATE,
DVM_DATA_STREAMS.DATA_STREAM_ID RULE_DATA_STREAM_ID,
DVM_DATA_STREAMS.DATA_STREAM_CODE RULE_DATA_STREAM_CODE,
DVM_DATA_STREAMS.DATA_STREAM_NAME RULE_DATA_STREAM_NAME,
DVM_DATA_STREAMS.DATA_STREAM_DESC RULE_DATA_STREAM_DESC,
DVM_DATA_STREAMS.DATA_STREAM_PAR_TABLE RULE_DATA_STREAM_PAR_TABLE



FROM
  DVM_ISSUES
INNER JOIN DVM_PTA_ISSUES
ON
  DVM_PTA_ISSUES.PTA_ISS_ID = DVM_ISSUES.PTA_ISS_ID
INNER JOIN DVM_CRITERIA_V
ON
	DVM_CRITERIA_V.ISS_TYPE_ID = DVM_ISSUES.ISS_TYPE_ID

LEFT JOIN DVM_PTA_RULE_SETS
ON
DVM_PTA_RULE_SETS.PTA_ISS_ID = DVM_PTA_ISSUES.PTA_ISS_ID

LEFT JOIN DVM_RULE_SETS
ON
DVM_RULE_SETS.RULE_SET_ID = DVM_PTA_RULE_SETS.RULE_SET_ID

LEFT JOIN DVM_DATA_STREAMS
ON
DVM_DATA_STREAMS.DATA_STREAM_ID = DVM_RULE_SETS.DATA_STREAM_ID

LEFT JOIN DVM_ISS_TYP_ASSOC
ON
DVM_ISS_TYP_ASSOC.RULE_SET_ID = DVM_RULE_SETS.RULE_SET_ID
AND
DVM_CRITERIA_V.ISS_TYPE_ID = DVM_ISS_TYP_ASSOC.ISS_TYPE_ID


/*
LEFT JOIN
	DVM_RULE_SETS_V
ON
DVM_RULE_SETS_V.ISS_TYPE_ID = DVM_ISSUES.ISS_TYPE_ID

	DVM_PTA_RULE_SETS_V




ON DVM_PTA_RULE_SETS_V.RULE_SET_ID = DVM_RULE_SETS_V.RULE_SET_ID
AND DVM_PTA_ISSUES.PTA_ISS_ID = DVM_PTA_RULE_SETS_V.PTA_ISS_ID
*/


LEFT JOIN DVM_ISS_RES_TYPES
ON
  DVM_ISS_RES_TYPES.ISS_RES_TYPE_ID = DVM_ISSUES.ISS_RES_TYPE_ID




  ORDER BY DVM_PTA_ISSUES.PTA_ISS_ID, DVM_CRITERIA_V.QC_SORT_ORDER, DVM_CRITERIA_V.OBJECT_NAME, DVM_CRITERIA_V.ISS_SEVERITY_CODE, DVM_CRITERIA_V.ISS_TYPE_NAME;

   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."PTA_ISS_ID" IS 'Foreign key reference to the Issues (PTA) intersection table';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."CREATE_DATE" IS 'The date/time the Validation Issue parent record was created in the database, this indicates the first time the parent record was validated using the DVM';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."FORMATTED_CREATE_DATE" IS 'The formatted date/time the Validation Issue parent record was created in the database, this indicates the first time the parent record was validated using the DVM (MM/DD/YYYY HH24:MI)';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."ISS_ID" IS 'Primary Key for the DVM_ISSUES table';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."ISS_DESC" IS 'The description of the given Validation Issue';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."ISS_NOTES" IS 'Manually entered notes for the corresponding data issue';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."ISS_TYPE_ID" IS 'The Issue Type for the given issue';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."ISS_TYPE_NAME" IS 'The name of the given QC validation criteria';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."ISS_TYPE_COMMENT_TEMPLATE" IS 'The template for the specific issue description that exists in the specific issue condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."QC_OBJECT_ID" IS 'The Data QC Object that the issue type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."OBJECT_NAME" IS 'The name of the object that is used in the given QC validation criteria';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."QC_OBJ_ACTIVE_YN" IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."QC_SORT_ORDER" IS 'Relative sort order for the QC object to be executed in';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."ISS_TYPE_DESC" IS 'The description for the given QC validation issue type';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."IND_FIELD_NAME" IS 'The field in the result set that indicates if the current issue type has been identified.  A ''Y'' value indicates that the given issue condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current issue type';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."ISS_SEVERITY_ID" IS 'The Severity of the given issue type criteria.  These indicate the status of the given issue (e.g. warnings, data errors, violations of law, etc.)';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."ISS_SEVERITY_CODE" IS 'The code for the given issue severity';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."ISS_SEVERITY_NAME" IS 'The name for the given issue severity';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."ISS_SEVERITY_DESC" IS 'The description for the given issue severity';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."DATA_STREAM_ID" IS 'Primary Key for the DVM_DATA_STREAMS table';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."DATA_STREAM_CODE" IS 'The code for the given data stream';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."DATA_STREAM_NAME" IS 'The name for the given data stream';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."DATA_STREAM_DESC" IS 'The description for the given data stream';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."ISS_TYPE_ACTIVE_YN" IS 'Flag to indicate if the given issue type criteria is active';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."ISS_RES_TYPE_ID" IS 'Primary Key for the DVM_ISS_RES_TYPES table';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."ISS_RES_TYPE_CODE" IS 'The Issue Resolution Type code';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."ISS_RES_TYPE_NAME" IS 'The Issue Resolution Type name';
   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."ISS_RES_TYPE_DESC" IS 'The Issue Resolution Type description';

   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."APP_LINK_TEMPLATE" IS 'The template for the specific application link to resolve the given data issue.  This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the [APP_ID] and [APP_SESSION] placeholders at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';


	COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."DATA_STREAM_PK_FIELD" IS 'The Data stream''s parent record''s primary key field (used when evaluating QC validation criteria to specify a given parent record)';

   COMMENT ON COLUMN "DVM_PTA_ISSUES_V"."APP_LINK_URL" IS 'The generated specific application link URL to resolve the given data issue.  This is generated at runtime of the DVM based on the values returned by the corresponding QC query and by the related DVM_ISS_TYPES record''s APP_LINK_TEMPLATE value';

COMMENT ON COLUMN DVM_PTA_ISSUES_V.FIRST_EVAL_DATE IS 'The date/time the rule set was first evaluated for the given parent issue record';
COMMENT ON COLUMN DVM_PTA_ISSUES_V.FORMAT_FIRST_EVAL_DATE IS 'The formatted date/time the rule set was first evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN DVM_PTA_ISSUES_V.LAST_EVAL_DATE IS 'The date/time the rule set was most recently evaluated for the given parent issue record';
COMMENT ON COLUMN DVM_PTA_ISSUES_V.FORMAT_LAST_EVAL_DATE IS 'The formatted date/time the rule set was most recently evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN DVM_PTA_ISSUES_V.ISS_TYP_ASSOC_ID IS 'Primary Key for the DVM_ISS_TYP_ASSOC table';
COMMENT ON COLUMN DVM_PTA_ISSUES_V.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';
COMMENT ON COLUMN DVM_PTA_ISSUES_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).  Only one rule set can be active at any given time';
COMMENT ON COLUMN DVM_PTA_ISSUES_V.RULE_SET_CREATE_DATE IS 'The date/time that the given rule set was created';
COMMENT ON COLUMN DVM_PTA_ISSUES_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN DVM_PTA_ISSUES_V.RULE_SET_INACTIVE_DATE IS 'The date/time that the given rule set was deactivated (due to a change in active rules)';
COMMENT ON COLUMN DVM_PTA_ISSUES_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN DVM_PTA_ISSUES_V.RULE_DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the rule set''s data stream for the given DVM rule set';
COMMENT ON COLUMN DVM_PTA_ISSUES_V.RULE_DATA_STREAM_CODE IS 'The code for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_PTA_ISSUES_V.RULE_DATA_STREAM_NAME IS 'The name for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_PTA_ISSUES_V.RULE_DATA_STREAM_DESC IS 'The description for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_PTA_ISSUES_V.RULE_DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name for the given validation rule set (used when evaluating QC validation criteria to specify a given parent table)';



   COMMENT ON TABLE "DVM_PTA_ISSUES_V"  IS 'PTA Issues (View)

This View returns all unresolved Issues associated with a given PTA Validation Issue record that were identified during the last evaluation of the associated Validation Issue Types.  A PTA Validation Issue record can be referenced by any data table that represents the parent record for a given data stream (e.g. SPT_VESSEL_TRIPS for RPL data).  The query returns detailed information about the specifics of each issue identified as well as general information about the given Validation Issue''s Issue Type.  Each associated date/time is provided as a standard formatted date in MM/DD/YYYY HH24:MI format.';



COMMENT ON COLUMN DVM_PTA_ISSUES.CREATE_DATE IS 'The date/time the Validation Issue parent record was created in the database, this indicates the first time the parent record was validated using the DVM';



drop view dvm_pta_errors_v;






CREATE OR REPLACE View
DVM_PTA_RULE_SETS_V
AS
select
DVM_RULE_SETS.RULE_SET_ID,
DVM_RULE_SETS.RULE_SET_ACTIVE_YN,
DVM_RULE_SETS.RULE_SET_CREATE_DATE,
TO_CHAR(DVM_RULE_SETS.RULE_SET_CREATE_DATE, 'MM/DD/YYYY HH24:MI:SS') FORMAT_RULE_SET_CREATE_DATE,
DVM_RULE_SETS.RULE_SET_INACTIVE_DATE,
TO_CHAR(DVM_RULE_SETS.RULE_SET_INACTIVE_DATE, 'MM/DD/YYYY HH24:MI:SS') FORMAT_RULE_SET_INACTIVE_DATE,

DVM_PTA_RULE_SETS.PTA_RULE_SET_ID,
DVM_PTA_RULE_SETS.PTA_ISS_ID,

DVM_PTA_RULE_SETS.FIRST_EVAL_DATE,
TO_CHAR(DVM_PTA_RULE_SETS.FIRST_EVAL_DATE, 'MM/DD/YYYY HH24:MI') FORMAT_FIRST_EVAL_DATE,
DVM_PTA_RULE_SETS.LAST_EVAL_DATE,
TO_CHAR(DVM_PTA_RULE_SETS.LAST_EVAL_DATE, 'MM/DD/YYYY HH24:MI') FORMAT_LAST_EVAL_DATE,

DVM_DATA_STREAMS.DATA_STREAM_ID,
DVM_DATA_STREAMS.DATA_STREAM_CODE,
DVM_DATA_STREAMS.DATA_STREAM_NAME,
DVM_DATA_STREAMS.DATA_STREAM_DESC,
DVM_DATA_STREAMS.DATA_STREAM_PAR_TABLE

FROM
DVM_RULE_SETS INNER JOIN
DVM_PTA_RULE_SETS ON
DVM_RULE_SETS.RULE_SET_ID = DVM_PTA_RULE_SETS.RULE_SET_ID
INNER join
DVM_DATA_STREAMS
ON
DVM_DATA_STREAMS.DATA_STREAM_ID = DVM_RULE_SETS.DATA_STREAM_ID
order by
DVM_DATA_STREAMS.DATA_STREAM_CODE,
DVM_RULE_SETS.RULE_SET_ID,
DVM_PTA_RULE_SETS.PTA_RULE_SET_ID;


COMMENT ON TABLE DVM_PTA_RULE_SETS_V IS 'DVM PTA Rule Sets (View)

This view returns all of the rule sets and associated data streams as well as all PTA rule sets to provide information about which parent issue records have been evaluated with which rule sets';


COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).  Only one rule set can be active at any given time';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.RULE_SET_CREATE_DATE IS 'The date/time that the given rule set was created';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.RULE_SET_INACTIVE_DATE IS 'The date/time that the given rule set was deactivated (due to a change in active rules)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.PTA_RULE_SET_ID IS 'The primary key field for the DVM_PTA_RULE_SETS table';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.PTA_ISS_ID IS 'Foreign key reference to the PTA Issue record associated validation rule set (DVM_PTA_ISSUES)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.FIRST_EVAL_DATE IS 'The date/time the rule set was first evaluated for the given parent issue record';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.FORMAT_FIRST_EVAL_DATE IS 'The formatted date/time the rule set was first evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.LAST_EVAL_DATE IS 'The date/time the rule set was most recently evaluated for the given parent issue record';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.FORMAT_LAST_EVAL_DATE IS 'The formatted date/time the rule set was most recently evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.DATA_STREAM_ID IS 'Primary Key for the DVM_DATA_STREAMS table';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.DATA_STREAM_CODE IS 'The code for the given data stream';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.DATA_STREAM_NAME IS 'The name for the given data stream';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.DATA_STREAM_DESC IS 'The description for the given data stream';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name (used when evaluating QC validation criteria to specify a given parent table)';








create or replace PACKAGE DVM_PKG IS



		--declare the numeric based array of strings, used in various package procedures
		TYPE VARCHAR_ARRAY_NUM IS TABLE OF VARCHAR2(30) INDEX BY PLS_INTEGER;

		--declare the associative array of integers Oracle type
		TYPE NUM_ARRAY IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;

		--declare the numeric array of DVM_ISSUES record Oracle type
		TYPE DVM_ISSUES_TABLE IS TABLE OF DVM_ISSUES%ROWTYPE INDEX BY PLS_INTEGER;

		--Main package procedure that validates a parent record based on the given data stream code(s) defined by p_data_stream_codes, and uniquely identified by p_PK_ID.  This is the main procedure that is called by external programs to validate a given parent record.
		--Example usage for the RPL and XML data streams (defined in the DVM_DATA_STREAMS.DATA_STREAM_CODE table field):
	/*
		--sample usage for data validation module:
		DECLARE
			P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
			P_PK_ID NUMBER;
		BEGIN
			-- Modify the code to initialize the variable
			P_DATA_STREAM_CODE(1) := 'RPL';
			P_DATA_STREAM_CODE(2) := 'XML';
			P_PK_ID := :vtid;

			DVM_PKG.VALIDATE_PARENT_RECORD(
			P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
			P_PK_ID => P_PK_ID
			);
			--rollback;
		END;
	*/
		PROCEDURE VALIDATE_PARENT_RECORD (p_data_stream_codes IN VARCHAR_ARRAY_NUM, p_PK_ID IN NUMBER);


		--procedure to generate a placeholder string based on the p_input_string_array elements that are supplied.  p_placeholder_string will contain a comma delimited string with generated placholder values, p_placeholder_array will contain the generated placeholder values, and p_delimited_string will contain a comma delimited string of the p_input_string_array elements:
		PROCEDURE GENERATE_PLACEHOLDERS (p_input_string_array IN VARCHAR_ARRAY_NUM, p_placeholder_string OUT CLOB, p_placeholder_array OUT VARCHAR_ARRAY_NUM, p_delimited_string OUT CLOB);

		--procedure to retrieve the data stream information for the supplied data stream code(s).  This procedure utilizes the DBMS_SQL package because the number of data stream code(s) that are allowed as arguments are only known at runtime:
		PROCEDURE RETRIEVE_DATA_STREAM_INFO (p_proc_return_code OUT PLS_INTEGER);

		--procedure to retrieve a parent record based off of the parent record and PK ID supplied:
		PROCEDURE RETRIEVE_PARENT_REC (p_proc_return_code OUT PLS_INTEGER);

		--package procedure that retrieves a parent issue record and returns p_proc_return_code with a code that indicates the result of the operation
		PROCEDURE RETRIEVE_PARENT_ISSUE_REC (p_proc_return_code OUT PLS_INTEGER);

		--package procedure to retrieve all of the QC criteria based on whether or not the parent record has been validated before:
		PROCEDURE RETRIEVE_QC_CRITERIA (p_rule_set_id_array IN NUM_ARRAY, p_proc_return_code OUT PLS_INTEGER);




		--define the parent issue record for the specified rule set(s) (p_rule_set_id_array)
		PROCEDURE DEFINE_PARENT_ISSUE_REC (p_rule_set_id_array IN NUM_ARRAY, p_proc_return_code OUT PLS_INTEGER);

		--associate the parent record with the new parent issue record:
		PROCEDURE ASSOC_PARENT_ISSUE_REC (p_proc_return_code OUT PLS_INTEGER);

		--evaluate the QC criteria stored in ALL_CRITERIA for the given parent record:
		PROCEDURE EVAL_QC_CRITERIA (p_data_stream_codes IN VARCHAR_ARRAY_NUM, p_proc_return_code OUT PLS_INTEGER);

		--validate a specific QC criteria in ALL_CRITERIA in the elements from p_begin_pos to p_end_pos
		PROCEDURE PROCESS_QC_CRITERIA (p_begin_pos IN PLS_INTEGER, p_end_pos IN PLS_INTEGER, p_proc_return_code OUT PLS_INTEGER);

		--procedure to populate an issue record with the information from the corresponding result set row:
		PROCEDURE POPULATE_ISSUE_REC (curid IN NUMBER, QC_criteria_pos IN NUMBER, issue_rec OUT DVM_ISSUES%ROWTYPE, p_proc_return_code OUT PLS_INTEGER);

		--update the PTA rule set record to indicate that the given validation rule set was re-evaluated for the specified parent issue record:
		PROCEDURE UPDATE_PTA_RULE_SET_LAST_EVAL (p_rule_set_id IN PLS_INTEGER, p_pta_iss_id IN PLS_INTEGER, p_proc_return_code OUT PLS_INTEGER);

		--function that will return a comma-delimited list of the placeholder fields that are not in the result set of the given View identified by QC_OBJECT_NAME:
		FUNCTION QC_MISSING_QUERY_FIELDS (ISS_TYPE_COMMENT_TEMPLATE DVM_ISS_TYPES.ISS_TYPE_COMMENT_TEMPLATE%TYPE, QC_OBJECT_NAME DVM_CRITERIA_V.OBJECT_NAME%TYPE) RETURN CLOB;

		--procedure that replaces all placeholders in P_TEMPLATE_VALUE with the corresponding values in the result set row specified by curid for the QC criteria identified by QC_criteria_pos and returns the rekaced value as P_REPLACED_VALUE.  p_proc_return_code will contain 1 if the operation was successful, 0 if there were unmatched placeholders other than the APEX reserved placeholders ([APP_SESSION], [APP_ID]) that are required to generate a valid APEX URL
		PROCEDURE REPLACE_PLACEHOLDER_VALS (curid IN NUMBER, QC_criteria_pos IN NUMBER, P_TEMPLATE_VALUE IN VARCHAR2, P_REPLACED_VALUE OUT VARCHAR2, p_proc_return_code OUT PLS_INTEGER);

		--check to see if there is an active rule set, if not a new rule set will be created with the new validation criteria (check count(*) to see if there is at least one active criteria, if not then return an error code). if so then the procedure will check to see if the active rule set is the same as the active set of validation criteria, if so then it will return the rule_set_id in P_rule_set_id parameter if not it will deactivate the rule set and insert a new active rule set with the current active rules:
		procedure RETRIEVE_ACTIVE_RULE_SET_SP (p_data_stream_codes IN VARCHAR_ARRAY_NUM, p_rule_set_id_array OUT NUM_ARRAY, p_proc_return_code OUT PLS_INTEGER);

		--procedure that defines a new rule set and associates all active issue types with the new rule set:
		--the p_rule_set_id contains the RULE_SET_ID value from the newly inserted DVM_PTA_RULE_SETS record and p_proc_return_code contains 1 if it was successful and 0 if there was a problem with the rules or validation criteria and -1 if there was a processing error
		PROCEDURE DEFINE_RULE_SET_SP (p_data_stream_code IN VARCHAR2, p_rule_set_id OUT PLS_INTEGER, p_proc_return_code OUT PLS_INTEGER);

		--this procedure queries for all issue records that are related to validation rule sets associated with the p_data_stream_codes data stream(s) so they can be compared to the issues that were just identified by the DVM
		PROCEDURE RETRIEVE_ISSUE_RECS (p_data_stream_codes IN VARCHAR_ARRAY_NUM, p_issue_recs OUT DVM_ISSUES_TABLE, p_proc_return_code OUT PLS_INTEGER);

		--this procedure will initialize the member variables to ensure that there are no leftover values from a previous execution
		PROCEDURE INIT_PKG_SP (p_proc_return_code OUT PLS_INTEGER);

	END DVM_PKG;
	/

	create or replace PACKAGE BODY DVM_PKG IS

		--Custom record type to store standard information returned by the DVM_CRITERIA_V View when the corresponding data validation criteria information is queried for the given parent table (populated in RETRIEVE_QC_CRITERIA() method procedure)
		TYPE QC_CRITERIA_INFO IS RECORD (
		OBJECT_NAME DVM_CRITERIA_V.OBJECT_NAME%TYPE,
		DATA_STREAM_PK_FIELD DVM_CRITERIA_V.DATA_STREAM_PK_FIELD%TYPE,
		IND_FIELD_NAME DVM_CRITERIA_V.IND_FIELD_NAME%TYPE,
		ISS_TYPE_COMMENT_TEMPLATE DVM_CRITERIA_V.ISS_TYPE_COMMENT_TEMPLATE%TYPE,
		ISS_TYPE_ID DVM_CRITERIA_V.ISS_TYPE_ID%TYPE,
		QC_OBJECT_ID DVM_CRITERIA_V.QC_OBJECT_ID%TYPE,
		APP_LINK_TEMPLATE DVM_CRITERIA_V.APP_LINK_TEMPLATE%TYPE
		);

		--numeric based array Oracle type for QC_CRITERIA_INFO record type used to store all data validation criteria for processing
		TYPE QC_CRITERIA_TABLE IS TABLE OF QC_CRITERIA_INFO INDEX BY PLS_INTEGER;

		--variable for the QC criteria Oracle type
		ALL_CRITERIA QC_CRITERIA_TABLE;


		--member variable to store the PK ID that is initially supplied to the VALIDATE_PARENT_RECORD procedure when the package is initialized and processed:
		v_PK_ID NUMBER;

		--member variable to store the DVM_PTA_ISSUES (parent issue table) record for the given parent record (e.g. SPT_VESSEL_TRIPS)
		v_PTA_ISSUE DVM_PTA_ISSUES%ROWTYPE;

		--member variable to hold the name of the Oracle parent table for the given data validation module execution.  This is defined in the DVM_DATA_STREAMS.DATA_STREAM_PAR_TABLE field for the corresponding data stream code(s) supplied to the VALIDATE_PARENT_RECORD procedure:
		v_data_stream_par_table VARCHAR(30);


		--member variable to hold the name of the Oracle parent table's primary key field for the given data validation module execution.  This is defined in the DVM_DATA_STREAMS_V.DATA_STREAM_PK_FIELD field for the corresponding data stream code(s) supplied to the VALIDATE_PARENT_RECORD procedure:
		v_data_stream_pk_field VARCHAR(30);


		--declare the associative array of integers Oracle type
		TYPE NUM_ASSOC_VARCHAR IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(30);


		--associative array variable used to store the relative position of each column that is returned by the QC queries executed using the DBMS_SQL package methods to allow dynamic processing:
		assoc_field_list NUM_ASSOC_VARCHAR;


		--numeric-based array variable used to store the name of each column in its relative position returned by QC queries executed using the DBMS_SQL package methods to allow dynamic processing:
		num_field_list VARCHAR_ARRAY_NUM;

		--numeric-based array variable used to store the value of p_data_stream_codes supplied to the VALIDATE_PARENT_RECORD procedure
		v_data_stream_codes VARCHAR_ARRAY_NUM;

		--member variable used to store column-level information for dynamic queries executed using the DBMS_SQL package methods to allow dynamic processing
		desctab  DBMS_SQL.DESC_TAB;


		--member variable used to store each validation issue that is determined by the data validation module execution so it can be loaded into the database as separate DVM_ISSUES records
		v_issue_rec_table DVM_ISSUES_TABLE;


		--member variable used to store the comma delimited string of the data stream code(s) supplied to the VALIDATE_PARENT_RECORD procedure
		v_data_stream_code_string CLOB;

		--member variable used to store the comma delimited string of the placeholders used when querying using the data stream code(s) supplied to the VALIDATE_PARENT_RECORD procedure
		v_data_str_placeholder_string CLOB;

		--member variable used to store each placholder used when querying using the data stream code(s) supplied to the VALIDATE_PARENT_RECORD procedure
		v_data_str_placeholder_array VARCHAR_ARRAY_NUM;


		--procedure boolean variable whose value is set based off of whether the parent record (e.g. SPT_VESSEL_TRIPS) has an associated parent issue record (DVM_PTA_ISSUES) to determine the behavior of the module
		v_first_validation BOOLEAN;



		--Main package procedure that validates a parent record based on the given data stream code(s) defined by p_data_stream_codes, and uniquely identified by p_PK_ID.  This is the main procedure that is called by external programs to validate a given parent record.
		--Example usage for the RPL and XML data streams (defined in the DVM_DATA_STREAMS.DATA_STREAM_CODE table field):
	/*
	--sample usage for data validation module:
	DECLARE
		P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
		P_PK_ID NUMBER;
	BEGIN
		-- Modify the code to initialize the variable
		P_DATA_STREAM_CODE(1) := 'RPL';
		P_DATA_STREAM_CODE(2) := 'XML';
		P_PK_ID := :vtid;

		DVM_PKG.VALIDATE_PARENT_RECORD(
		P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
		P_PK_ID => P_PK_ID
		);
		--rollback;
	END;
	*/
		PROCEDURE VALIDATE_PARENT_RECORD (p_data_stream_codes IN VARCHAR_ARRAY_NUM, p_PK_ID IN NUMBER) IS

			--procedure variable to store generated SQL statements that are executed in the procedure:
			v_temp_SQL CLOB;

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			v_proc_return_code PLS_INTEGER;

			--procedure boolean variable that determines if the procedure execution continues based on the results of the various procedure calls:
			v_continue BOOLEAN;

			--variable to store the RULE_SET_ID primary key value for a new/existing DVM_PTA_RULE_SETS record that is associated with the current parent issue record

			v_rule_set_id_array NUM_ARRAY;

			--temporary variable to store the RULE_SET_ID primary key value for new/existing DVM_PTA_RULE_SETS record that is associated with the current parent issue record

			v_temp_rule_set_id_array NUM_ARRAY;


			--variable to store the data stream codes that need to have validation rule sets retrieved:
			V_temp_data_stream_codes VARCHAR_ARRAY_NUM;

			--variable to store the number of validation rule sets that are associated with the given data stream (this is used to determine if the given data stream has already been evaluated for a given parent issue record
			v_num_rule_sets PLS_INTEGER;

			--variable to store the rule_set_id for the rule set that has already been evaluated
			v_temp_rule_set_id PLS_INTEGER;


		BEGIN

			DBMS_OUTPUT.PUT_LINE('Running VALIDATE_PARENT_RECORD('||p_data_stream_codes(1)||', '||p_PK_ID||')');

			--initialize the member variables used in the DVM_PKG package:
			INIT_PKG_SP (v_proc_return_code);

			--check if the initialization procedure was successful:
			IF (v_proc_return_code = 1) THEN


				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'Running VALIDATE_PARENT_RECORD('||p_data_stream_codes(1)||', '||p_PK_ID||')', v_proc_return_code);

				--set the member variable for usage later:
				v_data_stream_codes := p_data_stream_codes;

				--initialize the v_continue variable:
				v_continue := true;

				--set the package variables to the parameter values:
				v_PK_ID := p_PK_ID;




				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'VALIDATE_PARENT_RECORD('||p_data_stream_codes(1)||', '||p_PK_ID||'): Running RETRIEVE_DATA_STREAM_INFO()', v_proc_return_code);

				--query the database to for the data stream code(s) that will be used to determine the parent record and associated data validation criteria:
				RETRIEVE_DATA_STREAM_INFO(v_proc_return_code);

				--check the return code from RETRIEVE_DATA_STREAM_INFO():
				IF (v_proc_return_code = 1) THEN

					--the data stream code(s) have been returned a single parent table, continue processing:

					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'VALIDATE_PARENT_RECORD('||p_data_stream_codes(1)||', '||p_PK_ID||'): the data stream code(s) have been returned a single parent table, continue processing', v_proc_return_code);


					--check if the parent record exists using the information from the corresponding data stream:
					RETRIEVE_PARENT_REC (v_proc_return_code);

					--check the return code from RETRIEVE_PARENT_REC():
					IF (v_proc_return_code = 1) THEN

						--the parent record exists, continue processing:

						DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'VALIDATE_PARENT_RECORD('||p_data_stream_codes(1)||', '||p_PK_ID||'): the parent record exists, continue processing: RETRIEVE_PARENT_ISSUE_REC()', v_proc_return_code);

						--check if the parent record and PTA issue record exist:
						RETRIEVE_PARENT_ISSUE_REC (v_proc_return_code);


						--check the return code from RETRIEVE_PARENT_ISSUE_REC():
						IF (v_proc_return_code = 1) THEN
							--the parent record's PTA issue record exists:
							DBMS_OUTPUT.PUT_LINE('The parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'" was found in the database');

							DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'VALIDATE_PARENT_RECORD('||p_data_stream_codes(1)||', '||p_PK_ID||'): The parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'" was found in the database', v_proc_return_code);

							--the parent issue record already exists, use the data validation criteria that was active when the parent record was first validated:
							v_first_validation := false;


							for i in 1..p_data_stream_codes.COUNT LOOP
								v_temp_SQL := 'SELECT COUNT(*) FROM DVM_PTA_RULE_SETS_V WHERE DATA_STREAM_CODE = :DSC AND PTA_ISS_ID = :PEID';


								EXECUTE IMMEDIATE v_temp_SQL into v_num_rule_sets using p_data_stream_codes(i), v_PTA_ISSUE.PTA_ISS_ID;

								DBMS_OUTPUT.PUT_LINE('There are '||v_num_rule_sets||' active rule sets for the current data stream ('||p_data_stream_codes(i)||')');

								--check if the current data stream code has already been evaluated for the parent issue record
								IF (v_num_rule_sets > 0) THEN
									--this data stream has already been evaluated for the given parent issue record, retrieve the rule_set_id so it can be used for processing:

									DBMS_OUTPUT.PUT_LINE('this data stream has already been evaluated for the given parent issue record, retrieve the rule_set_id so it can be used for processing');

									SELECT RULE_SET_ID INTO v_temp_rule_set_id FROM DVM_PTA_RULE_SETS_V where DATA_STREAM_CODE = p_data_stream_codes(i) AND PTA_ISS_ID = v_PTA_ISSUE.PTA_ISS_ID;

									--add the rule_set_id to the array of rule set ids to evaluate for the current parent issue record
									v_rule_set_id_array(v_rule_set_id_array.COUNT + 1) := v_temp_rule_set_id;

									--The current existing PTA validation rule set was updated successfully
									DBMS_OUTPUT.PUT_LINE('The existing validation rule set to use is: '||v_temp_rule_set_id);



									--update the DVM_PTA_RULE_SETS to update the LAST_EVAL_DATE due to the validation process being executed:
									UPDATE_PTA_RULE_SET_LAST_EVAL (v_temp_rule_set_id, v_PTA_ISSUE.PTA_ISS_ID, v_proc_return_code);
									IF (v_proc_return_code = 1) then

										--The current existing PTA validation rule set was updated successfully
										DBMS_OUTPUT.PUT_LINE('The current existing PTA validation rule set was updated successfully');

										DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'The current existing PTA validation rule set was updated successfully', v_proc_return_code);

									ELSE

										--The current existing PTA validation rule set was NOT updated successfully
										DBMS_OUTPUT.PUT_LINE('Error - The current existing PTA validation rule set was NOT updated successfully');

										DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'The current existing PTA validation rule set was not updated successfully', v_proc_return_code);

										--do not continue processing the record:
										v_continue := false;
									END IF;

								ELSE
									--this data stream has not been evaluated on the current parent issue record yet, add it to the list of data stream codes that need to be retrieved:

									DBMS_OUTPUT.PUT_LINE('this data stream has not been evaluated on the current parent issue record yet, add it to the list of data stream codes that need to be retrieved: '||p_data_stream_codes(i));

									V_temp_data_stream_codes((V_temp_data_stream_codes.COUNT + 1)) := p_data_stream_codes(i);
								END IF;

							END LOOP;


							DBMS_OUTPUT.PUT_LINE('check if there are any data stream codes that need to be evaluated using RETRIEVE_ACTIVE_RULE_SET_SP');
							--check if there are any data stream codes that need to be evaluated using RETRIEVE_ACTIVE_RULE_SET_SP
							IF (V_temp_data_stream_codes.COUNT > 0) THEN
								--there is at least one data stream code that needs to be evaluated using RETRIEVE_ACTIVE_RULE_SET_SP

								DBMS_OUTPUT.PUT_LINE('there is at least one data stream code that needs to be evaluated using RETRIEVE_ACTIVE_RULE_SET_SP');


								--retrieve the active rule sets for the V_temp_data_stream_codes:
								RETRIEVE_ACTIVE_RULE_SET_SP (V_temp_data_stream_codes, v_temp_rule_set_id_array, v_proc_return_code);
								IF (v_proc_return_code = 1) THEN
									--the active rule sets were successfully retrieved:
									DBMS_OUTPUT.PUT_LINE('The active rule set(s) were successfully retrieved');

									--add the rule_set_id values returned by the RETRIEVE_ACTIVE_RULE_SET_SP function call to the v_rule_set_id_array variable
									FOR i in 1..v_temp_rule_set_id_array.COUNT Loop

										--add the rule_set_id:
										v_rule_set_id_array(v_rule_set_id_array.count + 1) := v_temp_rule_set_id_array(i);

--										DBMS_OUTPUT.PUT_LINE('The current rule set ('||v_temp_rule_set_id_array(i)||') was successfully added to the v_rule_set_id_array');

									END LOOP;

								ELSE

									--The return code from the DEFINE_PARENT_ISSUE_REC() procedure indicates an error: the parent issue record was not loaded successfully:
									DBMS_OUTPUT.PUT_LINE('Error - The active rule set(s) were not successfully retrieved');

									--do not continue processing the record:
									v_continue := false;
								END IF;



							END IF;


	/***********************************************/
	--put together the logic to determine if each data stream has been evaluated before, if not then insert the new DVM_PTA_RULE_SETS record for each of the active validation rule sets for each data stream

	--if we create the association records then it will make it easier to retrieve and evaluate the criteria because of the query (it will still need to incorporate multiple data stream codes but it can be done with a single query to simplify the process RETRIEVE_QC_CRITERIA procedure)
	/***********************************************/


							--query for all data streams that the parent record is associated with and then compare them against the data streams that were specified in the procedure:

							--populate the array of rule set IDs that can be passed to RETRIEVE_QC_CRITERIA procedure to ensure that the arguments are consistent and the logic is maintained in one place
								--the PTA rule set record will either be created (if it has not been evaluated yet) or retrieved (if it has been evaluated) and either way the ID array will contain those values


							--Any unmatched data streams will be loaded and can be done with the RETRIEVE_ACTIVE_RULE_SET_SP procedure
								--change this procedure to use an argument so that data streams that have already been evaluated can be excluded when calling this function to get all of the rule set IDs
									--try use a count(*) query to see if the given PTA rule set already exists for each data stream to determine if we build the rule set input array
										--If so then use the PTA_RULE_SET_ID from the given existing PTA rule set
										--If not then insert the new PTA_RULE_SET_ID and use that one







							--check if all of the data streams that were specified have been evaluated before, if not then











						ELSIF (v_proc_return_code = 0) THEN
							--the parent record's parent issue record (DVM_PTA_ISSUES) does not exist:
							DBMS_OUTPUT.PUT_LINE('The parent issue record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'" was NOT found in the database');

							DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'VALIDATE_PARENT_RECORD('||p_data_stream_codes(1)||', '||p_PK_ID||'): The parent issue record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'" was NOT found in the database.  continue processing: DEFINE_PARENT_ISSUE_REC()', v_proc_return_code);


							--the parent issue record does not already exist, use the data validation criteria that is currently active:
							v_first_validation := true;

							--insert the new parent issue record:
							DEFINE_PARENT_ISSUE_REC (v_rule_set_id_array, v_proc_return_code);

							--check the return code from DEFINE_PARENT_ISSUE_REC():
							IF (v_proc_return_code = 1) THEN

								--the parent issue record was loaded successfully, proceed with the validation process:
								DBMS_OUTPUT.PUT_LINE('The parent issue record was loaded successfully for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"');

								DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'VALIDATE_PARENT_RECORD('||p_data_stream_codes(1)||', '||p_PK_ID||'): The parent issue record was loaded successfully for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'" continue processing: RETRIEVE_ACTIVE_RULE_SET_SP()', v_proc_return_code);


								--determine the active rule set that should be used for this validation:
								DBMS_OUTPUT.PUT_LINE('determine the active rule set that should be used for this validation');

								--retrieve the active rule set (and if the active rule set does not match the currently active validation rules then create new rule sets)
								RETRIEVE_ACTIVE_RULE_SET_SP (p_data_stream_codes, v_rule_set_id_array, v_proc_return_code);
								IF (v_proc_return_code = 1) THEN
									DBMS_OUTPUT.PUT_LINE('The active rule set(s) was retrieved successfully, associate the parent record with the parent issue record');




									--update the parent record to associate it with the new parent issue record (DVM_PTA_ISSUES)
									ASSOC_PARENT_ISSUE_REC (v_proc_return_code);


									--check the return code from ASSOC_PARENT_ISSUE_REC():
									IF (v_proc_return_code = 1) THEN

										--the parent record was updated successfully:
										DBMS_OUTPUT.PUT_LINE('The new parent issue record was associated successfully with the parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"');

										DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'VALIDATE_PARENT_RECORD('||p_data_stream_codes(1)||', '||p_PK_ID||'): The new parent issue record was associated successfully with the parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'" continue processing', v_proc_return_code);

									ELSE
										--The return code from the ASSOC_PARENT_ISSUE_REC() procedure indicates an error: the parent issue record was not updated successfully
										DBMS_OUTPUT.PUT_LINE('The new parent issue record could not be associated successfully with the parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"');


										DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'The new parent issue record could not be associated successfully with the parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'", do not continue processing the record', v_proc_return_code);

										--do not continue processing the record:
										v_continue := false;



									END IF;

								ELSE

									--The return code from the DEFINE_PARENT_ISSUE_REC() procedure indicates an error: the parent issue record was not loaded successfully:
									DBMS_OUTPUT.PUT_LINE('The parent issue record could not be loaded successfully for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"');

									DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'The parent issue record could not be loaded successfully for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'", do not continue processing the record', v_proc_return_code);

									--do not continue processing the record:
									v_continue := false;



								END IF;
							ELSE
								--the active rule set could not be retrieved:
								v_continue := false;

								DBMS_OUTPUT.PUT_LINE('the active rule set could not be retrieved');

								DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'the active rule set could not be retrieved', v_proc_return_code);

							END IF;

						ELSE
							----The return code from the RETRIEVE_PARENT_ISSUE_REC() procedure indicates a database query error
							DBMS_OUTPUT.PUT_LINE('There was a database error when querying for the parent issue record for the data stream code(s) "'||v_data_stream_code_string||'"');

							DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'There was a database error when querying for the parent issue record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'", do not continue processing the record', v_proc_return_code);


							--there was a database error, do not continue processing:
							v_continue := false;


						END IF;

					ELSIF (v_proc_return_code = 0) THEN
						--The return code from the RETRIEVE_PARENT_REC() procedure indicates an error: the parent record does not exist
						DBMS_OUTPUT.PUT_LINE('The parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'" does not exist');

						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'The parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'" does not exist, do not continue processing the record', v_proc_return_code);

						--there is no parent record, do not continue processing:
						v_continue := false;

					ELSE
						--The return code from the RETRIEVE_PARENT_REC() procedure indicates a database query error
						DBMS_OUTPUT.PUT_LINE('There was a database error when querying for the parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"');

						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'There was a database error when querying for the parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"', v_proc_return_code);

						--there was a database error, do not continue processing:
						v_continue := false;

					END IF;

				ELSE
					--The return code from the RETRIEVE_DATA_STREAM_INFO() procedure indicates an error: the data stream code(s) did not resolve to a single parent table, stop processing the data validation module

					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'The return code from the RETRIEVE_DATA_STREAM_INFO() procedure indicates an error: the data stream code(s) did not resolve to a single parent table, stop processing the data validation module for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"', v_proc_return_code);
					--there was more than one parent record indicated by the data stream code(s), do not continue processing:
					v_continue := false;

				END IF;



				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'DVM_PKG.VALIDATE_PARENT_RECORD', 'The supporting DVM and parent records were processes, the value of v_continue is: '||(CASE WHEN v_continue THEN '1' ELSE '0' END), v_proc_return_code);

				--check if the data validation module processing should continue:
				IF v_continue THEN
					--there were no database errors or error conditions, continue processing:

					--retrieve the QC criteria for processing:
					RETRIEVE_QC_CRITERIA (v_rule_set_id_array, v_proc_return_code);

					--check the return code from RETRIEVE_QC_CRITERIA():
					IF (v_proc_return_code = 1) THEN
						--the QC criteria were loaded successfully:

						--evaluate the QC criteria:
						EVAL_QC_CRITERIA (p_data_stream_codes, v_proc_return_code);

						--check the return code from EVAL_QC_CRITERIA():
						IF (v_proc_return_code = 1) THEN
							--The QC Criteria was retrieved and evaluated successfully:
							DBMS_OUTPUT.PUT_LINE('The parent record was evaluated successfully for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"');

							--the data validation criteria evaluation process was successful, commit the SQL transaction
							COMMIT;

						ELSE
							--The return code from the EVAL_QC_CRITERIA() procedure indicates an error processing the QC validation criteria:
							DBMS_OUTPUT.PUT_LINE('The parent record was not evaluated successfully for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"');

							--the data validation criteria evaluation process was not successful, rollback the SQL transaction:
							ROLLBACK;

						END IF;

					ELSE
						--The return code from the RETRIEVE_QC_CRITERIA() procedure indicates an error retrieving the QC validation criteria:

						--there was no DML executed, there is no need to rollback the transaction


						--the QC criteria records were not loaded successfully:
						DBMS_OUTPUT.PUT_LINE('The QC validation criteria records were not loaded successfully');

					END IF;

				END IF;
			END IF;

		EXCEPTION

			--catch all PL/SQL database exceptions:
			WHEN OTHERS THEN
				--catch all other errors:

				--print out error message:
				DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

				--there was a PL/SQL error, rollback the SQL transaction:
				ROLLBACK;

		END VALIDATE_PARENT_RECORD;


		--procedure to generate a placeholder string based on the p_input_string_array elements that are supplied.  p_placeholder_string will contain a comma delimited string with generated placholder values, p_placeholder_array will contain the generated placeholder values, and p_delimited_string will contain a comma delimited string of the p_input_string_array elements:
		PROCEDURE GENERATE_PLACEHOLDERS (p_input_string_array IN VARCHAR_ARRAY_NUM, p_placeholder_string OUT CLOB, p_placeholder_array OUT VARCHAR_ARRAY_NUM, p_delimited_string OUT CLOB) IS

		BEGIN



			--initialize variables:

			--string of comma-delimited placeholders to be used in a dynamic query that will be bound with variables:
			p_placeholder_string := '';

			--string of comma-delimited p_input_string_array array elements for display purposes:
			p_delimited_string := '';

			--array of placeholders that will be used in a dynamic query that will be bound with variables:
			p_placeholder_array.delete;


			--loop through each element in the p_input_string_array
			FOR i IN 1 .. p_input_string_array.COUNT LOOP

				--check if this is the first array element in the processing loop:
				IF (i > 1) THEN

					--this is not the first variable, prepend a comma to generate the comma-delimited strings:
					p_delimited_string := p_delimited_string||', ';
					p_placeholder_string := p_placeholder_string||', ';
				END IF;

				--add the bind placeholder to the delimited string:
				p_placeholder_string := p_placeholder_string||':'||TO_CHAR(i);

				--add the bind placeholder name into the p_placeholder_array variable:
				p_placeholder_array(i) := ':'||TO_CHAR(i);

				--add the current p_input_string_array element to the delimited string for display purposes:
				p_delimited_string := p_delimited_string||v_data_stream_codes(i);

			END LOOP;



		EXCEPTION

			--catch all PL/SQL database exceptions:
			WHEN OTHERS THEN
				--catch all other errors:

				--print out error message:
				DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

		END GENERATE_PLACEHOLDERS;





		--procedure to retrieve the data stream information for the supplied data stream code(s).  This procedure utilizes the DBMS_SQL package because the number of data stream code(s) that are allowed as arguments are only known at runtime:
		PROCEDURE RETRIEVE_DATA_STREAM_INFO (p_proc_return_code OUT PLS_INTEGER) IS

			--procedure variable to store generated SQL statements that are executed in the procedure:
			v_temp_SQL CLOB;

			--variable to retrieve the parent table name for the data stream
			v_temp_par_table VARCHAR2(30);

			--variable to retrieve the parent table PK field name for the data stream:
			v_temp_par_pk_field VARCHAR2(30);

			--variable to store the current data stream being processed:
			v_current_data_stream VARCHAR2(2000);

		BEGIN

	    DBMS_OUTPUT.PUT_LINE('running RETRIEVE_DATA_STREAM_INFO()');

			--initialize the successful return code, it will be changed if any error conditions are found
			p_proc_return_code := 1;

			--initialize the member variable:
			v_data_stream_code_string:= '';

			v_temp_SQL := 'SELECT DATA_STREAM_PAR_TABLE, DATA_STREAM_PK_FIELD FROM DVM_DATA_STREAMS_V WHERE DATA_STREAM_CODE = :DSC';

			FOR i in 1..v_data_stream_codes.COUNT LOOP

				--construct the delimited string containing the data stream codes
				IF (i = 1) THEN
					v_data_stream_code_string := v_data_stream_codes(i);
				ELSE
					v_data_stream_code_string := v_data_stream_code_string||', '||v_data_stream_codes(i);
				END IF;

				--store the current data stream code being processed:
				v_current_data_stream := v_data_stream_codes(i);

--	    	DBMS_OUTPUT.PUT_LINE('query for the parent table and pk field for the current data stream ('||v_data_stream_codes(i)||')');

				EXECUTE IMMEDIATE v_temp_SQL INTO v_temp_par_table, v_temp_par_pk_field using v_data_stream_codes(i);

--				DBMS_OUTPUT.PUT_LINE('The parent table is: '||v_temp_par_table||', and PK field is: '||v_temp_par_pk_field);

				--check if this is the first data stream code retrieved, if so store in the corresponding member variables
				IF (i = 1) THEN
					--this is the first data stream code being checked:
--					DBMS_OUTPUT.PUT_LINE('this is the first data stream code being checked, store the values in the member variables');

					--set the member variable values:
					v_data_stream_par_table := v_temp_par_table;
					v_data_stream_pk_field := v_temp_par_pk_field;

				ELSIF ((v_data_stream_par_table <> v_temp_par_table) OR (v_data_stream_pk_field <> v_temp_par_pk_field)) THEN
--					DBMS_OUTPUT.PUT_LINE('this is not the first data stream and either the parent table or PK field names don''t match, exit with an error');

					p_proc_return_code := -1;

					--the parent table name and parent table PK field are not equivalent:
					EXIT;

				END IF;
			END LOOP;

			--check if there were any errors during processing:
			IF (p_proc_return_code = 1) THEN
				--there were no errors, the data stream code(s) resolved to one parent table and the data streams were found in the database:
				DBMS_OUTPUT.PUT_LINE('there were no errors, the data stream code(s) resolved to one parent table and the data streams were found in the database');

			END IF;



		EXCEPTION

			WHEN NO_DATA_FOUND THEN
				--catch all other errors:

				--print out error message:
				DBMS_OUTPUT.PUT_LINE('Error - the data stream code ('||v_current_data_stream||') was not found in the database');

				--define the return code that indicates that there was processing error due a database or PL/SQL error:
				p_proc_return_code := -1;


			--catch all PL/SQL database exceptions:
			WHEN OTHERS THEN
				--catch all other errors:

				--print out error message:
				DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

				--define the return code that indicates that there was processing error due a database or PL/SQL error:
				p_proc_return_code := -1;

		END RETRIEVE_DATA_STREAM_INFO;



		--procedure to retrieve a parent record based off of the data stream and PK ID supplied:
		PROCEDURE RETRIEVE_PARENT_REC (p_proc_return_code OUT PLS_INTEGER) IS

			--procedure variable to store generated SQL statements that are executed in the procedure:
			v_temp_SQL CLOB;

			--procedure variable that will be used to return the PK field value from the query
			v_return_ID NUMBER;

		BEGIN

	    DBMS_OUTPUT.PUT_LINE('Running RETRIEVE_PARENT_REC()');


			--construct the SQL query the parent table to see if the record exists:
			v_temp_SQL := 'SELECT '||v_data_stream_par_table||'.'||v_data_stream_pk_field||' FROM '||v_data_stream_par_table||' WHERE '||v_data_stream_pk_field||' = :pkid';

--	    DBMS_OUTPUT.PUT_LINE('The parent rec query is: '||v_temp_SQL);


			--execute the query using the PK value supplied in the VALIDATE_PARENT_RECORD() procedure call:
			EXECUTE IMMEDIATE v_temp_SQL INTO v_return_ID USING v_PK_ID;

			--define the return code that indicates that the parent record was found in the database
			p_proc_return_code := 1;

		EXCEPTION

			--catch all PL/SQL database exceptions:
			WHEN NO_DATA_FOUND THEN
				--no records were returned by the query:

				--the parent record does not exist:
				DBMS_OUTPUT.PUT_LINE('The parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'" was not found in the database');

				--set the return code to indicate the parent record was not found:
				p_proc_return_code := 0;

			WHEN OTHERS THEN
				--catch all other errors:

				--print out error message:
				DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

				--define the return code that indicates that there was processing error due a database or PL/SQL error:
				p_proc_return_code := -1;

		END RETRIEVE_PARENT_REC;



		--package procedure that retrieves a parent issue record and returns p_proc_return_code with a code that indicates the result of the operation
		PROCEDURE RETRIEVE_PARENT_ISSUE_REC (p_proc_return_code OUT PLS_INTEGER) IS

			--procedure variable to store generated SQL statements that are executed in the procedure:
			v_temp_SQL CLOB;

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			v_proc_return_code PLS_INTEGER;

		BEGIN

	    DBMS_OUTPUT.PUT_LINE('Running RETRIEVE_PARENT_ISSUE_REC()');


			--construct the query to check if the parent issue record (DVM_PTA_ISSUES) already exists, if so then re-use that PTA_ISS_ID otherwise query for all of the active data validation criteria:
			v_temp_SQL := 'SELECT DVM_PTA_ISSUES.* FROM '||v_data_stream_par_table||' INNER JOIN DVM_PTA_ISSUES ON ('||v_data_stream_par_table||'.PTA_ISS_ID = DVM_PTA_ISSUES.PTA_ISS_ID) WHERE '||v_data_stream_pk_field||' = :pkid';

--	    DBMS_OUTPUT.PUT_LINE('Execute the query: '||v_temp_SQL);

			--execute the query using the PK value supplied in the VALIDATE_PARENT_RECORD() procedure call:
			EXECUTE IMMEDIATE v_temp_SQL INTO v_PTA_ISSUE USING v_PK_ID;

			--set the success code:
			p_proc_return_code := 1;

		EXCEPTION

			--catch all PL/SQL database exceptions:
			WHEN NO_DATA_FOUND THEN
				--no records were returned by the query:

				--no parent issue record exists for the given parent record:
				DBMS_OUTPUT.PUT_LINE('The parent issue record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'" was not found in the database');

				--set the return code to indicate the parent issue record was not found:
				p_proc_return_code := 0;

			WHEN OTHERS THEN
				--catch all other errors:

				--output database error code and message:
				DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

				--define the return code that indicates that there was processing error due a database or PL/SQL error:
				p_proc_return_code := -1;

		END RETRIEVE_PARENT_ISSUE_REC;


		--package procedure to retrieve all of the QC criteria based on whether or not the parent record has been validated before:
		PROCEDURE RETRIEVE_QC_CRITERIA (p_rule_set_id_array IN NUM_ARRAY, p_proc_return_code OUT PLS_INTEGER) IS


			--return code from the dynamic query using the DBMS_SQL package:
			ignore   NUMBER;

			--procedure variable to store generated SQL statements that are executed in the procedure:
			v_temp_SQL CLOB;

			--procedure variable to store the CLOB data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			clobvar  VARCHAR2(2000);

			--procedure variable to store the character string data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			namevar  VARCHAR2(2000);

			--procedure variable to store the numeric data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			numvar   NUMBER;

			--dynamic cursor used with the dynamic SQL query for the DBMS_SQL query method:
	--        TYPE curtype IS REF CURSOR;

			--dynamic cursor ID variable for the dynamic SQL query for the DBMS_SQL query method:
			curid    NUMBER;

			--number used to store the number of columns returned by the dynamic query for the DBMS_SQL query method:
			colcnt   NUMBER;

			--counter variable used when populating the ALL_CRITERIA package variable
			v_all_criteria_pos NUMBER := 1;

			--variable to store the converted
			v_temp_string_array VARCHAR_ARRAY_NUM;

			v_placeholder_string CLOB;
 			v_placeholder_array VARCHAR_ARRAY_NUM;
 			v_delimited_string CLOB;

		BEGIN

      DBMS_OUTPUT.PUT_LINE('Running RETRIEVE_QC_CRITERIA()');




			DBMS_OUTPUT.PUT_LINE('The value of ALL_CRITERIA.COUNT before any processing begins is: '||ALL_CRITERIA.COUNT);


			--convert the numeric IDs to equivalent varchar2 IDs so the same GENERATE_PLACEHOLDERS procedure can be used
			FOR i in 1..v_data_stream_codes.COUNT LOOP

				v_temp_string_array(i) := TO_CHAR(p_rule_set_id_array(i));
      	DBMS_OUTPUT.PUT_LINE('Rule set ('||TO_CHAR(i)||') is: '||TO_CHAR(p_rule_set_id_array(i)));

			END LOOP;



			--generate the placeholders for the rule_set_id values:
			GENERATE_PLACEHOLDERS (v_temp_string_array, v_placeholder_string, v_placeholder_array, v_delimited_string);

			--query for all QC criteria for the specified RULE_SET_ID values (p_rule_set_id_array)
			v_temp_SQL := 'SELECT
			DVM_RULE_SETS_V.OBJECT_NAME,
			DVM_RULE_SETS_V.DATA_STREAM_PK_FIELD,
			DVM_RULE_SETS_V.IND_FIELD_NAME,
			DVM_RULE_SETS_V.ISS_TYPE_COMMENT_TEMPLATE,
			DVM_RULE_SETS_V.ISS_TYPE_ID,
			DVM_RULE_SETS_V.QC_OBJECT_ID,
			DVM_RULE_SETS_V.APP_LINK_TEMPLATE
		  FROM DVM_RULE_SETS_V
			WHERE RULE_SET_ID IN ('||v_placeholder_string||')
		  ORDER BY QC_SORT_ORDER, OBJECT_NAME, ISS_TYPE_ID';

--      DBMS_OUTPUT.PUT_LINE('Query for the QC criteria: '||v_temp_SQL);

		-- Open SQL cursor number:
		  curid := DBMS_SQL.OPEN_CURSOR;

			-- Parse SQL query:
			DBMS_SQL.PARSE(curid, v_temp_SQL, DBMS_SQL.NATIVE);

			--retrieve all of the column descriptions for the dynamic database query:
			DBMS_SQL.DESCRIBE_COLUMNS(curid, colcnt, desctab);

			--loop through each column's description to define each column's data type:
			FOR i IN 1 .. colcnt LOOP

				--save the column position in the array element defined by the column name:
				assoc_field_list (desctab(i).col_name) := i;

				--save the column name in the array element defined by the column position:
				num_field_list (i) := desctab(i).col_name;

				--retrieve column metadata from query results (the select list is known at compile time so it is already known that only numeric and character data types are used).  Check the data type of the current column


		--                DBMS_OUTPUT.PUT_LINE('The current col name is: ' ||desctab(i).col_name || ' col type is: '|| desctab(i).col_type);

				IF desctab(i).col_type = 2 THEN
					--this is a numeric value:

					--define the column data type as a NUMBER
					DBMS_SQL.DEFINE_COLUMN(curid, i, numvar);

				ELSIF desctab(i).col_type IN (1, 96) THEN
					--this is a CHAR/VARCHAR data type:

					--define the column data type as a long character string
					DBMS_SQL.DEFINE_COLUMN(curid, i, namevar, 2000);

				ELSIF desctab(i).col_type = 112 THEN
					--this is a CLOB data type:

					--define the column data type as a long character string
					DBMS_SQL.DEFINE_COLUMN(curid, i, clobvar, 10000);

				END IF;

			END LOOP;




			 -- Bind the query variables, loop through each of the data stream codes defined for the parent table:
			FOR i IN 1 .. v_data_stream_codes.COUNT LOOP
				--loop through the data stream codes:

				--bind the given placeholder variable with the corresponding data stream code value:
				DBMS_SQL.BIND_VARIABLE(curid, v_placeholder_array(i), p_rule_set_id_array(i));

			END LOOP;

			--execute the query
			ignore := DBMS_SQL.EXECUTE(curid);

			--initialize the result row counter:
			v_all_criteria_pos := 1;

			--loop through each QC criteria result set row:
			LOOP

				--fetch the next row if there is another on in the result set:
				IF DBMS_SQL.FETCH_ROWS(curid)>0 THEN

--					DBMS_OUTPUT.PUT_LINE('the value of v_all_criteria_pos is: '||v_all_criteria_pos);

				  --loop through each column in the result set row:
				  FOR i IN 1 .. colcnt LOOP


						--retrieve column metadata from query results:
						IF desctab(i).col_type = 2 THEN
							--this is a numeric value:

							--retrieve the NUMBER value into the procedure variable
							DBMS_SQL.COLUMN_VALUE(curid, i, numvar);

							--check the column name to assign it to the corresponding ALL_CRITERIA element record field values
							IF desctab(i).col_name = 'ISS_TYPE_ID' THEN
								ALL_CRITERIA(v_all_criteria_pos).ISS_TYPE_ID := numvar;

							ELSIF desctab(i).col_name = 'QC_OBJECT_ID' THEN
								ALL_CRITERIA(v_all_criteria_pos).QC_OBJECT_ID := numvar;

							END IF;

						ELSIF desctab(i).col_type IN (1, 96) THEN
							--this is a CHAR/VARCHAR data type:

							DBMS_SQL.COLUMN_VALUE(curid, i, namevar);

							--check the column name to assign it to the corresponding ALL_CRITERIA element record field values
							IF desctab(i).col_name = 'OBJECT_NAME' THEN
								ALL_CRITERIA(v_all_criteria_pos).OBJECT_NAME := namevar;

--								DBMS_OUTPUT.PUT_LINE('The value of the QC object name is: '||namevar);

							ELSIF desctab(i).col_name = 'DATA_STREAM_PK_FIELD' THEN
								ALL_CRITERIA(v_all_criteria_pos).DATA_STREAM_PK_FIELD := namevar;

							ELSIF desctab(i).col_name = 'IND_FIELD_NAME' THEN
								ALL_CRITERIA(v_all_criteria_pos).IND_FIELD_NAME := namevar;

							ELSIF desctab(i).col_name = 'APP_LINK_TEMPLATE' THEN
								ALL_CRITERIA(v_all_criteria_pos).APP_LINK_TEMPLATE := namevar;

							END IF;
						ELSIF desctab(i).col_type = 112 THEN

							--store the column value
							DBMS_SQL.COLUMN_VALUE(curid, i, clobvar);

							--check the column name to assign it to the corresponding ALL_CRITERIA element record field values
							IF desctab(i).col_name = 'ISS_TYPE_COMMENT_TEMPLATE' THEN
								ALL_CRITERIA(v_all_criteria_pos).ISS_TYPE_COMMENT_TEMPLATE := clobvar;
							END IF;

						END IF;

				  END LOOP;

				  --increment the row counter variable:
				  v_all_criteria_pos := v_all_criteria_pos + 1;

			   ELSE

					-- No more rows to process, exit the loop:
					EXIT;
			   END IF;
				END LOOP;
				DBMS_output.put_line('closing curid cursor in retrieve_QC_criteria()');
				DBMS_SQL.CLOSE_CURSOR(curid);


				DBMS_OUTPUT.PUT_LINE('The value of ALL_CRITERIA.COUNT after the current validation rules are loaded is: '||ALL_CRITERIA.COUNT);



				--define the return code that indicates that the QC criteria was successfully retrieved from the database
				p_proc_return_code := 1;


		EXCEPTION

			--catch all PL/SQL database exceptions:
			WHEN OTHERS THEN
				--catch all other errors:

				--print out error message:
				DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

				--define the return code that indicates that there was processing error due a database or PL/SQL error:
				p_proc_return_code := -1;

		END RETRIEVE_QC_CRITERIA;





		--define the parent issue record for the specified rule set (P_RULE_SET_ID)
		PROCEDURE DEFINE_PARENT_ISSUE_REC (p_rule_set_id_array IN NUM_ARRAY, p_proc_return_code OUT PLS_INTEGER) IS

			--procedure variable to store generated SQL statements that are executed in the procedure:
			v_temp_SQL CLOB;
      v_proc_return_code PLS_INTEGER;

		BEGIN

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'DVM_PKG.DEFINE_PARENT_ISSUE_REC', 'Running DVM_PKG.DEFINE_PARENT_ISSUE_REC()', v_proc_return_code);

			--execute the insert query to create a new parent issue record for the given parent record:
			INSERT INTO DVM_PTA_ISSUES (CREATE_DATE) VALUES (SYSDATE) RETURNING PTA_ISS_ID, CREATE_DATE INTO v_PTA_ISSUE.PTA_ISS_ID, v_PTA_ISSUE.CREATE_DATE;


			--insert the new PTA rule sets records:
			FOR i IN 1 .. p_rule_set_id_array.COUNT LOOP
				--insert the new PTA rule set record for the current rule set:
				INSERT INTO DVM_PTA_RULE_SETS (RULE_SET_ID, PTA_ISS_ID, FIRST_EVAL_DATE) VALUES (p_rule_set_id_array(i), v_PTA_ISSUE.PTA_ISS_ID, SYSDATE);

				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'DVM_PKG.DEFINE_PARENT_ISSUE_REC', 'Added the new DVM_PTA_RULES record', v_proc_return_code);


			END LOOP;


			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'DVM_PKG.DEFINE_PARENT_ISSUE_REC', 'For PK ID: '||v_PK_ID||', The DVM_PTA_ISSUES record was inserted successfully: '||v_PTA_ISSUE.PTA_ISS_ID, v_proc_return_code);


			--parent issue record was loaded successfully:
			p_proc_return_code := 1;


		EXCEPTION

			--catch all PL/SQL database exceptions:
			WHEN OTHERS THEN
				--catch all other errors:

				--print out error message:
				DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

				--define the return code that indicates that the parent issue record was not loaded successfully:
				p_proc_return_code := -1;

		END DEFINE_PARENT_ISSUE_REC;


		--associate the parent record with the new parent issue record:
		PROCEDURE ASSOC_PARENT_ISSUE_REC (p_proc_return_code OUT PLS_INTEGER) IS

			--procedure variable to store generated SQL statements that are executed in the procedure:
			v_temp_SQL CLOB;

		BEGIN

	--        DBMS_OUTPUT.PUT_LINE('running ASSOC_PARENT_ISSUE_REC ()');

			--construct the query to update the parent table to associate it with the new parent issue record::
			v_temp_SQL := 'UPDATE '||v_data_stream_par_table||' SET PTA_ISS_ID = :pta_errid WHERE '||v_data_stream_pk_field||' = :pkid';


	--        DBMS_OUTPUT.PUT_LINE('v_temp_SQL is: '||v_temp_SQL);

			--execute the query
			EXECUTE IMMEDIATE v_temp_SQL USING v_PTA_ISSUE.PTA_ISS_ID, v_PK_ID;

			--set the return code to indicate the parent record was successfully associated with the new parent issue record:
			p_proc_return_code := 1;



		EXCEPTION

			--catch all PL/SQL database exceptions:
			WHEN OTHERS THEN
				--catch all other errors:

				--print out error message:
				DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

				--define the return code that indicates that the parent record was not associated with the parent issue record successfully:
				p_proc_return_code := -1;


		END ASSOC_PARENT_ISSUE_REC;


		--evaluate the QC criteria stored in ALL_CRITERIA for the given parent record:
		PROCEDURE EVAL_QC_CRITERIA (p_data_stream_codes IN VARCHAR_ARRAY_NUM, p_proc_return_code OUT PLS_INTEGER) IS

			--procedure variable to store the ALL_CRITERIA array element position so it can be processed using the PROCESS_QC_CRITERIA procedure, this is used during the ALL_CRITERIA main processing loop:
			v_curr_QC_begin_pos PLS_INTEGER;

			--procedure variable to store a boolean that indicates if the processing of QC criteria should continue:
			v_continue BOOLEAN;

			--procedure variable to store the current QC_OBJ_ID value (indicates which QC object from ALL_CRITERIA is currently being processed)
			v_current_QC_OBJ_ID NUMBER;

			--procedure variable to store generated SQL statements that are executed in the procedure:
			v_temp_SQL CLOB;

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			v_proc_return_code PLS_INTEGER;

			--procedure variable to store numeric ISS_ID values for deletion (when existing validation issue records need to be purged if the issue condition no longer applies)
			v_ISS_IDs NUM_ARRAY;

			--procedure variable to store the existing DVM_ISSUES for the given parent issue record
			v_existing_issue_rec_table DVM_ISSUES_TABLE;

			--procedure variable to store the position of the given DVM_ISSUES record while looping through v_existing_issue_rec_table:
			v_existing_issue_rec_counter PLS_INTEGER;

			--procedure variable to store the position of the given DVM_ISSUES record while looping through v_issue_rec_table:
			v_issue_rec_counter PLS_INTEGER;



		BEGIN

	    DBMS_OUTPUT.PUT_LINE('running EVAL_QC_CRITERIA ()');

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'DVM_PKG.EVAL_QC_CRITERIA', 'running EVAL_QC_CRITERIA ()', v_proc_return_code);

			--initialize the tracking variable for the processing loop:
			v_current_QC_OBJ_ID := NULL;

			--initialize the v_continue variable:
			v_continue := true;


--			DBMS_OUTPUT.PUT_LINE('there are '||ALL_CRITERIA.COUNT||' QC criteria to evaluate');

			--loop through the QC criteria to execute each query and process each QC object separately:
			FOR indx IN 1 .. ALL_CRITERIA.COUNT
			LOOP

--				DBMS_OUTPUT.PUT_LINE('indx ('||indx||'), QC object: '||ALL_CRITERIA(indx).OBJECT_NAME);


				--check the QC_OBJECT_ID value:
				IF (v_current_QC_OBJ_ID IS NULL) THEN
					--the QC object ID is NULL, this is the first record in the loop:

					--set the QC object's begin position to 1 since this is the first value to be processed:
					v_curr_QC_begin_pos := 1;

					--initialize the v_current_QC_OBJ_ID variable:
					v_current_QC_OBJ_ID := ALL_CRITERIA(indx).QC_OBJECT_ID;

				ELSIF (v_current_QC_OBJ_ID <> ALL_CRITERIA(indx).QC_OBJECT_ID) THEN
					--this is not the same QC object as the previous issue type:

--					DBMS_OUTPUT.PUT_LINE('this is not the same QC object as the previous issue type, run PROCESS_QC_CRITERIA on the previous QC criteria object()');

					--process the last QC object:
					PROCESS_QC_CRITERIA (v_curr_QC_begin_pos, (indx - 1), v_proc_return_code);

					--check the procedure return code
					IF (v_proc_return_code = -1) THEN

						--there was an error processing the current QC criteria:

						DBMS_OUTPUT.PUT_LINE('There was an error when processing the current QC criteria object: '||ALL_CRITERIA(indx - 1).OBJECT_NAME);

						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', 'DVM_PKG.EVAL_QC_CRITERIA', 'There was an error when processing the current QC criteria object: '||ALL_CRITERIA(indx - 1).OBJECT_NAME, v_proc_return_code);


						--set the continue variable to false:
						v_continue := false;

						--exit the loop, no additional processing is necessary since there was an error processing the validation criteria:
						EXIT;
					END IF;



					--initialize the current QC object:
					v_curr_QC_begin_pos := indx;

					--set the QC_OBJ_ID variable value to the current row's corresponding value:
					v_current_QC_OBJ_ID := ALL_CRITERIA(indx).QC_OBJECT_ID;


				END IF;





			END LOOP;

			--check if there have been any processing errors so far
--			DBMS_OUTPUT.PUT_LINE('check if there have been any processing errors so far');


			IF (v_continue) THEN


--				DBMS_OUTPUT.PUT_LINE('execute the PROCESS_QC_CRITERIA() procedure for the last QC object definition');

				--there are no processing errors, process the last QC criteria:
				PROCESS_QC_CRITERIA (v_curr_QC_begin_pos, ALL_CRITERIA.COUNT, v_proc_return_code);

				--check the procedure return code
				IF (v_proc_return_code = -1) THEN

					--there was an error processing the current QC criteria:
					DBMS_OUTPUT.PUT_LINE('There was an error when processing the current QC criteria object: '||ALL_CRITERIA(v_curr_QC_begin_pos).OBJECT_NAME);

					--set the continue variable to false:
					v_continue := false;

				END IF;



			END IF;


			--check if all of the QC criteria was processed successfully:
			IF (v_continue) THEN
				--the QC criteria was processed successfully, loop through each of the validation issue records that were defined in the package variable by the POPULATE_ISSUE_REC() procedure:

	--            DBMS_OUTPUT.PUT_LINE('insert all of the DVM issues, there are '||v_issue_rec_table.COUNT||' issues to load');

				--check if this is the first time the given record has been validated:
				IF NOT (v_first_validation) THEN
					--this is not the first time the given record has been validated, check the pending issue records against the existing ones:

	        DBMS_OUTPUT.PUT_LINE('This is a revalidation attempt, attempt to purge resolved issues, and add any new issues');


					--determine all of the ISS_ID values of the existing issue records that should be deleted (those are the existing issue records that do not match a pending issue record's generated issue description)
					RETRIEVE_ISSUE_RECS (p_data_stream_codes, v_existing_issue_rec_table, v_proc_return_code);
					IF (v_proc_return_code = 1) then


						DBMS_OUTPUT.PUT_LINE('the validation issue records were retrieved successfully');

						--loop through and compare all existing issue records to the pending issue records:
						v_existing_issue_rec_counter := v_existing_issue_rec_table.FIRST;

						--begin the loop through the existing issue records:
						WHILE v_existing_issue_rec_counter IS NOT NULL LOOP

--		          DBMS_OUTPUT.PUT_LINE ('Looping through the existing issue record ('||v_existing_issue_rec_table(v_existing_issue_rec_counter).ISS_ID||') description: '||v_existing_issue_rec_table(v_existing_issue_rec_counter).ISS_DESC);


							--loop through all pending issue records:
							v_issue_rec_counter := v_issue_rec_table.FIRST;

							--start the loop:
							WHILE v_issue_rec_counter IS NOT NULL LOOP

--								DBMS_OUTPUT.PUT_LINE ('Looping through the pending issue record: '||v_issue_rec_table(v_issue_rec_counter).ISS_DESC);


								--check if the current existing issue description and issue_type_ID matches the pending issue description:
								IF (v_issue_rec_table(v_issue_rec_counter).ISS_DESC = v_existing_issue_rec_table(v_existing_issue_rec_counter).ISS_DESC) AND (v_issue_rec_table(v_issue_rec_counter).ISS_TYPE_ID = v_existing_issue_rec_table(v_existing_issue_rec_counter).ISS_TYPE_ID) THEN
									--the current existing issue description and issue_type_ID matches the pending issue description

		--                            DBMS_OUTPUT.PUT_LINE ('The Pending and Existing record description and issue_type_ID match, remove both the pending and existing nested table elements');


									--remove the current pending issue record from the nested table variable:
									v_issue_rec_table.DELETE(v_issue_rec_counter);

									--remove the current existing issue record from the nested table variable:
									v_existing_issue_rec_table.DELETE(v_existing_issue_rec_counter);

									EXIT;
								END IF;



								--increment to the next pending issue record:
								v_issue_rec_counter := v_issue_rec_table.NEXT(v_issue_rec_counter);

							END LOOP;



							--increment to the next existing issue record:
							v_existing_issue_rec_counter := v_existing_issue_rec_table.NEXT(v_existing_issue_rec_counter);
						END LOOP;




						DBMS_OUTPUT.PUT_LINE('all of the comparisons have been made, delete all of the existing issue records that were not matched ('||v_existing_issue_rec_table.COUNT||' total)');

						--construct the currnet delete DVM_ISSUES record since it doesn't match any pending issue records:
						v_temp_SQL := 'DELETE FROM DVM_ISSUES WHERE ISS_ID = :eid';


						--loop through all of the existing issue records that did not match so they can be deleted:
						v_existing_issue_rec_counter := v_existing_issue_rec_table.FIRST;

						--begin the loop through the existing issue records:
						WHILE v_existing_issue_rec_counter IS NOT NULL LOOP

							DBMS_OUTPUT.PUT_LINE('Delete the existing issue record: '||v_existing_issue_rec_table(v_existing_issue_rec_counter).ISS_ID);


							--store the results of the query into a collection that can be used to insert the new pending issue records:
							EXECUTE IMMEDIATE v_temp_SQL USING v_existing_issue_rec_table(v_existing_issue_rec_counter).ISS_ID;

							--increment to the next existing issue record:
							v_existing_issue_rec_counter := v_existing_issue_rec_table.NEXT(v_existing_issue_rec_counter);

						END LOOP;
					ELSE
						--QC criteria was not processed successfully:
						p_proc_return_code := -1;

						DBMS_OUTPUT.PUT_LINE('There was a problem querying the DVM issue records');

					END IF;
				END IF;

				--construct the parameterized query to insert all of the QC criteria issue records:
				v_temp_SQL := 'INSERT INTO DVM_ISSUES (PTA_ISS_ID, ISS_DESC, CREATE_DATE, CREATED_BY, ISS_TYPE_ID, APP_LINK_URL) VALUES (:p01, :p02, SYSDATE, :p03, :p04, :p05)';


	--            DBMS_OUTPUT.PUT_LINE('insert all of the unmatched pending issue records ('||v_issue_rec_table.COUNT||' total)');

				--loop through each element in the v_issue_rec_table package variable:
				v_issue_rec_counter := v_issue_rec_table.FIRST;

				--start the loop:
				WHILE v_issue_rec_counter IS NOT NULL LOOP

	--                DBMS_OUTPUT.PUT_LINE('insert the issue with issue description: "'||v_issue_rec_table(v_issue_rec_counter).ISS_DESC);

					--execute the QC criteria issue record insert query using the current v_issue_rec_table package variable:
					EXECUTE IMMEDIATE v_temp_SQL USING v_issue_rec_table(v_issue_rec_counter).PTA_ISS_ID, v_issue_rec_table(v_issue_rec_counter).ISS_DESC, sys_context( 'userenv', 'current_schema' ), v_issue_rec_table(v_issue_rec_counter).ISS_TYPE_ID, v_issue_rec_table(v_issue_rec_counter).APP_LINK_URL;

					--increment to the next pending issue record:
					v_issue_rec_counter := v_issue_rec_table.NEXT(v_issue_rec_counter);

				END LOOP;



				--define the return code that indicates that the QC criteria was processed successfully and the corresponding issue records were loaded into the database:
				p_proc_return_code := 1;

			ELSE
				--QC criteria was not processed successfully:
				p_proc_return_code := -1;

			END IF;

		EXCEPTION


			--catch all PL/SQL database exceptions:
			WHEN OTHERS THEN
				--catch all other errors:

				--print out error message:
				DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

				--define the return code that indicates that there was an error when processing the QC validation criteria:
				p_proc_return_code := -1;

		END EVAL_QC_CRITERIA;


		--validate a specific QC criteria in ALL_CRITERIA in the elements from p_begin_pos to p_end_pos
		PROCEDURE PROCESS_QC_CRITERIA (p_begin_pos IN PLS_INTEGER, p_end_pos IN PLS_INTEGER, p_proc_return_code OUT PLS_INTEGER) IS


			--procedure variable to store generated SQL statements that are executed in the procedure:
			v_temp_SQL CLOB;


			TYPE curtype IS REF CURSOR;
			src_cur  curtype;

			--dynamic cursor ID variable for the dynamic SQL query for the DBMS_SQL query method:
			curid    NUMBER;

			--number used to store the number of columns returned by the dynamic query for the DBMS_SQL query method:
			colcnt   NUMBER;

			--procedure variable to store the character string data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			namevar  VARCHAR2(2000);

			--procedure variable to store the numeric data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			numvar   NUMBER;

			--procedure variable to store the date data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			datevar  DATE;

			--procedure variable to store a given DVM_ISSUES record values that is returned by the POPULATE_ISSUE_REC() procedure:
			v_temp_issue_rec DVM_ISSUES%ROWTYPE;

			--procedure variable to store a boolean that indicates if the processing of QC criteria should continue:
			v_continue BOOLEAN;

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			v_proc_return_code PLS_INTEGER;


		BEGIN

--	    DBMS_OUTPUT.PUT_LINE('running PROCESS_QC_CRITERIA ('||p_begin_pos||', '||p_end_pos||')');

			--initialize the v_continue variable:
			v_continue := true;

			--initialize the variables that contain information about the result set:
			assoc_field_list.delete;
			num_field_list.delete;
			desctab.delete;


			--construct the QC query to be executed:
			v_temp_SQL := 'SELECT * FROM '||ALL_CRITERIA(p_begin_pos).OBJECT_NAME||' WHERE '||ALL_CRITERIA(p_begin_pos).DATA_STREAM_PK_FIELD||' = :pkid';

--	    DBMS_OUTPUT.PUT_LINE('the value of the QC query to be executed is: '||v_temp_SQL);

			-- Open REF CURSOR variable:
			OPEN src_cur FOR v_temp_SQL USING v_PK_ID;

			-- Switch from native dynamic SQL to DBMS_SQL package:
			curid := DBMS_SQL.TO_CURSOR_NUMBER(src_cur);

			--retrieve the result set column information:
			DBMS_SQL.DESCRIBE_COLUMNS(curid, colcnt, desctab);

	--        DBMS_OUTPUT.PUT_LINE ('fetching column descriptions');

			-- loop through each column and defined the data type of each column dynamically:
			FOR i IN 1 .. colcnt LOOP
	--          DBMS_OUTPUT.PUT_LINE ('current column name is: '||desctab(i).col_name);

			  --save the column position in the array element defined by the column name (to facilitate the generating of issue messages based on the issue type template value):
			  assoc_field_list (desctab(i).col_name) := i;

			  --save the column name in the array element defined by the column position (to facilitate the generating of issue messages based on the issue type template value):
			  num_field_list (i) := desctab(i).col_name;

			  --retrieve column metadata from query results:
			  IF desctab(i).col_type = 2 THEN
				--define the result set data type as NUMBER for the current column:
				DBMS_SQL.DEFINE_COLUMN(curid, i, numvar);
	--            DBMS_OUTPUT.PUT_LINE ('current numvar is: '||numvar);

			  ELSIF desctab(i).col_type = 12 THEN

				--define the result set data type as DATE for the current column:
				DBMS_SQL.DEFINE_COLUMN(curid, i, datevar);
	--            DBMS_OUTPUT.PUT_LINE ('current datevar is: '||datevar);

				-- statements
			  ELSIF desctab(i).col_type IN (1, 96) THEN
				 --define the result set data type as VARCHAR2 for the current column:
				DBMS_SQL.DEFINE_COLUMN(curid, i, namevar, 2000);
	--            DBMS_OUTPUT.PUT_LINE ('current namevar is: '||namevar);

			  END IF;

			END LOOP;

	--        DBMS_OUTPUT.PUT_LINE ('fetching rows');


			-- Fetch rows with DBMS_SQL package to loop through the result set:
			WHILE DBMS_SQL.FETCH_ROWS(curid) > 0 LOOP

	--            DBMS_OUTPUT.PUT_LINE('fetching new row from result set');

				--loop through the ISSUE_TYPES for the given QC View (all of these values are CHAR/VARCHAR2 fields based on documented requirements):
				FOR j IN p_begin_pos .. p_end_pos LOOP


	--              DBMS_OUTPUT.PUT_LINE ('loop #'||j||' for issue types');

	/*              DBMS_OUTPUT.PUT_LINE ('current IND_FIELD_NAME is: '||ALL_CRITERIA(j).IND_FIELD_NAME);
				  DBMS_OUTPUT.PUT_LINE ('current IND_FIELD_NAME position is: '||assoc_field_list(ALL_CRITERIA(j).IND_FIELD_NAME));
				  DBMS_OUTPUT.PUT_LINE ('current TO_CHAR(ISS_TYPE_COMMENT_TEMPLATE) is: '||TO_CHAR(ALL_CRITERIA(j).ISS_TYPE_COMMENT_TEMPLATE));
				  DBMS_OUTPUT.PUT_LINE ('current CAST(ISS_TYPE_COMMENT_TEMPLATE AS VARCHAR2) is: '||CAST(ALL_CRITERIA(j).ISS_TYPE_COMMENT_TEMPLATE AS VARCHAR2));
				  DBMS_OUTPUT.PUT_LINE ('current DBMS_LOB.SUBSTR(ISS_TYPE_COMMENT_TEMPLATE, 2000, 1) is: '||DBMS_LOB.SUBSTR(ALL_CRITERIA(j).ISS_TYPE_COMMENT_TEMPLATE, 2000, 1));
	*/

				  --retrieve the field name for the current QC criteria IND_FIELD_NAME and retrieve the result set's corresponding column value
				  DBMS_SQL.COLUMN_VALUE(curid, assoc_field_list(ALL_CRITERIA(j).IND_FIELD_NAME), namevar);
	--              DBMS_OUTPUT.PUT_LINE ('The result set value is: '||namevar);


				  --check if the current QC criteria was evaluated to true:
				  IF (namevar = 'Y') THEN
					  --the current QC criteria was evaluated as an issue, generate the issue message:


	--                  DBMS_OUTPUT.PUT_LINE ('The IND_FIELD_NAME ('||ALL_CRITERIA(j).IND_FIELD_NAME||') is ''Y'', evaluate the issue description and save the issue information');
					  --populate the issue rec based on the current QC criteria that was evaluated to true:
					  POPULATE_ISSUE_REC (curid, j, v_temp_issue_rec, v_proc_return_code);

					  --add the issue record information to the v_issue_rec_table array variable for loading into the database later:
					  v_issue_rec_table ((v_issue_rec_table.COUNT + 1)) := v_temp_issue_rec;

					  --re-initialize the issue rec:
					  v_temp_issue_rec := NULL;

					  --check the procedure return code
					  IF (v_proc_return_code = -1) THEN

							--the POPULATE_ISSUE_REC procedure failed, exit the loop:

							--set v_continue to false:
							v_continue := false;

							--exit the loop
							EXIT;

					  END IF;

				  END IF;

				END LOOP;

			END LOOP;

			--close the dynamic cursor:
			DBMS_SQL.CLOSE_CURSOR(curid);
	--		dbms_output.put_line('closing cursor src_cur in PROCESS_QC_CRITERIA()');
	--        close src_cur;

		EXCEPTION
			--catch all PL/SQL database exceptions:
			WHEN OTHERS THEN
				--catch all other errors:

				--print out error message:
				DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

				--define the return code that indicates that there was an error when processing the QC validation criteria:
				p_proc_return_code := -1;


		END PROCESS_QC_CRITERIA;


		--procedure to populate an issue record with the information from the corresponding result set row:
		PROCEDURE POPULATE_ISSUE_REC (curid IN NUMBER, QC_criteria_pos IN NUMBER, issue_rec OUT DVM_ISSUES%ROWTYPE, p_proc_return_code OUT PLS_INTEGER) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			v_proc_return_code PLS_INTEGER;

			--variable to store the generated issue message based off of the ISS_TYPE_COMMENT_TEMPLATE and the runtime values returned by the QC query result set:
			temp_issue_message CLOB;

			--variable to store the generated application link based off of the APP_LINK_TEMPLATE and the runtime values returned by the QC query result set:
			temp_app_link VARCHAR2(2000);


			--procedure variable to store the character string data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			namevar  VARCHAR2(2000);

			--procedure variable to store the numeric data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			numvar   NUMBER;

			--procedure variable to store the date data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			datevar  DATE;

			--procedure variable to store the current field name from the associative array
			temp_field_name VARCHAR2(30);


		BEGIN


	    DBMS_OUTPUT.PUT_LINE('Running POPULATE_ISSUE_REC('||QC_criteria_pos||'), template is: '||ALL_CRITERIA(QC_criteria_pos).ISS_TYPE_COMMENT_TEMPLATE);





			--set the temp_issue_message to the given issue type comment template based on the current result set:
			REPLACE_PLACEHOLDER_VALS (curid, QC_criteria_pos, ALL_CRITERIA(QC_criteria_pos).ISS_TYPE_COMMENT_TEMPLATE, temp_issue_message, v_proc_return_code);
			IF (v_proc_return_code = 1) THEN
				--the placeholders were successfully replaced:
--				DBMS_OUTPUT.PUT_LINE ('the issue description placeholders were successfully replaced: '||temp_issue_message);

				--set the temp_issue_message to the given issue type comment template based on the current result set:
				REPLACE_PLACEHOLDER_VALS (curid, QC_criteria_pos, ALL_CRITERIA(QC_criteria_pos).APP_LINK_TEMPLATE, temp_app_link, v_proc_return_code);
				IF (v_proc_return_code = 1) THEN
					--the placeholders were successfully replaced:
--					DBMS_OUTPUT.PUT_LINE ('the application URL placeholders were successfully replaced: '||temp_app_link);

--			    DBMS_OUTPUT.PUT_LINE('The value of the replaced temp_issue_message is: '||temp_issue_message);
--			    DBMS_OUTPUT.PUT_LINE('The value of the replaced temp_app_link is: '||temp_app_link);

					--set the attribute information for the given issue message so the calling procedure can process the current QC validation issue:
					issue_rec.ISS_DESC := temp_issue_message;
					issue_rec.ISS_TYPE_ID := ALL_CRITERIA(QC_criteria_pos).ISS_TYPE_ID;
					issue_rec.PTA_ISS_ID := v_PTA_ISSUE.PTA_ISS_ID;
					issue_rec.APP_LINK_URL := temp_app_link;




				ELSIF (v_proc_return_code = 0) THEN
					--the placeholders were not all found in the result set:
					DBMS_OUTPUT.PUT_LINE ('the placeholders were not all found in the application URL result set');
					--set the issue code:
					p_proc_return_code := -1;

				ELSE
					--an error occurred when processing the template:
					DBMS_OUTPUT.PUT_LINE ('there was a problem processing the application URL template');

					--set the error code:
					p_proc_return_code := -1;
				END IF;


			ELSIF (v_proc_return_code = 0) THEN
				--the placeholders were not all found in the result set:
				DBMS_OUTPUT.PUT_LINE ('the error description placeholders were not all found in the result set');

				--set the error code:
				p_proc_return_code := -1;

			ELSE
				--an error occurred when processing the template:
				DBMS_OUTPUT.PUT_LINE ('there was a problem processing the issue description template');

				--set the error code:
				p_proc_return_code := -1;

			END IF;






			EXCEPTION
			--catch all PL/SQL database exceptions:
			WHEN OTHERS THEN
				--catch all other errors:

				--print out error message:
				DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

				--define the return code that indicates that there was an error when generating the current QC validation issue message:
				p_proc_return_code := -1;

		END POPULATE_ISSUE_REC;

		--update the parent issue record to indicate that the parent record was re-evaluated:
		PROCEDURE UPDATE_PTA_RULE_SET_LAST_EVAL (p_rule_set_id IN PLS_INTEGER, p_pta_iss_id IN PLS_INTEGER, p_proc_return_code OUT PLS_INTEGER) IS


		BEGIN

			DBMS_OUTPUT.PUT_LINE('Running UPDATE_PTA_RULE_SET_LAST_EVAL ('||p_rule_set_id||', '||p_pta_iss_id||')');

			--update the DVM_PTA_RULE_SETS to update the LAST_EVAL_DATE for the validation rule set that is being re-evaluated:
			UPDATE DVM_PTA_RULE_SETS SET LAST_EVAL_DATE = SYSDATE WHERE PTA_ISS_ID = p_pta_iss_id AND RULE_SET_ID = p_rule_set_id;

			--define the return code that indicates that the parent issue record was updated successfully
			p_proc_return_code := 1;


		EXCEPTION
		--catch all PL/SQL database exceptions:
		WHEN OTHERS THEN
			--catch all other errors:

			--print out error message:
			DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

			--define the return code that indicates that there was an error when updating the parent issue record:
			p_proc_return_code := -1;

		END UPDATE_PTA_RULE_SET_LAST_EVAL;

		--function that will return a comma-delimited list of the placeholder fields that are not in the result set of the given View identified by QC_OBJECT_NAME:
		FUNCTION QC_MISSING_QUERY_FIELDS (ISS_TYPE_COMMENT_TEMPLATE DVM_ISS_TYPES.ISS_TYPE_COMMENT_TEMPLATE%TYPE, QC_OBJECT_NAME DVM_CRITERIA_V.OBJECT_NAME%TYPE) RETURN CLOB IS

			--procedure variable to store generated SQL statements that are executed in the procedure:
			v_temp_SQL CLOB;


			--variable to hold the constructed comma-delimited string of placeholder fields:
			v_temp_return CLOB;

			v_regexp_count PLS_INTEGER;

			v_assoc_fields NUM_ASSOC_VARCHAR;

			v_array_fields VARCHAR_ARRAY_NUM;

			--variable to store all of the result set fields so they can be processed:
			v_result_fields VARCHAR_ARRAY_NUM;


			--Oracle data type to store if a given placeholder was found in the result set:
			TYPE BOOL_ASSOC_VARCHAR IS TABLE OF BOOLEAN INDEX BY PLS_INTEGER;

			--variable to track if the given field name has been seen before:
			v_array_found_fields BOOL_ASSOC_VARCHAR;

			--maximum length of the placeholder should be 30 characters since it is a View column name, the brackets add two extra characters:
			v_field_name VARCHAR2(32);

			v_first_unmatched_field BOOLEAN;

			v_proc_return_code PLS_INTEGER;

		BEGIN

			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DVM_PKG.QC_MISSING_QUERY_FIELDS', 'running QC_MISSING_QUERY_FIELDS('||ISS_TYPE_COMMENT_TEMPLATE||', '|| QC_OBJECT_NAME||')', v_proc_return_code);
			--count the number of occurences of placeholders:
			v_regexp_count := REGEXP_COUNT(ISS_TYPE_COMMENT_TEMPLATE, '\[[A-Z0-9\_]{1,}\]');

			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DVM_PKG.QC_MISSING_QUERY_FIELDS', 'There are '||v_regexp_count||' placeholder occurrences', v_proc_return_code);

			IF (v_regexp_count > 0) THEN

				--loop through each placeholder and store them in an array:
				FOR i in 1..v_regexp_count LOOP



					--find the i oocurence of the pattern in the string:
					v_field_name := regexp_substr(ISS_TYPE_COMMENT_TEMPLATE, '\[([A-Z0-9\_]{1,})\]', 1, i, 'i', 1) ;

					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DVM_PKG.QC_MISSING_QUERY_FIELDS', 'The current placeholder name is: '||v_field_name, v_proc_return_code);

					--strip off the enclosing brackets from the field name:
--					v_field_name := SUBSTR(v_field_name, 2, LENGTH(v_field_name) - 2) ;

					--store the field name in the v_array_fields variable:
					v_array_fields(i) := v_field_name;

					--store the field position in the v_assoc_fields variable:
					v_assoc_fields(v_field_name) := i;

					--initialize the array that the given placeholder was not found yet:
					v_array_found_fields(i) := false;

				END LOOP;



				--query for all of the fields in the result set and mark off each


				v_temp_SQL := 'SELECT ALL_TAB_COLUMNS.COLUMN_NAME
				FROM SYS.ALL_OBJECTS
				INNER JOIN SYS.ALL_TAB_COLUMNS
				ON ALL_OBJECTS.OWNER        = ALL_TAB_COLUMNS.OWNER
				AND ALL_OBJECTS.OBJECT_NAME = ALL_TAB_COLUMNS.TABLE_NAME
				WHERE ALL_OBJECTS.OBJECT_TYPE IN (''VIEW'', ''TABLE'')
				AND ALL_OBJECTS.OWNER = sys_context(''userenv'', ''current_schema'')
				AND ALL_OBJECTS.OBJECT_NAME IN (:p01)';

				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DVM_PKG.QC_MISSING_QUERY_FIELDS', 'Execute the following query using the QC_OBJECT_NAME value ('||QC_OBJECT_NAME||') : '||v_temp_SQL, v_proc_return_code);

				EXECUTE IMMEDIATE v_temp_SQL BULK COLLECT INTO v_result_fields USING QC_OBJECT_NAME;


				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DVM_PKG.QC_MISSING_QUERY_FIELDS', 'The query was executed successfully', v_proc_return_code);

				--loop through all of the result set rows:
				FOR i IN 1 .. v_result_fields.COUNT LOOP

					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DVM_PKG.QC_MISSING_QUERY_FIELDS', 'Check if the result field '||v_result_fields(i)||' was found in the list of placeholders', v_proc_return_code);

					--loop through each of the issue templates'
					FOR j in 1.. v_array_fields.COUNT LOOP


						DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DVM_PKG.QC_MISSING_QUERY_FIELDS', 'The current placeholder name is: '||v_array_fields(j), v_proc_return_code);

						--check if the current placeholder field name matches the current QC object's column name or if the placeholder is an APEX reserved placeholder: [APP_ID] or [APP_SESSION]:
						IF (v_array_fields(j) = v_result_fields(i)) OR (v_array_fields(j) = 'APP_ID') OR (v_array_fields(j) = 'APP_SESSION') THEN

							--the current field was found, update the tracking array:
							v_array_found_fields(j) := true;

							DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DVM_PKG.QC_MISSING_QUERY_FIELDS', 'The current placeholder matches the current field name', v_proc_return_code);
							--exit the current loop (commented out because it would ignore any subsequent occurences of the same placeholder that match a result set field name)
							--EXIT;

						END IF;



					END LOOP;


				END LOOP;


				--initialize tracking field:
				v_first_unmatched_field := true;

				--initialize return variable:
				v_temp_return := '';

				--loop through the array fields:
				FOR j in 1.. v_array_fields.COUNT LOOP

					--check if the current placeholder field name matches the current QC object's column name:
					IF (NOT v_array_found_fields(j)) THEN
						--a match was found in the result set:




						--check if this is the first field:
						IF v_first_unmatched_field THEN


							v_first_unmatched_field := false;

						ELSE
							--this is not the first placeholder that was not matched, add the comma delimiter:
							v_temp_return := v_temp_return||', ';


						END IF;

						--add the current field name to the delimited string:
						v_temp_return := v_temp_return||v_array_fields(j);

					END IF;



				END LOOP;

				--check if all of the placeholders were found in the result set:
				IF (v_first_unmatched_field) THEN
					v_temp_return := NULL;
				END IF;




			ELSE
				--no placeholders found:
				v_temp_return := NULL;

			END IF;





			RETURN v_temp_return;


			EXCEPTION
			--catch all PL/SQL database exceptions:
			WHEN OTHERS THEN
				--catch all other errors:

				--print out error message:
				DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

				DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'DVM_PKG.QC_MISSING_QUERY_FIELDS', 'The error code is ' || SQLCODE || '- ' || SQLERRM, v_proc_return_code);

				--since there was an error return NULL:
				v_temp_return := NULL;

				RETURN v_temp_return;

		END QC_MISSING_QUERY_FIELDS;




		--procedure that replaces all placeholders in P_TEMPLATE_VALUE with the corresponding values in the result set row specified by curid for the QC criteria identified by QC_criteria_pos and returns the rekaced value as P_REPLACED_VALUE.  p_proc_return_code will contain 1 if the operation was successful, 0 if there were unmatched placeholders other than the APEX reserved placeholders ([APP_SESSION], [APP_ID]) that are required to generate a valid APEX URL
		PROCEDURE REPLACE_PLACEHOLDER_VALS (curid IN NUMBER, QC_criteria_pos IN NUMBER, P_TEMPLATE_VALUE IN VARCHAR2, P_REPLACED_VALUE OUT VARCHAR2, p_proc_return_code OUT PLS_INTEGER) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			v_proc_return_code PLS_INTEGER;

			--procedure variable to store the character string data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			namevar  VARCHAR2(2000);

			--procedure variable to store the numeric data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			numvar   NUMBER;

			--procedure variable to store the date data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			datevar  DATE;

			--maximum length of the placeholder should be 30 characters since it is a View column name:
			v_field_name VARCHAR2(30);

			--variable to store the value of the converted character string value for the given result set row's placeholder field
			v_field_value VARCHAR(2000);

			--procedure variable to store the CLOB data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			clobvar  VARCHAR2(2000);

			v_regexp_count PLS_INTEGER;

			--variable to track if the current field type has ben found and processed successfully
			v_field_data_type_found BOOLEAN;

		begin

--			DBMS_OUTPUT.PUT_LINE('running REPLACE_PLACEHOLDER_VALS ('||curid||', '||P_TEMPLATE_VALUE||')');

			--initialize the success return code, it will be changed if there are any issues processing the current template
			p_proc_return_code := 1;


			IF (P_TEMPLATE_VALUE IS NULL) THEN
				--the P_TEMPLATE_VALUE is null:

				DBMS_OUTPUT.PUT_LINE('The template value is null');

			ELSE
				--the P_TEMPLATE_VALUE is not null:




				--initialize the replaced return variable
				P_REPLACED_VALUE := P_TEMPLATE_VALUE;

				--count the number of occurences of placeholders:
				v_regexp_count := REGEXP_COUNT(P_TEMPLATE_VALUE, '\[[A-Z0-9\_]{1,}\]');

--				DBMS_OUTPUT.PUT_LINE('There are '||v_regexp_count||' placeholder occurrences');


				IF (v_regexp_count > 0) THEN

					--loop through each placeholder and store them in an array:
					FOR i in 1..v_regexp_count LOOP

						--find the i oocurence of the pattern in the string:
						v_field_name := regexp_substr(P_TEMPLATE_VALUE, '\[([A-Z0-9\_]{1,})\]', 1, i, 'i', 1) ;


--						DBMS_OUTPUT.PUT_LINE('The current placeholder name is: '||v_field_name);

						--strip off the enclosing brackets from the field name:
	--					v_field_name := SUBSTR(v_field_name, 2, LENGTH(v_field_name) - 2) ;

						IF NOT (v_field_name = 'APP_ID' OR v_field_name = 'APP_SESSION') THEN
							--this is not an APEX reserved placeholder name that will be replaced by the application values in APEX so don't attempt to replace them
--							DBMS_OUTPUT.PUT_LINE('This is NOT an APEX reserved placeholder name, check to see if the placeholder is included in the result set');

							--check if this field is found in the corresponding result set:
							IF assoc_field_list.exists(v_field_name) then
								--the field exists in the result set, replace the placeholder value with the corresponding field value:
--								DBMS_OUTPUT.PUT_LINE('The placeholder exists, replace the placeholder with the corresponding result set value');

								--initialize the field found variable value
								v_field_data_type_found := TRUE;

								IF (desctab(assoc_field_list(v_field_name)).col_type IN (1, 96)) THEN
								  --retrieve the character column data type value into the namevar variable:
								  DBMS_SQL.COLUMN_VALUE(curid, assoc_field_list(v_field_name), namevar);

									--set the field value to the varchar/char variable
									v_field_value := namevar;


								ELSIF (desctab(assoc_field_list(v_field_name)).col_type = 2) THEN
								  --retrieve the NUMBER column data type value into the numvar variable:
								  DBMS_SQL.COLUMN_VALUE(curid, assoc_field_list(v_field_name), numvar);

									--set the field value to the converted character string for the numeric value
									v_field_value := TO_CHAR(numvar);
								ELSIF (desctab(assoc_field_list(v_field_name)).col_type = 12) THEN
								  --this is a DATE field:
								  --retrieve the DATE column data type value into the datevar variable:
								  DBMS_SQL.COLUMN_VALUE(curid, assoc_field_list(v_field_name), datevar);

									--set the field value to the converted character string for the date variable
									v_field_value := TO_CHAR(datevar);

								ELSIF (desctab(assoc_field_list(v_field_name)).col_type = 112) THEN
								  --this is a CLOB field:
								  --retrieve the CLOB column data type value into the clobvar variable:
								  DBMS_SQL.COLUMN_VALUE(curid, assoc_field_list(v_field_name), clobvar);

									--set the field value to the character string for the clob variable
									v_field_value := clobvar;

								ELSE
									--this field type is not handled in the processing code, exit the loop with an error code:

	--								DBMS_OUTPUT.PUT_LINE('The placeholder field for the result set row was an unexpected field type: '||desctab(assoc_field_list(v_field_name)).col_type);

									--set the error code:
									p_proc_return_code := -1;

									--initialize the field found variable value
									v_field_data_type_found := FALSE;


									EXIT;




								END IF;

								IF v_field_data_type_found THEN
--									DBMS_OUTPUT.PUT_LINE('The placeholder field was found and successfully retrieved ('||v_field_value||')');

									P_REPLACED_VALUE := REPLACE(P_REPLACED_VALUE, '['||v_field_name||']', v_field_value);

--									DBMS_OUTPUT.PUT_LINE('The value of the replaced value is: '||P_REPLACED_VALUE);
								END IF;


							ELSE
								--the field does not exist in the result set
--								DBMS_OUTPUT.PUT_LINE('Error - The placeholder ['||v_field_name||'] does not exist in the '||ALL_CRITERIA(QC_criteria_pos).OBJECT_NAME||' QC View result set');

								p_proc_return_code := 0;


							END IF;

/*						ELSE
							--this is an APEX reserved placeholder name that will be replaced by the application values in APEX so don't attempt to replace them
							DBMS_OUTPUT.PUT_LINE('This is an APEX reserved placeholder name, skip this field');
*/

						END IF;


					END LOOP;

/*				ELSE
					--no placeholders were found in the :
					DBMS_OUTPUT.PUT_LINE('There were no placeholders found');
*/
				END IF;
			END IF;

			EXCEPTION
				WHEN OTHERS THEN
					--print out error message:
					DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

					--set the error code:
					p_proc_return_code := -1;

		END REPLACE_PLACEHOLDER_VALS;


		--check to see if there is an active rule set, if not a new rule set will be created with the new validation criteria (check count(*) to see if there is at least one active criteria, if not then return an error code). if so then the procedure will check to see if the active rule set is the same as the active set of validation criteria, if so then it will return the rule_set_id in P_rule_set_id parameter if not it will deactivate the rule set and insert a new active rule set with the current active rules:
		procedure RETRIEVE_ACTIVE_RULE_SET_SP (p_data_stream_codes IN VARCHAR_ARRAY_NUM, p_rule_set_id_array OUT NUM_ARRAY, p_proc_return_code OUT PLS_INTEGER) IS


			V_NUM_active_rules PLS_INTEGER;

			V_NEW_RULE_SET_ID PLS_INTEGER;

			V_NUM_active_criteria PLS_INTEGER;

			V_VALUES_MATCH CHAR(1);

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			v_proc_return_code PLS_INTEGER;



			--procedure variable to store generated SQL statements that are executed in the procedure:
			v_temp_SQL CLOB;

			--dynamic cursor ID variable for the dynamic SQL query for the DBMS_SQL query method:
			curid    NUMBER;

			--number used to store the number of columns returned by the dynamic query for the DBMS_SQL query method:
			colcnt   NUMBER;

			--procedure variable to store the numeric data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			numvar   NUMBER;

			--return code from the dynamic query using the DBMS_SQL package:
			ignore   NUMBER;

			--variable to store the RULE_SET_ID value of the inserted DVM_RULE_SETS record:
			P_rule_set_id PLS_INTEGER;


		BEGIN

			DBMS_OUTPUT.PUT_LINE('running RETRIEVE_ACTIVE_RULE_SET_SP()');




			v_temp_SQL := 'SELECT COUNT(*) FROM DVM_CRITERIA_V WHERE ISS_TYPE_ACTIVE_YN = ''Y''
			AND QC_OBJ_ACTIVE_YN = ''Y''
			AND DATA_STREAM_CODE IN (:DSC)';

			DBMS_OUTPUT.PUT_LINE('the query is: '||v_temp_SQL);

			 -- Bind the query variables, loop through each of the data stream codes defined for the parent table:
			FOR i IN 1 .. p_data_stream_codes.COUNT LOOP
				--loop through the data stream codes:

				DBMS_OUTPUT.PUT_LINE('query for the active validation criteria for the current data stream code ('||p_data_stream_codes(i)||')');

				EXECUTE IMMEDIATE v_temp_SQL INTO V_NUM_active_criteria using p_data_stream_codes(i);


				DBMS_OUTPUT.PUT_LINE('the number of active validation criteria for the current data stream is: '||TO_CHAR(V_NUM_active_criteria));



				IF (V_NUM_active_criteria > 0) THEN


					--check if there are more than one active validation criteria:

					DBMS_OUTPUT.PUT_LINE('There is at least one active validation criteria');

					--query for all active rule sets for the current data stream
					SELECT COUNT(*) into V_NUM_active_rules FROM
						DVM_RULE_SETS
						INNER JOIN DVM_DATA_STREAMS
						ON DVM_RULE_SETS.DATA_STREAM_ID = DVM_DATA_STREAMS.DATA_STREAM_ID
						WHERE RULE_SET_ACTIVE_YN = 'Y' AND DATA_STREAM_CODE = p_data_stream_codes(i);

					DBMS_OUTPUT.PUT_LINE('The value of V_NUM_active_rules is: '||V_NUM_active_rules);

					--check how many active rules there are
					IF (V_NUM_active_rules = 0) THEN
						--there are no active rules, create the new rule set and populate it with the current active rules

						DBMS_OUTPUT.PUT_LINE('there are no active rules, create the new rule set and populate it with the current active rules');

						--insert the rule set
						DEFINE_RULE_SET_SP (p_data_stream_codes(i), P_rule_set_id, v_proc_return_code);

						IF (v_proc_return_code = 1) THEN

							DBMS_OUTPUT.PUT_LINE('the new rule set was successfully inserted, rule_set_id: '||P_rule_set_id);

							--add the rule set to the rule set id array so it can be used to retrieve the QC criteria:
							p_rule_set_id_array(i) := P_rule_set_id;


							--set the success code:
							p_proc_return_code := 1;
						ELSE

							DBMS_OUTPUT.PUT_LINE('the new rule set was NOT successfully inserted');

							p_proc_return_code := v_proc_return_code;

						END IF;


					ELSIF (V_NUM_active_rules > 1) THEN
						--there are more than one active rule set, throw an error and exit:

						p_proc_return_code := 0;
						DBMS_OUTPUT.PUT_LINE('there are more than one active rule set, throw an error and exit');


					ELSE
						--there is only one active rule set, check if it's the same as the currently active set:
						DBMS_OUTPUT.PUT_LINE('there is only one active rule set, check if it''s the same as the currently active set');

						--check if the active rule set and the active validation crtieria are the same, if so then use the existing RULE_SET_ID for the current record

						--if not then disable the current rule set and add the new one:

						SELECT CASE WHEN COUNT(*) = 0 THEN 'Y' ELSE 'N' END VALUES_MATCH_YN INTO V_VALUES_MATCH FROM

						((SELECT ISS_TYPE_ID FROM
						DVM_RULE_SETS_V WHERE RULE_SET_ACTIVE_YN = 'Y' AND DATA_STREAM_CODE = p_data_stream_codes(i)
						MINUS
						SELECT ISS_TYPE_ID FROM
						DVM_CRITERIA_V WHERE QC_OBJ_ACTIVE_YN = 'Y' AND ISS_TYPE_ACTIVE_YN = 'Y' AND  DATA_STREAM_CODE = p_data_stream_codes(i))
						union all

						(SELECT ISS_TYPE_ID FROM
						DVM_CRITERIA_V WHERE QC_OBJ_ACTIVE_YN = 'Y' AND ISS_TYPE_ACTIVE_YN = 'Y' AND DATA_STREAM_CODE = p_data_stream_codes(i)
						MINUS
						SELECT ISS_TYPE_ID FROM
						DVM_RULE_SETS_V WHERE RULE_SET_ACTIVE_YN = 'Y' AND DATA_STREAM_CODE = p_data_stream_codes(i)));

						DBMS_OUTPUT.PUT_LINE('query for the active rule set for the current data stream');


						--check to see if the active rule set matches the active validation rules
						IF (V_VALUES_MATCH = 'Y') THEN
							--the values match, use the active rule set for the new PTA issue record:
							DBMS_OUTPUT.PUT_LINE('the values match, use the active rule set for the new PTA issue record');

							SELECT DISTINCT RULE_SET_ID INTO V_NEW_RULE_SET_ID FROM DVM_RULE_SETS_V where RULE_SET_ACTIVE_YN = 'Y' AND DATA_STREAM_CODE = p_data_stream_codes(i);


							DBMS_OUTPUT.PUT_LINE('the active rule set ID for the data stream ('||p_data_stream_codes(i)||') is: '||V_NEW_RULE_SET_ID);

							--add the rule set to the rule set id array so it can be used to retrieve the QC criteria:
							p_rule_set_id_array(i) := V_NEW_RULE_SET_ID;

							p_proc_return_code := 1;

						ELSE
							--the values do not match, deactivate the active rule set and add the new rule set:

							DBMS_OUTPUT.PUT_LINE('the current active validation rules do not match the active rule set');

							UPDATE DVM_RULE_SETS SET RULE_SET_INACTIVE_DATE = SYSDATE, RULE_SET_ACTIVE_YN = 'N' WHERE DATA_STREAM_ID IN (SELECT DATA_STREAM_ID FROM DVM_DATA_STREAMS WHERE DATA_STREAM_CODE = p_data_stream_codes(i)) AND RULE_SET_ACTIVE_YN = 'Y';

							DBMS_OUTPUT.PUT_LINE('The active rule set was disabled, insert the new active rule set');

							DEFINE_RULE_SET_SP (p_data_stream_codes(i), P_rule_set_id, v_proc_return_code);


							IF (v_proc_return_code = 1) THEN

								DBMS_OUTPUT.PUT_LINE('the new rule set was successfully inserted');


								--add the rule set to the rule set id array so it can be used to retrieve the QC criteria:
								p_rule_set_id_array(i) := P_rule_set_id;


								--set the success code:
								p_proc_return_code := 1;
							ELSE

								DBMS_OUTPUT.PUT_LINE('the new rule set was NOT successfully inserted');

								p_proc_return_code := v_proc_return_code;

							END IF;

						END IF;

					END IF;

					--check to see if the retrieval of rule_set_ids was successful:
					IF (p_proc_return_code = 1) THEN


						--insert the new DVM_PTA_RULE_SETS record(s) that have not been processed for the specified parent issue record:
						DBMS_OUTPUT.PUT_LINE('insert the new DVM_PTA_RULE_SETS record(s) that have not been processed for the specified parent issue record');

						FOR i in 1..p_rule_set_id_array.COUNT LOOP
							DBMS_OUTPUT.PUT_LINE('insert the DVM_PTA_RULE_SETS record for the current rule set');

							INSERT INTO DVM_PTA_RULE_SETS (RULE_SET_ID, PTA_ISS_ID, FIRST_EVAL_DATE, LAST_EVAL_DATE) VALUES (p_rule_set_id_array(i), v_PTA_ISSUE.PTA_ISS_ID, SYSDATE, SYSDATE);


						END LOOP;



					END IF;



				ELSE

					--there are no active validation criteria -> throw an error and rollback the transaction:
					p_proc_return_code := 0;
					DBMS_OUTPUT.PUT_LINE('there are no active validation criteria -> throw an error and rollback the transaction');

				END IF;



			END LOOP;






			EXCEPTION
				WHEN OTHERS THEN
					--print out error message:
					DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

					--set the error code:
					p_proc_return_code := -1;

		END RETRIEVE_ACTIVE_RULE_SET_SP;

		--procedure that defines a new rule set and associates all active issue types with the new rule set:
		--the p_rule_set_id contains the RULE_SET_ID value from the newly inserted DVM_PTA_RULE_SETS record and p_proc_return_code contains 1 if it was successful and 0 if there was a processing error
		PROCEDURE DEFINE_RULE_SET_SP (p_data_stream_code IN VARCHAR2, p_rule_set_id OUT PLS_INTEGER, p_proc_return_code OUT PLS_INTEGER) IS

			v_temp_SQL VARCHAR2(2000);


			v_proc_return_code PLS_INTEGER;

			V_ISS_TYPE_IDS NUM_ARRAY;

		BEGIN

			DBMS_OUTPUT.PUT_LINE('running DEFINE_RULE_SET_SP ('||p_data_stream_code||')');

			INSERT INTO DVM_RULE_SETS (RULE_SET_ACTIVE_YN, RULE_SET_CREATE_DATE, DATA_STREAM_ID) VALUES ('Y', SYSDATE, (SELECT DATA_STREAM_ID FROM DVM_DATA_STREAMS WHERE DATA_STREAM_CODE = p_data_stream_code)) RETURNING RULE_SET_ID INTO p_rule_set_id;

			DBMS_OUTPUT.PUT_LINE('The Rule set insert query was successful: '||p_rule_set_id);

			--select all issue types and insert them into the DVM_ISS_TYP_ASSOC table for the validation rule set
			v_temp_SQL := 'SELECT
					DVM_CRITERIA_V.ISS_TYPE_ID
					FROM DVM_CRITERIA_V
					WHERE ISS_TYPE_ACTIVE_YN = ''Y''
					AND QC_OBJ_ACTIVE_YN = ''Y''
					AND DATA_STREAM_CODE IN (:DSC)';

			DBMS_OUTPUT.PUT_LINE('The select DVM criteria query is: '||v_temp_SQL);

			EXECUTE IMMEDIATE v_temp_SQL BULK COLLECT into V_ISS_TYPE_IDS USING p_data_stream_code;
			--loop through each of the
			FOR i IN 1 .. V_ISS_TYPE_IDS.count LOOP

				DBMS_OUTPUT.PUT_LINE('Insert the issue type ID is: '||V_ISS_TYPE_IDS(i));

				INSERT INTO DVM_ISS_TYP_ASSOC (RULE_SET_ID, ISS_TYPE_ID) VALUES (p_rule_set_id, V_ISS_TYPE_IDS(i));

				DBMS_OUTPUT.PUT_LINE('The issue type ID association record was inserted successfully');

			END LOOP;

			--set the success code:
			p_proc_return_code := 1;


			EXCEPTION
				WHEN OTHERS THEN
					--print out error message:
					DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

					--set the error code:
					p_proc_return_code := 0;


		END DEFINE_RULE_SET_SP;

		--this procedure queries for all issue records that are related to validation rule sets associated with the p_data_stream_codes data stream(s) so they can be compared to the issues that were just identified by the DVM
		PROCEDURE RETRIEVE_ISSUE_RECS (p_data_stream_codes IN VARCHAR_ARRAY_NUM, p_issue_recs OUT DVM_ISSUES_TABLE, p_proc_return_code OUT PLS_INTEGER) IS


			--return code from the dynamic query using the DBMS_SQL package:
			ignore   NUMBER;

			--procedure variable to store generated SQL statements that are executed in the procedure:
			v_temp_SQL CLOB;

			--procedure variable to store the CLOB data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			clobvar  VARCHAR2(2000);

			--procedure variable to store the character string data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			namevar  VARCHAR2(2000);

			--procedure variable to store the numeric data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			numvar   NUMBER;

			--dynamic cursor used with the dynamic SQL query for the DBMS_SQL query method:
	--        TYPE curtype IS REF CURSOR;

			--dynamic cursor ID variable for the dynamic SQL query for the DBMS_SQL query method:
			curid    NUMBER;

			--number used to store the number of columns returned by the dynamic query for the DBMS_SQL query method:
			colcnt   NUMBER;

			--counter variable used when populating the ALL_CRITERIA package variable
			v_issue_pos NUMBER := 1;

			--placeholder string for the rule set IDs
			v_placeholder_string CLOB;

			--placeholder array for the rule set IDs
 			v_placeholder_array VARCHAR_ARRAY_NUM;

			--string to store the comma-delimited delimited rule set IDs
 			v_delimited_string CLOB;

		BEGIN

			DBMS_OUTPUT.PUT_LINE ('running RETRIEVE_ISSUE_RECS()');

			--generate the placeholders for the rule_set_id values:
			GENERATE_PLACEHOLDERS (p_data_stream_codes, v_placeholder_string, v_placeholder_array, v_delimited_string);



			--query for all QC criteria for the specified RULE_SET_ID values (p_rule_set_id_array)
			v_temp_SQL := 'SELECT
			DVM_PTA_ISSUES_V.ISS_ID,
			DVM_PTA_ISSUES_V.PTA_ISS_ID,
			DVM_PTA_ISSUES_V.ISS_TYPE_ID,
			DVM_PTA_ISSUES_V.ISS_NOTES,
			DVM_PTA_ISSUES_V.ISS_RES_TYPE_ID,
			DVM_PTA_ISSUES_V.ISS_DESC,
			DVM_PTA_ISSUES_V.APP_LINK_URL
			FROM DVM_PTA_ISSUES_V
			INNER JOIN
			DVM_RULE_SETS_V
			ON DVM_PTA_ISSUES_V.ISS_TYPE_ID = DVM_RULE_SETS_V.ISS_TYPE_ID
      INNER JOIN DVM_PTA_RULE_SETS ON
			DVM_PTA_ISSUES_V.PTA_ISS_ID = DVM_PTA_RULE_SETS.PTA_ISS_ID
			AND DVM_PTA_RULE_SETS.RULE_SET_ID = DVM_RULE_SETS_V.RULE_SET_ID
			WHERE DVM_PTA_ISSUES_V.PTA_ISS_ID = :PTAISSUEID
			AND DVM_RULE_SETS_V.DATA_STREAM_CODE IN ('||v_placeholder_string||')';

--			DBMS_OUTPUT.PUT_LINE ('run the query: '||v_temp_SQL);

		-- Open SQL cursor number:
		  curid := DBMS_SQL.OPEN_CURSOR;

			-- Parse SQL query:
			DBMS_SQL.PARSE(curid, v_temp_SQL, DBMS_SQL.NATIVE);

			--retrieve all of the column descriptions for the dynamic database query:
			DBMS_SQL.DESCRIBE_COLUMNS(curid, colcnt, desctab);

			--loop through each column's description to define each column's data type:
			FOR i IN 1 .. colcnt LOOP

				--retrieve column metadata from query results (the select list is known at compile time so it is already known that only numeric and character data types are used).  Check the data type of the current column


		--                DBMS_OUTPUT.PUT_LINE('The current col name is: ' ||desctab(i).col_name || ' col type is: '|| desctab(i).col_type);

				IF desctab(i).col_type = 2 THEN
					--this is a numeric value:

					--define the column data type as a NUMBER
					DBMS_SQL.DEFINE_COLUMN(curid, i, numvar);

				ELSIF desctab(i).col_type IN (1, 96) THEN
					--this is a CHAR/VARCHAR data type:

					--define the column data type as a long character string
					DBMS_SQL.DEFINE_COLUMN(curid, i, namevar, 2000);

				ELSIF desctab(i).col_type = 112 THEN
					--this is a CLOB data type:

					--define the column data type as a long character string
					DBMS_SQL.DEFINE_COLUMN(curid, i, clobvar, 10000);

				END IF;

			END LOOP;



			--bind the PTA_issue_ID:
			DBMS_SQL.BIND_VARIABLE(curid, ':PTAISSUEID', v_PTA_ISSUE.PTA_ISS_ID);
			 -- Bind the query variables, loop through each of the data stream codes defined for the parent table:
			FOR i IN 1 .. p_data_stream_codes.COUNT LOOP
				--loop through the data stream codes:

				--bind the given placeholder variable with the corresponding data stream code value:
				DBMS_SQL.BIND_VARIABLE(curid, v_placeholder_array(i), p_data_stream_codes(i));

			END LOOP;

			--execute the query
			ignore := DBMS_SQL.EXECUTE(curid);

			--initialize the result row counter:
			v_issue_pos := 1;

			--loop through each QC criteria result set row:
			LOOP

				--fetch the next row if there is another on in the result set:
				IF DBMS_SQL.FETCH_ROWS(curid)>0 THEN

				  --loop through each column in the result set row:
				  FOR i IN 1 .. colcnt LOOP


						--retrieve column metadata from query results:
						IF desctab(i).col_type = 2 THEN
							--this is a numeric value:

							--retrieve the NUMBER value into the procedure variable
							DBMS_SQL.COLUMN_VALUE(curid, i, numvar);

							--check the column name to assign it to the corresponding p_issue_recs element record field values
							IF desctab(i).col_name = 'ISS_ID' THEN
								p_issue_recs(v_issue_pos).ISS_ID := numvar;

							ELSIF desctab(i).col_name = 'PTA_ISS_ID' THEN
								p_issue_recs(v_issue_pos).PTA_ISS_ID := numvar;

							ELSIF desctab(i).col_name = 'ISS_TYPE_ID' THEN
								p_issue_recs(v_issue_pos).ISS_TYPE_ID := numvar;
--								DBMS_OUTPUT.PUT_LINE('The current issue_type_id is: '||to_char(numvar));

							ELSIF desctab(i).col_name = 'ISS_RES_TYPE_ID' THEN
								p_issue_recs(v_issue_pos).ISS_RES_TYPE_ID := numvar;

							END IF;

						ELSIF desctab(i).col_type IN (1, 96) THEN
							--this is a CHAR/VARCHAR data type:

							DBMS_SQL.COLUMN_VALUE(curid, i, namevar);

							--check the column name to assign it to the corresponding p_issue_recs element record field values
							IF desctab(i).col_name = 'ISS_NOTES' THEN
								p_issue_recs(v_issue_pos).ISS_NOTES := namevar;

							ELSIF desctab(i).col_name = 'APP_LINK_URL' THEN
								p_issue_recs(v_issue_pos).APP_LINK_URL := namevar;
							END IF;
						ELSIF desctab(i).col_type = 112 THEN

							--store the column value
							DBMS_SQL.COLUMN_VALUE(curid, i, clobvar);

							--check the column name to assign it to the corresponding p_issue_recs element record field values
							IF desctab(i).col_name = 'ISS_DESC' THEN
								p_issue_recs(v_issue_pos).ISS_DESC := clobvar;
							END IF;

						END IF;

				  END LOOP;

				  --increment the row counter variable:
				  v_issue_pos := v_issue_pos + 1;

			   ELSE

					-- No more rows to process, exit the loop:
					EXIT;
			   END IF;
				END LOOP;
--				DBMS_output.put_line('closing curid cursor in RETRIEVE_ISSUE_RECS()');
				DBMS_SQL.CLOSE_CURSOR(curid);

				--set the success code:
				p_proc_return_code := 1;

		EXCEPTION

			--catch all PL/SQL database exceptions:
			WHEN OTHERS THEN
				--catch all other errors:

				--print out error message:
				DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);
				--set the error code:
				p_proc_return_code := -1;

		END RETRIEVE_ISSUE_RECS;


	PROCEDURE INIT_PKG_SP (p_proc_return_code OUT PLS_INTEGER) IS

	BEGIN

		dbms_output.put_line('running INIT_PKG_SP()');

		--clear the ALL_CRITERIA table before retrieving the validation rule sets:
		ALL_CRITERIA.delete;


		--initialize the v_issue_rec_table
		v_issue_rec_table.delete;

		--set the successful return code:
		p_proc_return_code := 1;

		EXCEPTION

			--catch all PL/SQL database exceptions:
			WHEN OTHERS THEN
				--catch all other errors:

				--print out error message:
				DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);
				--set the error code:
				p_proc_return_code := -1;


	END INIT_PKG_SP;

	END DVM_PKG;
	/





























CREATE OR REPLACE VIEW DVM_QC_MSG_MISS_FIELDS_V AS
select DATA_STREAM_CODE,
DATA_STREAM_DESC,
DATA_STREAM_ID,
DATA_STREAM_NAME,
DATA_STREAM_PK_FIELD,
ISS_TYPE_ID,
ISS_SEVERITY_CODE,
ISS_SEVERITY_DESC,
ISS_SEVERITY_ID,
ISS_SEVERITY_NAME,
ISS_TYPE_ACTIVE_YN,
ISS_TYPE_COMMENT_TEMPLATE,
ISS_TYPE_DESC,
ISS_TYPE_NAME,
IND_FIELD_NAME,
APP_LINK_TEMPLATE,
OBJECT_NAME,
QC_OBJECT_ID,
QC_OBJ_ACTIVE_YN,
QC_SORT_ORDER,
DVM_PKG.QC_MISSING_QUERY_FIELDS(ISS_TYPE_COMMENT_TEMPLATE, OBJECT_NAME) MISSING_ISS_DESC_FIELDS,
DVM_PKG.QC_MISSING_QUERY_FIELDS(APP_LINK_TEMPLATE, OBJECT_NAME) MISSING_APP_LINK_FIELDS

from DVM_CRITERIA_V WHERE
DVM_PKG.QC_MISSING_QUERY_FIELDS(ISS_TYPE_COMMENT_TEMPLATE, OBJECT_NAME) IS NOT NULL
OR DVM_PKG.QC_MISSING_QUERY_FIELDS(APP_LINK_TEMPLATE, OBJECT_NAME) IS NOT NULL;

COMMENT ON TABLE DVM_QC_MSG_MISS_FIELDS_V IS 'Data Validation Module Missing Template Field References QC (View)

This query returns all issue types (DVM_ISS_TYPES) that have a ISS_TYPE_COMMENT_TEMPLATE or APP_LINK_TEMPLATE value that is missing one or more field references in the corresponding QC View object (based on the data dictionary). The [APP_ID] and [APP_SESSION] are special reserved placeholders that are intended to be used by a given APEX application and replaced at runtime by the APEX application variables so they are not identified in this QC query.  This View should be used to identify if there are any field references that will not be populated by the Data Validation Module.  MISSING_ISS_DESC_FIELDS and MISSING_APP_LINK_FIELDS will contain a comma-delimited list of field references that are not in the corresponding QC View object for the issue description templates and application link templates respectively.';


COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.DATA_STREAM_CODE IS 'The code for the given data stream';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.DATA_STREAM_DESC IS 'The description for the given data stream';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.DATA_STREAM_ID IS 'Primary Key for the SPT_DATA_STREAMS table';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.DATA_STREAM_NAME IS 'The name for the given data stream';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.DATA_STREAM_PK_FIELD IS 'The Data stream''s parent record''s primary key field (used when evaluating QC validation criteria to specify a given parent record)';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ISS_TYPE_ID IS 'The Issue Type for the given issue';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ISS_SEVERITY_CODE IS 'The code for the given issue severity';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ISS_SEVERITY_DESC IS 'The description for the given issue severity';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ISS_SEVERITY_ID IS 'The Severity of the given issue type criteria.  These indicate the status of the given issue (e.g. warnings, data issues, violations of law, etc.)';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ISS_SEVERITY_NAME IS 'The name for the given issue severity';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ISS_TYPE_ACTIVE_YN IS 'Flag to indicate if the given issue type criteria is active';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ISS_TYPE_COMMENT_TEMPLATE IS 'The template for the specific issue description that exists in the specific issue condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ISS_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ISS_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current issue type has been identified.  A ''Y'' value indicates that the given issue condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current issue type';


COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.APP_LINK_TEMPLATE IS 'The template for the specific application link to resolve the given data issue.  This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the [APP_ID] and [APP_SESSION] placeholders at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';

COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.QC_OBJECT_ID IS 'The Data QC Object that the issue type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB issue)';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';


COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.MISSING_ISS_DESC_FIELDS IS 'The comma-delimited list of field names that is not found in the corresponding QC View object for the given ISS_TYPE_COMMENT_TEMPLATE value';

COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.MISSING_APP_LINK_FIELDS IS 'The comma-delimited list of field names that is not found in the corresponding QC View object for the given APP_LINK_TEMPLATE value (this will exclude the [APP_ID] and [APP_SESSION] reserved APEX placeholders that are generated by APEX at runtime)';





--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Data Validation Module', '0.6', TO_DATE('10-JUN-20', 'DD-MON-YY'), 'Updated the terminology of all objects from ERR/ERROR to ISS/ISSUE so the module is more accurately named since there are warnings and errors and additional issue severity values can be defined');

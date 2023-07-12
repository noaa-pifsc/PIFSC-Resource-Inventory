--------------------------------------------------------
--------------------------------------------------------
--Database Name: Database Log
--Database Description: This module was created to log information in the database for various backend operations.  This is preferable to a file-based log since it can be easily queried, filtered, searched, and used for reporting purposes
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Database Log - version 0.3 updates:
--------------------------------------------------------

--Database Log Package Specification:
CREATE OR REPLACE PACKAGE DB_LOG_PKG
--this package provides functions and procedures to interact with the database log package module

AS

--procedure to add a database log entry into the database with the specific parameters in an autonomous transaction:
--Parameter List:
--p_entry_type_code: this is a string that defines the type of log entry, these correspond to DB_LOG_ENTRY_TYPES.ENTRY_TYPE_CODE values
--p_log_source: The application/module/script that produced the database log entry
--p_entry_content: The content of the database log entry
--p_proc_return_code: return variable to indicate the result of the database log entry attempt, it will contain 1 if the database log entry was successfully inserted into the database and 0 if it was not
--Example Usage (to enter a debugging entry):
/*
DECLARE
  P_ENTRY_TYPE_CODE VARCHAR2(200);
  P_LOG_SOURCE VARCHAR2(200);
  P_ENTRY_CONTENT CLOB;
  P_PROC_RETURN_CODE BINARY_INTEGER;
BEGIN
  P_ENTRY_TYPE_CODE := 'DEBUG';
  P_LOG_SOURCE := 'Module Name';
  P_ENTRY_CONTENT := 'Content for DB Log Entry';

  DB_LOG_PKG.ADD_LOG_ENTRY(
    P_ENTRY_TYPE_CODE => P_ENTRY_TYPE_CODE,
    P_LOG_SOURCE => P_LOG_SOURCE,
    P_ENTRY_CONTENT => P_ENTRY_CONTENT,
    P_PROC_RETURN_CODE => P_PROC_RETURN_CODE
  );
END;
*/
procedure ADD_LOG_ENTRY (p_entry_type_code IN VARCHAR2, p_log_source IN VARCHAR2, p_entry_content IN CLOB, p_proc_return_code OUT PLS_INTEGER);




--procedure to add a database log entry into the database with the specific parameters in an autonomous transaction:
--Parameter List:
--p_entry_type_code: this is a string that defines the type of log entry, these correspond to DB_LOG_ENTRY_TYPES.ENTRY_TYPE_CODE values
--p_log_source: The application/module/script that produced the database log entry
--p_entry_content: The content of the database log entry
--Example Usage (to enter a debugging entry):
/*
DECLARE
  P_ENTRY_TYPE_CODE VARCHAR2(200);
  P_LOG_SOURCE VARCHAR2(200);
  P_ENTRY_CONTENT CLOB;
BEGIN
  P_ENTRY_TYPE_CODE := 'DEBUG';
  P_LOG_SOURCE := 'Module Name';
  P_ENTRY_CONTENT := 'Content for DB Log Entry';

  DB_LOG_PKG.ADD_LOG_ENTRY(
    P_ENTRY_TYPE_CODE => P_ENTRY_TYPE_CODE,
    P_LOG_SOURCE => P_LOG_SOURCE,
    P_ENTRY_CONTENT => P_ENTRY_CONTENT
  );
END;
*/
procedure ADD_LOG_ENTRY (p_entry_type_code IN VARCHAR2, p_log_source IN VARCHAR2, p_entry_content IN CLOB);


END DB_LOG_PKG;
/

--Database Log Package Body:
create or replace PACKAGE BODY DB_LOG_PKG
--this package provides functions and procedures to interact with the database log package module
AS

		--procedure to add a database log entry into the database with the specific parameters in an autonomous transaction:
		--Parameter List:
		--p_entry_type_code: this is a string that defines the type of log entry, these correspond to DB_LOG_ENTRY_TYPES.ENTRY_TYPE_CODE values
		--p_log_source: The application/module/script that produced the database log entry
		--p_entry_content: The content of the database log entry
		--p_proc_return_code: return variable to indicate the result of the database log entry attempt, it will contain 1 if the database log entry was successfully inserted into the database and 0 if it was not
		PROCEDURE ADD_LOG_ENTRY (p_entry_type_code IN VARCHAR2, p_log_source IN VARCHAR2, p_entry_content IN CLOB, p_proc_return_code OUT PLS_INTEGER) IS

        --procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
        v_proc_return_code PLS_INTEGER;

        --DECLARE THIS AS AN AUTONOMOUS TRANSACTION:
        PRAGMA AUTONOMOUS_TRANSACTION;


    BEGIN


        --insert the db_log_entries record based on the procedure parameters:
        INSERT INTO DB_LOG_ENTRIES (ENTRY_TYPE_ID, LOG_SOURCE, ENTRY_CONTENT, ENTRY_DTM) VALUES ((select entry_type_id from db_log_entry_types where upper(entry_type_code) = upper(p_entry_type_code)), p_log_source, p_entry_content, SYSDATE);

        --commit the DB log entry independent of any ongoing transaction
        COMMIT;

        --define the return code that indicates that the database log entry was successfully added to the database:
        p_proc_return_code := 1;


    EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
            --catch all other errors:

            --print out error message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --define the return code that indicates that the database log entry was not successfully added to the database:
            p_proc_return_code := 0;


    END ADD_LOG_ENTRY;


		--procedure to add a database log entry into the database with the specific parameters in an autonomous transaction:
		--Parameter List:
		--p_entry_type_code: this is a string that defines the type of log entry, these correspond to DB_LOG_ENTRY_TYPES.ENTRY_TYPE_CODE values
		--p_log_source: The application/module/script that produced the database log entry
		--p_entry_content: The content of the database log entry
		PROCEDURE ADD_LOG_ENTRY (p_entry_type_code IN VARCHAR2, p_log_source IN VARCHAR2, p_entry_content IN CLOB) IS

        --procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
        v_proc_return_code PLS_INTEGER;

    BEGIN

				--call the ADD_LOG_ENTRY procedure
				ADD_LOG_ENTRY (p_entry_type_code, p_log_source, p_entry_content, v_proc_return_code);

    EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
            --catch all other errors:

						--log the processing error:
						ADD_LOG_ENTRY ('ERROR', p_log_source, SQLERRM, v_proc_return_code);

    END ADD_LOG_ENTRY;

end DB_LOG_PKG;
/



--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Database Log', '0.3', TO_DATE('14-JUN-22', 'DD-MON-YY'), 'Updated DB_LOG_PKG package to overload the ADD_LOG_ENTRY procedure to not require a return code parameter.');

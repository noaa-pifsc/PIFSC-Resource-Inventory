--------------------------------------------------------
--------------------------------------------------------
--Database Name: Data Validation Module
--Database Description: This module was developed to perform systematic data quality control (QC) on a given set of data tables so the data issues can be stored in a single table and easily reviewed to identify and resolve/annotate data issues
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--version 0.7 updates:
--------------------------------------------------------


--drop old synonym (deprecated functionality)
DROP SYNONYM DAT_STRM;
DROP SYNONYM ERRS;
DROP SYNONYM ERR_RES;
DROP SYNONYM ERR_SEV;
DROP SYNONYM ERR_TYP;
DROP SYNONYM PTA_ERR;
DROP SYNONYM PTA_ER_ASC;
DROP SYNONYM PTA_ER_TYP;
DROP SYNONYM QC_OBJ;






create or replace PACKAGE DVM_PKG IS

		--declare the numeric based array of strings, used in various package procedures
		TYPE VARCHAR_ARRAY_NUM IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;

		--declare the associative array of integers Oracle type
		TYPE NUM_ARRAY IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;

		--declare the numeric array of DVM_ISSUES record Oracle type
		TYPE DVM_ISSUES_TABLE IS TABLE OF DVM_ISSUES%ROWTYPE INDEX BY PLS_INTEGER;

		--Main package procedure that validates a parent record based on the given data stream code(s) defined by P_DATA_STREAM_CODES, and uniquely identified by P_PK_ID.  This is the main procedure that is called by external programs to validate a given parent record.
		--Example usage for the RPL and XML data streams (defined in the DVM_DATA_STREAMS.DATA_STREAM_CODE table field):
	/*
		set serveroutput on;
		--sample usage for data validation module:
		DECLARE
			P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
			P_PK_ID NUMBER;
			V_SP_RET_CODE PLS_INTEGER;
		BEGIN
			-- Modify the code to initialize the variable
			P_DATA_STREAM_CODE(1) := 'RPL';
			P_DATA_STREAM_CODE(2) := 'XML';
			P_PK_ID := :vtid;

			DVM_PKG.VALIDATE_PARENT_RECORD_SP(
			P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
			P_PK_ID => P_PK_ID,
			P_SP_RET_CODE => V_SP_RET_CODE
			);
			IF (V_SP_RET_CODE = 1) then
				DBMS_output.put_line('The parent record was evaluated successfully');
			ELSE
				DBMS_output.put_line('The parent record was NOT evaluated successfully');

			END IF;

			--rollback;
		END;
	*/
		PROCEDURE VALIDATE_PARENT_RECORD_SP (P_DATA_STREAM_CODES IN VARCHAR_ARRAY_NUM, P_PK_ID IN NUMBER, P_SP_RET_CODE OUT PLS_INTEGER);


		--procedure to generate a placeholder string based on the P_INPUT_STRING_ARRAY elements that are supplied.  P_PLACEHOLDER_STRING will contain a comma delimited string with generated placholder values, P_PLACEHOLDER_ARRAY will contain the generated placeholder values.
		--If the procedure is successful it will have a P_SP_RET_CODE value of 1 and if it is unsuccessful it will have a P_SP_RET_CODE value of 0
		PROCEDURE GENERATE_PLACEHOLDERS_SP (P_INPUT_STRING_ARRAY IN VARCHAR_ARRAY_NUM, P_PLACEHOLDER_STRING OUT CLOB, P_PLACEHOLDER_ARRAY OUT VARCHAR_ARRAY_NUM, P_SP_RET_CODE OUT PLS_INTEGER);

		--procedure to retrieve the data stream information for the supplied data stream code(s).  This procedure utilizes the DBMS_SQL package because the number of data stream code(s) that are allowed as arguments are only known at runtime:
		PROCEDURE RETRIEVE_DATA_STREAM_INFO_SP (P_SP_RET_CODE OUT PLS_INTEGER);

		--procedure to retrieve a parent record based off of the parent record and PK ID supplied:
		PROCEDURE RETRIEVE_PARENT_REC_SP (P_SP_RET_CODE OUT PLS_INTEGER);

		--package procedure that retrieves a parent issue record and returns P_SP_RET_CODE with a code that indicates the result of the operation
		PROCEDURE RETRIEVE_PARENT_ISSUE_REC_SP (P_SP_RET_CODE OUT PLS_INTEGER);

		--package procedure to retrieve all of the QC criteria based on whether or not the parent record has been validated before:
		PROCEDURE RETRIEVE_QC_CRITERIA_SP (P_RULE_SET_ID_ARRAY IN NUM_ARRAY, P_SP_RET_CODE OUT PLS_INTEGER);




		--define the parent issue record for the parent record
		PROCEDURE DEFINE_PARENT_ISSUE_REC_SP (P_SP_RET_CODE OUT PLS_INTEGER);

		--associate the parent record with the new parent issue record:
		PROCEDURE ASSOC_PARENT_ISSUE_REC_SP (P_SP_RET_CODE OUT PLS_INTEGER);

		--evaluate the QC criteria stored in PV_ALL_CRITERIA for the given parent record for the specified data streams (PV_DATA_STREAM_CODES):
		PROCEDURE EVAL_QC_CRITERIA_SP (P_SP_RET_CODE OUT PLS_INTEGER);

		--validate a specific QC criteria in PV_ALL_CRITERIA in the elements from P_BEGIN_POS to P_END_POS
		PROCEDURE PROCESS_QC_CRITERIA_SP (P_BEGIN_POS IN PLS_INTEGER, P_END_POS IN PLS_INTEGER, P_SP_RET_CODE OUT PLS_INTEGER);

		--procedure to populate an issue record with the information from the corresponding result set row:
		PROCEDURE POPULATE_ISSUE_REC_SP (CUR_ID IN NUMBER, QC_CRITERIA_POS IN NUMBER, ISSUE_REC OUT DVM_ISSUES%ROWTYPE, P_SP_RET_CODE OUT PLS_INTEGER);

		--update the PTA rule set record to indicate that the given validation rule set was re-evaluated for the specified parent issue record:
		PROCEDURE UPDATE_PTA_RULE_LAST_EVAL_SP (P_RULE_SET_ID IN PLS_INTEGER, P_PTA_ISS_ID IN PLS_INTEGER, P_SP_RET_CODE OUT PLS_INTEGER);

		--function that will return a comma-delimited list of the placeholder fields that are not in the result set of the given View identified by P_QC_OBJECT_NAME:
		--if the P_APP_LINK_PARAM is 1 then this is an application link (APP_ID and APP_SESSION placeholders are ignored) and if P_APP_LINK_PARAM is 0 it is not an application link
		--if there was a processing error the return value will be '-1'
		--if there were no unmatched placeholder values the return value will be null
		--if there were unmatched placeholder values the return value will be a comma-delimited list of unmatched placeholder field names
		FUNCTION QC_MISSING_QUERY_FIELDS_FN (P_TEMPLATE_VAL CLOB, P_QC_OBJECT_NAME DVM_CRITERIA_V.OBJECT_NAME%TYPE, P_APP_LINK_PARAM PLS_INTEGER) RETURN CLOB;

		--procedure that replaces all placeholders in P_TEMPLATE_VALUE with the corresponding values in the result set row specified by CUR_ID for the QC criteria identified by QC_CRITERIA_POS and returns the rekaced value as P_REPLACED_VALUE.  P_SP_RET_CODE will contain 1 if the operation was successful, 0 if there were unmatched placeholders other than the APEX reserved placeholders ([APP_SESSION], [APP_ID]) that are required to generate a valid APEX URL
		--if the P_APP_LINK_PARAM is true then this is an application link (APP_ID and APP_SESSION placeholders are ignored) and if P_APP_LINK_PARAM is false it is not an application link
		PROCEDURE REPLACE_PLACEHOLDER_VALS_SP (CUR_ID IN NUMBER, QC_CRITERIA_POS IN NUMBER, P_TEMPLATE_VALUE IN VARCHAR2, P_REPLACED_VALUE OUT VARCHAR2, P_APP_LINK_PARAM IN BOOLEAN, P_SP_RET_CODE OUT PLS_INTEGER);

		--check to see if there is an active rule set, if not a new rule set will be created with the new validation criteria (check count(*) to see if there is at least one active criteria, if not then return an error code). if so then the procedure will check to see if the active rule set is the same as the active set of validation criteria, if so then it will return the rule_set_id in P_RULE_SET_ID parameter if not it will deactivate the rule set and insert a new active rule set with the current active rules:
		procedure RETRIEVE_ACTIVE_RULE_SET_SP (P_DATA_STREAM_CODES IN VARCHAR_ARRAY_NUM, P_RULE_SET_ID_ARRAY OUT NUM_ARRAY, P_SP_RET_CODE OUT PLS_INTEGER);

		--procedure that defines a new rule set and associates all active issue types with the new rule set:
		--the P_RULE_SET_ID contains the RULE_SET_ID value from the newly inserted DVM_PTA_RULE_SETS record and P_SP_RET_CODE contains 1 if it was successful and 0 if there was a problem with the rules or validation criteria and -1 if there was a processing error
		PROCEDURE DEFINE_RULE_SET_SP (P_DATA_STREAM_CODE IN VARCHAR2, P_RULE_SET_ID OUT PLS_INTEGER, P_SP_RET_CODE OUT PLS_INTEGER);

		--this procedure queries for all issue records that are related to validation rule sets associated with the PV_DATA_STREAM_CODES data stream(s) so they can be compared to the issues that were just identified by the DVM
		PROCEDURE RETRIEVE_ISSUE_RECS_SP (P_ISSUE_RECS OUT DVM_ISSUES_TABLE, P_SP_RET_CODE OUT PLS_INTEGER);

		--this procedure will initialize the package variables to ensure that there are no leftover values from a previous execution
		PROCEDURE INIT_PKG_SP (P_SP_RET_CODE OUT PLS_INTEGER);

		--function that will return a comma-delimited list of the elements in P_STR_ARRAY:
		--if there was a processing error the return value will be '-1'
		FUNCTION COMMA_DELIM_LIST_FN (P_STR_ARRAY IN VARCHAR_ARRAY_NUM) RETURN CLOB;

		--function that will return a comma-delimited list of the elements in P_NUM_ARRAY:
		--if there was a processing error the return value will be '-1'
		FUNCTION COMMA_DELIM_LIST_FN (P_NUM_ARRAY IN NUM_ARRAY) RETURN CLOB;

	END DVM_PKG;
	/

	create or replace PACKAGE BODY DVM_PKG IS

		--Custom record type to store standard information returned by the DVM_CRITERIA_V View when the corresponding data validation criteria information is queried for the given parent table (populated in RETRIEVE_QC_CRITERIA_SP() method procedure)
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
		PV_ALL_CRITERIA QC_CRITERIA_TABLE;


		--package variable to store the PK ID that is initially supplied to the VALIDATE_PARENT_RECORD_SP procedure when the package is initialized and processed:
		PV_PK_ID NUMBER;

		--package variable to store the DVM_PTA_ISSUES (parent issue table) record for the given parent record (e.g. SPT_VESSEL_TRIPS)
		PV_PTA_ISSUE DVM_PTA_ISSUES%ROWTYPE;

		--package variable to hold the name of the Oracle parent table for the given data validation module execution.  This is defined in the DVM_DATA_STREAMS.DATA_STREAM_PAR_TABLE field for the corresponding data stream code(s) supplied to the VALIDATE_PARENT_RECORD_SP procedure:
		PV_DATA_STREAM_PAR_TABLE VARCHAR(30);


		--package variable to hold the name of the Oracle parent table's primary key field for the given data validation module execution.  This is defined in the DVM_DATA_STREAMS_V.DATA_STREAM_PK_FIELD field for the corresponding data stream code(s) supplied to the VALIDATE_PARENT_RECORD_SP procedure:
		PV_DATA_STREAM_PK_FIELD VARCHAR(30);


		--declare the associative array of integers Oracle type
		TYPE NUM_ASSOC_VARCHAR IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(30);


		--associative array variable used to store the relative position of each column that is returned by the QC queries executed using the DBMS_SQL package methods to allow dynamic processing:
		PV_ASSOC_FIELD_LIST NUM_ASSOC_VARCHAR;


		--numeric-based array variable used to store the name of each column in its relative position returned by QC queries executed using the DBMS_SQL package methods to allow dynamic processing:
		PV_NUM_FIELD_LIST VARCHAR_ARRAY_NUM;

		--numeric-based array variable used to store the value of P_DATA_STREAM_CODES supplied to the VALIDATE_PARENT_RECORD_SP procedure
		PV_DATA_STREAM_CODES VARCHAR_ARRAY_NUM;

		--package variable used to store column-level information for dynamic queries executed using the DBMS_SQL package methods to allow dynamic processing
		PV_DESC_TAB  DBMS_SQL.DESC_TAB;


		--package variable used to store each validation issue that is determined by the data validation module execution so it can be loaded into the database as separate DVM_ISSUES records
		PV_ISSUE_REC_TABLE DVM_ISSUES_TABLE;


		--package variable used to store the comma delimited string of the data stream code(s) supplied to the VALIDATE_PARENT_RECORD_SP procedure
		PV_DATA_STREAM_CODE_STRING CLOB;

		--package variable used to store the comma delimited string of the placeholders used when querying using the data stream code(s) supplied to the VALIDATE_PARENT_RECORD_SP procedure
		PV_DATA_STR_PLACEHOLDER_STRING CLOB;

		--package variable used to store each placholder used when querying using the data stream code(s) supplied to the VALIDATE_PARENT_RECORD_SP procedure
--		v_data_str_placeholder_array VARCHAR_ARRAY_NUM;


		--procedure boolean variable whose value is set based off of whether the parent record (e.g. SPT_VESSEL_TRIPS) has an associated parent issue record (DVM_PTA_ISSUES) to determine the behavior of the module
		PV_FIRST_VALIDATION BOOLEAN;

		--package variable to store the original procedure arguments for a given DVM execution so it can be added to a standard DB Logging module entry
		PV_LOG_MSG_HEADER DB_LOG_ENTRIES.LOG_SOURCE%TYPE;


		--Main package procedure that validates a parent record based on the given data stream code(s) defined by P_DATA_STREAM_CODES, and uniquely identified by P_PK_ID.  This is the main procedure that is called by external programs to validate a given parent record.
		--Example usage for the RPL and XML data streams (defined in the DVM_DATA_STREAMS.DATA_STREAM_CODE table field):
	/*
		set serveroutput on;
		--sample usage for data validation module:
		DECLARE
			P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
			P_PK_ID NUMBER;
			V_SP_RET_CODE PLS_INTEGER;
		BEGIN
			-- Modify the code to initialize the variable
			P_DATA_STREAM_CODE(1) := 'RPL';
			P_DATA_STREAM_CODE(2) := 'XML';
			P_PK_ID := :vtid;

			DVM_PKG.VALIDATE_PARENT_RECORD_SP(
			P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
			P_PK_ID => P_PK_ID,
			P_SP_RET_CODE => V_SP_RET_CODE
			);
			IF (V_SP_RET_CODE = 1) then
				DBMS_output.put_line('The parent record was evaluated successfully');
			ELSE
				DBMS_output.put_line('The parent record was NOT evaluated successfully');

			END IF;

			--rollback;
		END;
	*/
		PROCEDURE VALIDATE_PARENT_RECORD_SP (P_DATA_STREAM_CODES IN VARCHAR_ARRAY_NUM, P_PK_ID IN NUMBER, P_SP_RET_CODE OUT PLS_INTEGER) IS

			--procedure variable to store generated SQL statements that are executed in the procedure:
			V_TEMP_SQL CLOB;

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--procedure boolean variable that determines if the procedure execution continues based on the results of the various procedure calls:
			V_CONTINUE BOOLEAN;

			--variable to store the RULE_SET_ID primary key value for a new/existing DVM_PTA_RULE_SETS record that is associated with the current parent issue record
			V_RULE_SET_ID_ARRAY NUM_ARRAY;

			--temporary variable to store the RULE_SET_ID primary key value for new/existing DVM_PTA_RULE_SETS record that is associated with the current parent issue record
			V_TEMP_RULE_SET_ID_ARRAY NUM_ARRAY;


			--variable to store the data stream codes that need to have validation rule sets retrieved:
			V_TEMP_DATA_STREAM_CODES VARCHAR_ARRAY_NUM;

			--variable to store the number of validation rule sets that are associated with the given data stream (this is used to determine if the given data stream has already been evaluated for a given parent issue record
			V_NUM_RULE_SETS PLS_INTEGER;

			--variable to store the rule_set_id for the rule set that has already been evaluated
			V_TEMP_RULE_SET_ID PLS_INTEGER;


		BEGIN

			--construct the information to be included with all debug/info/error messages (this is necessary for the first execution of COMMA_DELIM_LIST_FN before it is used to contruct the delimited list of data stream codes):
			PV_LOG_MSG_HEADER := 'DVM_PKG.VALIDATE_PARENT_RECORD_SP ((P_DATA_STREAM_CODES(1): '||P_DATA_STREAM_CODES(1)||'), (P_PK_ID: '||P_PK_ID||'))';

			--construct the comma-delimited data stream codes:
			PV_DATA_STREAM_CODE_STRING := COMMA_DELIM_LIST_FN(P_DATA_STREAM_CODES);

			--construct the information to be included with all debug/info/error messages:
			PV_LOG_MSG_HEADER := 'DVM_PKG.VALIDATE_PARENT_RECORD_SP ((P_DATA_STREAM_CODES: '||PV_DATA_STREAM_CODE_STRING||'), (P_PK_ID: '||P_PK_ID||'))';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'Running VALIDATE_PARENT_RECORD_SP()', V_SP_RET_CODE);


			--check if the comma-delimited list of data stream codes has been generated successfully
			IF (PV_DATA_STREAM_CODE_STRING <> '-1') THEN
				--the comma-delimited string of data stream codes was generated successfully

				--initialize the package variables used in the DVM_PKG package:
				INIT_PKG_SP (V_SP_RET_CODE);

				--check if the initialization procedure was successful:
				IF (V_SP_RET_CODE = 1) THEN
					--the package procedure was initialized successfully

					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'The DVM_PKG package was initialized successfully (INIT_PKG_SP)', V_SP_RET_CODE);

					--set the package variable for usage later:
					PV_DATA_STREAM_CODES := P_DATA_STREAM_CODES;

					--initialize the V_CONTINUE variable:
					V_CONTINUE := true;

					--set the package variables to the parameter values:
					PV_PK_ID := P_PK_ID;


--					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'Running RETRIEVE_DATA_STREAM_INFO_SP()', V_SP_RET_CODE);

					--query the database to for the data stream code(s) that will be used to determine the parent record and associated data validation criteria:
					RETRIEVE_DATA_STREAM_INFO_SP(V_SP_RET_CODE);

					--check the return code from RETRIEVE_DATA_STREAM_INFO_SP():
					IF (V_SP_RET_CODE = 1) THEN

						--the data stream code(s) have been returned a single parent table, continue processing:

						DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'the data stream code(s) have been returned a single parent table, continue processing', V_SP_RET_CODE);

						--check if the parent record exists using the information from the corresponding data stream:
						RETRIEVE_PARENT_REC_SP (V_SP_RET_CODE);

						--check the return code from RETRIEVE_PARENT_REC_SP():
						IF (V_SP_RET_CODE = 1) THEN

							--the parent record exists, continue processing:
							DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'the parent record exists, retrieve the parent issue record()', V_SP_RET_CODE);

							--check if the PTA issue record exist:
							RETRIEVE_PARENT_ISSUE_REC_SP (V_SP_RET_CODE);


							--check the return code from RETRIEVE_PARENT_ISSUE_REC_SP():
							IF (V_SP_RET_CODE = 1) THEN
								--the parent record's PTA issue record exists:

								DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'The parent record for the data stream code(s) and PK was found in the database', V_SP_RET_CODE);

								--the parent issue record already exists, use the data validation criteria that was active when the parent record was first validated:
								PV_FIRST_VALIDATION := false;

								--loop through the data stream codes and see if the current data stream code has already been evaluated for the specified parent record
								for i in 1..PV_DATA_STREAM_CODES.COUNT LOOP

									--construct the query to retrieve any validation rule sets associated with the parent record and data stream code
									V_TEMP_SQL := 'SELECT COUNT(*) FROM DVM_PTA_RULE_SETS_V WHERE DATA_STREAM_CODE = :DSC AND PTA_ISS_ID = :PEID';

									--execute the query
									EXECUTE IMMEDIATE V_TEMP_SQL into V_NUM_RULE_SETS using PV_DATA_STREAM_CODES(i), PV_PTA_ISSUE.PTA_ISS_ID;

									DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'There are '||V_NUM_RULE_SETS||' active rule sets for the current data stream(s) and parent issue record (PTA_ISS_ID: '||PV_PTA_ISSUE.PTA_ISS_ID||')', V_SP_RET_CODE);

									--check if the current data stream code has already been evaluated for the parent issue record
									IF (V_NUM_RULE_SETS > 0) THEN
										--this data stream has already been evaluated for the given parent issue record, retrieve the rule_set_id so it can be used for processing:

										DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'this data stream has already been evaluated for the given parent issue record, retrieve the rule_set_id so it can be used for processing', V_SP_RET_CODE);
										--query for the rule_set_id that is associated with the specified parent issue record
										SELECT RULE_SET_ID INTO V_TEMP_RULE_SET_ID FROM DVM_PTA_RULE_SETS_V where DATA_STREAM_CODE = PV_DATA_STREAM_CODES(i) AND PTA_ISS_ID = PV_PTA_ISSUE.PTA_ISS_ID;

										--add the rule_set_id to the array of rule set ids to evaluate for the current parent issue record
										V_RULE_SET_ID_ARRAY(V_RULE_SET_ID_ARRAY.COUNT + 1) := V_TEMP_RULE_SET_ID;

										--The current existing PTA validation rule set was updated successfully
										DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'The existing validation rule set to use is: '||V_TEMP_RULE_SET_ID||', update the last evaluation date', V_SP_RET_CODE);

										--update the DVM_PTA_RULE_SETS to update the LAST_EVAL_DATE due to the validation process being executed:
										UPDATE_PTA_RULE_LAST_EVAL_SP (V_TEMP_RULE_SET_ID, PV_PTA_ISSUE.PTA_ISS_ID, V_SP_RET_CODE);

										--check to see if the existing PTA validation rule set was updated successfully:
										IF (V_SP_RET_CODE = 1) then

											--The current existing PTA validation rule set was updated successfully
											DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'The current existing PTA validation rule set was updated successfully (RULE_SET_ID: '||V_TEMP_RULE_SET_ID||'), (PTA_ISS_ID: '||PV_PTA_ISSUE.PTA_ISS_ID||')', V_SP_RET_CODE);

										ELSE

											--The current existing PTA validation rule set was NOT updated successfully
											DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', PV_LOG_MSG_HEADER, 'The current existing PTA validation rule set was not updated successfully (RULE_SET_ID: '||V_TEMP_RULE_SET_ID||'), (PTA_ISS_ID: '||PV_PTA_ISSUE.PTA_ISS_ID||')', V_SP_RET_CODE);

											--do not continue processing the record:
											V_CONTINUE := false;
										END IF;

									ELSE
										--this data stream has not been evaluated on the current parent issue record yet, add it to the list of data stream codes that need to be retrieved:

										DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'this data stream (data stream code: '||PV_DATA_STREAM_CODES(i)||') has not been evaluated on the current parent issue record yet, add it to the list of data stream codes that need to be retrieved', V_SP_RET_CODE);

										--add the current data stream code to the array of data stream codes that need to retrieve the corresponding active validation rules
										V_TEMP_DATA_STREAM_CODES((V_TEMP_DATA_STREAM_CODES.COUNT + 1)) := PV_DATA_STREAM_CODES(i);
									END IF;

								END LOOP;


								DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'check if there are any data stream codes that need to be evaluated using RETRIEVE_ACTIVE_RULE_SET_SP', V_SP_RET_CODE);

								--check if there are any data stream codes that need to be evaluated using RETRIEVE_ACTIVE_RULE_SET_SP
								IF (V_TEMP_DATA_STREAM_CODES.COUNT > 0) THEN
									--there is at least one data stream code that needs to be evaluated using RETRIEVE_ACTIVE_RULE_SET_SP

									DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'there is at least one data stream code that needs to be evaluated using RETRIEVE_ACTIVE_RULE_SET_SP', V_SP_RET_CODE);

									--retrieve the active rule sets for the V_TEMP_DATA_STREAM_CODES:
									RETRIEVE_ACTIVE_RULE_SET_SP (V_TEMP_DATA_STREAM_CODES, V_TEMP_RULE_SET_ID_ARRAY, V_SP_RET_CODE);

									--check if the active rule set was retrieved successfully
									IF (V_SP_RET_CODE = 1) THEN
										--the active rule sets were successfully retrieved:

										DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'The active rule set(s) were successfully retrieved', V_SP_RET_CODE);

										--loop through the array of active rule set IDs and add them each to the list of rule set IDs that will be evaluated for the specified parent record
										FOR i in 1..V_TEMP_RULE_SET_ID_ARRAY.COUNT Loop

											--add the rule_set_id for evaluation:
											V_RULE_SET_ID_ARRAY(V_RULE_SET_ID_ARRAY.count + 1) := V_TEMP_RULE_SET_ID_ARRAY(i);

--												DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'The current rule set ('||V_TEMP_RULE_SET_ID_ARRAY(i)||') was successfully added to the V_RULE_SET_ID_ARRAY', V_SP_RET_CODE);
										END LOOP;

									ELSE

										--The return code from the DEFINE_PARENT_ISSUE_REC_SP() procedure indicates an error: the parent issue record was not loaded successfully:

										DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', PV_LOG_MSG_HEADER, 'The active rule set(s) were not successfully retrieved', V_SP_RET_CODE);


										--do not continue processing the record:
										V_CONTINUE := false;
									END IF;



								END IF;



							ELSIF (V_SP_RET_CODE = 0) THEN
								--the parent record's parent issue record (DVM_PTA_ISSUES) does not exist:

								DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'The parent issue record was not found in the database, create a new parent issue record', V_SP_RET_CODE);


								--the parent issue record does not already exist, use the data validation criteria that is currently active:
								PV_FIRST_VALIDATION := true;

								DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'Run DEFINE_PARENT_ISSUE_REC_SP(V_RULE_SET_ID_ARRAY)', V_SP_RET_CODE);


								--insert the new parent issue record:
								DEFINE_PARENT_ISSUE_REC_SP (V_SP_RET_CODE);

								--check the return code from DEFINE_PARENT_ISSUE_REC_SP():
								IF (V_SP_RET_CODE = 1) THEN

									--the parent issue record was loaded successfully, proceed with the validation process:
									DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'The parent issue record was inserted successfully for the data stream code(s) and parent record.  Continue processing: RETRIEVE_ACTIVE_RULE_SET_SP()', V_SP_RET_CODE);



									--retrieve the active rule set (and if the active rule set does not match the currently active validation rules then create new rule sets)
									RETRIEVE_ACTIVE_RULE_SET_SP (PV_DATA_STREAM_CODES, V_RULE_SET_ID_ARRAY, V_SP_RET_CODE);

									--check if the active rule set(s) were retrieved successfully:
									IF (V_SP_RET_CODE = 1) THEN
										--the active rule set(s) were retrieved successfully:

										DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'The active rule set(s) was retrieved successfully, associate the parent record with the parent issue record', V_SP_RET_CODE);




										--update the parent record to associate it with the new parent issue record (DVM_PTA_ISSUES)
										ASSOC_PARENT_ISSUE_REC_SP (V_SP_RET_CODE);


										--check the return code from ASSOC_PARENT_ISSUE_REC_SP():
										IF (V_SP_RET_CODE = 1) THEN

											--the parent record was updated successfully:
											DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'The new parent issue record was associated successfully with the validation rule set(s). Continue processing', V_SP_RET_CODE);

										ELSE
											--The return code from the ASSOC_PARENT_ISSUE_REC_SP() procedure indicates an error: the parent issue record was not updated successfully
											DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', PV_LOG_MSG_HEADER, 'The new parent issue record could not be associated successfully with the validation rule set(s). Continue processing', V_SP_RET_CODE);

											--do not continue processing the record:
											V_CONTINUE := false;



										END IF;

									ELSE
										--the active rule set could not be retrieved:

										DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', PV_LOG_MSG_HEADER, 'the active rule set could not be retrieved', V_SP_RET_CODE);

										--do not continue processing the record:
										V_CONTINUE := false;



									END IF;
								ELSE
									--The return code from the DEFINE_PARENT_ISSUE_REC_SP() procedure indicates an error: the parent issue record was not loaded successfully:

									--do not continue processing the record:
									V_CONTINUE := false;


									DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', PV_LOG_MSG_HEADER, 'The parent issue record could not be inserted successfully for the data stream code(s) and parent record PK', V_SP_RET_CODE);

								END IF;

							ELSE
								----The return code from the RETRIEVE_PARENT_ISSUE_REC_SP() procedure indicates a database query error

								DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', PV_LOG_MSG_HEADER, 'There was a database error when querying for the parent issue record for the data stream code(s) and parent record PK', V_SP_RET_CODE);

								--there was a database error, do not continue processing:
								V_CONTINUE := false;


							END IF;

						ELSIF (V_SP_RET_CODE = 0) THEN
							--The return code from the RETRIEVE_PARENT_REC_SP() procedure indicates an error: the parent record does not exist

							DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', PV_LOG_MSG_HEADER, 'The parent record for the data stream code(s) and parent record PK does not exist', V_SP_RET_CODE);

							--there is no parent record, do not continue processing:
							V_CONTINUE := false;

						ELSE
							--The return code from the RETRIEVE_PARENT_REC_SP() procedure indicates a database query error

							DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', PV_LOG_MSG_HEADER, 'There was a database error when querying for the parent record for the data stream code(s) and parent record PK', V_SP_RET_CODE);

							--there was a database error, do not continue processing:
							V_CONTINUE := false;

						END IF;

					ELSE
						--The return code from the RETRIEVE_DATA_STREAM_INFO_SP() procedure indicates an error: the data stream code(s) did not resolve to a single parent table, stop processing the data validation module

						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', PV_LOG_MSG_HEADER, 'The return code from the RETRIEVE_DATA_STREAM_INFO_SP() procedure indicates an error: the data stream code(s) did not resolve to a single parent table, stop processing the data validation module', V_SP_RET_CODE);
						--there was more than one parent record indicated by the data stream code(s), do not continue processing:
						V_CONTINUE := false;

					END IF;
				ELSE
					--the package procedure was not initialized successfully

					--set the V_CONTINUE to false to indicate there was a processing error:
					V_CONTINUE := false;


					--log the processing error
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', PV_LOG_MSG_HEADER, 'the package procedure was not initialized successfully', V_SP_RET_CODE);


				END IF;
			ELSE
				--the comma-delimited list of data stream codes was not successfully generated

				--set the V_CONTINUE to false to indicate there was a processing error:
				V_CONTINUE := false;

				--log the processing error
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', PV_LOG_MSG_HEADER, 'the comma-delimited list of data stream codes was not successfully generated', V_SP_RET_CODE);


			END IF;




			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'The supporting DVM and parent records were processed, the value of V_CONTINUE is: '||(CASE WHEN V_CONTINUE THEN '1' ELSE '0' END), V_SP_RET_CODE);

			--check if the data validation module processing should continue:
			IF V_CONTINUE THEN
				--there were no database errors or error conditions, continue processing:

				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'there were no database errors or error conditions, retrieve the QC criteria', V_SP_RET_CODE);

				--retrieve the QC criteria for processing:
				RETRIEVE_QC_CRITERIA_SP (V_RULE_SET_ID_ARRAY, V_SP_RET_CODE);

				--check the return code from RETRIEVE_QC_CRITERIA_SP():
				IF (V_SP_RET_CODE = 1) THEN
					--the QC criteria were loaded successfully:

					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'The QC criteria has been loaded successfully, evaluate the QC criteria', V_SP_RET_CODE);

					--evaluate the QC criteria:
					EVAL_QC_CRITERIA_SP (V_SP_RET_CODE);

					--check the return code from EVAL_QC_CRITERIA_SP():
					IF (V_SP_RET_CODE = 1) THEN
						--The QC Criteria was retrieved and evaluated successfully:

						DB_LOG_PKG.ADD_LOG_ENTRY ('SUCCESS', PV_LOG_MSG_HEADER, 'The QC criteria has been evaluated successfully for the specified parameters (P_DATA_STREAM_CODES:  '||PV_DATA_STREAM_CODE_STRING||'), (PK_ID: '||P_PK_ID||')', V_SP_RET_CODE);

						--the data validation criteria evaluation process was successful, commit the SQL transaction
						COMMIT;

					ELSE
						--The return code from the EVAL_QC_CRITERIA_SP() procedure indicates an error processing the QC validation criteria:
						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', PV_LOG_MSG_HEADER, 'The parent record was not evaluated successfully for the data stream code(s) and parent record PK', V_SP_RET_CODE);

						--set the V_CONTINUE to false to indicate there was a processing error:
						V_CONTINUE := false;

					END IF;

				ELSE
					--The return code from the RETRIEVE_QC_CRITERIA_SP() procedure indicates an error retrieving the QC validation criteria:

					--there was no DML executed, there is no need to rollback the transaction

					--set the V_CONTINUE to false to indicate there was a processing error:
					V_CONTINUE := false;

					--the QC criteria records were not loaded successfully:

					--log the processing error
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', PV_LOG_MSG_HEADER, 'The QC validation criteria was not loaded successfully', V_SP_RET_CODE);
				END IF;

			END IF;

			IF (V_CONTINUE) THEN
				--there were no error conditions encountered during processing

				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', PV_LOG_MSG_HEADER, 'there were no error conditions encountered during processing', V_SP_RET_CODE);

				--set the return code to indicate successful processing:
				P_SP_RET_CODE := 1;
			ELSE
				--there was an error condition encountered during processing

				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', PV_LOG_MSG_HEADER, 'there was an error condition encountered during processing', V_SP_RET_CODE);
				--set the return code to indicate an error:
				P_SP_RET_CODE := 0;

				--there was a problem with processing the specified parent record's validation criteria:
				ROLLBACK;


			END IF;

      EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
		  		--catch all other errors:


					--log the processing error
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', PV_LOG_MSG_HEADER, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

					--there was a PL/SQL error, rollback the SQL transaction:
					ROLLBACK;

					--set the return code to indicate an error:
					P_SP_RET_CODE := 0;

		END VALIDATE_PARENT_RECORD_SP;


		--procedure to generate a placeholder string based on the P_INPUT_STRING_ARRAY elements that are supplied.  P_PLACEHOLDER_STRING will contain a comma delimited string with generated placholder values, P_PLACEHOLDER_ARRAY will contain the generated placeholder values.
		--If the procedure is successful it will have a P_SP_RET_CODE value of 1 and if it is unsuccessful it will have a P_SP_RET_CODE value of 0
		PROCEDURE GENERATE_PLACEHOLDERS_SP (P_INPUT_STRING_ARRAY IN VARCHAR_ARRAY_NUM, P_PLACEHOLDER_STRING OUT CLOB, P_PLACEHOLDER_ARRAY OUT VARCHAR_ARRAY_NUM, P_SP_RET_CODE OUT PLS_INTEGER) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - GENERATE_PLACEHOLDERS_SP (P_INPUT_STRING_ARRAY: '||COMMA_DELIM_LIST_FN(P_INPUT_STRING_ARRAY)||')';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Running GENERATE_PLACEHOLDERS_SP()', V_SP_RET_CODE);


			--initialize variables:

			--string of comma-delimited placeholders to be used in a dynamic query that will be bound with variables:
			P_PLACEHOLDER_STRING := '';

			--array of placeholders that will be used in a dynamic query that will be bound with variables:
			P_PLACEHOLDER_ARRAY.delete;


			--loop through each element in the P_INPUT_STRING_ARRAY
			FOR i IN 1 .. P_INPUT_STRING_ARRAY.COUNT LOOP

				--add the bind placeholder name into the P_PLACEHOLDER_ARRAY variable:
				P_PLACEHOLDER_ARRAY(i) := ':'||TO_CHAR(i);

			END LOOP;


			--construct the comma-delimited string of placeholders:
			P_PLACEHOLDER_STRING := COMMA_DELIM_LIST_FN (P_PLACEHOLDER_ARRAY);

			--check if the comma-delimited strings were constructed successfully:
			IF (P_PLACEHOLDER_STRING = '-1') THEN
				--The delimited string of placeholders was not successfully generated, log the error:

				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The delimited string of placeholders was not successfully generated', V_SP_RET_CODE);

				--set the error return code:
				P_SP_RET_CODE := 0;

			ELSE
				--the comma-delimited strings were constructed successfully:

				--set the successful return code:
				P_SP_RET_CODE := 1;

			END IF;



      EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
		  		--catch all other errors:


					--log the procedure processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

					--set the error return code:
					P_SP_RET_CODE := 0;

		END GENERATE_PLACEHOLDERS_SP;





		--procedure to retrieve the data stream information for the supplied data stream code(s).  This procedure utilizes the DBMS_SQL package because the number of data stream code(s) that are allowed as arguments are only known at runtime:
		PROCEDURE RETRIEVE_DATA_STREAM_INFO_SP (P_SP_RET_CODE OUT PLS_INTEGER) IS

			--procedure variable to store generated SQL statements that are executed in the procedure:
			V_TEMP_SQL CLOB;

			--variable to retrieve the parent table name for the data stream
			V_TEMP_PAR_TABLE VARCHAR2(30);

			--variable to retrieve the parent table PK field name for the data stream:
			V_TEMP_PAR_PK_FIELD VARCHAR2(30);

			--variable to store the current data stream being processed:
			V_CURRENT_DATA_STREAM VARCHAR2(2000);

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - RETRIEVE_DATA_STREAM_INFO_SP()';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Running RETRIEVE_DATA_STREAM_INFO_SP()', V_SP_RET_CODE);


			--initialize the successful return code, it will be changed if any error conditions are found
			P_SP_RET_CODE := 1;


			--construct the query to retrieve the data stream information for a given data stream code
			V_TEMP_SQL := 'SELECT DATA_STREAM_PAR_TABLE, DATA_STREAM_PK_FIELD FROM DVM_DATA_STREAMS_V WHERE DATA_STREAM_CODE = :DSC';

			--loop through the data stream codes:
			FOR i in 1..PV_DATA_STREAM_CODES.COUNT LOOP

				--store the current data stream code being processed:
				V_CURRENT_DATA_STREAM := PV_DATA_STREAM_CODES(i);

				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'query for the parent table and pk field for the current data stream ('||PV_DATA_STREAM_CODES(i)||')', V_SP_RET_CODE);

				--execute the SELECT query to retrieve the parent table and parent table's primary key field for the current data stream code value
				EXECUTE IMMEDIATE V_TEMP_SQL INTO V_TEMP_PAR_TABLE, V_TEMP_PAR_PK_FIELD using PV_DATA_STREAM_CODES(i);

				--check if this is the first data stream code retrieved, if so store in the corresponding package variables
				IF (i = 1) THEN
					--this is the first data stream code being checked:
					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'this is the first data stream code being checked, store the values in the package variables', V_SP_RET_CODE);

					--set the package variable values to the first data stream code's associated parent table and parent table's primary key field:
					PV_DATA_STREAM_PAR_TABLE := V_TEMP_PAR_TABLE;
					PV_DATA_STREAM_PK_FIELD := V_TEMP_PAR_PK_FIELD;

				ELSIF ((PV_DATA_STREAM_PAR_TABLE <> V_TEMP_PAR_TABLE) OR (PV_DATA_STREAM_PK_FIELD <> V_TEMP_PAR_PK_FIELD)) THEN
					--the associated parent table and parent table's primary key field for the current and previous data stream code are not the same, this indicates that the data stream codes are for different parent tables so this procedure call is invalid

					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'the associated parent table ('||PV_DATA_STREAM_PAR_TABLE||' AND '||V_TEMP_PAR_TABLE||') and parent table''s primary key field ('||PV_DATA_STREAM_PK_FIELD||' AND '||V_TEMP_PAR_PK_FIELD||') for the current and previous data stream codes ('||PV_DATA_STREAM_CODES(i)||' AND '||PV_DATA_STREAM_CODES(i - 1)||') are not the same, this indicates that the data stream codes are for different parent tables so this procedure call is invalid', V_SP_RET_CODE);

					P_SP_RET_CODE := -1;

					--the parent table name and parent table PK field are not equivalent:
					EXIT;

				END IF;
			END LOOP;

			--check if there were any errors during processing:
			IF (P_SP_RET_CODE = 1) THEN
				--there were no errors, the data stream code(s) resolved to one parent table and the data streams were found in the database:

				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'the data stream code(s) successfully resolved to one parent table and the data streams were found in the database', V_SP_RET_CODE);

			END IF;

			EXCEPTION
				--catch all PL/SQL database exceptions:

				WHEN NO_DATA_FOUND THEN
					--catch no query results errors:

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'the data stream code ('||V_CURRENT_DATA_STREAM||') was not found in the database', V_SP_RET_CODE);

					--define the return code that indicates that there was processing error due a database or PL/SQL error:
					P_SP_RET_CODE := -1;


				WHEN OTHERS THEN
					--catch all other errors:

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

					--define the return code that indicates that there was processing error due a database or PL/SQL error:
					P_SP_RET_CODE := -1;

		END RETRIEVE_DATA_STREAM_INFO_SP;



		--procedure to retrieve a parent record based off of the data stream and PK ID supplied:
		PROCEDURE RETRIEVE_PARENT_REC_SP (P_SP_RET_CODE OUT PLS_INTEGER) IS

			--procedure variable to store generated SQL statements that are executed in the procedure:
			V_TEMP_SQL CLOB;

			--procedure variable that will be used to return the PK field value from the query
			V_RETURN_ID NUMBER;

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - RETRIEVE_PARENT_REC_SP()';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Running RETRIEVE_PARENT_REC_SP()', V_SP_RET_CODE);

			--construct the SQL query the parent table to see if the record exists:
			V_TEMP_SQL := 'SELECT '||PV_DATA_STREAM_PAR_TABLE||'.'||PV_DATA_STREAM_PK_FIELD||' FROM '||PV_DATA_STREAM_PAR_TABLE||' WHERE '||PV_DATA_STREAM_PK_FIELD||' = :pkid';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The parent rec query is: '||V_TEMP_SQL, V_SP_RET_CODE);


			--execute the query using the PK value supplied in the VALIDATE_PARENT_RECORD_SP() procedure call:
			EXECUTE IMMEDIATE V_TEMP_SQL INTO V_RETURN_ID USING PV_PK_ID;

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The parent record was successfully retrieved', V_SP_RET_CODE);

			--define the return code that indicates that the parent record was found in the database
			P_SP_RET_CODE := 1;

			EXCEPTION

				--catch all PL/SQL database exceptions:
				WHEN NO_DATA_FOUND THEN
					--no records were returned by the query:

					--log the processing error
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The parent record for the data stream code(s) and parent record PK was not found in the database', V_SP_RET_CODE);

					--set the return code to indicate the parent record was not found:
					P_SP_RET_CODE := 0;

				WHEN OTHERS THEN
					--catch all other errors:

					--log the processing error
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

					--define the return code that indicates that there was processing error due a database or PL/SQL error:
					P_SP_RET_CODE := -1;

		END RETRIEVE_PARENT_REC_SP;



		--package procedure that retrieves a parent issue record and returns P_SP_RET_CODE with a code that indicates the result of the operation
		PROCEDURE RETRIEVE_PARENT_ISSUE_REC_SP (P_SP_RET_CODE OUT PLS_INTEGER) IS

			--procedure variable to store generated SQL statements that are executed in the procedure:
			V_TEMP_SQL CLOB;

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - RETRIEVE_PARENT_ISSUE_REC_SP ()';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Running RETRIEVE_PARENT_ISSUE_REC_SP()', V_SP_RET_CODE);

			--construct the query to check if the parent issue record (DVM_PTA_ISSUES) already exists, if so then re-use that PTA_ISS_ID otherwise query for all of the active data validation criteria:
			V_TEMP_SQL := 'SELECT DVM_PTA_ISSUES.* FROM '||PV_DATA_STREAM_PAR_TABLE||' INNER JOIN DVM_PTA_ISSUES ON ('||PV_DATA_STREAM_PAR_TABLE||'.PTA_ISS_ID = DVM_PTA_ISSUES.PTA_ISS_ID) WHERE '||PV_DATA_STREAM_PK_FIELD||' = :pkid';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The query is: '||V_TEMP_SQL, V_SP_RET_CODE);

			--execute the query using the PK value supplied in the VALIDATE_PARENT_RECORD_SP() procedure call:
			EXECUTE IMMEDIATE V_TEMP_SQL INTO PV_PTA_ISSUE USING PV_PK_ID;

			--set the success code:
			P_SP_RET_CODE := 1;

			EXCEPTION

				--catch all PL/SQL database exceptions:
				WHEN NO_DATA_FOUND THEN
					--no parent issue record exists for the given parent record:

					--log the exit condition
					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The parent issue record for the data stream code(s) and parent table PK was not found in the database', V_SP_RET_CODE);

					--set the return code to indicate the parent issue record was not found:
					P_SP_RET_CODE := 0;

				WHEN OTHERS THEN
					--catch all other errors:

					--log the processing error
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

					--define the return code that indicates that there was processing error due a database or PL/SQL error:
					P_SP_RET_CODE := -1;

		END RETRIEVE_PARENT_ISSUE_REC_SP;


		--package procedure to retrieve all of the QC criteria based on whether or not the parent record has been validated before:
		PROCEDURE RETRIEVE_QC_CRITERIA_SP (P_RULE_SET_ID_ARRAY IN NUM_ARRAY, P_SP_RET_CODE OUT PLS_INTEGER) IS


			--return code from the dynamic query using the DBMS_SQL package:
			IGNORE   NUMBER;

			--procedure variable to store generated SQL statements that are executed in the procedure:
			V_TEMP_SQL CLOB;

			--procedure variable to store the CLOB data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			CLOB_VAR  VARCHAR2(2000);

			--procedure variable to store the character string data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			NAME_VAR  VARCHAR2(2000);

			--procedure variable to store the numeric data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			NUM_VAR   NUMBER;

			--dynamic cursor used with the dynamic SQL query for the DBMS_SQL query method:
	--        TYPE CUR_TYPE IS REF CURSOR;

			--dynamic cursor ID variable for the dynamic SQL query for the DBMS_SQL query method:
			CUR_ID    NUMBER;

			--number used to store the number of columns returned by the dynamic query for the DBMS_SQL query method:
			COL_CNT   NUMBER;

			--counter variable used when populating the PV_ALL_CRITERIA package variable
			V_ALL_CRITERIA_POS NUMBER := 1;

			--variable to store the array of VARCHAR2 values thta are converted from the array of numeric validation rule set ID values
			V_TEMP_STRING_ARRAY VARCHAR_ARRAY_NUM;

			--variable to store the comma-delimited string of generated placeholders for the dynamic query
			V_PLACEHOLDER_STRING CLOB;

			--variable to store array of placeholder variable names for the dynamic query
 			V_PLACEHOLDER_ARRAY VARCHAR_ARRAY_NUM;

			--variable to store the comma-delimited string of placeholder values
-- 			V_DELIM_STRING CLOB;

			--variable to store the return code from a given stored procedure call
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - RETRIEVE_QC_CRITERIA_SP (P_RULE_SET_ID_ARRAY: '||COMMA_DELIM_LIST_FN(P_RULE_SET_ID_ARRAY)||')';


			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Running RETRIEVE_QC_CRITERIA_SP()', V_SP_RET_CODE);

			--loop through the rule set IDs and convert the numeric IDs to equivalent varchar2 IDs so the same GENERATE_PLACEHOLDERS_SP procedure can be used
			FOR i in 1..P_RULE_SET_ID_ARRAY.COUNT LOOP

				--add the converted string value of the current rule set ID to the array of
				V_TEMP_STRING_ARRAY(i) := TO_CHAR(P_RULE_SET_ID_ARRAY(i));

			END LOOP;


			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Generate the placeholders for the different validation rule sets', V_SP_RET_CODE);


			--generate the placeholders for the rule_set_id values:
			GENERATE_PLACEHOLDERS_SP (V_TEMP_STRING_ARRAY, V_PLACEHOLDER_STRING, V_PLACEHOLDER_ARRAY, V_SP_RET_CODE);

			--check to see if GENERATE_PLACEHOLDERS_SP has completed successfully
			IF (V_SP_RET_CODE = 1) THEN
				--the GENERATE_PLACEHOLDERS_SP procedure has completed successfully

				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The placeholders were generated successfully, execute the query', V_SP_RET_CODE);

				--construct the query for all QC criteria for the specified RULE_SET_ID values (P_RULE_SET_ID_ARRAY)
				V_TEMP_SQL := 'SELECT
				DVM_RULE_SETS_V.OBJECT_NAME,
				DVM_RULE_SETS_V.DATA_STREAM_PK_FIELD,
				DVM_RULE_SETS_V.IND_FIELD_NAME,
				DVM_RULE_SETS_V.ISS_TYPE_COMMENT_TEMPLATE,
				DVM_RULE_SETS_V.ISS_TYPE_ID,
				DVM_RULE_SETS_V.QC_OBJECT_ID,
				DVM_RULE_SETS_V.APP_LINK_TEMPLATE
			  FROM DVM_RULE_SETS_V
				WHERE RULE_SET_ID IN ('||V_PLACEHOLDER_STRING||')
			  ORDER BY QC_SORT_ORDER, OBJECT_NAME, ISS_TYPE_ID';

				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Query for the QC criteria: '||V_TEMP_SQL, V_SP_RET_CODE);

			-- Open SQL cursor number:
			  CUR_ID := DBMS_SQL.OPEN_CURSOR;

				-- Parse SQL query:
				DBMS_SQL.PARSE(CUR_ID, V_TEMP_SQL, DBMS_SQL.NATIVE);

				--retrieve all of the column descriptions for the dynamic database query:
				DBMS_SQL.DESCRIBE_COLUMNS(CUR_ID, COL_CNT, PV_DESC_TAB);

				--loop through each column's description to define each column's data type:
				FOR i IN 1 .. COL_CNT LOOP

					--save the column position in the array element defined by the column name:
					PV_ASSOC_FIELD_LIST (PV_DESC_TAB(i).col_name) := i;

					--save the column name in the array element defined by the column position:
					PV_NUM_FIELD_LIST (i) := PV_DESC_TAB(i).col_name;

					--retrieve column metadata from query results (the select list is known at compile time so it is already known that only numeric and character data types are used).  Check the data type of the current column

					--check the data type for the current column
					IF PV_DESC_TAB(i).col_type = 2 THEN
						--this is a numeric value:

						--define the column data type as a NUMBER
						DBMS_SQL.DEFINE_COLUMN(CUR_ID, i, NUM_VAR);

					ELSIF PV_DESC_TAB(i).col_type IN (1, 96) THEN
						--this is a CHAR/VARCHAR data type:

						--define the column data type as a long character string
						DBMS_SQL.DEFINE_COLUMN(CUR_ID, i, NAME_VAR, 2000);

					ELSIF PV_DESC_TAB(i).col_type = 112 THEN
						--this is a CLOB data type:

						--define the column data type as a long character string
						DBMS_SQL.DEFINE_COLUMN(CUR_ID, i, CLOB_VAR, 10000);

					END IF;

				END LOOP;




				 -- Bind the query variables, loop through each of the rule set IDs defined for the parent table:
				FOR i IN 1 .. P_RULE_SET_ID_ARRAY.COUNT LOOP
					--loop through the data stream codes:

					--bind the given placeholder variable with the corresponding rule set ID value:
					DBMS_SQL.BIND_VARIABLE(CUR_ID, V_PLACEHOLDER_ARRAY(i), P_RULE_SET_ID_ARRAY(i));

				END LOOP;

				--execute the query
				IGNORE := DBMS_SQL.EXECUTE(CUR_ID);

				--initialize the result row counter:
				V_ALL_CRITERIA_POS := 1;

				--loop through each QC criteria result set row:
				LOOP

					--fetch the next row if there is another on in the result set:
					IF DBMS_SQL.FETCH_ROWS(CUR_ID)>0 THEN

--						DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'the value of V_ALL_CRITERIA_POS is: '||V_ALL_CRITERIA_POS, V_SP_RET_CODE);

					  --loop through each column in the result set row:
					  FOR i IN 1 .. COL_CNT LOOP


							--retrieve column metadata from query results:
							IF PV_DESC_TAB(i).col_type = 2 THEN
								--this is a numeric value:

								--retrieve the NUMBER value into the procedure variable
								DBMS_SQL.COLUMN_VALUE(CUR_ID, i, NUM_VAR);

								--check the column name to assign it to the corresponding PV_ALL_CRITERIA element record field values
								IF PV_DESC_TAB(i).col_name = 'ISS_TYPE_ID' THEN	--this is the ISS_TYPE_ID field, store the numeric value of the current record's field in the current PV_ALL_CRITERIA array element for the corresponding variable field
									PV_ALL_CRITERIA(V_ALL_CRITERIA_POS).ISS_TYPE_ID := NUM_VAR;

								ELSIF PV_DESC_TAB(i).col_name = 'QC_OBJECT_ID' THEN  --this is the QC_OBJECT_ID field, store the numeric value of the current record's field in the current PV_ALL_CRITERIA array element for the corresponding variable field
									PV_ALL_CRITERIA(V_ALL_CRITERIA_POS).QC_OBJECT_ID := NUM_VAR;

								END IF;

							ELSIF PV_DESC_TAB(i).col_type IN (1, 96) THEN
								--this is a CHAR/VARCHAR data type:

								DBMS_SQL.COLUMN_VALUE(CUR_ID, i, NAME_VAR);

								--check the column name to assign it to the corresponding PV_ALL_CRITERIA element record field values
								IF PV_DESC_TAB(i).col_name = 'OBJECT_NAME' THEN  --this is the OBJECT_NAME field, store the numeric value of the current record's field in the current PV_ALL_CRITERIA array element for the corresponding variable field
									PV_ALL_CRITERIA(V_ALL_CRITERIA_POS).OBJECT_NAME := NAME_VAR;

--									DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The value of the QC object name is: '||NAME_VAR, V_SP_RET_CODE);

								ELSIF PV_DESC_TAB(i).col_name = 'DATA_STREAM_PK_FIELD' THEN  --this is the DATA_STREAM_PK_FIELD field, store the numeric value of the current record's field in the current PV_ALL_CRITERIA array element for the corresponding variable field
									PV_ALL_CRITERIA(V_ALL_CRITERIA_POS).DATA_STREAM_PK_FIELD := NAME_VAR;

								ELSIF PV_DESC_TAB(i).col_name = 'IND_FIELD_NAME' THEN  --this is the IND_FIELD_NAME field, store the numeric value of the current record's field in the current PV_ALL_CRITERIA array element for the corresponding variable field
									PV_ALL_CRITERIA(V_ALL_CRITERIA_POS).IND_FIELD_NAME := NAME_VAR;

								ELSIF PV_DESC_TAB(i).col_name = 'APP_LINK_TEMPLATE' THEN  --this is the APP_LINK_TEMPLATE field, store the numeric value of the current record's field in the current PV_ALL_CRITERIA array element for the corresponding variable field
									PV_ALL_CRITERIA(V_ALL_CRITERIA_POS).APP_LINK_TEMPLATE := NAME_VAR;

								END IF;
							ELSIF PV_DESC_TAB(i).col_type = 112 THEN

								--store the column value
								DBMS_SQL.COLUMN_VALUE(CUR_ID, i, CLOB_VAR);

								--check the column name to assign it to the corresponding PV_ALL_CRITERIA element record field values
								IF PV_DESC_TAB(i).col_name = 'ISS_TYPE_COMMENT_TEMPLATE' THEN  --this is the ISS_TYPE_COMMENT_TEMPLATE field, store the numeric value of the current record's field in the current PV_ALL_CRITERIA array element for the corresponding variable field
									PV_ALL_CRITERIA(V_ALL_CRITERIA_POS).ISS_TYPE_COMMENT_TEMPLATE := CLOB_VAR;
								END IF;

							END IF;

						END LOOP;

					  --increment the row counter variable:
					  V_ALL_CRITERIA_POS := V_ALL_CRITERIA_POS + 1;

				  ELSE

						-- There are no more rows to process, exit the loop:
						EXIT;
				  END IF;
				END LOOP;


				--close the dynamic query cursor:
				DBMS_SQL.CLOSE_CURSOR(CUR_ID);


				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The RETRIEVE_QC_CRITERIA_SP procedure was executed successfully, the number of validation criteria rules that were loaded is: '||PV_ALL_CRITERIA.COUNT, V_SP_RET_CODE);


				--define the return code that indicates that the QC criteria was successfully retrieved from the database
				P_SP_RET_CODE := 1;
			ELSE
				--the GENERATE_PLACEHOLDERS_SP procedure has not completed successfully

				--define the return code that indicates that there was processing error due a database or PL/SQL error:
				P_SP_RET_CODE := -1;

				--log the processing error
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'the GENERATE_PLACEHOLDERS_SP procedure failed to successfully execute', V_SP_RET_CODE);

			END IF;


			EXCEPTION

				--catch all PL/SQL database exceptions:
				WHEN OTHERS THEN
					--catch all other errors:

					--log the processing error
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

					--define the return code that indicates that there was processing error due a database or PL/SQL error:
					P_SP_RET_CODE := -1;

		END RETRIEVE_QC_CRITERIA_SP;





		--define the parent issue record for the parent record
		PROCEDURE DEFINE_PARENT_ISSUE_REC_SP (P_SP_RET_CODE OUT PLS_INTEGER) IS

			--procedure variable to store generated SQL statements that are executed in the procedure:
			V_TEMP_SQL CLOB;

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
      V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - DEFINE_PARENT_ISSUE_REC_SP ()';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Running DEFINE_PARENT_ISSUE_REC_SP()', V_SP_RET_CODE);


			--execute the insert query to create a new parent issue record for the given parent record:
			INSERT INTO DVM_PTA_ISSUES (CREATE_DATE) VALUES (SYSDATE) RETURNING PTA_ISS_ID, CREATE_DATE INTO PV_PTA_ISSUE.PTA_ISS_ID, PV_PTA_ISSUE.CREATE_DATE;

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Parent Issue Record inserted successfully (PTA_ISS_ID: '||PV_PTA_ISSUE.PTA_ISS_ID||')', V_SP_RET_CODE);

/*			--loop through the array of validation rule set IDs and insert the new PTA rule set records for each one:
			FOR i IN 1 .. P_RULE_SET_ID_ARRAY.COUNT LOOP
				--insert the new PTA rule set record for the current rule set:
				INSERT INTO DVM_PTA_RULE_SETS (RULE_SET_ID, PTA_ISS_ID, FIRST_EVAL_DATE) VALUES (P_RULE_SET_ID_ARRAY(i), PV_PTA_ISSUE.PTA_ISS_ID, SYSDATE);

				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Added the new DVM_PTA_RULES record (RULE_SET_ID: '||P_RULE_SET_ID_ARRAY(i)||'), (PTA_ISS_ID: '||PV_PTA_ISSUE.PTA_ISS_ID||')', V_SP_RET_CODE);
			END LOOP;
*/

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The parent issue record was inserted successfully', V_SP_RET_CODE);


			--parent issue record was loaded successfully:
			P_SP_RET_CODE := 1;


			EXCEPTION

				--catch all PL/SQL database exceptions:
				WHEN OTHERS THEN
					--catch all other errors:

					--log the processing error
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);


					--define the return code that indicates that the parent issue record was not loaded successfully:
					P_SP_RET_CODE := -1;

		END DEFINE_PARENT_ISSUE_REC_SP;


		--associate the parent record with the new parent issue record:
		PROCEDURE ASSOC_PARENT_ISSUE_REC_SP (P_SP_RET_CODE OUT PLS_INTEGER) IS

			--procedure variable to store generated SQL statements that are executed in the procedure:
			V_TEMP_SQL CLOB;

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - ASSOC_PARENT_ISSUE_REC_SP ()';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Running ASSOC_PARENT_ISSUE_REC_SP()', V_SP_RET_CODE);

			--construct the query to update the parent table to associate it with the new parent issue record::
			V_TEMP_SQL := 'UPDATE '||PV_DATA_STREAM_PAR_TABLE||' SET PTA_ISS_ID = :pta_errid WHERE '||PV_DATA_STREAM_PK_FIELD||' = :pkid';


			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The query is: '||V_TEMP_SQL, V_SP_RET_CODE);

			--execute the query
			EXECUTE IMMEDIATE V_TEMP_SQL USING PV_PTA_ISSUE.PTA_ISS_ID, PV_PK_ID;

			--set the return code to indicate the parent record was successfully associated with the new parent issue record:
			P_SP_RET_CODE := 1;



			EXCEPTION

				--catch all PL/SQL database exceptions:
				WHEN OTHERS THEN
					--catch all other errors:

					--define the return code that indicates that the parent record was not associated with the parent issue record successfully:
					P_SP_RET_CODE := -1;

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

		END ASSOC_PARENT_ISSUE_REC_SP;


		--evaluate the QC criteria stored in PV_ALL_CRITERIA for the given parent record:
		PROCEDURE EVAL_QC_CRITERIA_SP (P_SP_RET_CODE OUT PLS_INTEGER) IS

			--procedure variable to store the PV_ALL_CRITERIA array element position so it can be processed using the PROCESS_QC_CRITERIA_SP procedure, this is used during the PV_ALL_CRITERIA main processing loop:
			V_CURR_QC_BEGIN_POS PLS_INTEGER;

			--procedure variable to store a boolean that indicates if the processing of QC criteria should continue:
			V_CONTINUE BOOLEAN;

			--procedure variable to store the current QC_OBJ_ID value (indicates which QC object from PV_ALL_CRITERIA is currently being processed)
			V_CURRENT_QC_OBJ_ID NUMBER;

			--procedure variable to store generated SQL statements that are executed in the procedure:
			V_TEMP_SQL CLOB;

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--procedure variable to store numeric ISS_ID values for deletion (when existing validation issue records need to be purged if the issue condition no longer applies)
			V_ISS_IDS NUM_ARRAY;

			--procedure variable to store the existing DVM_ISSUES for the given parent issue record
			V_EXISTING_ISSUE_REC_TABLE DVM_ISSUES_TABLE;

			--procedure variable to store the position of the given DVM_ISSUES record while looping through V_EXISTING_ISSUE_REC_TABLE:
			V_EXISTING_ISSUE_REC_COUNTER PLS_INTEGER;

			--procedure variable to store the position of the given DVM_ISSUES record while looping through PV_ISSUE_REC_TABLE:
			V_ISSUE_REC_COUNTER PLS_INTEGER;


			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - EVAL_QC_CRITERIA_SP ()';


			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'running EVAL_QC_CRITERIA_SP ()', V_SP_RET_CODE);

			--initialize the tracking variable for the processing loop:
			V_CURRENT_QC_OBJ_ID := NULL;

			--initialize the V_CONTINUE variable:
			V_CONTINUE := true;


			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'there are '||PV_ALL_CRITERIA.COUNT||' QC criteria to evaluate', V_SP_RET_CODE);

			--loop through the QC criteria to execute each query and process each QC object separately:
			FOR indx IN 1 .. PV_ALL_CRITERIA.COUNT
			LOOP

--				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'indx ('||indx||'), QC object: '||PV_ALL_CRITERIA(indx).OBJECT_NAME, V_SP_RET_CODE);


				--check the QC_OBJECT_ID value:
				IF (V_CURRENT_QC_OBJ_ID IS NULL) THEN
					--the QC object ID is NULL, this is the first record in the loop:

					--set the QC object's begin position to 1 since this is the first value to be processed:
					V_CURR_QC_BEGIN_POS := 1;

					--initialize the V_CURRENT_QC_OBJ_ID variable:
					V_CURRENT_QC_OBJ_ID := PV_ALL_CRITERIA(indx).QC_OBJECT_ID;

				ELSIF (V_CURRENT_QC_OBJ_ID <> PV_ALL_CRITERIA(indx).QC_OBJECT_ID) THEN
					--this is not the same QC object as the previous issue type:

					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'this is not the same QC object as the previous issue type, run PROCESS_QC_CRITERIA_SP on the previous QC criteria object ('||PV_ALL_CRITERIA(indx - 1).OBJECT_NAME||')', V_SP_RET_CODE);

					--process the last QC object:
					PROCESS_QC_CRITERIA_SP (V_CURR_QC_BEGIN_POS, (indx - 1), V_SP_RET_CODE);

					--check the procedure return code
					IF (V_SP_RET_CODE = -1) THEN

						--there was an error processing the current QC criteria:

						--log the processing error
						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'There was an error when processing the current QC criteria object: '||PV_ALL_CRITERIA(indx - 1).OBJECT_NAME, V_SP_RET_CODE);


						--set the continue variable to false:
						V_CONTINUE := false;

						--exit the loop, no additional processing is necessary since there was an error processing the validation criteria:
						EXIT;
					END IF;



					--initialize the current QC object:
					V_CURR_QC_BEGIN_POS := indx;

					--set the QC_OBJ_ID variable value to the current row's corresponding value:
					V_CURRENT_QC_OBJ_ID := PV_ALL_CRITERIA(indx).QC_OBJECT_ID;


				END IF;





			END LOOP;

			--check if there have been any processing errors so far
			IF (V_CONTINUE) THEN
				--there are no processing errors encountered so far


				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'execute the PROCESS_QC_CRITERIA_SP() procedure for the last QC object definition: '||PV_ALL_CRITERIA(V_CURR_QC_BEGIN_POS).OBJECT_NAME, V_SP_RET_CODE);

				--there are no processing errors, process the last QC criteria:
				PROCESS_QC_CRITERIA_SP (V_CURR_QC_BEGIN_POS, PV_ALL_CRITERIA.COUNT, V_SP_RET_CODE);

				--check the procedure return code
				IF (V_SP_RET_CODE = -1) THEN

					--there was an error processing the current QC criteria:

					--log the processing error
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'There was an error when processing the current QC criteria object: '||PV_ALL_CRITERIA(V_CURR_QC_BEGIN_POS).OBJECT_NAME, V_SP_RET_CODE);


					--set the continue variable to false:
					V_CONTINUE := false;

				END IF;



			END IF;


			--check if all of the QC criteria was processed successfully:
			IF (V_CONTINUE) THEN
				--the QC criteria was processed successfully, loop through each of the validation issue records that were defined in the package variable by the POPULATE_ISSUE_REC_SP() procedure:

				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'the QC criteria was processed successfully, loop through each of the validation issue records that were defined in the package variable by the POPULATE_ISSUE_REC_SP() procedure', V_SP_RET_CODE);

				--check if this is the first time the given record has been validated:
				IF NOT (PV_FIRST_VALIDATION) THEN
					--this is not the first time the given record has been validated, check the pending issue records against the existing ones:

					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'this is not the first time the given record has been validated retrieve the existing validation issues to compare against the pending issue records', V_SP_RET_CODE);


					--determine all of the ISS_ID values of the existing issue records that should be deleted (those are the existing issue records that do not match a pending issue record's generated issue description)
					RETRIEVE_ISSUE_RECS_SP (V_EXISTING_ISSUE_REC_TABLE, V_SP_RET_CODE);

					--check if the issue records have been retrieved successfully
					IF (V_SP_RET_CODE = 1) then
						--the issue records have been retrieve successfully

						DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'the validation issue records were retrieved successfully', V_SP_RET_CODE);

						--loop through and compare all existing issue records to the pending issue records:
						V_EXISTING_ISSUE_REC_COUNTER := V_EXISTING_ISSUE_REC_TABLE.FIRST;

						--begin the loop through the existing issue records:
						WHILE V_EXISTING_ISSUE_REC_COUNTER IS NOT NULL LOOP

							DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Looping through the existing issue record ('||V_EXISTING_ISSUE_REC_TABLE(V_EXISTING_ISSUE_REC_COUNTER).ISS_ID||') description: '||V_EXISTING_ISSUE_REC_TABLE(V_EXISTING_ISSUE_REC_COUNTER).ISS_DESC, V_SP_RET_CODE);

							--loop through all pending issue records:
							V_ISSUE_REC_COUNTER := PV_ISSUE_REC_TABLE.FIRST;

							--start the loop:
							WHILE V_ISSUE_REC_COUNTER IS NOT NULL LOOP

								DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Looping through the pending issue record: '||PV_ISSUE_REC_TABLE(V_ISSUE_REC_COUNTER).ISS_DESC, V_SP_RET_CODE);


								--check if the current existing issue description and iss_type_ID matches the pending issue description:
								IF (PV_ISSUE_REC_TABLE(V_ISSUE_REC_COUNTER).ISS_DESC = V_EXISTING_ISSUE_REC_TABLE(V_EXISTING_ISSUE_REC_COUNTER).ISS_DESC) AND (PV_ISSUE_REC_TABLE(V_ISSUE_REC_COUNTER).ISS_TYPE_ID = V_EXISTING_ISSUE_REC_TABLE(V_EXISTING_ISSUE_REC_COUNTER).ISS_TYPE_ID) THEN
									--the current existing issue description and issue_type_ID matches the pending issue description, remove both the pending and existing nested table elements

									--remove the current pending issue record from the nested table variable:
									PV_ISSUE_REC_TABLE.DELETE(V_ISSUE_REC_COUNTER);

									--remove the current existing issue record from the nested table variable:
									V_EXISTING_ISSUE_REC_TABLE.DELETE(V_EXISTING_ISSUE_REC_COUNTER);

									DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The current pending validation issue record and existing validation issue record match each other (description and issue type), remove both of them from their respective arrays', V_SP_RET_CODE);


									EXIT;
								END IF;


								--increment to the next pending issue record:
								V_ISSUE_REC_COUNTER := PV_ISSUE_REC_TABLE.NEXT(V_ISSUE_REC_COUNTER);

							END LOOP;



							--increment to the next existing issue record:
							V_EXISTING_ISSUE_REC_COUNTER := V_EXISTING_ISSUE_REC_TABLE.NEXT(V_EXISTING_ISSUE_REC_COUNTER);
						END LOOP;



						DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'all of the comparisons have been made, delete all of the existing issue records that were not matched ('||V_EXISTING_ISSUE_REC_TABLE.COUNT||' total)', V_SP_RET_CODE);

						--construct the currnet delete DVM_ISSUES record since it doesn't match any pending issue records:
						V_TEMP_SQL := 'DELETE FROM DVM_ISSUES WHERE ISS_ID = :iss_id';

						--loop through all of the existing issue records that did not match so they can be deleted:
						V_EXISTING_ISSUE_REC_COUNTER := V_EXISTING_ISSUE_REC_TABLE.FIRST;

						--begin the loop through the existing issue records:
						WHILE V_EXISTING_ISSUE_REC_COUNTER IS NOT NULL LOOP
							--delete the existing validation issue record

							DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Delete the existing issue record: '||V_EXISTING_ISSUE_REC_TABLE(V_EXISTING_ISSUE_REC_COUNTER).ISS_ID, V_SP_RET_CODE);



							--delete the current validation issue record since the corresponding issue was not identified when the DVM was re-evaluated
							EXECUTE IMMEDIATE V_TEMP_SQL USING V_EXISTING_ISSUE_REC_TABLE(V_EXISTING_ISSUE_REC_COUNTER).ISS_ID;

							--increment to the next existing issue record:
							V_EXISTING_ISSUE_REC_COUNTER := V_EXISTING_ISSUE_REC_TABLE.NEXT(V_EXISTING_ISSUE_REC_COUNTER);

						END LOOP;
					ELSE
						--QC criteria was not processed successfully:
						P_SP_RET_CODE := -1;

						--log the processing error:
						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'There was a problem querying the DVM issue records', V_SP_RET_CODE);


					END IF;
				END IF;


				--check if there have been any processing errors encountered so far:
				IF (P_SP_RET_CODE IS NULL) THEN
					--no processing errors have been encountered so far, insert the DVM validation issue records:

					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'no processing errors have been encountered so far, insert the DVM validation issue records', V_SP_RET_CODE);


					--construct the parameterized query to insert all of the QC criteria issue records:
					V_TEMP_SQL := 'INSERT INTO DVM_ISSUES (PTA_ISS_ID, ISS_DESC, CREATE_DATE, CREATED_BY, ISS_TYPE_ID, APP_LINK_URL) VALUES (:p01, :p02, SYSDATE, :p03, :p04, :p05)';


--					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'insert all of the unmatched pending issue records ('||PV_ISSUE_REC_TABLE.COUNT||' total)', V_SP_RET_CODE);

					--loop through each element in the PV_ISSUE_REC_TABLE package variable:
					V_ISSUE_REC_COUNTER := PV_ISSUE_REC_TABLE.FIRST;

					--start the processing loop:
					WHILE V_ISSUE_REC_COUNTER IS NOT NULL LOOP

						DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'insert the issue with issue description: "'||PV_ISSUE_REC_TABLE(V_ISSUE_REC_COUNTER).ISS_DESC, V_SP_RET_CODE);


						--execute the DVM issue record insert query using the current PV_ISSUE_REC_TABLE package variable for this new validation issue:
						EXECUTE IMMEDIATE V_TEMP_SQL USING PV_ISSUE_REC_TABLE(V_ISSUE_REC_COUNTER).PTA_ISS_ID, PV_ISSUE_REC_TABLE(V_ISSUE_REC_COUNTER).ISS_DESC, sys_context( 'userenv', 'current_schema' ), PV_ISSUE_REC_TABLE(V_ISSUE_REC_COUNTER).ISS_TYPE_ID, PV_ISSUE_REC_TABLE(V_ISSUE_REC_COUNTER).APP_LINK_URL;

						--increment to the next pending issue record:
						V_ISSUE_REC_COUNTER := PV_ISSUE_REC_TABLE.NEXT(V_ISSUE_REC_COUNTER);

					END LOOP;



					--define the return code that indicates that the QC criteria was processed successfully and the corresponding issue records were loaded into the database:
					P_SP_RET_CODE := 1;

				END IF;

			ELSE
				--QC criteria was not processed successfully:
				P_SP_RET_CODE := -1;

				--log the error
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'QC criteria was not processed successfully', V_SP_RET_CODE);

			END IF;

			EXCEPTION


				--catch all PL/SQL database exceptions:
				WHEN OTHERS THEN
					--catch all other errors:

					--log the error
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

					--define the return code that indicates that there was an error when processing the QC validation criteria:
					P_SP_RET_CODE := -1;

		END EVAL_QC_CRITERIA_SP;


		--validate a specific QC criteria in PV_ALL_CRITERIA in the elements from P_BEGIN_POS to P_END_POS
		PROCEDURE PROCESS_QC_CRITERIA_SP (P_BEGIN_POS IN PLS_INTEGER, P_END_POS IN PLS_INTEGER, P_SP_RET_CODE OUT PLS_INTEGER) IS


			--procedure variable to store generated SQL statements that are executed in the procedure:
			V_TEMP_SQL CLOB;

			--cursor type used for executing and processing the dynamic QC queries
			TYPE CUR_TYPE IS REF CURSOR;

			--source cursor variable used for processing the dynamic QC queries
			SRC_CUR  CUR_TYPE;

			--dynamic cursor ID variable for the dynamic SQL query for the DBMS_SQL query method:
			CUR_ID    NUMBER;

			--number used to store the number of columns returned by the dynamic query for the DBMS_SQL query method:
			COL_CNT   NUMBER;

			--procedure variable to store the character string data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			NAME_VAR  VARCHAR2(2000);

			--procedure variable to store the numeric data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			NUM_VAR   NUMBER;

			--procedure variable to store the date data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			DATE_VAR  DATE;

			--procedure variable to store a given DVM_ISSUES record values that is returned by the POPULATE_ISSUE_REC_SP() procedure:
			V_TEMP_ISSUE_REC DVM_ISSUES%ROWTYPE;

			--procedure variable to store a boolean that indicates if the processing of QC criteria should continue:
			V_CONTINUE BOOLEAN;

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;


			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - PROCESS_QC_CRITERIA_SP (P_BEGIN_POS: '||P_BEGIN_POS||', P_END_POS: '||P_END_POS||')';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'running PROCESS_QC_CRITERIA_SP ()', V_SP_RET_CODE);

			--initialize the V_CONTINUE variable:
			V_CONTINUE := true;

			--initialize the package package variables that contain information about the result set:
			PV_ASSOC_FIELD_LIST.delete;
			PV_NUM_FIELD_LIST.delete;
			PV_DESC_TAB.delete;


			--construct the QC query to be executed to determine if a given parent record has any of the corresponding validation issues:
			V_TEMP_SQL := 'SELECT * FROM '||PV_ALL_CRITERIA(P_BEGIN_POS).OBJECT_NAME||' WHERE '||PV_ALL_CRITERIA(P_BEGIN_POS).DATA_STREAM_PK_FIELD||' = :pkid';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'the value of the QC query to be executed is: '||V_TEMP_SQL, V_SP_RET_CODE);

			-- Open Source cursor for the current QC query:
			OPEN SRC_CUR FOR V_TEMP_SQL USING PV_PK_ID;

			-- Switch from native dynamic SQL to DBMS_SQL package:
			CUR_ID := DBMS_SQL.TO_CURSOR_NUMBER(SRC_CUR);

			--retrieve the result set column information:
			DBMS_SQL.DESCRIBE_COLUMNS(CUR_ID, COL_CNT, PV_DESC_TAB);

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'fetching column descriptions', V_SP_RET_CODE);
			-- loop through each column and defined the data type of each column dynamically:
			FOR i IN 1 .. COL_CNT LOOP
--				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'current column name is: '||PV_DESC_TAB(i).col_name, V_SP_RET_CODE);

			  --save the column position in the array element defined by the column name (to facilitate the generating of issue messages based on the issue type template value):
			  PV_ASSOC_FIELD_LIST (PV_DESC_TAB(i).col_name) := i;

			  --save the column name in the array element defined by the column position (to facilitate the generating of issue messages based on the issue type template value):
			  PV_NUM_FIELD_LIST (i) := PV_DESC_TAB(i).col_name;

			  --retrieve column metadata from query results:
			  IF PV_DESC_TAB(i).col_type = 2 THEN
					--define the result set data type as NUMBER for the current column:
					DBMS_SQL.DEFINE_COLUMN(CUR_ID, i, NUM_VAR);

--					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'current NUM_VAR is: '||NUM_VAR, V_SP_RET_CODE);
			  ELSIF PV_DESC_TAB(i).col_type = 12 THEN

					--define the result set data type as DATE for the current column:
					DBMS_SQL.DEFINE_COLUMN(CUR_ID, i, DATE_VAR);

--					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'current DATE_VAR is: '||DATE_VAR, V_SP_RET_CODE);

			  ELSIF PV_DESC_TAB(i).col_type IN (1, 96) THEN
					 --define the result set data type as VARCHAR2 for the current column:
					DBMS_SQL.DEFINE_COLUMN(CUR_ID, i, NAME_VAR, 2000);

--					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'current NAME_VAR is: '||NAME_VAR, V_SP_RET_CODE);

			  END IF;

			END LOOP;

--			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'fetching rows', V_SP_RET_CODE);


			-- Fetch rows with DBMS_SQL package to loop through the result set:
			WHILE DBMS_SQL.FETCH_ROWS(CUR_ID) > 0 LOOP

--				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'fetching new row from result set', V_SP_RET_CODE);

				--loop through the ISSUE_TYPES for the given QC View (all of these values are CHAR/VARCHAR2 fields based on documented requirements):
				FOR j IN P_BEGIN_POS .. P_END_POS LOOP

--					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'current IND_FIELD_NAME is: '||PV_ALL_CRITERIA(j).IND_FIELD_NAME, V_SP_RET_CODE);



				  --retrieve the field name for the current QC criteria IND_FIELD_NAME and retrieve the result set's corresponding column value
				  DBMS_SQL.COLUMN_VALUE(CUR_ID, PV_ASSOC_FIELD_LIST(PV_ALL_CRITERIA(j).IND_FIELD_NAME), NAME_VAR);

--					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'current IND_FIELD_NAME is: '||PV_ALL_CRITERIA(j).IND_FIELD_NAME||', the corresponding result set value is: '||NAME_VAR, V_SP_RET_CODE);


				  --check if the current QC criteria was evaluated to true:
				  IF (NAME_VAR = 'Y') THEN
					  --the current QC criteria was evaluated as a validation issue, generate the issue message:

						DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The IND_FIELD_NAME ('||PV_ALL_CRITERIA(j).IND_FIELD_NAME||') is ''Y'', populate a new pending validation issue record so it can be compared to existing validation issues and inserted if it does not already exist', V_SP_RET_CODE);

					  --populate the issue rec based on the current QC criteria that was evaluated to true:
					  POPULATE_ISSUE_REC_SP (CUR_ID, j, V_TEMP_ISSUE_REC, V_SP_RET_CODE);

					  --add the issue record information to the PV_ISSUE_REC_TABLE array variable for loading into the database later:
					  PV_ISSUE_REC_TABLE ((PV_ISSUE_REC_TABLE.COUNT + 1)) := V_TEMP_ISSUE_REC;

						DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The validation issue was added to the array of issues', V_SP_RET_CODE);

					  --re-initialize the issue rec:
					  V_TEMP_ISSUE_REC := NULL;

					  --check the procedure return code
					  IF (V_SP_RET_CODE = -1) THEN

							--the POPULATE_ISSUE_REC_SP procedure failed, exit the loop:

							--log the error
							DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'the POPULATE_ISSUE_REC_SP procedure failed, exit the loop', V_SP_RET_CODE);

							--set V_CONTINUE to false:
							V_CONTINUE := false;

							--exit the loop
							EXIT;

					  END IF;

				  END IF;

				END LOOP;

			END LOOP;

			--close the dynamic cursor:
			DBMS_SQL.CLOSE_CURSOR(CUR_ID);

--			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'closing cursor SRC_CUR in PROCESS_QC_CRITERIA_SP()', V_SP_RET_CODE);

			EXCEPTION
				--catch all PL/SQL database exceptions:
				WHEN OTHERS THEN
					--catch all other errors:

					--define the return code that indicates that there was an error when processing the QC validation criteria:
					P_SP_RET_CODE := -1;

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);


		END PROCESS_QC_CRITERIA_SP;


		--procedure to populate an issue record with the information from the corresponding result set row:
		PROCEDURE POPULATE_ISSUE_REC_SP (CUR_ID IN NUMBER, QC_CRITERIA_POS IN NUMBER, ISSUE_REC OUT DVM_ISSUES%ROWTYPE, P_SP_RET_CODE OUT PLS_INTEGER) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the generated issue message based off of the ISS_TYPE_COMMENT_TEMPLATE and the runtime values returned by the QC query result set:
			TEMP_ISS_MESSAGE CLOB;

			--variable to store the generated application link based off of the APP_LINK_TEMPLATE and the runtime values returned by the QC query result set:
			TEMP_APP_LINK VARCHAR2(2000);


			--procedure variable to store the character string data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			NAME_VAR  VARCHAR2(2000);

			--procedure variable to store the numeric data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			NUM_VAR   NUMBER;

			--procedure variable to store the date data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			DATE_VAR  DATE;

			--procedure variable to store the current field name from the associative array
--			temp_field_name VARCHAR2(30);

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - POPULATE_ISSUE_REC_SP (CUR_ID: '||CUR_ID||', QC_CRITERIA_POS: '||QC_CRITERIA_POS||')';


			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Running POPULATE_ISSUE_REC_SP (), issue type template is: '||PV_ALL_CRITERIA(QC_CRITERIA_POS).ISS_TYPE_COMMENT_TEMPLATE, V_SP_RET_CODE);



			--set the TEMP_ISS_MESSAGE to the given issue type comment template (ISS_TYPE_COMMENT_TEMPLATE) based on the current result set values:
			REPLACE_PLACEHOLDER_VALS_SP (CUR_ID, QC_CRITERIA_POS, PV_ALL_CRITERIA(QC_CRITERIA_POS).ISS_TYPE_COMMENT_TEMPLATE, TEMP_ISS_MESSAGE, FALSE, V_SP_RET_CODE);
			IF (V_SP_RET_CODE = 1) THEN
				--the placeholders were successfully replaced:

				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The issue type template was replaced with runtime values from the query successfully: '||TEMP_ISS_MESSAGE||'. Process the application link template: '||PV_ALL_CRITERIA(QC_CRITERIA_POS).APP_LINK_TEMPLATE, V_SP_RET_CODE);

				--set the TEMP_APP_LINK to the given issue type comment template (APP_LINK_TEMPLATE) based on the current result set values:
				REPLACE_PLACEHOLDER_VALS_SP (CUR_ID, QC_CRITERIA_POS, PV_ALL_CRITERIA(QC_CRITERIA_POS).APP_LINK_TEMPLATE, TEMP_APP_LINK, TRUE, V_SP_RET_CODE);
				IF (V_SP_RET_CODE = 1) THEN
					--the placeholders were successfully replaced:

					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The application link template was replaced with runtime values from the query successfully: '||TEMP_APP_LINK||'.  Populate the pending validation issue record with the replaced values', V_SP_RET_CODE);


					--set the attribute information for the current validation issue so the corresponding validation issue record can be inserted into the database by the calling procedure:
					ISSUE_REC.ISS_DESC := TEMP_ISS_MESSAGE;
					ISSUE_REC.ISS_TYPE_ID := PV_ALL_CRITERIA(QC_CRITERIA_POS).ISS_TYPE_ID;
					ISSUE_REC.PTA_ISS_ID := PV_PTA_ISSUE.PTA_ISS_ID;
					ISSUE_REC.APP_LINK_URL := TEMP_APP_LINK;

				ELSIF (V_SP_RET_CODE = 0) THEN
					--the placeholders were not all found in the result set:

					--log the processing error
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'the placeholders were not all found in the application URL result set', V_SP_RET_CODE);

					--set the issue code:
					P_SP_RET_CODE := -1;

				ELSE
					--an error occurred when processing the template:

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'there was a problem processing the application URL template', V_SP_RET_CODE);

					--set the error code:
					P_SP_RET_CODE := -1;
				END IF;


			ELSIF (V_SP_RET_CODE = 0) THEN
				--the placeholders were not all found in the result set:

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'the error description placeholders were not all found in the result set', V_SP_RET_CODE);
				--set the error code:
				P_SP_RET_CODE := -1;

			ELSE
				--an error occurred when processing the template:

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'there was a problem processing the issue description template', V_SP_RET_CODE);

				--set the error code:
				P_SP_RET_CODE := -1;

			END IF;






			EXCEPTION
				--catch all PL/SQL database exceptions:
				WHEN OTHERS THEN
					--catch all other errors:

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);


					--define the return code that indicates that there was an error when generating the current QC validation issue message:
					P_SP_RET_CODE := -1;

		END POPULATE_ISSUE_REC_SP;

		--update the parent issue record to indicate that the parent record was re-evaluated:
		PROCEDURE UPDATE_PTA_RULE_LAST_EVAL_SP (P_RULE_SET_ID IN PLS_INTEGER, P_PTA_ISS_ID IN PLS_INTEGER, P_SP_RET_CODE OUT PLS_INTEGER) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - UPDATE_PTA_RULE_LAST_EVAL_SP (P_RULE_SET_ID: '||P_RULE_SET_ID||', P_PTA_ISS_ID: '||P_PTA_ISS_ID||')';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Running UPDATE_PTA_RULE_LAST_EVAL_SP()', V_SP_RET_CODE);

			--update the DVM_PTA_RULE_SETS to update the LAST_EVAL_DATE for the validation rule set that is being re-evaluated:
			UPDATE DVM_PTA_RULE_SETS SET LAST_EVAL_DATE = SYSDATE WHERE PTA_ISS_ID = P_PTA_ISS_ID AND RULE_SET_ID = P_RULE_SET_ID;

			--define the return code that indicates that the parent issue record was updated successfully
			P_SP_RET_CODE := 1;


			EXCEPTION
				--catch all PL/SQL database exceptions:
				WHEN OTHERS THEN
					--catch all other errors:

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

					--define the return code that indicates that there was an error when updating the parent issue record:
					P_SP_RET_CODE := -1;

		END UPDATE_PTA_RULE_LAST_EVAL_SP;

		--function that will return a comma-delimited list of the placeholder fields that are not in the result set of the given View identified by P_QC_OBJECT_NAME:
		--if the P_APP_LINK_PARAM is 1 then this is an application link (APP_ID and APP_SESSION placeholders are ignored) and if P_APP_LINK_PARAM is 0 it is not an application link
		--if there was a processing error the return value will be '-1'
		--if there were no unmatched placeholder values the return value will be null
		--if there were unmatched placeholder values the return value will be a comma-delimited list of unmatched placeholder field names
		FUNCTION QC_MISSING_QUERY_FIELDS_FN (P_TEMPLATE_VAL CLOB, P_QC_OBJECT_NAME DVM_CRITERIA_V.OBJECT_NAME%TYPE, P_APP_LINK_PARAM PLS_INTEGER) RETURN CLOB IS

			--procedure variable to store generated SQL statements that are executed in the procedure:
			V_TEMP_SQL CLOB;


			--variable to hold the constructed comma-delimited string of placeholder fields:
			V_TEMP_RETURN CLOB;

			--variable to store the number of placeholders defined in
			V_REGEXP_COUNT PLS_INTEGER;

			--array variable to store the element position of the given field name
			V_ASSOC_FIELDS NUM_ASSOC_VARCHAR;

			--array variable to store the field name for the given element position
			V_ARRAY_FIELDS VARCHAR_ARRAY_NUM;

			--variable to store all of the result set fields so they can be checked against the placeholder values to see if they match:
			V_RESULT_FIELDS VARCHAR_ARRAY_NUM;


			--Oracle data type to store if a given placeholder was found in the result set:
			TYPE BOOL_ASSOC_VARCHAR IS TABLE OF BOOLEAN INDEX BY PLS_INTEGER;

			--variable to track if the given field name has been seen before:
			V_ARRAY_FOUND_FIELDS BOOL_ASSOC_VARCHAR;

			--maximum length of the placeholder should be 30 characters since it is a View column name, the brackets add two extra characters:
			V_FIELD_NAME VARCHAR2(32);

			--boolean variable to store if the first unmatched placeholder field has been found
			V_FIRST_UNMATCHED_FIELD BOOLEAN;

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - QC_MISSING_QUERY_FIELDS_FN (P_TEMPLATE_VAL: '||P_TEMPLATE_VAL||', P_QC_OBJECT_NAME: '||P_QC_OBJECT_NAME||', P_APP_LINK_PARAM: '||P_APP_LINK_PARAM||')';

			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running QC_MISSING_QUERY_FIELDS_FN()', V_SP_RET_CODE);

			--count the number of occurences of placeholders:
			V_REGEXP_COUNT := REGEXP_COUNT(P_TEMPLATE_VAL, '\[[A-Z0-9\_]{1,}\]');

--			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'There are '||V_REGEXP_COUNT||' placeholder occurrences', V_SP_RET_CODE);

			--check if one or more placeholder fields are defined in the given P_TEMPLATE_VAL
			IF (V_REGEXP_COUNT > 0) THEN
				--there is at least one placeholder field defined in the P_TEMPLATE_VAL

				--loop through each placeholder and store them in an array:
				FOR i in 1..V_REGEXP_COUNT LOOP

					--find the i oocurence of the pattern in the string:
					V_FIELD_NAME := regexp_substr(P_TEMPLATE_VAL, '\[([A-Z0-9\_]{1,})\]', 1, i, 'i', 1) ;

--					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The current placeholder name is: '||V_FIELD_NAME, V_SP_RET_CODE);

					--strip off the enclosing brackets from the field name:
--					V_FIELD_NAME := SUBSTR(V_FIELD_NAME, 2, LENGTH(V_FIELD_NAME) - 2) ;

					--store the field name in the V_ARRAY_FIELDS variable:
					V_ARRAY_FIELDS(i) := V_FIELD_NAME;

					--store the field position in the V_ASSOC_FIELDS variable:
					V_ASSOC_FIELDS(V_FIELD_NAME) := i;

					--initialize the array that the given placeholder was not found yet:
					V_ARRAY_FOUND_FIELDS(i) := false;

				END LOOP;



				--construct the query for all of the fields in the given QC query so they can be compared to the placeholder values:

				V_TEMP_SQL := 'SELECT ALL_TAB_COLUMNS.COLUMN_NAME
				FROM SYS.ALL_OBJECTS
				INNER JOIN SYS.ALL_TAB_COLUMNS
				ON ALL_OBJECTS.OWNER        = ALL_TAB_COLUMNS.OWNER
				AND ALL_OBJECTS.OBJECT_NAME = ALL_TAB_COLUMNS.TABLE_NAME
				WHERE ALL_OBJECTS.OBJECT_TYPE IN (''VIEW'', ''TABLE'')
				AND ALL_OBJECTS.OWNER = sys_context(''userenv'', ''current_schema'')
				AND ALL_OBJECTS.OBJECT_NAME IN (:p01)';

				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'Execute the following query using the P_QC_OBJECT_NAME value ('||P_QC_OBJECT_NAME||') : '||V_TEMP_SQL, V_SP_RET_CODE);

				--store all field names into V_RESULT_FIELDS so they can be processed:
				EXECUTE IMMEDIATE V_TEMP_SQL BULK COLLECT INTO V_RESULT_FIELDS USING P_QC_OBJECT_NAME;


--				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The query was executed successfully', V_SP_RET_CODE);

				--loop through all of the result set rows:
				FOR i IN 1 .. V_RESULT_FIELDS.COUNT LOOP
					--compare the current field name from the QC view to see if it matches any of the defined placeholders in the template

--					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'Check if the result field '||V_RESULT_FIELDS(i)||' was found in the list of placeholders', V_SP_RET_CODE);

					--loop through each of the issue templates'
					FOR j in 1.. V_ARRAY_FIELDS.COUNT LOOP


--						DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The current placeholder name is: '||V_ARRAY_FIELDS(j), V_SP_RET_CODE);

						--check if the current placeholder field name matches the current QC object's column name or if this is the APP_LINK_TEMPLATE field and the placeholder is an APEX reserved placeholder: [APP_ID] or [APP_SESSION]:
						IF (V_ARRAY_FIELDS(j) = V_RESULT_FIELDS(i)) OR (P_APP_LINK_PARAM = 1 AND V_ARRAY_FIELDS(j) = 'APP_ID') OR (P_APP_LINK_PARAM = 1 AND V_ARRAY_FIELDS(j) = 'APP_SESSION') THEN

							--the current field was found, update the tracking array:
							V_ARRAY_FOUND_FIELDS(j) := true;

--							DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The current placeholder matches the current field name', V_SP_RET_CODE);
							--exit the current loop (commented out because it would IGNORE any subsequent occurences of the same placeholder that match a result set field name)
							--EXIT;

						END IF;



					END LOOP;


				END LOOP;


				--initialize tracking field:
				V_FIRST_UNMATCHED_FIELD := true;

				--initialize return variable:
				V_TEMP_RETURN := '';

				--loop through the array fields:
				FOR j in 1.. V_ARRAY_FIELDS.COUNT LOOP

					--check if the current placeholder field name matches the current QC object's column name:
					IF (NOT V_ARRAY_FOUND_FIELDS(j)) THEN
						--a match for the current placeholder fields was not found in the QC view object field query result set:

						--check if this is the first field:
						IF V_FIRST_UNMATCHED_FIELD THEN
							--this is not the first unmatched field that was found

							--set the V_FIRST_UNMATCHED_FIELD boolean to false
							V_FIRST_UNMATCHED_FIELD := false;

						ELSE
							--this is not the first placeholder that was not matched, add the comma delimiter and append the current unmatched placeholder:
							V_TEMP_RETURN := V_TEMP_RETURN||', ';

						END IF;

						--add the current field name to the delimited string:
						V_TEMP_RETURN := V_TEMP_RETURN||V_ARRAY_FIELDS(j);

					END IF;

				END LOOP;

				--check if all of the placeholders were found in the result set:
				IF (V_FIRST_UNMATCHED_FIELD) THEN
					--all of the template placeholder fields were matched in the QC view object field query result set:

					V_TEMP_RETURN := NULL;
				END IF;




			ELSE
				--no placeholders found so by definition there are no unmatched placeholders:
				V_TEMP_RETURN := NULL;

			END IF;





			--return the string value
			RETURN V_TEMP_RETURN;


			EXCEPTION
				--catch all PL/SQL database exceptions:
				WHEN OTHERS THEN
					--catch all other errors:

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

					--since there was an error return -1 to indicate the error:
					V_TEMP_RETURN := '-1';

					--return the string value
					RETURN V_TEMP_RETURN;

		END QC_MISSING_QUERY_FIELDS_FN;




		--procedure that replaces all placeholders in P_TEMPLATE_VALUE with the corresponding values in the result set row specified by CUR_ID for the QC criteria identified by QC_CRITERIA_POS and returns the rekaced value as P_REPLACED_VALUE.  P_SP_RET_CODE will contain 1 if the operation was successful, 0 if there were unmatched placeholders other than the APEX reserved placeholders ([APP_SESSION], [APP_ID]) that are required to generate a valid APEX URL
		--if the P_APP_LINK_PARAM is true then this is an application link (APP_ID and APP_SESSION placeholders are ignored) and if P_APP_LINK_PARAM is false it is not an application link
		PROCEDURE REPLACE_PLACEHOLDER_VALS_SP (CUR_ID IN NUMBER, QC_CRITERIA_POS IN NUMBER, P_TEMPLATE_VALUE IN VARCHAR2, P_REPLACED_VALUE OUT VARCHAR2, P_APP_LINK_PARAM IN BOOLEAN, P_SP_RET_CODE OUT PLS_INTEGER) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--procedure variable to store the character string data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			NAME_VAR  VARCHAR2(2000);

			--procedure variable to store the numeric data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			NUM_VAR   NUMBER;

			--procedure variable to store the date data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			DATE_VAR  DATE;

			--maximum length of the placeholder should be 30 characters since it is a View column name:
			V_FIELD_NAME VARCHAR2(30);

			--variable to store the value of the converted character string value for the given result set row's placeholder field
			V_FIELD_VALUE VARCHAR(2000);

			--procedure variable to store the CLOB data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			CLOB_VAR  VARCHAR2(2000);

			--variable to store the number of regular expression matches
			V_REGEXP_COUNT PLS_INTEGER;

			--variable to track if the current field type has ben found and processed successfully
			V_FIELD_DATA_TYPE_FOUND BOOLEAN;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the list of missing fields for the given template and corresponding QC view object
			V_MISSING_FIELDS CLOB;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - REPLACE_PLACEHOLDER_VALS_SP (CUR_ID: '||CUR_ID||', QC_CRITERIA_POS: '||QC_CRITERIA_POS||', (P_TEMPLATE_VALUE: '||P_TEMPLATE_VALUE||'), P_APP_LINK_PARAM: '||(CASE WHEN P_APP_LINK_PARAM THEN 'TRUE' ELSE 'FALSE' END)||')';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Running REPLACE_PLACEHOLDER_VALS_SP()', V_SP_RET_CODE);

			--initialize the success return code, it will be changed if there are any issues processing the current template
			P_SP_RET_CODE := 1;

			--check if the template is null
			IF (P_TEMPLATE_VALUE IS NULL) THEN
				--the P_TEMPLATE_VALUE is null:

				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'the template value is NULL, do nothing', V_SP_RET_CODE);

			ELSE
				--the P_TEMPLATE_VALUE is not null:


				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'the template value is not NULL, find the placeholders', V_SP_RET_CODE);

				--check if there are any missing placeholders in the QC object result fields:
				V_MISSING_FIELDS := QC_MISSING_QUERY_FIELDS_FN (P_TEMPLATE_VALUE, PV_ALL_CRITERIA(QC_CRITERIA_POS).OBJECT_NAME, (CASE WHEN P_APP_LINK_PARAM THEN 1 ELSE 0 END));

				--check if there were any missing placeholders found:
				IF (V_MISSING_FIELDS = '-1') THEN
					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The QC_MISSING_QUERY_FIELDS_FN function was not processed successfully for the QC view object: '||PV_ALL_CRITERIA(QC_CRITERIA_POS).OBJECT_NAME, V_SP_RET_CODE);

					--set the error code:
					P_SP_RET_CODE := 0;


				ELSIF (V_MISSING_FIELDS IS NOT NULL) then
					--there was at least one missing placeholder found:

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The following placeholders were not found in the QC Object ('||PV_ALL_CRITERIA(QC_CRITERIA_POS).OBJECT_NAME||'): '||V_MISSING_FIELDS, V_SP_RET_CODE);

					--set the error code:
					P_SP_RET_CODE := 0;

				ELSE
					--there were no missing placeholders found, continue processing the fields:

					--initialize the replaced return variable
					P_REPLACED_VALUE := P_TEMPLATE_VALUE;

					--count the number of occurences of placeholders:
					V_REGEXP_COUNT := REGEXP_COUNT(P_TEMPLATE_VALUE, '\[[A-Z0-9\_]{1,}\]');

--					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'There are '||V_REGEXP_COUNT||' placeholder occurrences', V_SP_RET_CODE);

					--check if there was at least one placeholder found
					IF (V_REGEXP_COUNT > 0) THEN
						--there was at least one placeholder found

						DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'there was at least one placeholder found', V_SP_RET_CODE);

						--loop through each placeholder and store them in an array:
						FOR i in 1..V_REGEXP_COUNT LOOP

							--find the i oocurence of the pattern in the string:
							V_FIELD_NAME := regexp_substr(P_TEMPLATE_VALUE, '\[([A-Z0-9\_]{1,})\]', 1, i, 'i', 1) ;

							DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The current placeholder name is: '||V_FIELD_NAME, V_SP_RET_CODE);

							--if this is not an app link (P_APP_LINK_PARAM = FALSE) or if this is an app link (P_APP_LINK_PARAM = TRUE) and if this is not one of the special APEX placeholders (APP_ID or APP_SESSION) then replace the placeholder with the correponding query field value
							IF NOT P_APP_LINK_PARAM OR (P_APP_LINK_PARAM AND NOT (V_FIELD_NAME = 'APP_ID' OR V_FIELD_NAME = 'APP_SESSION')) THEN
								--this is not an APEX reserved placeholder name that will be replaced by the application values in APEX so don't attempt to replace them

								DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'this is not an app link (P_APP_LINK_PARAM = FALSE) or this is an app link (P_APP_LINK_PARAM = TRUE) that is not one of the special APEX placeholders (APP_ID or APP_SESSION) so replace the placeholder with the correponding query field value', V_SP_RET_CODE);

								--replace the placeholder value with the corresponding field value:
								DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'replace the placeholder value with the corresponding field value', V_SP_RET_CODE);

								--initialize the field found variable value
								V_FIELD_DATA_TYPE_FOUND := TRUE;

								--check the data type for the current column (based on code)
								IF (PV_DESC_TAB(PV_ASSOC_FIELD_LIST(V_FIELD_NAME)).col_type IN (1, 96)) THEN
									--retrieve the character column data type value into the NAME_VAR variable:
									DBMS_SQL.COLUMN_VALUE(CUR_ID, PV_ASSOC_FIELD_LIST(V_FIELD_NAME), NAME_VAR);

									--set the field value to the varchar/char variable
									V_FIELD_VALUE := NAME_VAR;


								ELSIF (PV_DESC_TAB(PV_ASSOC_FIELD_LIST(V_FIELD_NAME)).col_type = 2) THEN
									--retrieve the NUMBER column data type value into the NUM_VAR variable:
									DBMS_SQL.COLUMN_VALUE(CUR_ID, PV_ASSOC_FIELD_LIST(V_FIELD_NAME), NUM_VAR);

									--set the field value to the converted character string for the numeric value
									V_FIELD_VALUE := TO_CHAR(NUM_VAR);
								ELSIF (PV_DESC_TAB(PV_ASSOC_FIELD_LIST(V_FIELD_NAME)).col_type = 12) THEN
									--this is a DATE field:
									--retrieve the DATE column data type value into the DATE_VAR variable:
									DBMS_SQL.COLUMN_VALUE(CUR_ID, PV_ASSOC_FIELD_LIST(V_FIELD_NAME), DATE_VAR);

									--set the field value to the converted character string for the date variable
									V_FIELD_VALUE := TO_CHAR(DATE_VAR);

								ELSIF (PV_DESC_TAB(PV_ASSOC_FIELD_LIST(V_FIELD_NAME)).col_type = 112) THEN
									--this is a CLOB field:
									--retrieve the CLOB column data type value into the CLOB_VAR variable:
									DBMS_SQL.COLUMN_VALUE(CUR_ID, PV_ASSOC_FIELD_LIST(V_FIELD_NAME), CLOB_VAR);

									--set the field value to the character string for the clob variable
									V_FIELD_VALUE := CLOB_VAR;

								ELSE
									--this field type is not handled in the processing code, exit the loop with an error code:

									--log the processing error:
									DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The placeholder field ('||V_FIELD_NAME||') for the result set row was an unexpected field type: '||PV_DESC_TAB(PV_ASSOC_FIELD_LIST(V_FIELD_NAME)).col_type, V_SP_RET_CODE);


									--set the error code:
									P_SP_RET_CODE := -1;

									--initialize the field found variable value
									V_FIELD_DATA_TYPE_FOUND := FALSE;

									--stop processing the columns due to processing error
									EXIT;

								END IF;

								--check if the data type for the current column has been found
								IF V_FIELD_DATA_TYPE_FOUND THEN
									--The placeholder field was found and successfully retrieved
				--									DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The placeholder field was found and successfully retrieved', V_SP_RET_CODE);

									--replace the placeholder field name with the corresponding field value
									P_REPLACED_VALUE := REPLACE(P_REPLACED_VALUE, '['||V_FIELD_NAME||']', V_FIELD_VALUE);

				--									DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The value of the replaced value is: '||P_REPLACED_VALUE, V_SP_RET_CODE);
								END IF;


							END IF;


						END LOOP;

					END IF;

				END IF;

			END IF;

			EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
		  		--catch all other errors:

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

					--set the error code:
					P_SP_RET_CODE := -1;

		END REPLACE_PLACEHOLDER_VALS_SP;


		--check to see if there is an active rule set, if not a new rule set will be created with the new validation criteria (check count(*) to see if there is at least one active criteria, if not then return an error code). if so then the procedure will check to see if the active rule set is the same as the active set of validation criteria, if so then it will return the rule_set_id in P_RULE_SET_ID parameter if not it will deactivate the rule set and insert a new active rule set with the current active rules:
		procedure RETRIEVE_ACTIVE_RULE_SET_SP (P_DATA_STREAM_CODES IN VARCHAR_ARRAY_NUM, P_RULE_SET_ID_ARRAY OUT NUM_ARRAY, P_SP_RET_CODE OUT PLS_INTEGER) IS

			--variable to store the number of active validation rule sets for the specified data stream codes (P_DATA_STREAM_CODES)
			V_NUM_ACTIVE_RULES PLS_INTEGER;

			--variable to store the active rule set for the given data stream code:
			V_ACT_RULE_SET_ID PLS_INTEGER;

			--variable to store the number of active validation criteria for the given data stream code
			V_NUM_ACTIVE_CRITERIA PLS_INTEGER;

			--variable to store the number of matching values
			V_VALUES_MATCH CHAR(1);

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;



			--procedure variable to store generated SQL statements that are executed in the procedure:
			V_TEMP_SQL CLOB;

			--dynamic cursor ID variable for the dynamic SQL query for the DBMS_SQL query method:
			CUR_ID    NUMBER;

			--number used to store the number of columns returned by the dynamic query for the DBMS_SQL query method:
			COL_CNT   NUMBER;

			--procedure variable to store the numeric data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			NUM_VAR   NUMBER;

			--return code from the dynamic query using the DBMS_SQL package:
			IGNORE   NUMBER;

			--variable to store the RULE_SET_ID value of the inserted DVM_RULE_SETS record:
			P_RULE_SET_ID PLS_INTEGER;


			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - RETRIEVE_ACTIVE_RULE_SET_SP (P_DATA_STREAM_CODES: '||COMMA_DELIM_LIST_FN(P_DATA_STREAM_CODES) ||')';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Running RETRIEVE_ACTIVE_RULE_SET_SP()', V_SP_RET_CODE);

			--query for the number of active validation criteria for the given data stream code
			V_TEMP_SQL := 'SELECT COUNT(*) FROM DVM_CRITERIA_V WHERE ISS_TYPE_ACTIVE_YN = ''Y''
			AND QC_OBJ_ACTIVE_YN = ''Y''
			AND DATA_STREAM_CODE IN (:DSC)';

--			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'the query is: '||V_TEMP_SQL, V_SP_RET_CODE);

			 -- Bind the query variables, loop through each of the data stream codes defined for the parent table:
			FOR i IN 1 .. P_DATA_STREAM_CODES.COUNT LOOP
				--loop through the data stream codes:

--				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'query for the active validation criteria for the current data stream code ('||P_DATA_STREAM_CODES(i)||')', V_SP_RET_CODE);

				--query for the number of active validation criteria for the current data stream
				EXECUTE IMMEDIATE V_TEMP_SQL INTO V_NUM_ACTIVE_CRITERIA using P_DATA_STREAM_CODES(i);

--				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'the number of active validation criteria for the current data stream is: '||TO_CHAR(V_NUM_ACTIVE_CRITERIA), V_SP_RET_CODE);


				--check if there is at least one active validation criteria for the current data stream
				IF (V_NUM_ACTIVE_CRITERIA > 0) THEN
					--there is at least one active validation criteria for the current data stream

--					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'There is at least one active validation criteria. V_NUM_ACTIVE_CRITERIA: '||V_NUM_ACTIVE_CRITERIA, V_SP_RET_CODE);

					--query for all active rule sets for the current data stream
					SELECT COUNT(*) into V_NUM_ACTIVE_RULES FROM
						DVM_RULE_SETS
						INNER JOIN DVM_DATA_STREAMS
						ON DVM_RULE_SETS.DATA_STREAM_ID = DVM_DATA_STREAMS.DATA_STREAM_ID
						WHERE RULE_SET_ACTIVE_YN = 'Y' AND DATA_STREAM_CODE = P_DATA_STREAM_CODES(i);

--					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The value of V_NUM_ACTIVE_RULES is: '||V_NUM_ACTIVE_RULES, V_SP_RET_CODE);

					--check how many active validation rule sets there are
					IF (V_NUM_ACTIVE_RULES = 0) THEN
						--there are no active validation rule sets, create the new rule set and populate it with the current active rules

						DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'there are no active rules, create the new rule set and populate it with the current active rules', V_SP_RET_CODE);

						--insert the new validation rule set:
						DEFINE_RULE_SET_SP (P_DATA_STREAM_CODES(i), P_RULE_SET_ID, V_SP_RET_CODE);

						--check if the new validation rule set was defined successfully
						IF (V_SP_RET_CODE = 1) THEN
							--the new validation rule set was defined successfully

							DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'the new rule set was successfully inserted, rule_set_id: '||P_RULE_SET_ID, V_SP_RET_CODE);

							--add the rule set to the rule set id array so it can be used to retrieve the QC criteria:
							P_RULE_SET_ID_ARRAY(i) := P_RULE_SET_ID;

							--set the success code:
							P_SP_RET_CODE := 1;
						ELSE
							--the new validation rule set was not defined successfully

							--log the processing error:
							DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'the new rule set was NOT successfully inserted', V_SP_RET_CODE);

							--set the processing code returned by this procedure (P_SP_RET_CODE)
							P_SP_RET_CODE := V_SP_RET_CODE;

							--exit the loop:
							EXIT;
						END IF;


					ELSIF (V_NUM_ACTIVE_RULES > 1) THEN
						--there are more than one active rule set, throw an error and exit:

						--set the procedure error code:
						P_SP_RET_CODE := 0;

						--log the processing error:
						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'there are more than one active rule set, throw an error and exit', V_SP_RET_CODE);

						--exit the loop:
						EXIT;

					ELSE
						--there is only one active rule set, check if it's the same as the currently active set:

						DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'there is only one active rule set, check if it''s the same as the currently active set', V_SP_RET_CODE);


						--check if the active rule set and the active validation crtieria are the same
						SELECT CASE WHEN COUNT(*) = 0 THEN 'Y' ELSE 'N' END VALUES_MATCH_YN INTO V_VALUES_MATCH FROM
						((SELECT ISS_TYPE_ID FROM
						DVM_RULE_SETS_V WHERE RULE_SET_ACTIVE_YN = 'Y' AND DATA_STREAM_CODE = P_DATA_STREAM_CODES(i)
						MINUS
						SELECT ISS_TYPE_ID FROM
						DVM_CRITERIA_V WHERE QC_OBJ_ACTIVE_YN = 'Y' AND ISS_TYPE_ACTIVE_YN = 'Y' AND  DATA_STREAM_CODE = P_DATA_STREAM_CODES(i))
						union all

						(SELECT ISS_TYPE_ID FROM
						DVM_CRITERIA_V WHERE QC_OBJ_ACTIVE_YN = 'Y' AND ISS_TYPE_ACTIVE_YN = 'Y' AND DATA_STREAM_CODE = P_DATA_STREAM_CODES(i)
						MINUS
						SELECT ISS_TYPE_ID FROM
						DVM_RULE_SETS_V WHERE RULE_SET_ACTIVE_YN = 'Y' AND DATA_STREAM_CODE = P_DATA_STREAM_CODES(i)));

						--check to see if the active rule set matches the active validation rules
						IF (V_VALUES_MATCH = 'Y') THEN

							--the values match, use the active rule set for the new PTA issue record:
							DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'the values match, use the active rule set for the new PTA issue record', V_SP_RET_CODE);

							--query for the active rule set ID for the current data stream code
							SELECT DISTINCT RULE_SET_ID INTO V_ACT_RULE_SET_ID FROM DVM_RULE_SETS_V where RULE_SET_ACTIVE_YN = 'Y' AND DATA_STREAM_CODE = P_DATA_STREAM_CODES(i);

--							DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'the active rule set ID for the data stream ('||P_DATA_STREAM_CODES(i)||') is: '||V_ACT_RULE_SET_ID, V_SP_RET_CODE);

							--add the rule set to the rule set id array so it can be used to retrieve the QC criteria:
							P_RULE_SET_ID_ARRAY(i) := V_ACT_RULE_SET_ID;

							--set the successful return code:
							P_SP_RET_CODE := 1;

						ELSE
							--the values do not match, deactivate the active rule set and add the new rule set:

							DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'the current active validation rules do not match the active rule set', V_SP_RET_CODE);

							--update the active rule set for the current data stream code to deactivate it:
							UPDATE DVM_RULE_SETS SET RULE_SET_INACTIVE_DATE = SYSDATE, RULE_SET_ACTIVE_YN = 'N' WHERE DATA_STREAM_ID IN (SELECT DATA_STREAM_ID FROM DVM_DATA_STREAMS WHERE DATA_STREAM_CODE = P_DATA_STREAM_CODES(i)) AND RULE_SET_ACTIVE_YN = 'Y';

							DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The active rule set was disabled, insert the new active rule set', V_SP_RET_CODE);

							--define the new active validation rule set:
							DEFINE_RULE_SET_SP (P_DATA_STREAM_CODES(i), P_RULE_SET_ID, V_SP_RET_CODE);

							--check if the new active validation rule set was successfully added:
							IF (V_SP_RET_CODE = 1) THEN
								--the new active validation rule set was successfully added:

								DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'the new rule set was successfully inserted', V_SP_RET_CODE);

								--add the rule set to the rule set id array so it can be used to retrieve the QC criteria:
								P_RULE_SET_ID_ARRAY(i) := P_RULE_SET_ID;


								--set the success code:
								P_SP_RET_CODE := 1;
							ELSE
								--the new active validation rule set was not successfully added:

								--log the processing error:
								DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'the new rule set was not successfully inserted', V_SP_RET_CODE);


								--set the error code:
								P_SP_RET_CODE := V_SP_RET_CODE;

								--exit the loop:
								EXIT;

							END IF;

						END IF;

					END IF;

				ELSE

					--there are no active validation criteria -> throw an error and rollback the transaction:

					--set the error code:
					P_SP_RET_CODE := 0;

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'there are no active validation criteria', V_SP_RET_CODE);

					--exit the loop:
					EXIT;

				END IF;



			END LOOP;


			--check to see if the retrieval of rule_set_ids was successful:
			IF (P_SP_RET_CODE = 1) THEN
				--the retrieval of rule_set_ids was successful

				--insert the new DVM_PTA_RULE_SETS record(s) that have not been processed for the specified parent issue record:

--				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'insert the new DVM_PTA_RULE_SETS record(s) that have not been processed for the specified parent issue record', V_SP_RET_CODE);

				--loop through the rule set IDs and insert the PTA rule set record for the specified parent record and current data stream
				FOR i in 1..P_RULE_SET_ID_ARRAY.COUNT LOOP
--					DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'insert the DVM_PTA_RULE_SETS record for the current rule set', V_SP_RET_CODE);

					--insert the DVM_PTA_RULE_SETS record for the current rule set
					INSERT INTO DVM_PTA_RULE_SETS (RULE_SET_ID, PTA_ISS_ID, FIRST_EVAL_DATE, LAST_EVAL_DATE) VALUES (P_RULE_SET_ID_ARRAY(i), PV_PTA_ISSUE.PTA_ISS_ID, SYSDATE, SYSDATE);

				END LOOP;

			END IF;



			EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
		  		--catch all other errors:

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

					--set the error code:
					P_SP_RET_CODE := -1;

		END RETRIEVE_ACTIVE_RULE_SET_SP;

		--procedure that defines a new rule set and associates all active issue types with the new rule set:
		--the P_RULE_SET_ID contains the RULE_SET_ID value from the newly inserted DVM_PTA_RULE_SETS record and P_SP_RET_CODE contains 1 if it was successful and 0 if there was a processing error
		PROCEDURE DEFINE_RULE_SET_SP (P_DATA_STREAM_CODE IN VARCHAR2, P_RULE_SET_ID OUT PLS_INTEGER, P_SP_RET_CODE OUT PLS_INTEGER) IS

			--variable to store the dynamic query SQL
			V_TEMP_SQL VARCHAR2(2000);

			--variable to store the issue type IDs for active validation criteria for the given data stream
			V_ISS_TYPE_IDS NUM_ARRAY;

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - DEFINE_RULE_SET_SP (P_DATA_STREAM_CODE: '||P_DATA_STREAM_CODE||')';


			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Running DEFINE_RULE_SET_SP()', V_SP_RET_CODE);

			--insert the active validation rule set record
			INSERT INTO DVM_RULE_SETS (RULE_SET_ACTIVE_YN, RULE_SET_CREATE_DATE, DATA_STREAM_ID) VALUES ('Y', SYSDATE, (SELECT DATA_STREAM_ID FROM DVM_DATA_STREAMS WHERE DATA_STREAM_CODE = P_DATA_STREAM_CODE)) RETURNING RULE_SET_ID INTO P_RULE_SET_ID;

--			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The Rule set insert query was successful: '||P_RULE_SET_ID, V_SP_RET_CODE);

			--select all issue types and insert them into the DVM_ISS_TYP_ASSOC table for the validation rule set

			--query for the active validation criteria for the specified data stream code:
			V_TEMP_SQL := 'SELECT
					DVM_CRITERIA_V.ISS_TYPE_ID
					FROM DVM_CRITERIA_V
					WHERE ISS_TYPE_ACTIVE_YN = ''Y''
					AND QC_OBJ_ACTIVE_YN = ''Y''
					AND DATA_STREAM_CODE IN (:DSC)';

--			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The select DVM criteria query is: '||V_TEMP_SQL, V_SP_RET_CODE);

			--query for the ISS_TYPE_ID values for the data stream code (P_DATA_STREAM_CODE) and store the results in the V_ISS_TYPE_IDS array variable
			EXECUTE IMMEDIATE V_TEMP_SQL BULK COLLECT into V_ISS_TYPE_IDS USING P_DATA_STREAM_CODE;

			--loop through each of the ISS_TYPE_ID values
			FOR i IN 1 .. V_ISS_TYPE_IDS.count LOOP

--				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Insert the issue type ID is: '||V_ISS_TYPE_IDS(i), V_SP_RET_CODE);


				--insert the current issue type for the new validation rule set
				INSERT INTO DVM_ISS_TYP_ASSOC (RULE_SET_ID, ISS_TYPE_ID) VALUES (P_RULE_SET_ID, V_ISS_TYPE_IDS(i));

--				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The issue type ID association record was inserted successfully', V_SP_RET_CODE);

			END LOOP;

			--set the success code:
			P_SP_RET_CODE := 1;


			EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
		  		--catch all other errors:

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

					--set the error code:
					P_SP_RET_CODE := 0;


		END DEFINE_RULE_SET_SP;

		--this procedure queries for all issue records that are related to validation rule sets associated with the PV_DATA_STREAM_CODES data stream(s) so they can be compared to the issues that were just identified by the DVM
		PROCEDURE RETRIEVE_ISSUE_RECS_SP (P_ISSUE_RECS OUT DVM_ISSUES_TABLE, P_SP_RET_CODE OUT PLS_INTEGER) IS


			--return code from the dynamic query using the DBMS_SQL package:
			IGNORE   NUMBER;

			--procedure variable to store generated SQL statements that are executed in the procedure:
			V_TEMP_SQL CLOB;

			--procedure variable to store the CLOB data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			CLOB_VAR  VARCHAR2(2000);

			--procedure variable to store the character string data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			NAME_VAR  VARCHAR2(2000);

			--procedure variable to store the numeric data type values returned by the dynamic SQL query for the DBMS_SQL query method:
			NUM_VAR   NUMBER;

			--dynamic cursor used with the dynamic SQL query for the DBMS_SQL query method:
	--        TYPE CUR_TYPE IS REF CURSOR;

			--dynamic cursor ID variable for the dynamic SQL query for the DBMS_SQL query method:
			CUR_ID    NUMBER;

			--number used to store the number of columns returned by the dynamic query for the DBMS_SQL query method:
			COL_CNT   NUMBER;

			--counter variable used when populating the PV_ALL_CRITERIA package variable
			V_ISSUE_POS NUMBER := 1;

			--placeholder string for the rule set IDs
			V_PLACEHOLDER_STRING CLOB;

			--placeholder array for the rule set IDs
 			V_PLACEHOLDER_ARRAY VARCHAR_ARRAY_NUM;

			--string to store the comma-delimited delimited rule set IDs
-- 			V_DELIM_STRING CLOB;

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - RETRIEVE_ISSUE_RECS_SP ()';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Running RETRIEVE_ISSUE_RECS_SP()', V_SP_RET_CODE);


			--generate the placeholders for the rule_set_id values:
			GENERATE_PLACEHOLDERS_SP (PV_DATA_STREAM_CODES, V_PLACEHOLDER_STRING, V_PLACEHOLDER_ARRAY, V_SP_RET_CODE);



			--query for all QC criteria for the specified RULE_SET_ID values (P_RULE_SET_ID_ARRAY)
			V_TEMP_SQL := 'SELECT
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
			AND DVM_RULE_SETS_V.DATA_STREAM_CODE IN ('||V_PLACEHOLDER_STRING||')';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'run the query: '||V_TEMP_SQL, V_SP_RET_CODE);

		-- Open SQL cursor number:
		  CUR_ID := DBMS_SQL.OPEN_CURSOR;

			-- Parse SQL query:
			DBMS_SQL.PARSE(CUR_ID, V_TEMP_SQL, DBMS_SQL.NATIVE);

			--retrieve all of the column descriptions for the dynamic database query:
			DBMS_SQL.DESCRIBE_COLUMNS(CUR_ID, COL_CNT, PV_DESC_TAB);

			--loop through each column's description to define each column's data type:
			FOR i IN 1 .. COL_CNT LOOP

				--retrieve column metadata from query results (the select list is known at compile time so it is already known that only numeric and character data types are used).  Check the data type of the current column

--				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The current col name is: ' ||PV_DESC_TAB(i).col_name || ' col type is: '|| PV_DESC_TAB(i).col_type, V_SP_RET_CODE);

				IF PV_DESC_TAB(i).col_type = 2 THEN
					--this is a numeric value:

					--define the column data type as a NUMBER
					DBMS_SQL.DEFINE_COLUMN(CUR_ID, i, NUM_VAR);

				ELSIF PV_DESC_TAB(i).col_type IN (1, 96) THEN
					--this is a CHAR/VARCHAR data type:

					--define the column data type as a long character string
					DBMS_SQL.DEFINE_COLUMN(CUR_ID, i, NAME_VAR, 2000);

				ELSIF PV_DESC_TAB(i).col_type = 112 THEN
					--this is a CLOB data type:

					--define the column data type as a long character string
					DBMS_SQL.DEFINE_COLUMN(CUR_ID, i, CLOB_VAR, 10000);

				END IF;

			END LOOP;



			--bind the PTA_ISS_ID:
			DBMS_SQL.BIND_VARIABLE(CUR_ID, ':PTAISSUEID', PV_PTA_ISSUE.PTA_ISS_ID);
			 -- Bind the query variables, loop through each of the data stream codes defined for the parent table:
			FOR i IN 1 .. PV_DATA_STREAM_CODES.COUNT LOOP
				--loop through the data stream codes:

				--bind the given placeholder variable with the corresponding data stream code value:
				DBMS_SQL.BIND_VARIABLE(CUR_ID, V_PLACEHOLDER_ARRAY(i), PV_DATA_STREAM_CODES(i));

			END LOOP;

			--execute the query
			IGNORE := DBMS_SQL.EXECUTE(CUR_ID);

			--initialize the result row counter:
			V_ISSUE_POS := 1;

			--loop through each QC criteria result set row:
			LOOP

				--fetch the next row if there is another on in the result set:
				IF DBMS_SQL.FETCH_ROWS(CUR_ID)>0 THEN

				  --loop through each column in the result set row:
				  FOR i IN 1 .. COL_CNT LOOP


						--retrieve column metadata from query results:
						IF PV_DESC_TAB(i).col_type = 2 THEN
							--this is a numeric value:

							--retrieve the NUMBER value into the procedure variable
							DBMS_SQL.COLUMN_VALUE(CUR_ID, i, NUM_VAR);

							--check the column name to assign it to the corresponding P_ISSUE_RECS element record field values
							IF PV_DESC_TAB(i).col_name = 'ISS_ID' THEN	--this is the ISS_ID field, store the numeric value of the current record's field in the current PV_ALL_CRITERIA array element for the corresponding variable field
								P_ISSUE_RECS(V_ISSUE_POS).ISS_ID := NUM_VAR;

							ELSIF PV_DESC_TAB(i).col_name = 'PTA_ISS_ID' THEN	--this is the PTA_ISS_ID field, store the numeric value of the current record's field in the current PV_ALL_CRITERIA array element for the corresponding variable field
								P_ISSUE_RECS(V_ISSUE_POS).PTA_ISS_ID := NUM_VAR;

							ELSIF PV_DESC_TAB(i).col_name = 'ISS_TYPE_ID' THEN	--this is the ISS_TYPE_ID field, store the numeric value of the current record's field in the current PV_ALL_CRITERIA array element for the corresponding variable field
								P_ISSUE_RECS(V_ISSUE_POS).ISS_TYPE_ID := NUM_VAR;

--								DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The current issue_type_id is: '||to_char(NUM_VAR), V_SP_RET_CODE);
							ELSIF PV_DESC_TAB(i).col_name = 'ISS_RES_TYPE_ID' THEN	--this is the ISS_RES_TYPE_ID field, store the numeric value of the current record's field in the current PV_ALL_CRITERIA array element for the corresponding variable field
								P_ISSUE_RECS(V_ISSUE_POS).ISS_RES_TYPE_ID := NUM_VAR;

							END IF;

						ELSIF PV_DESC_TAB(i).col_type IN (1, 96) THEN
							--this is a CHAR/VARCHAR data type:

							DBMS_SQL.COLUMN_VALUE(CUR_ID, i, NAME_VAR);

							--check the column name to assign it to the corresponding P_ISSUE_RECS element record field values
							IF PV_DESC_TAB(i).col_name = 'ISS_NOTES' THEN	--this is the ISS_NOTES field, store the numeric value of the current record's field in the current PV_ALL_CRITERIA array element for the corresponding variable field
								P_ISSUE_RECS(V_ISSUE_POS).ISS_NOTES := NAME_VAR;

							ELSIF PV_DESC_TAB(i).col_name = 'APP_LINK_URL' THEN	--this is the APP_LINK_URL field, store the numeric value of the current record's field in the current PV_ALL_CRITERIA array element for the corresponding variable field
								P_ISSUE_RECS(V_ISSUE_POS).APP_LINK_URL := NAME_VAR;
							END IF;
						ELSIF PV_DESC_TAB(i).col_type = 112 THEN

							--store the column value
							DBMS_SQL.COLUMN_VALUE(CUR_ID, i, CLOB_VAR);

							--check the column name to assign it to the corresponding P_ISSUE_RECS element record field values
							IF PV_DESC_TAB(i).col_name = 'ISS_DESC' THEN	--this is the ISS_DESC field, store the numeric value of the current record's field in the current PV_ALL_CRITERIA array element for the corresponding variable field
								P_ISSUE_RECS(V_ISSUE_POS).ISS_DESC := CLOB_VAR;
							END IF;

						END IF;

				  END LOOP;

				  --increment the row counter variable:
				  V_ISSUE_POS := V_ISSUE_POS + 1;

			   ELSE

					-- No more rows to process, exit the loop:
					EXIT;
			   END IF;
				END LOOP;

--				DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'closing CUR_ID cursor in RETRIEVE_ISSUE_RECS_SP()', V_SP_RET_CODE);

				DBMS_SQL.CLOSE_CURSOR(CUR_ID);

				--set the success code:
				P_SP_RET_CODE := 1;

			EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
		  		--catch all other errors:

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

					--set the error code:
					P_SP_RET_CODE := -1;

		END RETRIEVE_ISSUE_RECS_SP;


		PROCEDURE INIT_PKG_SP (P_SP_RET_CODE OUT PLS_INTEGER) IS
			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - INIT_PKG_SP ()';


			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Running INIT_PKG_SP()', V_SP_RET_CODE);


			--clear the PV_ALL_CRITERIA table before retrieving the validation rule sets:
			PV_ALL_CRITERIA.delete;


			--initialize the PV_ISSUE_REC_TABLE
			PV_ISSUE_REC_TABLE.delete;

			--set the successful return code:
			P_SP_RET_CODE := 1;

			EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
		  		--catch all other errors:

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

					--set the error code:
					P_SP_RET_CODE := -1;


		END INIT_PKG_SP;

		--function that will return a comma-delimited list of the elements in P_STR_ARRAY:
		--if there was a processing error the return value will be '-1'
		FUNCTION COMMA_DELIM_LIST_FN (P_STR_ARRAY IN VARCHAR_ARRAY_NUM) RETURN CLOB IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to hold the constructed comma-delimited string of P_STR_ARRAY element values:
			V_TEMP_RETURN CLOB;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN


			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - COMMA_DELIM_LIST_FN ('||CASE WHEN P_STR_ARRAY.COUNT = 0 THEN 'NULL' ELSE 'P_STR_ARRAY(1): '||TO_CHAR(P_STR_ARRAY(1)) END||')';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Running COMMA_DELIM_LIST_FN ()', V_SP_RET_CODE);

			--loop through each element in the P_STR_ARRAY
			FOR i IN 1 .. P_STR_ARRAY.COUNT LOOP

				--check if this is the first array element in the processing loop:
				IF (i > 1) THEN

					--this is not the first variable, prepend a comma to generate the comma-delimited strings:
					V_TEMP_RETURN := V_TEMP_RETURN||', ';
				END IF;

				--append the current array element value to the return string:
				V_TEMP_RETURN := V_TEMP_RETURN||P_STR_ARRAY(i);

			END LOOP;

			--return the string value
			RETURN V_TEMP_RETURN;



			EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
		  		--catch all other errors:

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

					--since there was an error return -1 to indicate the error:
					V_TEMP_RETURN := '-1';

					--return the string value
					RETURN V_TEMP_RETURN;

		END COMMA_DELIM_LIST_FN;


		--function that will return a comma-delimited list of the elements in P_STR_ARRAY:
		--if there was a processing error the return value will be '-1'
		FUNCTION COMMA_DELIM_LIST_FN (P_NUM_ARRAY IN NUM_ARRAY) RETURN CLOB IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to hold the constructed comma-delimited string of P_STR_ARRAY element values:
			V_TEMP_RETURN CLOB;

			--variable to store the converted numeric element values so it can be used with the overloaded COMMA_DELIM_LIST_FN function with the VARCHAR_ARRAY_NUM data type parameter:
			V_VARCHAR_ARRAY VARCHAR_ARRAY_NUM;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - COMMA_DELIM_LIST_FN ('||CASE WHEN P_NUM_ARRAY.COUNT = 0 THEN 'NULL' ELSE 'P_NUM_ARRAY(1): '||TO_CHAR(P_NUM_ARRAY(1)) END||')';

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Running COMMA_DELIM_LIST_FN ()', V_SP_RET_CODE);

			--loop through each element in the P_STR_ARRAY
			FOR i IN 1 .. P_NUM_ARRAY.COUNT LOOP

				--store the converted string value of the current numeric array element:
				V_VARCHAR_ARRAY(i) := TO_CHAR(P_NUM_ARRAY(i));

			END LOOP;

			--return the delimited string value:
			RETURN COMMA_DELIM_LIST_FN(V_VARCHAR_ARRAY);



      EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
		  		--catch all other errors:



					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

					--since there was an error return -1 to indicate the error:
					V_TEMP_RETURN := '-1';

					--return the string value
					RETURN V_TEMP_RETURN;

		END COMMA_DELIM_LIST_FN;


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
DVM_PKG.QC_MISSING_QUERY_FIELDS_FN(ISS_TYPE_COMMENT_TEMPLATE, OBJECT_NAME, 0) MISSING_ISS_DESC_FIELDS,
DVM_PKG.QC_MISSING_QUERY_FIELDS_FN(APP_LINK_TEMPLATE, OBJECT_NAME, 1) MISSING_APP_LINK_FIELDS

from DVM_CRITERIA_V WHERE
DVM_PKG.QC_MISSING_QUERY_FIELDS_FN(ISS_TYPE_COMMENT_TEMPLATE, OBJECT_NAME, 0) IS NOT NULL
OR DVM_PKG.QC_MISSING_QUERY_FIELDS_FN(APP_LINK_TEMPLATE, OBJECT_NAME, 1) IS NOT NULL;

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
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Data Validation Module', '0.7', TO_DATE('09-JUL-20', 'DD-MON-YY'), 'Removed DVM synonyms.  Updated the DVM_PKG package to include code comments, error logging, procedure/function logging, return code values for all procedures to indicate their success/error conditions.  Updated DVM_QC_MSG_MISS_FIELDS_V to use the updated DVM_PKG.QC_MISSING_QUERY_FIELDS_FN function name and arguments.  Requires version 0.2 (Git tag: db_log_db_v0.2) of the Database Logging Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/database-logging-module.git).');

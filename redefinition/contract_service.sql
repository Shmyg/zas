/*
|| Partitioning of CONTRACT_SERVICE
|| Table is recreated as IOT and partitioned by contract sets
|| Created for Zain Sudan
|| Author: Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com // sergiy.shmygelskyy@ericsson.com
||
|| $Log: contract_service.sql,v $
|| Revision 1.2  2013/08/21 13:12:34  shmyg
|| Fixed minor bugs in contract_service.sql
||
|| Revision 1.1  2013-08-20 15:17:38  shmyg
|| Added redefinition for contract_service
||
||
*/

VAR num_errors NUMBER;

ALTER TABLE sysadm.contract_service PARALLEL;

BEGIN
DBMS_REDEFINITION.CAN_REDEF_TABLE
	(
	'SYSADM',
	'CONTRACT_SERVICE',
	DBMS_REDEFINITION.CONS_USE_PK
	);
END;
/

CREATE	TABLE sysadm.int_contract_service
	(
	co_id	NUMBER(*,0) NOT NULL,
	sncode	NUMBER(*,0) NOT NULL,
	PRIMARY KEY (co_id, sncode)
	)
ORGANIZATION INDEX
PARTITION BY RANGE (co_id)
	(  
	PARTITION contract_service_1 VALUES LESS THAN (1000001),
	PARTITION contract_service_2 VALUES LESS THAN (2000001),
	PARTITION contract_service_3 VALUES LESS THAN (3000001),
	PARTITION contract_service_4 VALUES LESS THAN (4000001),
	PARTITION contract_service_5 VALUES LESS THAN (5000001),
	PARTITION contract_service_6 VALUES LESS THAN (6000001),
	PARTITION contract_service_7 VALUES LESS THAN (7000001),
	PARTITION contract_service_8 VALUES LESS THAN (8000001),
	PARTITION contract_service_9 VALUES LESS THAN (9000001),
	PARTITION contract_service_10 VALUES LESS THAN (10000001),
	PARTITION contract_service_11 VALUES LESS THAN (11000001),
	PARTITION contract_service_12 VALUES LESS THAN (12000001),
	PARTITION contract_service_13 VALUES LESS THAN (13000001),
	PARTITION contract_service_14 VALUES LESS THAN (14000001),
	PARTITION contract_service_15 VALUES LESS THAN (15000001),
	PARTITION contract_service_16 VALUES LESS THAN (16000001),
	PARTITION contract_service_17 VALUES LESS THAN (17000001),
	PARTITION contract_service_18 VALUES LESS THAN (18000001),
	PARTITION contract_service_19 VALUES LESS THAN (19000001),
	PARTITION contract_service_20 VALUES LESS THAN (20000001),
	PARTITION contract_service_21 VALUES LESS THAN (21000001),
	PARTITION contract_service_22 VALUES LESS THAN (MAXVALUE)
	)
INITRANS 8
PCTFREE 5
STORAGE
	(
	INITIAL	16M
	NEXT	16M
	)
NOLOGGING;

BEGIN
DBMS_REDEFINITION.START_REDEF_TABLE
	(
	'SYSADM',
	'CONTRACT_SERVICE',
	'INT_CONTRACT_SERVICE',
	col_mapping => NULL,
	options_flag => DBMS_REDEFINITION.CONS_USE_PK
	);
END;
/

BEGIN
DBMS_REDEFINITION.COPY_TABLE_DEPENDENTS
	(
	'SYSADM',
	'CONTRACT_SERVICE',
	'INT_CONTRACT_SERVICE',
	1,
	TRUE,
	TRUE,
	TRUE,
	TRUE,
	:num_errors
	);
END;
/

BEGIN
DBMS_REDEFINITION.SYNC_INTERIM_TABLE
	(
	'SYSADM',
	'CONTRACT_SERVICE',
	'INT_CONTRACT_SERVICE'
	);
END;
/

BEGIN
DBMS_REDEFINITION.FINISH_REDEF_TABLE
	(
	'SYSADM',
	'CONTRACT_SERVICE',
	'INT_CONTRACT_SERVICE'
	);
END;
/

DROP	TABLE sysadm.int_contract_service;

BEGIN
        DBMS_SCHEDULER.CREATE_JOB
        (
        job_name => 'STAT_CONTRACT_SERVICE',
        job_type => 'PLSQL_BLOCK',
        job_action => 'begin execute immediate ''alter session force parallel ddl''; ' || 
                        'DBMS_STATS.GATHER_TABLE_STATS( ''sysadm'', ''contract_service'', '  ||
                        'method_opt => ''FOR ALL COLUMNS SIZE AUTO'', degree => 32); end;',
        enabled => TRUE,
        auto_drop => TRUE
        );
END;
/
/

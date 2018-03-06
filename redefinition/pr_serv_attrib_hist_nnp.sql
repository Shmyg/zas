/*
|| Partitioning for pr_serv_attrib_hist_nnp
|| Zain Sudan project
|| Author: Serge Shmygelskyy aka Shmyg 
|| mailto: serge.shmygelskyy@gmail.com // sergiy.shmygelskyy@ericsson.com
||
|| $Log: pr_serv_attrib_hist_nnp.sql,v $
|| Revision 1.1  2013/08/20 11:22:44  shmyg
|| More redefinition scripts
||
||
*/

VAR num_errors NUMBER;

ALTER TABLE sysadm.pr_serv_attrib_hist_nnp PARALLEL
/

BEGIN
DBMS_REDEFINITION.CAN_REDEF_TABLE
	(
	'SYSADM',
	'pr_serv_attrib_hist_nnp',
	DBMS_REDEFINITION.CONS_USE_PK
	);
END;
/

 CREATE TABLE sysadm.int_pr_serv_attrib_hist_nnp
	(
	service_attr_hist_id	NUMBER(*,0) NOT NULL,
	profile_id		NUMBER(*,0) NOT NULL,
	co_id			NUMBER(*,0) NOT NULL,
	sncode			NUMBER(*,0) NOT NULL,
	prepaid_flag		CHAR(1),
	charging_schedule	CHAR(1) DEFAULT 'B' NOT NULL,
	valid_from		DATE,
	entry_date		DATE DEFAULT SYSDATE NOT NULL,
	rec_version		NUMBER(*,0) DEFAULT 0 NOT NULL
	)
PARTITION BY RANGE( co_id )
	(
	PARTITION pr_serv_attrib_hist_nnp_1 VALUES LESS THAN (1000001),
	PARTITION pr_serv_attrib_hist_nnp_2 VALUES LESS THAN (2000001),
	PARTITION pr_serv_attrib_hist_nnp_3 VALUES LESS THAN (3000001),
	PARTITION pr_serv_attrib_hist_nnp_4 VALUES LESS THAN (4000001),
	PARTITION pr_serv_attrib_hist_nnp_5 VALUES LESS THAN (5000001),
	PARTITION pr_serv_attrib_hist_nnp_6 VALUES LESS THAN (6000001),
	PARTITION pr_serv_attrib_hist_nnp_7 VALUES LESS THAN (7000001),
	PARTITION pr_serv_attrib_hist_nnp_8 VALUES LESS THAN (8000001),
	PARTITION pr_serv_attrib_hist_nnp_9 VALUES LESS THAN (9000001),
	PARTITION pr_serv_attrib_hist_nnp_10 VALUES LESS THAN (10000001),
	PARTITION pr_serv_attrib_hist_nnp_11 VALUES LESS THAN (11000001),
	PARTITION pr_serv_attrib_hist_nnp_12 VALUES LESS THAN (12000001),
	PARTITION pr_serv_attrib_hist_nnp_13 VALUES LESS THAN (13000001),
	PARTITION pr_serv_attrib_hist_nnp_14 VALUES LESS THAN (14000001),
	PARTITION pr_serv_attrib_hist_nnp_15 VALUES LESS THAN (15000001),
	PARTITION pr_serv_attrib_hist_nnp_16 VALUES LESS THAN (16000001),
	PARTITION pr_serv_attrib_hist_nnp_17 VALUES LESS THAN (17000001),
	PARTITION pr_serv_attrib_hist_nnp_18 VALUES LESS THAN (18000001),
	PARTITION pr_serv_attrib_hist_nnp_19 VALUES LESS THAN (19000001),
	PARTITION pr_serv_attrib_hist_nnp_20 VALUES LESS THAN (20000001),
	PARTITION pr_serv_attrib_hist_nnp_21 VALUES LESS THAN (21000001),
	PARTITION pr_serv_attrib_hist_nnp_22 VALUES LESS THAN (MAXVALUE)
	)
PCTFREE 2
STORAGE
	(
	INITIAL	16M
	NEXT	16M
	)
INITRANS 16
NOLOGGING
COMPRESS;

BEGIN
DBMS_REDEFINITION.START_REDEF_TABLE
	(
	'SYSADM',
	'pr_serv_attrib_hist_nnp',
	'int_pr_serv_attrib_hist_nnp',
	col_mapping => NULL,
	options_flag => DBMS_REDEFINITION.CONS_USE_PK
	);
END;
/

CREATE INDEX sysadm.int_ix_pr_serv_attrib_hist_nnp
ON sysadm.int_pr_serv_attrib_hist_nnp
	(
	co_id,
	sncode,
	profile_id
	)
INITRANS 16
NOLOGGING
COMPRESS
PARALLEL
LOCAL;

BEGIN
DBMS_REDEFINITION.COPY_TABLE_DEPENDENTS
	(
	'SYSADM',
	'pr_serv_attrib_hist_nnp',
	'int_pr_serv_attrib_hist_nnp',
	0,
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
	'pr_serv_attrib_hist_nnp',
	'int_pr_serv_attrib_hist_nnp'
	);
END;
/

BEGIN
DBMS_REDEFINITION.FINISH_REDEF_TABLE
	(
	'SYSADM',
	'pr_serv_attrib_hist_nnp',
	'int_pr_serv_attrib_hist_nnp'
	);
END;
/

DROP	TABLE sysadm.int_pr_serv_attrib_hist_nnp
CASCADE	CONSTRAINTS
/

ALTER	INDEX sysadm.int_ix_pr_serv_attrib_hist_nnp
RENAME	TO ix_pr_serv_attrib_hist_nnp
/

ALTER TABLE sysadm.pr_serv_attrib_hist_nnp NOPARALLEL
/
ALTER TABLE sysadm.pr_serv_attrib_hist_nnp LOGGING
/
ALTER INDEX ix_pr_serv_attrib_hist_nnp NOPARALLEL
/
ALTER TABLE sysadm.pr_serv_attrib_hist_nnp
ADD CONSTRAINT pk_prservattrhistnnp PRIMARY KEY (service_attr_hist_id)
/

BEGIN
        DBMS_SCHEDULER.CREATE_JOB
        (
        job_name => 'STAT_1',
        job_type => 'PLSQL_BLOCK',
        job_action => 'begin execute immediate ''alter session force parallel ddl''; ' || 
                        'DBMS_STATS.GATHER_TABLE_STATS( ''sysadm'', ''pr_serv_attrib_hist_nnp'', '  ||
                        'method_opt => ''FOR ALL COLUMNS SIZE AUTO'', degree => 32); end;',
        enabled => TRUE,
        auto_drop => TRUE
        );
END;
/

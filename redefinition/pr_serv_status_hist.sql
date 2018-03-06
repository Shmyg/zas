/*
|| Partitioning for PR_SERV_STATUS_HIST
|| Reused for Zain Sudan from Maroc Telecom project
|| Author: Serge Shmygelskyy aka Shmyg 
|| mailto: serge.shmygelskyy@gmail.com // sergiy.shmygelskyy@ericsson.com
||
|| $Log: pr_serv_status_hist.sql,v $
|| Revision 1.3  2013/08/14 14:20:59  shmyg
|| First completely working version of redefinition scrips for ZAS
||
|| Revision 1.2  2013-08-12 14:08:40  shmyg
|| *** empty log message ***
||
|| Revision 1.1  2013-08-05 14:32:43  shmyg
|| Added redefinition scripts
||
*/

VAR num_errors NUMBER;

ALTER TABLE sysadm.pr_serv_status_hist PARALLEL
/

BEGIN
DBMS_REDEFINITION.CAN_REDEF_TABLE
	(
	'SYSADM',
	'PR_SERV_STATUS_HIST',
	DBMS_REDEFINITION.CONS_USE_PK
	);
END;
/

CREATE TABLE sysadm.int_pr_serv_status_hist
(
	profile_id	NUMBER(38) NOT NULL,
	co_id		NUMBER(38) NOT NULL,
	sncode		NUMBER(38) NOT NULL,
	histno		NUMBER(38) NOT NULL,
	status		VARCHAR2(1) NOT NULL,
	reason		NUMBER(38) NOT NULL,
	transactionno	NUMBER(38) NOT NULL,
	valid_from_date	DATE,
	entry_date	DATE NOT NULL,
	request_id	NUMBER(38),
	rec_version	NUMBER(38) NOT NULL,
	user_reason	NUMBER(38)
	)
PARTITION BY RANGE( co_id )
	(
	PARTITION pr_serv_status_hist_1 VALUES LESS THAN (1000001),
	PARTITION pr_serv_status_hist_2 VALUES LESS THAN (2000001),
	PARTITION pr_serv_status_hist_3 VALUES LESS THAN (3000001),
	PARTITION pr_serv_status_hist_4 VALUES LESS THAN (4000001),
	PARTITION pr_serv_status_hist_5 VALUES LESS THAN (5000001),
	PARTITION pr_serv_status_hist_6 VALUES LESS THAN (6000001),
	PARTITION pr_serv_status_hist_7 VALUES LESS THAN (7000001),
	PARTITION pr_serv_status_hist_8 VALUES LESS THAN (8000001),
	PARTITION pr_serv_status_hist_9 VALUES LESS THAN (9000001),
	PARTITION pr_serv_status_hist_10 VALUES LESS THAN (10000001),
	PARTITION pr_serv_status_hist_11 VALUES LESS THAN (11000001),
	PARTITION pr_serv_status_hist_12 VALUES LESS THAN (12000001),
	PARTITION pr_serv_status_hist_13 VALUES LESS THAN (13000001),
	PARTITION pr_serv_status_hist_14 VALUES LESS THAN (14000001),
	PARTITION pr_serv_status_hist_15 VALUES LESS THAN (15000001),
	PARTITION pr_serv_status_hist_16 VALUES LESS THAN (16000001),
	PARTITION pr_serv_status_hist_17 VALUES LESS THAN (17000001),
	PARTITION pr_serv_status_hist_18 VALUES LESS THAN (18000001),
	PARTITION pr_serv_status_hist_19 VALUES LESS THAN (19000001),
	PARTITION pr_serv_status_hist_20 VALUES LESS THAN (20000001),
	PARTITION pr_serv_status_hist_21 VALUES LESS THAN (21000001),
	PARTITION pr_serv_status_hist_22 VALUES LESS THAN (MAXVALUE)
	)
TABLESPACE shmyg_ts
PCTFREE 5
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
	'PR_SERV_STATUS_HIST',
	'INT_PR_SERV_STATUS_HIST',
	col_mapping => NULL,
	options_flag => DBMS_REDEFINITION.CONS_USE_PK
	);
END;
/

CREATE	INDEX sysadm.int_1
ON sysadm.int_pr_serv_status_hist
	(
	co_id,
	request_id
	)
INITRANS 16
NOLOGGING
COMPRESS
PARALLEL 32
LOCAL; 

/*
CREATE INDEX sysadm.int_2
ON sysadm.int_pr_serv_status_hist
	(
	co_id,
	sncode,
	profile_id,
	valid_from_date,
	status
	)
INITRANS 16
NOLOGGING
COMPRESS
PARALLEL 32
LOCAL;
*/

CREATE UNIQUE INDEX sysadm.int_3
ON sysadm.int_pr_serv_status_hist
	(
	co_id,
	sncode,
	profile_id,
	histno
	)
INITRANS 16
NOLOGGING
PARALLEL 32
COMPRESS
LOCAL; 

BEGIN
DBMS_REDEFINITION.COPY_TABLE_DEPENDENTS
	(
	'SYSADM',
	'PR_SERV_STATUS_HIST',
	'INT_PR_SERV_STATUS_HIST',
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
	'PR_SERV_STATUS_HIST',
	'INT_PR_SERV_STATUS_HIST'
	);
END;
/

BEGIN
DBMS_REDEFINITION.FINISH_REDEF_TABLE
	(
	'SYSADM',
	'PR_SERV_STATUS_HIST',
	'INT_PR_SERV_STATUS_HIST'
	);
END;
/

DROP	TABLE sysadm.int_pr_serv_status_hist
CASCADE	CONSTRAINTS;

ALTER	INDEX sysadm.int_1
RENAME	TO i_dbx_prserv_status_hist_coreq;

/*
ALTER	INDEX sysadm.int_2
RENAME	TO i_pr_serv_stat_hist_val_st;
*/

ALTER	INDEX sysadm.int_3
RENAME	TO pk_pr_serv_status_hist;


BEGIN
DBMS_STATS.GATHER_TABLE_STATS
	(
	'SYSADM',
	'PR_SERV_STATUS_HIST',
	degree => 32,
	method_opt => 'for all columns size auto',
	estimate_percent => 10,
	granularity => 'ALL',
	cascade => TRUE
	);
END;
/

ALTER TABLE sysadm.pr_serv_status_hist NOPARALLEL;
ALTER INDEX i_dbx_prserv_status_hist_coreq NOPARALLEL;
ALTER INDEX pk_pr_serv_status_hist NOPARALLEL;

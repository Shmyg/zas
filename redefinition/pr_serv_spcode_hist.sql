/*
|| Partitioning of PR_SERV_SPCODE_HIST
|| Reused for Zain Sudan from Maroc Telecom project
|| Author: Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com // sergiy.shmygelskyy@ericsson.com
||
|| $Log: pr_serv_spcode_hist.sql,v $
|| Revision 1.3  2013/08/14 14:20:59  shmyg
|| First completely working version of redefinition scrips for ZAS
||
|| Revision 1.2  2013-08-12 14:08:40  shmyg
|| *** empty log message ***
||
|| Revision 1.1  2013-08-05 14:32:42  shmyg
|| Added redefinition scripts
||
*/

VAR num_errors NUMBER;

ALTER TABLE sysadm.pr_serv_spcode_hist PARALLEL
/

BEGIN
DBMS_REDEFINITION.CAN_REDEF_TABLE
	(
	'SYSADM',
	'PR_SERV_SPCODE_HIST',
	DBMS_REDEFINITION.CONS_USE_PK
	);
END;
/

CREATE	TABLE sysadm.int_pr_serv_spcode_hist
	(
	profile_id	NUMBER(38) NOT NULL,
	co_id		NUMBER(38) NOT NULL,
	sncode		NUMBER(38) NOT NULL,
	histno		NUMBER(38) NOT NULL,
	spcode		NUMBER(38) NOT NULL,
	transactionno	NUMBER(38) NOT NULL,
	valid_from_date	DATE,
	entry_date	DATE NOT NULL,
	request_id	NUMBER(38),
	rec_version	NUMBER(38) NOT NULL
	)
PARTITION BY RANGE (co_id)
	(  
	PARTITION pr_serv_spcode_hist_1 VALUES LESS THAN (1000001),
	PARTITION pr_serv_spcode_hist_2 VALUES LESS THAN (2000001),
	PARTITION pr_serv_spcode_hist_3 VALUES LESS THAN (3000001),
	PARTITION pr_serv_spcode_hist_4 VALUES LESS THAN (4000001),
	PARTITION pr_serv_spcode_hist_5 VALUES LESS THAN (5000001),
	PARTITION pr_serv_spcode_hist_6 VALUES LESS THAN (6000001),
	PARTITION pr_serv_spcode_hist_7 VALUES LESS THAN (7000001),
	PARTITION pr_serv_spcode_hist_8 VALUES LESS THAN (8000001),
	PARTITION pr_serv_spcode_hist_9 VALUES LESS THAN (9000001),
	PARTITION pr_serv_spcode_hist_10 VALUES LESS THAN (10000001),
	PARTITION pr_serv_spcode_hist_11 VALUES LESS THAN (11000001),
	PARTITION pr_serv_spcode_hist_12 VALUES LESS THAN (12000001),
	PARTITION pr_serv_spcode_hist_13 VALUES LESS THAN (13000001),
	PARTITION pr_serv_spcode_hist_14 VALUES LESS THAN (14000001),
	PARTITION pr_serv_spcode_hist_15 VALUES LESS THAN (15000001),
	PARTITION pr_serv_spcode_hist_16 VALUES LESS THAN (16000001),
	PARTITION pr_serv_spcode_hist_17 VALUES LESS THAN (17000001),
	PARTITION pr_serv_spcode_hist_18 VALUES LESS THAN (18000001),
	PARTITION pr_serv_spcode_hist_19 VALUES LESS THAN (19000001),
	PARTITION pr_serv_spcode_hist_20 VALUES LESS THAN (20000001),
	PARTITION pr_serv_spcode_hist_21 VALUES LESS THAN (21000001),
	PARTITION pr_serv_spcode_hist_22 VALUES LESS THAN (MAXVALUE)
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
	'PR_SERV_SPCODE_HIST',
	'INT_PR_SERV_SPCODE_HIST',
	col_mapping => NULL,
	options_flag => DBMS_REDEFINITION.CONS_USE_PK
	);
END;
/

CREATE	UNIQUE INDEX sysadm.int_pk_pr_serv_spcode_hist
ON	sysadm.int_pr_serv_spcode_hist
	(
	co_id,
	sncode,
	profile_id,
	histno
	)
TABLESPACE shmyg_ts
INITRANS 16
NOLOGGING
COMPRESS
PARALLEL
LOCAL;

BEGIN
DBMS_REDEFINITION.COPY_TABLE_DEPENDENTS
	(
	'SYSADM',
	'PR_SERV_SPCODE_HIST',
	'INT_PR_SERV_SPCODE_HIST',
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
	'PR_SERV_SPCODE_HIST',
	'INT_PR_SERV_SPCODE_HIST'
	);
END;
/

BEGIN
DBMS_REDEFINITION.FINISH_REDEF_TABLE
	(
	'SYSADM',
	'PR_SERV_SPCODE_HIST',
	'INT_PR_SERV_SPCODE_HIST'
	);
END;
/

DROP	TABLE sysadm.int_pr_serv_spcode_hist
CASCADE	CONSTRAINTS;

ALTER	INDEX sysadm.int_pk_pr_serv_spcode_hist
RENAME	TO pk_pr_serv_spcode_hist;

BEGIN
DBMS_STATS.GATHER_TABLE_STATS
	(
	'SYSADM',
	'PR_SERV_SPCODE_HIST',
	degree => 32,
	method_opt => 'for all columns size auto',
	estimate_percent => 10,
	granularity => 'ALL',
	cascade => TRUE
	);
END;
/

CREATE	BITMAP INDEX sysadm.ix_pr_serv_spcode_hist_spcode
ON	sysadm.pr_serv_spcode_hist
	(
	spcode
	)
TABLESPACE shmyg_ts
NOLOGGING
COMPRESS
PARALLEL;

ALTER TABLE sysadm.pr_serv_spcode_hist LOGGING;
ALTER TABLE sysadm.pr_serv_spcode_hist NOPARALLEL;
ALTER INDEX sysadm.pk_pr_serv_spcode_hist LOGGING;
ALTER INDEX sysadm.pk_pr_serv_spcode_hist NOPARALLEL;

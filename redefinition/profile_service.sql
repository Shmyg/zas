/*
|| Partitioning of PROFILE_SERVICE
|| Reused for Zain Sudan from Maroc Telecom project
|| Author: Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com // sergiy.shmygelskyy@ericsson.com
||
|| $Log: profile_service.sql,v $
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

ALTER TABLE sysadm.profile_service PARALLEL;

BEGIN
DBMS_REDEFINITION.CAN_REDEF_TABLE
	(
	'SYSADM',
	'PROFILE_SERVICE',
	DBMS_REDEFINITION.CONS_USE_PK
	);
END;
/

CREATE TABLE sysadm.int_profile_service
	(
	profile_id		NUMBER NOT NULL,
	co_id			NUMBER NOT NULL,
	sncode			NUMBER NOT NULL,
	spcode_histno		NUMBER NOT NULL,
	status_histno		NUMBER NOT NULL,
	entry_date		DATE DEFAULT SYSDATE NOT NULL, 
	channel_num		NUMBER,
	ovw_acc_first		VARCHAR2(1),
	date_billed		DATE,
	sn_class		NUMBER,
	ovw_subscr		VARCHAR2(1),
	subscript		NUMBER,
	ovw_access		VARCHAR2(1),
	ovw_acc_prd		NUMBER NOT NULL,
	accessfee		NUMBER,
	channel_excl		VARCHAR2(1),
	dis_subscr		NUMBER,
	install_date		DATE,
	trial_end_date		DATE,
	prm_value_id		NUMBER,
	currency		NUMBER,
	srv_type		VARCHAR2(1),
	srv_subtype		VARCHAR2(1),
	ovw_adv_charge		VARCHAR2(1) NOT NULL,
	adv_charge		NUMBER,
	adv_charge_prd		NUMBER NOT NULL,
	delete_flag		VARCHAR2(1),
	rec_version		NUMBER DEFAULT 0 NOT NULL,
	attrib_histno		NUMBER,
	attrib_histno_nnp	NUMBER,
	ovwaccfee_histno	NUMBER
	)
PARTITION BY RANGE (co_id)
	(  
	PARTITION profile_service_1 VALUES LESS THAN (1000001),
	PARTITION profile_service_2 VALUES LESS THAN (2000001),
	PARTITION profile_service_3 VALUES LESS THAN (3000001),
	PARTITION profile_service_4 VALUES LESS THAN (4000001),
	PARTITION profile_service_5 VALUES LESS THAN (5000001),
	PARTITION profile_service_6 VALUES LESS THAN (6000001),
	PARTITION profile_service_7 VALUES LESS THAN (7000001),
	PARTITION profile_service_8 VALUES LESS THAN (8000001),
	PARTITION profile_service_9 VALUES LESS THAN (9000001),
	PARTITION profile_service_10 VALUES LESS THAN (10000001),
	PARTITION profile_service_11 VALUES LESS THAN (11000001),
	PARTITION profile_service_12 VALUES LESS THAN (12000001),
	PARTITION profile_service_13 VALUES LESS THAN (13000001),
	PARTITION profile_service_14 VALUES LESS THAN (14000001),
	PARTITION profile_service_15 VALUES LESS THAN (15000001),
	PARTITION profile_service_16 VALUES LESS THAN (16000001),
	PARTITION profile_service_17 VALUES LESS THAN (17000001),
	PARTITION profile_service_18 VALUES LESS THAN (18000001),
	PARTITION profile_service_19 VALUES LESS THAN (19000001),
	PARTITION profile_service_20 VALUES LESS THAN (20000001),
	PARTITION profile_service_21 VALUES LESS THAN (21000001),
	PARTITION profile_service_22 VALUES LESS THAN (MAXVALUE)
	)
TABLESPACE shmyg_ts
INITRANS 32
PCTFREE 10
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
	'PROFILE_SERVICE',
	'INT_PROFILE_SERVICE',
	col_mapping => NULL,
	options_flag => DBMS_REDEFINITION.CONS_USE_PK
	);
END;
/

CREATE	UNIQUE INDEX sysadm.int_pk_profile_service
ON	sysadm.int_profile_service
	(
	co_id,
	sncode,
	profile_id
	)
TABLESPACE shmyg_ts
INITRANS 32
STORAGE
	(
	INITIAL	16M
	NEXT	16M
	)
NOLOGGING
PARALLEL
LOCAL;

BEGIN
DBMS_REDEFINITION.COPY_TABLE_DEPENDENTS
	(
	'SYSADM',
	'PROFILE_SERVICE',
	'INT_PROFILE_SERVICE',
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
	'PROFILE_SERVICE',
	'INT_PROFILE_SERVICE'
	);
END;
/

BEGIN
DBMS_REDEFINITION.FINISH_REDEF_TABLE
	(
	'SYSADM',
	'PROFILE_SERVICE',
	'INT_PROFILE_SERVICE'
	);
END;
/

DROP	TABLE sysadm.int_profile_service;

CREATE	INDEX sysadm.idx_prof_serv_prm_value_id
ON	sysadm.profile_service
	(
	prm_value_id
	)
TABLESPACE idx
STORAGE
	(
	INITIAL	16M
	NEXT	16M
	)
PARALLEL
/

CREATE	INDEX sysadm.profile_service_delete_flag
ON	sysadm.profile_service
	(
	delete_flag
	)
TABLESPACE idx
PARALLEL
/

CREATE	INDEX sysadm.ix_profilesrv_trialenddate 
ON	sysadm.profile_service
	(
	trial_end_date	
	)
TABLESPACE idx
PARALLEL
/
BEGIN
DBMS_STATS.GATHER_TABLE_STATS
	(
	'SYSADM',
	'PROFILE_SERVICE',
	degree => 32,
	method_opt => 'for all columns size auto',
	estimate_percent => 10,
	granularity => 'ALL',
	cascade => TRUE
	);
END;
/

ALTER	INDEX sysadm.int_pk_profile_service
RENAME	TO pk_profile_service;

ALTER TABLE sysadm.profile_service LOGGING;
ALTER TABLE sysadm.profile_service NOPARALLEL;
ALTER INDEX sysadm.pk_profile_service NOPARALLEL;
ALTER INDEX sysadm.profile_service_delete_flag NOPARALLEL;
ALTER INDEX sysadm.ix_profilesrv_trialenddate NOPARALLEL;

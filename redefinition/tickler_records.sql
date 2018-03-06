/*
|| Partitioning of TICKLER_RECORDS
|| Reused for Zain Sudan from Maroc Telecom project
|| Author: Serge Shmygelskyy aka Shmyg 
|| mailto: serge.shmygelskyy@gmail.com // sergiy.shmygelskyy@ericsson.com
|| 
|| $Log: tickler_records.sql,v $
|| Revision 1.1  2013/08/14 14:20:59  shmyg
|| First completely working version of redefinition scrips for ZAS
||
*/

VAR num_errors NUMBER;

ALTER TABLE sysadm.tickler_records PARALLEL
/

BEGIN
DBMS_REDEFINITION.CAN_REDEF_TABLE
	(
	'SYSADM',
	'TICKLER_RECORDS',
	DBMS_REDEFINITION.CONS_USE_PK
	);
END;
/

CREATE	TABLE sysadm.int_tickler_records
	(
	customer_id		NUMBER(*,0) DEFAULT 0 NOT NULL,
	tickler_number		NUMBER(*,0) DEFAULT 0 NOT NULL,
	tickler_code		VARCHAR2(8) DEFAULT ' ' NOT NULL,
	tickler_status		VARCHAR2(8) DEFAULT ' ' NOT NULL,
	priority		NUMBER(*,0) DEFAULT 0 NOT NULL,
	follow_up_code		VARCHAR2(8),
	follow_up_date		DATE,
	follow_up_user		VARCHAR2(16),
	x_coordinate		VARCHAR2(15),
	y_coordinate		VARCHAR2(15),
	distribution_user1	VARCHAR2(16),
	distribution_user2	VARCHAR2(16),
	distribution_user3	VARCHAR2(16),
	created_by		VARCHAR2(16),
	created_date		DATE DEFAULT (SYSDATE),
	modified_by		VARCHAR2(16),
	modified_date		DATE,
	closed_by		VARCHAR2(16),
	closed_date		DATE,
	short_description	VARCHAR2(20),
	long_description	VARCHAR2(2000),
	co_id			NUMBER(*,0),
	msg_user		VARCHAR2(16),
	msg_date		DATE,
	mkt_id			NUMBER(*,0),
	msg_id			NUMBER(*,0),
	equ_id			NUMBER(*,0),
	usg_id			NUMBER(*,0),
	src_id			NUMBER(*,0),
	typ_id			NUMBER(*,0),
	act_id			NUMBER(*,0),
	tr_code			VARCHAR2(18),
	rec_version		NUMBER(*,0) DEFAULT 0 NOT NULL,
	follow_up_status	VARCHAR2(1) DEFAULT 'N'
	)
PARTITION BY RANGE( follow_up_date ) INTERVAL  (NUMTOYMINTERVAL (1, 'MONTH'))
SUBPARTITION BY HASH ( customer_id ) SUBPARTITIONS 16
	(
	PARTITION p1 VALUES LESS THAN (TO_DATE('01.08.2013', 'DD.MM.YYYY'))
	)
TABLESPACE shmyg_ts
INITRANS 16
STORAGE
        (
        INITIAL 16M
        NEXT    16M
        )
PCTFREE 5
NOLOGGING
COMPRESS;

BEGIN
DBMS_REDEFINITION.START_REDEF_TABLE
	(
	'SYSADM',
	'TICKLER_RECORDS',
	'INT_TICKLER_RECORDS',
	col_mapping => NULL,
	options_flag => DBMS_REDEFINITION.CONS_USE_PK
	;
END;
/

CREATE	UNIQUE INDEX sysadm.int_pktickler_records
ON	sysadm.int_tickler_records
	(
	customer_id,
	tickler_number
	)
TABLESPACE shmyg_ts
INITRANS 16
STORAGE
        (
        INITIAL 16M
        NEXT    16M
        )
NOLOGGING
PARALLEL
LOCAL;

BEGIN
DBMS_REDEFINITION.COPY_TABLE_DEPENDENTS
	(
	'SYSADM',
	'TICKLER_RECORDS',
	'INT_TICKLER_RECORDS',
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
	'TICKLER_RECORDS',
	'INT_TICKLER_RECORDS'
	);
END;
/

BEGIN
DBMS_REDEFINITION.FINISH_REDEF_TABLE
	(
	'SYSADM',
	'TICKLER_RECORDS',
	'INT_TICKLER_RECORDS'
	);
END;
/

DROP	TABLE sysadm.int_tickler_records
CASCADE	CONSTRAINTS;

ALTER	INDEX sysadm.int_pktickler_records
RENAME	TO pk_tickler_records;

CREATE	INDEX sysadm.FKITCCREAT
ON	sysadm.tickler_records
	(
	CREATED_BY
	)
STORAGE
        (
        INITIAL 16M
        NEXT    16M
        )
UNRECOVERABLE PARALLEL
/

CREATE	INDEX sysadm.FKITCRCDOC
ON	sysadm.tickler_records
	(
	co_id
	)
STORAGE
        (
        INITIAL 16M
        NEXT    16M
        )
UNRECOVERABLE PARALLEL
/

-- Not needed, the field is always NULL in ZAS
/*
CREATE	INDEX sysadm.FKITIRCCODE
ON	sysadm.tickler_records
	(
	follow_up_code
	)
UNRECOVERABLE PARALLEL
/
*/

CREATE	INDEX sysadm.IDX_TICKLER_NUMBER
ON	sysadm.tickler_records
	(
	tickler_number
	)
STORAGE
        (
        INITIAL 16M
        NEXT    16M
        )
UNRECOVERABLE PARALLEL
/

BEGIN
DBMS_STATS.GATHER_TABLE_STATS
	(
	'SYSADM',
	'TICKLER_RECORDS',
	degree => 32,
	method_opt => 'for all columns size auto',
	estimate_percent => 10,
	granularity => 'ALL',
	cascade => TRUE
	);
END;
/

ALTER TABLE sysadm.tickler_records LOGGING;
ALTER TABLE sysadm.tickler_records NOPARALLEL;

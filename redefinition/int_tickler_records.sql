ALTER	TABLE sysadm.tickler_records PARALLEL;

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
	follow_up_status	VARCHAR2(1) DEFAULT 'N,
	)
PARTITION BY RANGE( created_date ) INTERVAL  (NUMTOYMINTERVAL (1, 'MONTH'))
SUBPARTITION BY HASH ( customer_id ) SUBPARTITIONS 16
	(
	PARTITION p1 VALUES LESS THAN (TO_DATE('01.01.2012', 'DD.MM.YYYY')) COMPRESS,
	PARTITION p2 VALUES LESS THAN (TO_DATE('01.01.2013', 'DD.MM.YYYY')) COMPRESS,
	PARTITION p3 VALUES LESS THAN (TO_DATE('01.08.2014', 'DD.MM.YYYY')) COMPRESS,
	PARTITION p4 VALUES LESS THAN (TO_DATE('01.09.2014', 'DD.MM.YYYY')) COMPRESS
	)
INITRANS 16
STORAGE
        (
        INITIAL 16M
        NEXT    16M
        )
PCTFREE 5
NOLOGGING
COMPRESS;

COMMENT ON COLUMN sysadm.int_tickler_records.CUSTOMER_ID is '(Already existing field in other tables) key field together with TICKLER_NUMBER';
COMMENT ON COLUMN sysadm.int_tickler_records.TICKLER_NUMBER is 'BSCS memo (formerly: tickler) number';
COMMENT ON COLUMN sysadm.int_tickler_records.TICKLER_CODE is 'Memo type (formerly: tickler code), e.g. SYSTEM';
COMMENT ON COLUMN sysadm.int_tickler_records.TICKLER_STATUS is 'Memo status (formerly: tickler status)';
COMMENT ON COLUMN sysadm.int_tickler_records.PRIORITY is 'The priority of the memo (formerly: tickler) - can have values between 1 and 9.
9 is the highest priority.';
COMMENT ON COLUMN sysadm.int_tickler_records.FOLLOW_UP_CODE is 'the action, the follow-up-user has to do';
COMMENT ON COLUMN sysadm.int_tickler_records.FOLLOW_UP_DATE is 'The deadline by which the follow-up user has to complete an action related to the memo (formerly: tickler).';
COMMENT ON COLUMN sysadm.int_tickler_records.FOLLOW_UP_USER is 'one of the existing users as defined in the user table';
COMMENT ON COLUMN sysadm.int_tickler_records.X_COORDINATE is 'X Coordinate';
COMMENT ON COLUMN sysadm.int_tickler_records.Y_COORDINATE is 'Y Coordinate';
COMMENT ON COLUMN sysadm.int_tickler_records.DISTRIBUTION_USER1 is 'one of the existing users as defined in the user table - can be used for distribution purposes - a maximum of three users is supported for distribution';
COMMENT ON COLUMN sysadm.int_tickler_records.DISTRIBUTION_USER2 is 'one of the existing users as defined in the user table - can be used for distribution purposes - a maximum of three users is supported for distribution';
COMMENT ON COLUMN sysadm.int_tickler_records.DISTRIBUTION_USER3 is 'one of the existing users as defined in the user table - can be used for distribution purposes - a maximum of three users is supported for distribution';
COMMENT ON COLUMN sysadm.int_tickler_records.CREATED_BY is 'name of the user who created the record';
COMMENT ON COLUMN sysadm.int_tickler_records.CREATED_DATE is 'Date of creation';
COMMENT ON COLUMN sysadm.int_tickler_records.MODIFIED_BY is 'name of the user who modified the table';
COMMENT ON COLUMN sysadm.int_tickler_records.MODIFIED_DATE is 'Date of modification';
COMMENT ON COLUMN sysadm.int_tickler_records.CLOSED_BY is 'The name of the user who closed the memo (formerly: tickler).';
COMMENT ON COLUMN sysadm.int_tickler_records.CLOSED_DATE is 'Date of closing';
COMMENT ON COLUMN sysadm.int_tickler_records.SHORT_DESCRIPTION is 'Short Description';
COMMENT ON COLUMN sysadm.int_tickler_records.LONG_DESCRIPTION is 'details of the customer contact or any other customer oriented transaction';
COMMENT ON COLUMN sysadm.int_tickler_records.CO_ID is 'link to CONTRACT_ALL';
COMMENT ON COLUMN sysadm.int_tickler_records.MSG_USER is 'User, who sent last message';
COMMENT ON COLUMN sysadm.int_tickler_records.MSG_DATE is 'Date, when last message has been sent';
COMMENT ON COLUMN sysadm.int_tickler_records.MKT_ID is 'Market Code, FK to MPDSCTAB';
COMMENT ON COLUMN sysadm.int_tickler_records.MSG_ID is 'Message Code, FK to TICKLER_TRACKING_REF';
COMMENT ON COLUMN sysadm.int_tickler_records.EQU_ID is 'Equipment Code, FK to TICKLER_TRACKING_REF';
COMMENT ON COLUMN sysadm.int_tickler_records.USG_ID is 'Usage Code, FK to TICKLER_TRACKING_REF';
COMMENT ON COLUMN sysadm.int_tickler_records.SRC_ID is 'Source Code, FK to TICKLER_TRACKING_REF';
COMMENT ON COLUMN sysadm.int_tickler_records.TYP_ID is 'Type Code, FK to TICKLER_TRACKING_REF';
COMMENT ON COLUMN sysadm.int_tickler_records.ACT_ID is 'Action Code, FK to TICKLER_TRACKING_REF';
COMMENT ON COLUMN sysadm.int_tickler_records.TR_CODE is 'Problem Tracking Code, build by concatenating the appropriate codes from TICKLER_TRACKING_REF.CODE';
COMMENT ON COLUMN sysadm.int_tickler_records.REC_VERSION is 'Record Version
The TICKLER_RECORDS.REC_VERSION attribute specifies the counter for multi user access. It is used for the optimistic locking method.';
COMMENT ON COLUMN sysadm.int_tickler_records.FOLLOW_UP_STATUS is 'Follow-up status for memos (formerly: ticklers) to be delivered to a user at some times in the future to prompt some action.
Domain:
  "N" Not notified
  "S" Sent notification
  "A" Acknowledged notification';

GRANT DELETE ON SYSADM.int_tickler_records TO BSCS_ROLE;
GRANT INSERT ON SYSADM.int_tickler_records TO BSCS_ROLE;
GRANT SELECT ON SYSADM.int_tickler_records TO BSCS_ROLE;
GRANT UPDATE ON SYSADM.int_tickler_records TO BSCS_ROLE;

INSERT	/*+ append */ INTO sysadm.int_tickler_records
	(
	SELECT	/*+ parallel (tickler_records, 32) */ *
	FROM	tickler_records
	)
/

DROP	TABLE sysadm.tickler_records
/

ALTER TABLE int_tickler_records PARALLEL;

ALTER	TABLE SYSADM.int_tickler_records
ADD	CONSTRAINT TCCREAT FOREIGN KEY (CREATED_BY)
REFERENCES SYSADM.USERS (USERNAME) ENABLE NOVALIDATE;

ALTER	TABLE SYSADM.int_tickler_records
ADD	CONSTRAINT TCRCCUST FOREIGN KEY (CUSTOMER_ID)
REFERENCES SYSADM.CUSTOMER_ALL (CUSTOMER_ID) ENABLE NOVALIDATE;

ALTER	TABLE SYSADM.int_tickler_records
ADD	CONSTRAINT TCRCDOC FOREIGN KEY (CO_ID)
REFERENCES SYSADM.CONTRACT_ALL (CO_ID) ENABLE NOVALIDATE;

ALTER	TABLE SYSADM.int_tickler_records
ADD	CONSTRAINT TCRC_ACT_ID FOREIGN KEY (ACT_ID)
REFERENCES SYSADM.TICKLER_TRACKING_REF (TR_ID) ENABLE NOVALIDATE;

ALTER	TABLE SYSADM.int_tickler_records
ADD	CONSTRAINT TCRC_EQU_ID FOREIGN KEY (EQU_ID)
REFERENCES SYSADM.TICKLER_TRACKING_REF (TR_ID) ENABLE NOVALIDATE;

ALTER	TABLE SYSADM.int_tickler_records
ADD	CONSTRAINT TIRCCODE FOREIGN KEY (FOLLOW_UP_CODE)
REFERENCES SYSADM.FOLLOW_UP_CODE_DEF (FOLLOW_UP_CODE) ENABLE NOVALIDATE;

ALTER	TABLE SYSADM.int_tickler_records
ADD	CONSTRAINT TCRC_MSG_ID FOREIGN KEY (MSG_ID)
REFERENCES SYSADM.TICKLER_TRACKING_REF (TR_ID) ENABLE NOVALIDATE;

ALTER	TABLE SYSADM.int_tickler_records
ADD	CONSTRAINT TCRC_SRC_ID FOREIGN KEY (SRC_ID)
REFERENCES SYSADM.TICKLER_TRACKING_REF (TR_ID) ENABLE NOVALIDATE;

ALTER	TABLE SYSADM.int_tickler_records
ADD	CONSTRAINT TCRC_TYP_ID FOREIGN KEY (TYP_ID)
REFERENCES SYSADM.TICKLER_TRACKING_REF (TR_ID) ENABLE NOVALIDATE;

ALTER	TABLE SYSADM.int_tickler_records
ADD	CONSTRAINT TCRC_USG_ID FOREIGN KEY (USG_ID)
REFERENCES SYSADM.TICKLER_TRACKING_REF (TR_ID) ENABLE NOVALIDATE;

ALTER	TABLE SYSADM.int_tickler_records
ADD	CONSTRAINT TCRC_MKT_ID FOREIGN KEY (MKT_ID)
REFERENCES SYSADM.MPDSCTAB (SCCODE) ENABLE NOVALIDATE;

ALTER	TABLE sysadm.int_tickler_records RENAME to tickler_records
/

DECLARE
        -- Number of the job
        v_job_num       PLS_INTEGER := 1;

BEGIN

        FOR     rec IN
                (
                SELECT  table_name,
                        constraint_name
                FROM    dba_constraints
                WHERE   owner = 'SYSADM'
                AND     validated = 'NOT VALIDATED'
                AND     constraint_type NOT IN ('O', 'V')
		AND	table_name = 'TICKLER_RECORDS'
                ORDER   BY DBMS_RANDOM.RANDOM
                )
        LOOP
                DBMS_SCHEDULER.CREATE_JOB                       
                (
                job_name => 'VALCONS_' || v_job_num,
                job_type => 'PLSQL_BLOCK',
                job_action => 'begin execute immediate ''alter session force parallel ddl''; ' || 
                                'execute immediate ''alter table sysadm.' || rec.table_name ||
                                ' enable constraint ' || rec.constraint_name || '''; end;',
                enabled => TRUE,
                auto_drop => TRUE
                );
        
                v_job_num := v_job_num + 1;
        END     LOOP;
END;
/

COMMIT;

ALTER	TABLE sysadm.tickler_records ADD CONSTRAINT pktickler_records PRIMARY KEY (customer_id, tickler_number)
/

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
        DBMS_SCHEDULER.CREATE_JOB
        (
        job_name => 'STAT_1',
        job_type => 'PLSQL_BLOCK',
        job_action => 'begin execute immediate ''alter session force parallel ddl''; ' || 
                        'DBMS_STATS.GATHER_TABLE_STATS( ''sysadm'', ''tickler_records'', '  ||
                        'method_opt => ''FOR ALL COLUMNS SIZE AUTO'', degree => 32); end;',
        enabled => TRUE,
        auto_drop => TRUE
        );
END;
/

ALTER TABLE sysadm.tickler_records LOGGING;
ALTER TABLE sysadm.tickler_records NOPARALLEL;
CREATE PUBLIC SYNONYM tickler_records FOR sysadm.tickler_records;


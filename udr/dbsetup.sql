CREATE	TABLE rejected_records
	(
	file_name	VARCHAR2(100) NOT NULL,
	record_num	NUMBER NOT NULL,
	line_num	NUMBER NOT NULL,
	udr_part	VARCHAR2(2) NOT NULL,
	uds_node	NUMBER NOT NULL,
	uds_member	NUMBER NOT NULL,
	value		VARCHAR2(200) NOT NULL,
	entry_date	DATE DEFAULT SYSDATE,
	file_type	VARCHAR2(3) NOT NULL,
CONSTRAINT pk_my_udr
PRIMARY KEY
	(
	file_name,
	record_num,
	uds_node,
	uds_member
	)
)
/

LOAD	DATA
INTO	TABLE rejected_records
APPEND
FIELDS	TERMINATED BY ','
TRAILING NULLCOLS
	(
	file_name,
	file_type,
	record_num	INTEGER EXTERNAL,
	line_num	INTEGER EXTERNAL,
	udr_part,
	uds_node	INTEGER EXTERNAL,
	uds_member	INTEGER EXTERNAL,
	value
	)

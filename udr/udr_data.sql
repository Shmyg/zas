SET LINESIZE 999
COLUMN udr_part FOR a2
COLUMN uds_member_des for a40
COLUMN uds_member_des NOPRINT
COLUMN uds_element_des for a40
COLUMN uds_code for a10
COLUMN value FOR A30
COLUMN file_name FOR A45
BREAK ON file_name SKIP 1

SELECT	file_name,
	record_num,
	line_num,
	udr_part,
	uds_item.uds_member_code || ',' || uds_item.uds_element_code as uds_code,
	uds_item.column_name,
	NVL( uds_member.uds_member_des, uds_member.uds_member_name) as uds_member_des,
	NVL( uds_element.uds_element_des, uds_element.uds_element_name) as uds_element_des,
	rejected_records.value
FROM	uds_item,
	uds_member,
	uds_element,
	rejected_records
WHERE	uds_item.uds_member_code = uds_member.uds_member_code
AND	uds_element.uds_element_code = uds_item.uds_element_code
AND	rejected_records.uds_node = uds_item.uds_member_code
AND	rejected_records.uds_member = uds_item.uds_element_code
AND	rejected_records.file_type = 'UDR'
ORDER	BY 1, 2, 3, 4
/

UPDATE	refnum_base
SET	refnum_maintenance_type = 'M',
	range_autoextension_type = 'F'
WHERE	refnum_id = 15;

INSERT	INTO refnum_version
	(
	refnum_id,
	refnum_version,
	valid_from,
	period_type,
	refnum_prefix,
	refnum_suffix,
	value_length,
	range_length,
	first_ref_value,
	rec_version,
	business_unit_id
	)
VALUES	(
	15,	-- 'Regular invoice' ID
	2,
	TRUNC( SYSDATE ),
	'D',
	'INV',
	'YYYYMM01',	-- Billcycle '01'	
	20,
	9,
	1,
	0,
	NULL
	)
/

INSERT	INTO refnum_period
	(
	refnum_id,
	refnum_version,
	period_cnt,
	period_start_date,
	period_active_ind,
	rec_version
	)
VALUES	(
	15,
	2,
	1,
	'20.06.2013',
	'Y',
	0
	)
/

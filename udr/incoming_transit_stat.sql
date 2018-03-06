SELECT	SUM( aggreg_info_rec_counter),
	SUM( rated_volume) / 60,
	SUM( rated_flat_amount)
FROM	udr_sum_st@bscs_to_rtx_link
WHERE	TRUNC( start_time_timestamp + ( entry_date_offset / (24*3600) ) ) >= TO_DATE ('01.10.2012', 'DD.MM.YYYY')
AND	TRUNC( start_time_timestamp + ( entry_date_offset / (24*3600) ) ) < TO_DATE ('01.11.2012', 'DD.MM.YYYY')
AND	call_type = 4
AND	tariff_info_usage_ind = 38
AND	aggreg_info_aggreg_purpose = 'B' 
/

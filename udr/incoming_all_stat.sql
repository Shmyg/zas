SELECT	interconnect_partner.partner,
	contacts_address.ccname,
	contacts_address.country_name,
	TO_CHAR( udr_sum_st.start_time_timestamp + ( udr_sum_st.entry_date_offset / ( 24*3600 ) ), 'YYYY' ) AS year,
	TO_CHAR( udr_sum_st.start_time_timestamp + ( udr_sum_st.entry_date_offset / ( 24*3600 ) ), 'MON' ) AS month,
	DECODE( SUBSTR( udr_sum_st.call_dest, 0, 1 ), 'I', 'International', 'N', 'National' ) AS type,
	interconnect_zone.zone,
	interconnect_zone.name,
	mpusntab.des,
	SUM( udr_sum_st.aggreg_info_rec_counter ) AS qty,
	SUM( udr_sum_st.rated_volume )/ 60 AS volume,
	SUM( udr_sum_st.rated_flat_amount ) AS amount
FROM	( 
	SELECT	DISTINCT rp.tmcode,
		REPLACE( REPLACE( des, 'IC '), 'Rateplan' ) AS partner,
		rp.des
	FROM	rateplan	rp,
		contract_all	co
	WHERE	co.tmcode = rp.tmcode
	AND	co.agreement_type = 'EC'
	)  interconnect_partner,
	( 
	SELECT	cc.*,
		ca.name AS country_name
	FROM	ccontact_all	cc,
		country		ca
	WHERE	cc.country = ca.country_id
	AND	cc.ccseq =
		(
		SELECT	MAX( ccseq )
		FROM	ccontact
		WHERE	customer_id = cc.customer_id
		)
	)  contacts_address,
	( 
	SELECT	DISTINCT gm.zncode,
		gm.zpcode,
		cc.iso,
		cc.name,
		zn.des as zone,
		gm.zodes,
		gm.zpdes 
	FROM	mpulkgvm	gm,
		mpuzntab	zn,
		mpuzptab	zp,
		country		cc 
	WHERE	gm.zncode = zn.zncode
	AND	gm.zpcode = zp.zpcode
	AND	SUBSTR( zp.shdes, 1, 3 ) = CC.ISO
	)  interconnect_zone,
	contract_all,
	mpusntab,
	udr_sum_st
WHERE	udr_sum_st.cust_info_contract_id = contract_all.co_id  
AND	udr_sum_st.cust_info_customer_id = contract_all.customer_id  
AND	udr_sum_st.tariff_info_tmcode = contract_all.tmcode  
AND	contract_all.tmcode = interconnect_partner.tmcode  
AND	contacts_address.customer_id = contract_all.customer_id  
AND	udr_sum_st.tariff_info_zncode = interconnect_zone.zncode  
AND	interconnect_zone.zpcode = udr_sum_st.tariff_info_zpcode  
AND	mpusntab.sncode = udr_sum_st.tariff_info_sncode
AND	TRUNC( udr_sum_st.start_time_timestamp + ( udr_sum_st.entry_date_offset / ( 24*3600 ) ) ) >= TO_DATE( '01.01.2010', 'DD.MM.YYYY' )
AND	TRUNC( udr_sum_st.start_time_timestamp + ( udr_sum_st.entry_date_offset / ( 24*3600 ) ) ) < TO_DATE( '01.01.2015', 'DD.MM.YYYY' )
AND	(
	( udr_sum_st.call_type = 4 AND udr_sum_st.tariff_info_usage_ind = 38 ) 
	OR
	udr_sum_st.call_type = 2
	)
AND	udr_sum_st.aggreg_info_aggreg_purpose = 'R'
GROUP	BY interconnect_partner.partner, 
	contacts_address.ccname, 
	contacts_address.country_name, 
	TO_CHAR( udr_sum_st.start_time_timestamp + ( udr_sum_st.entry_date_offset / ( 24*3600 ) ), 'YYYY' ),
	TO_CHAR( udr_sum_st.start_time_timestamp + ( udr_sum_st.entry_date_offset / ( 24*3600 ) ), 'MON' ),
	DECODE( SUBSTR( udr_sum_st.call_dest, 0, 1 ), 'I', 'International', 'N', 'National' ),
	interconnect_zone.zone, 
	interconnect_zone.name,
	mpusntab.des
/

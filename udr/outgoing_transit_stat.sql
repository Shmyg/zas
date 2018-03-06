SELECT	interconnect_partner.partner,
	contacts_address.ccname,
	contacts_address.country_name,
	TO_CHAR( udr_sum_st.start_time_timestamp + ( udr_sum_st.entry_date_offset / ( 24*3600 ) ), 'YYYY' ),
	TO_CHAR( udr_sum_st.start_time_timestamp + ( udr_sum_st.entry_date_offset / ( 24*3600 ) ), 'MON' ),
	DECODE( SUBSTR( udr_sum_st.call_dest, 0, 1 ), 'I', 'International', 'N', 'National' ),
	interconnect_zone.zone,
	interconnect_zone.name,
	SUM( udr_sum_st.aggreg_info_rec_counter ),
	SUM( udr_sum_st.rated_volume )/ 60,
	SUM( udr_sum_st.rated_flat_amount )
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
	SELECT	DISTINCT GM.ZNCODE,
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
	udr_sum_st@bscs_to_rtx_link AS udr_sum_st
WHERE	udr_sum_st.cust_info_contract_id = contract_all.co_id  
AND	udr_sum_st.cust_info_customer_id = contract_all.customer_id  
AND	udr_sum_st.tariff_info_tmcode = contract_all.tmcode  
AND	contract_all.tmcode = interconnect_partner.tmcode  
AND	contacts_address.customer_id = contract_all.customer_id  
AND	udr_sum_st.tariff_info_zncode = interconnect_zone.zncode  
AND	interconnect_zone.zpcode = udr_sum_st.tariff_info_zpcode  
AND	TRUNC(UDR_SUM_ST.START_TIME_TIMESTAMP+(UDR_SUM_ST.ENTRY_DATE_OFFSET/(24*3600)))  BETWEEN  '01-10-2012 00:00:00'  AND  '31-10-2012 00:00:00'
AND	UDR_SUM_ST.CALL_TYPE = 4 AND UDR_SUM_ST.TARIFF_INFO_USAGE_IND = 39  
AND	UDR_SUM_ST.AGGREG_INFO_AGGREG_PURPOSE = 'R'  
GROUP BY INTERCONNECT_PARTNER.PARTNER, 
	contacts_address.ccname, 
	contacts_address.country_name, 
	TO_CHAR(UDR_SUM_ST.START_TIME_TIMESTAMP+(UDR_SUM_ST.ENTRY_DATE_OFFSET/(24*3600)),'YYYY'), 
	TO_CHAR(UDR_SUM_ST.START_TIME_TIMESTAMP+(UDR_SUM_ST.ENTRY_DATE_OFFSET/(24*3600)),'MON'), 
	DECODE(SUBSTR(UDR_SUM_ST.CALL_DEST,0,1), 'I', 'International', 'N','National'), 
	interconnect_zone.zone, 
	interconnect_zone.name

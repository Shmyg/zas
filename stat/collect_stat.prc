CREATE	OR REPLACE
PROCEDURE	collect_stat
		(
		i_date IN DATE := TRUNC(SYSDATE)
		)
AS
BEGIN
INSERT	INTO udr_stat
	(
	entdate,
	service_logic_code,
	follow_up_call_type,
	call_amt,
	customer_amt
	)
(
SELECT	/*+ parallel (UDR_ST, 64) */ i_date,
	service_logic_code,
	follow_up_call_type,
	COUNT(*),
	COUNT( DISTINCT cust_info_customer_id )
FROM	sysadm.udr_st
WHERE	entry_date_timestamp < i_date
AND	entry_date_timestamp >= i_date - 1	
GROUP	BY service_logic_code,
	follow_up_call_type
);

COMMIT;

END	collect_stat;
/
SHOW ERROR

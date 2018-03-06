BEGIN
        DBMS_SCHEDULER.CREATE_JOB
        (
        job_name => 'UDR_STAT_JOB',
        job_type => 'STORED_PROCEDURE',
        job_action => 'COLLECT_STAT',
        enabled => TRUE,
	start_date => TO_DATE( '14.08.2013 02:32', 'dd.mm.yyyy hh24:mi'),
	repeat_interval => 'FREQ=DAILY'
        );
END;
/

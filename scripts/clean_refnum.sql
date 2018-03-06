delete from refnum_value;
delete from refnum_period where period_start_date > '01.01.1970';
delete from refnum_version where refnum_version > 1;
delete from refnum_range_name;
delete from refnum_version where refnum_version > 1;
commit;

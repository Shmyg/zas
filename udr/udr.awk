BEGIN { FS = ","; record_num = 0 }
/^$/ {next}
$1 ~ /P/ {
 rectype = $1
 if ( $1 ~ /P1/ )
  {
  line_num = 0
  record_num++
  }
}
$1 != "" && $1 !~ /P/ {
 uds_type = $1
 line_num++
 print record_num "," line_num "," rectype "," $1 "," $2
}
$1 == "" {
 line_num++
 print record_num "," line_num "," rectype "," uds_type "," $2
 }

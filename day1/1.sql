with splitted_data as (
      select rn as id, val as column_value
        from json_table('["'
                || replace(:data, unistr('\000a'), '","')
                || '"]"', '$[*]'
                columns (
                   rn for ordinality,
                   val varchar2 path '$'
                )
             )
   )
select sum(
          to_number(
             regexp_substr(column_value, '[0-9]', 1)
             ||
             regexp_substr(column_value, '[0-9]', 1, regexp_count(column_value, '[0-9]'))
          )
       ) as result
  from splitted_data
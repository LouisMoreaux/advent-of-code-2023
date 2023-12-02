with splitted_data as (
      select rn, val as column_value
        from json_table('["'
                || replace(:data, unistr('\000a'), '","')
                || '"]"', '$[*]'
                columns (
                   rn for ordinality,
                   val varchar2 path '$'
                )
             )
   ), converted_data as (
      select rn,
             column_value,
             regexp_count(column_value, '1|one') as count_one,
             regexp_count(column_value, '2|two') as count_two,
             regexp_count(column_value, '3|three') as count_three,
             regexp_count(column_value, '4|four') as count_four,
             regexp_count(column_value, '5|five') as count_five,
             regexp_count(column_value, '6|six') as count_six,
             regexp_count(column_value, '7|seven') as count_seven,
             regexp_count(column_value, '8|eight') as count_eight,
             regexp_count(column_value, '9|nine') as count_nine
        from splitted_data
   ), transformed_data as (
      select rn,
             column_value,
             regexp_instr(column_value, '1|one') as first_one,
             case
                when count_one > 1 then
                   regexp_instr(column_value, '1|one', 1, count_one)
             end as last_one,
             regexp_instr(column_value, '2|two') as first_two,
             case
                when count_two > 1 then
                   regexp_instr(column_value, '2|two', 1, count_two)
             end as last_two,
             regexp_instr(column_value, '3|three') as first_three,
             case
                when count_three > 1 then
                   regexp_instr(column_value, '3|three', 1, count_three)
             end as last_three,
             regexp_instr(column_value, '4|four') as first_four,
             case
                when count_four > 1 then
                   regexp_instr(column_value, '4|four', 1, count_four)
             end as last_four,
             regexp_instr(column_value, '5|five') as first_five,
             case
                when count_five > 1 then
                   regexp_instr(column_value, '5|five', 1, count_five)
             end as last_five,
             regexp_instr(column_value, '6|six') as first_six,
             case
                when count_six > 1 then
                   regexp_instr(column_value, '6|six', 1, count_six)
             end as last_six,
             regexp_instr(column_value, '7|seven') as first_seven,
             case
                when count_seven > 1 then
                   regexp_instr(column_value, '7|seven', 1, count_seven)
             end as last_seven,
             regexp_instr(column_value, '8|eight') as first_eight,
             case
                when count_eight > 1 then
                   regexp_instr(column_value, '8|eight', 1, count_eight)
             end as last_eight,
             regexp_instr(column_value, '9|nine') as first_nine,
             case
                when count_nine > 1 then
                   regexp_instr(column_value, '9|nine', 1, count_nine)
             end as last_nine
        from converted_data
   ), unpivoted_data as (
      select *
        from transformed_data
             unpivot (
                pos
                for letter
                in (
                   first_one as '1',
                   last_one as '1',
                   first_two as '2',
                   last_two as '2',
                   first_three as '3',
                   last_three as '3',
                   first_four as '4',
                   last_four as '4',
                   first_five as '5',
                   last_five as '5',
                   first_six as '6',
                   last_six as '6',
                   first_seven as '7',
                   last_seven as '7',
                   first_eight as '8',
                   last_eight as '8',
                   first_nine as '9',
                   last_nine as '9'
                )
             )
   ), aggregate_data as (
      select rn,
             column_value,
             pos,
             letter,
             max(pos) over(partition by rn) as max_val,
             min(pos) over(partition by rn) as min_val
        from unpivoted_data
       where pos > 0
   ), filtered_data as (
      select rn,
             column_value,
             letter,
             case
                when pos = min_val then
                   'first_letter'
                when pos = max_val then
                   'last_letter'
             end as letter_role
        from aggregate_data
       where pos = min_val
          or pos = max_val
   )
select sum(
          to_number(first_letter || coalesce(last_letter, first_letter)
          )
       ) as result
  from filtered_data
       pivot(
         max(letter)
         for letter_role
          in (
            'first_letter' as first_letter,
            'last_letter' as last_letter
          )
       )
with
   splitted_data as (
      select rn as id,
             trim(substr(val, instr(val, ':') + 1)) as games
        from json_table('["'
                || replace(:data, unistr('\000a'), '","')
                || '"]"', '$[*]'
                columns (
                   rn for ordinality,
                   val varchar2 path '$'
                )
             )
   ), extracted_data as (
      select id,
             jt.rn as draw_rn,
             jt.val as draw
        from splitted_data,
             json_table('["'
                || replace(replace(games, ',', '@'), ';', '","')
                || '"]', '$[*]'
                columns (
                   rn for ordinality,
                   val varchar2 path '$'
                )) jt
   ), cubes as (
      select id,
             draw_rn,
             rn as cube_rn,
             to_number(regexp_replace(val, '[^0-9]')) as cube_number,
             trim(regexp_replace(trim(val), '[0-9]')) as cube_color
        from extracted_data,
             json_table('["'
                || replace(draw, '@', '","')
                || '"]', '$[*]'
                columns (
                   rn for ordinality,
                   val varchar2 path '$'
                )) jt
   ), grouped_data as (
      select id,
             cube_color,
             max(cube_number) as cube_number
        from cubes
       group by id, cube_color
   ), pivoted_data as (
      select *
        from grouped_data
             pivot (
                max(cube_number)
                for cube_color
                in (
                   'blue' as blue,
                   'red' as red,
                   'green' as green
                )
             )
   )
select sum(blue * red * green) as result
  from pivoted_data
with
   function row_sum(
      p_column_value          in varchar2,
      p_previous_column_value in varchar2,
      p_next_column_value     in varchar2
   )
      return number
   is
      l_row_sum      number  := 0;
      l_gear         number  := 0;

      l_count_number integer;
      l_count_star   integer;
      l_pos_star     integer;
      l_nb_adjacent  integer := 0;
      l_adjacents    apex_t_varchar2;

      l_str_num      varchar2(10);
      l_str_pos      integer;
      l_str_length   integer;

   begin
      l_count_star := regexp_count(p_column_value, '[*]');

      for i in 1..l_count_star
      loop
         l_gear         := 0;
         l_adjacents    := apex_t_varchar2();
         l_nb_adjacent  := 0;
         l_pos_star     := regexp_instr(p_column_value, '[*]', 1, i);
      
         -- look if number in the same row
         l_count_number := regexp_count(p_column_value, '([0-9]{1,})');
         for j in 1..l_count_number
         loop
            l_str_num    := regexp_substr(p_column_value, '([0-9]{1,})', 1, j);
            l_str_pos    := regexp_instr(p_column_value, '([0-9]{1,})', 1, j);
            l_str_length := length(l_str_num);

            if (l_str_pos + l_str_length = l_pos_star) then
               apex_string.push(l_adjacents, l_str_num);
               l_nb_adjacent := l_nb_adjacent + 1;
               continue;
            end if;
            if (l_str_pos = l_pos_star + 1) then
               apex_string.push(l_adjacents, l_str_num);
               l_nb_adjacent := l_nb_adjacent + 1;
               continue;
            end if;
         end loop;
      
         -- look for previous row
         l_count_number := regexp_count(p_previous_column_value, '([0-9]{1,})');
         for j in 1..l_count_number
         loop
            l_str_num    := regexp_substr(p_previous_column_value, '([0-9]{1,})', 1, j);
            l_str_pos    := regexp_instr(p_previous_column_value, '([0-9]{1,})', 1, j);
            l_str_length := length(l_str_num);

            if (l_str_pos < l_pos_star and l_str_pos + l_str_length >= l_pos_star) then
               apex_string.push(l_adjacents, l_str_num);
               l_nb_adjacent := l_nb_adjacent + 1;
               continue;
            end if;
            if (l_str_pos = l_pos_star or l_str_pos = l_pos_star + 1) then
               apex_string.push(l_adjacents, l_str_num);
               l_nb_adjacent := l_nb_adjacent + 1;
               continue;
            end if;
         end loop;
      
         -- look for next row
         l_count_number := regexp_count(p_next_column_value, '([0-9]{1,})');
         for j in 1..l_count_number
         loop
            l_str_num    := regexp_substr(p_next_column_value, '([0-9]{1,})', 1, j);
            l_str_pos    := regexp_instr(p_next_column_value, '([0-9]{1,})', 1, j);
            l_str_length := length(l_str_num);

            if (l_str_pos < l_pos_star and l_str_pos + l_str_length >= l_pos_star) then
               apex_string.push(l_adjacents, l_str_num);
               l_nb_adjacent := l_nb_adjacent + 1;
               continue;
            end if;
            if (l_str_pos = l_pos_star or l_str_pos = l_pos_star + 1) then
               apex_string.push(l_adjacents, l_str_num);
               l_nb_adjacent := l_nb_adjacent + 1;
               continue;
            end if;
         end loop;

         if (l_nb_adjacent = 2) then
            for j in 1..l_adjacents.count()
            loop
               if j = 1 then
                  l_gear := to_number(l_adjacents(j));
               else
                  l_gear := l_gear * to_number(l_adjacents(j));
               end if;
            end loop;
         end if;
         l_row_sum      := l_row_sum + l_gear;

      end loop;
      return l_row_sum;
   end;
   splitted_data as (
      select rn as id,
             trim(substr(val, instr(val, ':') + 1)) as column_value
        from json_table('["'
                || replace(apex_string.join(
                      apex_t_varchar2(
                         '.....487.599...........411...........................................574..679.136..........................30......255.......432............',
                         '....*......*............*..........&586..........................375...@..*....../.....835.............610*........./...............582.....',
                         '...833........304...&.862...............203..........922.125...............819.............@....563.....................722..775............',
                         '..............+...994..........#.........*..244.457.....*...........867.........829.....469.....#...........................*...............',
                         '313.....753.....................596............*................270..../........*........................38.......836..850..914......942*215',
                         '........*............10.525.515.......417$........976...........*..............878.613/.......*247.......*........+.........................',
                         '.......725.............*......................848*......236....25.........#605............................602.352...+............505#.619...',
                         '741........872...........899...........596..........824..*............542......#....893........299&...........*......389.....176.......*....',
                         '..........*....691...165....*../.........@...........#..973...........%.....207............435.........296...269...&........*....$..112.....',
                         '...707..311.............@.522.561..........470.................152......524.......964*853.....*...........+......541....578...871...........',
                         '..................*805..................................774...*.....397*....$261..............74............956.........*............451....',
                         '....328..+907..665.............872.=744..745=....../...........21...................-.560..................*.........332....135.......+.....',
                         '......*..........................*................96.................754.........750....@.......803...*..163.....475.........*..............',
                         '...309.......51*................658...633..769..........%426............*191......................./.598.....685*....898......685...........',
                         '.......-.........972%.................*............................39.........220......@....366..........................257...........@....',
                         '.......532.............149..968.......86...690.....933.........800....91*545.*........65..........633..17*609.863*.......&...40....485.185..',
                         '............63........./.......*.426.........*................*..............639............+.....@...............191.......................',
                         '..801.......................425..%.....420..615.816...186*614..783..........................583...............*........&.417...248*.........',
                         '........292.....%.................................+................147.....933........+.......................31....260............563......',
                         '...539...=.......553.....$.....=331.........89.........................688.............586...264........80%.................................',
                         '...*....................964.$...........836*......&./22...#.962.........*../934.625..........*.................$543...284.%...821=.959......',
                         '........285.206..............363..#.............311.....501....=......676.........&.557.........#....................*....713...............',
                         '....................%.............659....493........698...........719.................@.539..810...................119......................',
                         '...................305..554.....................164*........989=.=.....885...46...........*.............426................276..............',
                         '........602................%.849..595...877..........389...................................322.............*...................../...%.930..',
                         '....115...*.........67....................*.......79*....................422.......843................859...771.......355.1...404..103......',
                         '......*..836...94.........758.....90...306....210...........921............$...115..$.......892..923....*..............*....................',
                         '.....806.......*..............................................*................*......809......=.......592.....894...884...152......%.......',
                         '...$.........299.......189..412...142..........................908.........-.891........*....%.............859*...........*.......910.......',
                         '..667.............+457../....*..........................................532......333..418....958.648*889.............%728..99.863.......-...',
                         '...............73............958.....650.....127........=........*480............./..........................99.221.............#...171..532',
                         '.................*......*831.......-...@........*151.901...723.16............113....209......39-.........130*......&...796..........*.......',
                         '.............838.621.985..........588......................%....................=....#.........................../........*380.810.720......',
                         '..317..$304..-...........+.................../851..................93.....846........................+........744........................398',
                         '....*..........156*....614.......134...&18...........109.360.........-.......*....301..=..............509........./206...*349...861.........',
                         '...717.206@..................1=......3...................*....37/.......104..449........599...............$......................%..........',
                         '...............808..............287..-..........724....781..........443*........................&91........485....433..516..............995.',
                         '.....42*254..........706#........&..........................656...............9.........*916.....................&.................$....%...',
                         '.................311.................*........308...................901..............615..........114*10...47*.....875..............593.....',
                         '616*97..&............679*..........657.819...*.....61................*......@....@...........=................375..@...378.718*.............',
                         '.......901...182.695.........47........$...227....$....163............786..217..836..577....151......958...............*.......398..242.....',
                         '.....*..........*.....709.....*..........................*.....182..................+..................*.-....910....106............*....532',
                         '..682.104................*65..941..536..277..............60...%......438.420..254...............97..126...761..@.....................924....',
                         '................$.............................353....8*.................*......../................-..............+..........351.............',
                         '.............893...................801*........#.......246................#.974.........712..................662..594..898...*..958*..324.49',
                         '........899............................731.................#.......225..152...#........*......*403.%...................$...738......6.......',
                         '............821....171............477...........996........556....*..................837...998.....35.............................#.....*...',
                         '.............$.....*.................*............/................19.....614+.891..............................+..............183.......303',
                         '....916.15.......172......#.447*348.823.@....475....381.................................925....432...#.........795..........................',
                         '.......*...183..........578..............94.*......&....305............294....470.443.............+.435.197.................................',
                         '...113....*.....159................783......325...............769-........-..@.....*....249.............*...........993........487.599..719.',
                         '...*.......827...*........179#.........=855........................129............988..........=568...998.715......*......235.....*.....*...',
                         '.991.....+........340............380...............645.*....78........*................929.448..............%.....337.......*........871....',
                         '.....479..273.250...................-..=...............293..$..40.....602...297........*....*.....422.........*..............341............',
                         '...&.............*..........721.839.....455..302.................*.............*.....706....158............742.885...............441........',
                         '.931.....306*499.965.........&...&...........*..........950@....438..515...41..205......................................+....%...%......860.',
                         '.....................301....................182.......................#.....*..........846.......869..624......746...689....677.............',
                         '..143.729.638...%910...*.980..45.................215.539*346.-............651...714......*.......#...*.........=.................45.........',
                         '.....*.......*.......274....%.*......361........*............852.960........../....*539.....390*......31...........................#........',
                         '..........949.................813.33....*612.357..........+.......%..=211...114.................495................200................367...',
                         '.......................434..............................771..849..................................................*...............128*......',
                         '.......865...830..........*..=34...=124..........281............=....*........10.791.........437..................760......*536.............',
                         '.......*....*...........641................144....-....180.........506.139.....@...#.............148....................135.................',
                         '...727..344.972.....573...............418..*.............*.540*.........*.............185....79.*.......241-.272................271.720.....',
                         '......*................*..877..251....#.....170........906.....716..........414..............@...235.........%.....................*........',
                         '.......458.....*362.846...*.....$..................................=....=..*.........407...#...................................441..........',
                         '.....+......334.........995...........690....639.................119.777...674....-...#....974.93........335............816.....*..654......',
                         '..270.......................%............%......*.....475........................910...............................462.........586...*..317.',
                         '........................218..605...856.......894.....-.......%771........288%........632..352.......410........314.&...............952......',
                         '825.64..392.834.......2*............$....164.....540....94..........................*......*........+..........*.........914................',
                         '.....*.....*.................*..........*.......*..........@...........461..678.681.599..906....188.........510............@..398...........',
                         '..991....*.......223.....846.460........814....47..721..113......*257......#.....*....................440.............154......*............',
                         '......225.518...*.....................%...............&.......549......../....28..133............338.....*554.7.............................',
                         '..745............996.....75....@.....88....*...%....*...................772.....*....................618..............44*573................',
                         '..........107@...........*....245........606...949...817.....................114....*944................*........../.................694....',
                         '......128...............269.................................556..................892...........99.....960...608..577............1......#....',
                         '...=....*....*....598...............716.959...763...........*...378........736.........526%..........................309..........559.......',
                         '300...963...345....................*.....@......*..........28..#...............676........../....327................*.....301.........727...',
                         '................457..926.....856..553.........480.@181............912...982.....*........./..40....*......701....843.........*....379.......',
                         '.244*.............*......364...*.........................*........*.....*.......943..=...768....660......*................489...........994.',
                         '.....664...........839.....*.37.............360.......536..379.........872...........623..............122.....*.....-94.......108...320*....',
                         '...........401*710........37.......-..........*..............*..............53*.................$..........868.698........171*..............',
                         '...................#.............572...........943..931...592..................192...91*381......638....................................335.',
                         '398@...728%.....661.....#541.............$363..........*.......701..921.......................&......*416............490*..337-.............',
                         '......................$............531.........54...205.........#.......739.669=..621..488*....6..894...........#.................%.174.....',
                         '..........776........185....97.....*.......$./............................*..........*.....688..............253.998....223......610....*890.',
                         '....#.....*..............&.*........546.270..713............379............797....$............212...275......$.............................',
                         '...399....828.........962...137......................384....*....................599..181......*......%.........228.630/.............504....',
                         '................26*.......................=...........*..820..........982................#.764..79................*.........&........*......',
                         '.....845...........338..277...$..461.#....603.804=.262.......969....................*.......*...............681.212.......782..857..814.....',
                         '...........357*155.....*....486.@....439.....................*...................553.395.....901.................................*..........',
                         '....................210..................../....748*.671......448....+283.................................321.408...............483...+.....',
                         '.....169*95......................449%.....16..........&..........................55.......$....781...579...-...........534...........274....',
                         '690...........154..........239....................883....903.....701.838.............$...467......*...=..................=..................',
                         '.........699....*.........=............15*619.......................*......515....487........................808...............*.....611*121',
                         '.....369.*.....................813..21.................630...................#.................$....................153........11...........',
                         '.358*.....30.......514...........=.%....624......&942.....+....831.....669.......142.282#......835......632.175..$.....*...855..............',
                         '......212..........*........................*148..............*.................#.......................&.....-...382..239...=........486...',
                         '......*........734.211.*...65............696................459......90.&847..#......+..621.....18*251.............................../......',
                         '...684....@............384...*..................650.............957-.*.........12..669....#.................53........618..246..............',
                         '.......249..476...621.........78..243..........*....864...............374.......................389...43..............@...*.........737.....',
                         '...........*.........................*304.220.......*......162................455.&.............................307........895......*...898.',
                         '....=......642.........878..@.............@...883...816...@.......$................273.......210...........235.....*470................*....',
                         '.537...........+........*...135...98..........*..............202.445.......................+..*....907................................78....',
                         '..............102...998.6./........./....853.545.481............................*........56..449...*.........&3..501.13..195......&.........',
                         '.....................*.....442...........*...................................928.111...............428............./....*.........11........',
                         '..319..954...........................52...867...........25............716....................@..............775.......711...................',
                         '....%....%.......286.....313.....116.*...........245.....*.269....520*.............*507...878..............*....520........*648.............',
                         '..............16*......../......@..................*...328.-...........@........919...........419*640...378......*......933.......980.......',
                         '......643....................38...........414.................559....&.612.144*......181........................946.571.....................',
                         '.74...*.....+.........566......*.........-................882*.....249.........504.....=...........34.833...518......*.......276.../177.....',
                         '...*..241..236...........*...93....*.600......924..420.........822........4........&...............#..+........*708...201.......%...........',
                         '.63.................*...531.....685.............*.....*.825...*....&............658...........220..........813.....................426......',
                         '......*98........520.41..................-387.260...51....+...156..601......136.......*......+............*........./......161.....@........',
                         '...862.....96........................297..........%...........................&.786.789...........776.+...528....271........................',
                         '........../.....446...890..%....393....*......43=.178...................519..................-...*....967.............213..796..614.#441....',
                         '..847*87....@........=....704......-..235..............193.......279*......@........*37...535..414..........234.......*.......@...*.........',
                         '...........963............................................@.861......360......@..906....*...............564.=.......85....285...564.........',
                         '....845...............*....469........+...460*989..............=...........884.......877.....738*505.....*.............................500..',
                         '.....*...214...825..18.917...........651...........248.............&....&.......&../......................342....271........644.........+...',
                         '....988...*.....*...........289+.423......287.....*........547&.9..163...613..605..447....73...817..$...........$......=....................',
                         '...............80......900............464*.........729...................................&........=..972.923.........654...852.......150....',
                         '837.174*671.............*.....147.............70...........................170%..............640*........*................=......615*.......',
                         '............878.......282........*............+....................120...........................987..636..950*.$...........................',
                         '...........*.....................731...................-....6.162....@......753.105.678.........................1.........992.......708.....',
                         '...*296.....821...817.....#...........29...-............588..*............@......$..*...202.........+212...2=.......8........*.........+....',
                         '660.....403............579.....873.....*....521..167.......................321......598...........%......%.....721.....825..440.928.........',
                         '.....37........................*.....964........*....622..........402#..........315................626.488.702*...........%.....*...........',
                         '..............783...........71..66..............460...*..+838...........*911....%................................................537...343..',
                         '..........625*...............&.......-......866.....989...............12................950.......................*912......................',
                         '...............121=.&886........=....351........................808........604...898.....*..199...913....433............@....121/...........',
                         '..........................362...120........464...................=.........*....*.......287..@...*........*..........828....................',
                         '..619..815.213......982...$.................*......588...165........544.805...136...870.........964..$....345.............829.......909.....',
                         '...-.../...*.......$..........273-.234....979.617.....=.*..........=...................*..............320.....324.%..........=......../.....',
                         '...........475......................./..........*............718........*......963%....994...................*.....109...644............116.',
                         '...../...............*133.......132..............41.........-...........506........................415.....585............*.................',
                         '.....304..873*633.382.....+............179.............410.......572.........................999...$...106.....+543.....421..887............',
                         '..........................997....925....*........153......*.383...*..50*.............585.102..........@........................*......199...',
                         '.......................................645.1.......+...622.....$.720....518...........*...*.................#........@303.......286.........',
                         '......696..................................................753......................957.715.............396..159...........338.......806....'
                      )), unistr('\000a'), '","')
                || '"]"', '$[*]'
                columns (
                   rn for ordinality,
                   val varchar2 path '$'
                )
             )
   ),
   computed_data as (
      select id,
             column_value,
             lag(column_value) over (order by id) previous_column_value,
             lead(column_value) over (order by id) next_column_value,
             row_sum(column_value, lag(column_value) over (order by id), lead(column_value) over (order by id)) as row_sum
        from splitted_data
   )
select sum(row_sum)
  from computed_data
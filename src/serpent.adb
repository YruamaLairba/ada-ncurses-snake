With xterm_console ;            Use xterm_console ;
with Ada.Calendar; use Ada.Calendar;
with ada.text_io; use ada.text_io;
with ada.wide_text_io; use ada.wide_text_io;
with Ada.Strings.UTF_Encoding; use Ada.Strings.UTF_Encoding;
with Ada.Strings.UTF_Encoding.Conversions;
use Ada.Strings.UTF_Encoding.Conversions;

procedure serpent is
    temps : Time := Clock; 
    duree : Duration := 1.0;
    UP : String := ASCII.ESC & '[' & 'A';
    DOWN : String := ASCII.ESC & '[' & 'B';
    RIGHT : String := ASCII.ESC & '[' & 'C';
    LEFT : String := ASCII.ESC & '[' & 'D';

    --VBAR : UTF_8_String := Convert("" & Wide_Character'val(16#2503#));
    --HBAR : UTF_8_String := Convert("" & Wide_Character'val(16#2501#));
    --UP_LEFT_BAR : UTF_8_String := Convert("" & Wide_Character'val(16#251B#));
    --DOWN_LEFT_BAR : UTF_8_String := Convert("" & Wide_Character'val(16#2513#));
    --UP_RIGHT_BAR : UTF_8_String := Convert("" & Wide_Character'val(16#2503#)) ;
    --DOWN_RIGHT_BAR : UTF_8_String := Convert("" & Wide_Character'val(16#2517#));

    VBAR : UTF_8_String := Convert("" & Wide_Character'val(16#2551#));
    HBAR : UTF_8_String := Convert("" & Wide_Character'val(16#2550#));
    UP_LEFT_BAR : UTF_8_String := Convert("" & Wide_Character'val(16#255D#));
    DOWN_LEFT_BAR : UTF_8_String := Convert("" & Wide_Character'val(16#2557#));
    UP_RIGHT_BAR : UTF_8_String := Convert("" & Wide_Character'val(16#255A#)) ;
    DOWN_RIGHT_BAR : UTF_8_String := Convert("" & Wide_Character'val(16#2554#));

begin
    ada.text_io.put_line("Jeu du serpent");
    temps := Clock;
    Alternate_Screen_Buffer;
    main: loop
        declare
            x : natural;
            a : Character;
            b : boolean;
        begin
            x := 0;
            get_immediate(a,b);
            if x in 0..79 then
                if (Clock - temps) >= 0.5 then
                    temps := Clock;
                    GOTO_XY(x,0);
                    Put(HBAR);
                end if;
            else 
                exit main;
            end if;
        end;
    end loop main;
    Normal_Screen_Buffer;
end serpent;

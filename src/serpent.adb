with Terminal_Interface.Curses;
use  Terminal_Interface.Curses;
with Terminal_Interface.Curses.Text_IO;
use  Terminal_Interface.Curses.Text_IO;

with Ada.Containers.Doubly_Linked_Lists ;
with Ada.Calendar; use Ada.Calendar;

procedure serpent is
   type T_Position is record
      line : Line_Position; 
      column : Column_Position ; 
   end record ;
   package P_Lists is new Ada.Containers.Doubly_Linked_Lists(T_Position) ; 
   use P_Lists ;

   snake : list;
   snake_cursor : cursor;
   pos : T_position;
   temps : Time := Clock; 
   duree : Duration := 1.0;
   key : Real_Key_Code;
begin
   Init_Screen;
   Set_Timeout_Mode(mode=>Non_Blocking,Amount=>0);
   border(standard_window);
   Move_cursor(standard_window,0,1);
   Put("jeu du serpent");
   temps := Clock;
   pos := (line=>1, Column=>0);
   main: loop
      if (Clock - temps) >= 0.25 then
         temps := Clock;
         pos.column := pos.column + 1;
         exit when pos.column > (Columns - 1);
         Prepend(snake,pos);
         Add(Line=>pos.line, Column=>pos.column, ch=>'O');
         Refresh;
      end if;
   end loop main;
         
   --main: loop
   --   declare
   --      x : natural;
   --      a : Character;
   --      b : boolean;
   --   begin
   --      x := 0;
   --      --get_immediate(a,b);
   --      --if x in 0..79 then
   --      --   if (Clock - temps) >= 0.5 then
   --      --      temps := Clock;
   --      --      GOTO_XY(x,0);
   --      --      Put(HBAR);
   --      --   end if;
   --      --else 
   --      --   exit main;
   --      --end if;
   --   end;
   --end loop main;
   Set_Timeout_Mode(mode=>Blocking,Amount=>0);
   key := Get_Keystroke;
   End_Windows;
end serpent;

with Terminal_Interface.Curses;
use  Terminal_Interface.Curses;
with Terminal_Interface.Curses.Text_IO;
use  Terminal_Interface.Curses.Text_IO;
with Terminal_Interface.Curses.Text_IO.Integer_IO;

with Ada.Containers.Doubly_Linked_Lists ;
with Ada.Calendar; use Ada.Calendar;

procedure serpent is
   type T_Position is record
      line : Line_Position; 
      column : Column_Position ; 
   end record;
   function "+" (Left, Right : T_Position) return T_Position is
      res : T_Position;
   begin
      res.line := left.line + right.line;
      res.column := left.column + right.column;
      return res;
   end "+";
   package P_Lists is new Ada.Containers.Doubly_Linked_Lists(T_Position) ; 
   use P_Lists ;
   package Line_Position_Text_IO
   is new Terminal_Interface.Curses.Text_IO.Integer_IO(Line_Position);
   use Line_Position_Text_IO;
   package Column_Position_Text_IO 
   is new Terminal_Interface.Curses.Text_IO.Integer_IO(Column_Position);
   use Column_Position_Text_IO;


   type T_Direction is (Up, Down, Left, Right);

   snake : list;
   direction : T_Direction := Right;
   snake_cursor : cursor;
   pos, pop : T_position;
   delta_pos : T_position :=(0,1);
   temps : Time := Clock; 
   duree : Duration := 1.0;
   key : Real_Key_Code;
   curs_visibility : Cursor_Visibility := Invisible;
begin
   Init_Screen;
   Set_Timeout_Mode(mode=>Non_Blocking,Amount=>0);
   Set_Cursor_Visibility(curs_visibility);
   Set_Echo_Mode(SwitchOn => false);
   Set_KeyPad_Mode(SwitchOn => true);
   border(standard_window);
   Move_cursor(standard_window,0,1);
   Put("jeu du serpent");
   --init the snake with a size
   pos := (line=>1,Column=>1);
   for i in 1..8 loop
      Prepend(snake,pos);
      Add(Line=>pos.line, Column=>pos.column, ch=>'O');
   end loop;
   --star moving the snake
   temps := Clock;
   main: loop
      declare
         tmp_delta_pos : T_Position:= (0,0);
      begin
         key := Get_Keystroke;
         case key is
            when KEY_UP => tmp_delta_pos := (-1,0);--Put("key_up");
            when KEY_DOWN => tmp_delta_pos := (1,0);--Put("key_down");
            when KEY_LEFT => tmp_delta_pos := (0,-1);--Put("key_left");
            when KEY_RIGHT => tmp_delta_pos := (0,1);--Put("key_right");
            when others => null; 
         end case;
         Move_Cursor(Standard_Window,0,15);
         if tmp_delta_pos /= (0,0) then
            delta_pos := tmp_delta_pos;
         end if;
      end;
      if (Clock - temps) >= 0.5 then
         temps := Clock;
         pos := pos + delta_pos;
         exit when pos.column > (Columns - 1);
         exit when pos.column < (1);
         exit when pos.line > (Lines - 1);
         exit when pos.line < (1);
         --add element to the front
         Prepend(snake,pos);
         Add(Line=>pos.line, Column=>pos.column, ch=>'O');
         Refresh;
         --delete element at the end
         pop := Last_element(snake);
         Delete_Last(snake);
         if (not Contains(snake, pop)) then
            Add(Line=>pop.line, Column=>pop.column, ch=>' ');
         end if;
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

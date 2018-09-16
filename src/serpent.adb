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

   function Self_Collision(snake : list; pos : T_Position) return Boolean is
   curs : cursor := First(snake);
   begin
      while curs /= Last(snake) loop
         if Element(curs)= pos then
            return true;
         else
            Next(Curs);
         end if;
      end loop;
      return false;
   end Self_Collision;

   snake : list;
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
      --Get the direction
      begin
         key := Get_Keystroke;
         case key is
            when KEY_UP =>
               if delta_pos /= (1,0) then
                  delta_pos := (-1,0);
               end if;
            when KEY_DOWN =>
               if delta_pos /= (-1,0) then
                  delta_pos := (1,0);
               end if;
            when KEY_LEFT =>
               if delta_pos /= (0,1) then
                  delta_pos := (0,-1);
               end if;
            when KEY_RIGHT =>
               if delta_pos /= (0,-1) then
                  delta_pos := (0,1);
               end if;
            when others => null; 
         end case;
      end;
      --Moving the snake on tick
      if (Clock - temps) >= 0.5 then
         temps := Clock;
         pos := pos + delta_pos;
         --detect collision with border
         exit when pos.column > (Columns - 1);
         exit when pos.column < (1);
         exit when pos.line > (Lines - 1);
         exit when pos.line < (1);
         --detect self collision
         exit when Self_Collision(snake, pos) ;
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

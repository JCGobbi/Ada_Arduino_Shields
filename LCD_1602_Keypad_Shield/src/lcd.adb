with STM32.GPIO;          use STM32.GPIO;
with LCD_Keypad_Shield;    use LCD_Keypad_Shield;

package body LCD is

   ----------------
   -- Wait_Until --
   ----------------

   procedure Wait_Until (S : Time_Span) is
      T : Constant Time := Clock + S;
   begin
      while Clock < T loop
         null;
      end loop;
   end Wait_Until;

   ------------
   -- LCD_Lo --
   ------------

   procedure LCD_Lo (Mask : Byte) is
      c8 : Bits_8 with Size => 8;
   begin
      c8 := B8_From_B(Mask);
      for i in LCD_Data'Range loop
         Drive (LCD_Data(i), Condition => c8(i));
      end loop;
   end LCD_Lo;

   ------------
   -- LCD_Hi --
   ------------

   procedure LCD_Hi (Mask : Byte) is
      c8       : Bits_8 with Size => 8;
   begin
      c8 := B8_From_B(Mask);
      for i in LCD_Data'Range loop
         Drive (LCD_Data(i), Condition => c8(i + 4));
      end loop;
   end LCD_Hi;

   ----------------
   -- LCD_Strobe --
   ----------------

   procedure LCD_strobe is
   begin
      LCD_E.Set;
      Wait_Until(Nanoseconds(500));
      LCD_E.Clear;
   end LCD_strobe;

   -----------------------
   -- LCD_Write_4x2Bits --
   -----------------------

   procedure LCD_Write_4x2Bits (C : Character) is
   begin
      Wait_Until(Microseconds(50));
      LCD_Hi(Character'Pos(C)); -- The ASCII byte address of the character
      LCD_Strobe;
      LCD_Lo(Character'Pos(C));
      LCD_Strobe;
   end LCD_Write_4x2Bits;

   -----------------------
   -- LCD_Write_4x2Bits --
   -----------------------

   procedure LCD_Write_4x2Bits (D : Byte) is
   begin
      Wait_Until(Microseconds(50));
      LCD_Hi(D);
      LCD_Strobe;
      LCD_Lo(D);
      LCD_Strobe;
   end LCD_Write_4x2Bits;

   -----------------------
   -- LCD_Write_4x1Bits --
   -----------------------

   procedure LCD_Write_4x1Bits (D : Byte) is
   begin
      LCD_Hi(D);
      LCD_Strobe;
   end LCD_Write_4x1Bits;

   -------------
   -- LCD_Cmd --
   -------------

   procedure LCD_Cmd (Cmd : Byte) is
   begin
      LCD_RS.Clear;
      LCD_Write_4x2Bits(Cmd);
   end LCD_Cmd;

   --------------
   -- LCD_Init --
   --------------

   procedure LCD_Init is
   begin
      LCD_E.Clear;
      --LCD_RW.Clear;
      LCD_RS.Clear;

      LCD_BKLT.Set;

      Wait_Until(Milliseconds(20));
      LCD_Write_4x1Bits(DISP_INIT);
      Wait_Until(Milliseconds(5));
      LCD_Write_4x1Bits(DISP_INIT);
      Wait_Until(Milliseconds(1));
      LCD_Write_4x1Bits(DISP_INIT);
      Wait_Until(Milliseconds(1));
      LCD_Write_4x1Bits(DISP_4BITS);
      Wait_Until(Milliseconds(1));

      LCD_Cmd(DISP_CONFIG);
      LCD_Cmd(DISP_OFF);
      LCD_Cmd(DISP_CLR);
      Wait_Until(Milliseconds(2));  -- undocumented but required!
      LCD_Cmd(DISP_EMS);
      LCD_Cmd(DISP_ON);
   end LCD_Init;

   ---------------
   -- LCD_Clear --
   ---------------

   procedure LCD_Clear is
   begin
      LCD_Cmd(DISP_CLR);
      Wait_Until(Milliseconds(2));  -- undocumented but required!
   end LCD_Clear;

   --------------
   -- LCD_Goto --
   --------------

   procedure LCD_Goto (X : Byte; Y : Byte) is
      Base : Byte;
   begin
      case Y is
         when 0 => Base := DD_RAM_ADDR;
         when 1 => Base := DD_RAM_ADDR2;
--         when 2 => Base := DD_RAM_ADDR3; -- Displays with 3 lines
--         when 3 => Base := DD_RAM_ADDR4; -- Displays with 4 lines
         when others => Base := DD_RAM_ADDR;
      end case;

      LCD_Cmd(Base + X + 16#80#);  -- addr command
   end LCD_Goto;

   ------------------
   -- LCD_Put_Char --
   ------------------

   procedure LCD_Put_Char (C : Character) is
   begin
      LCD_RS.Set;
      LCD_Write_4x2Bits(C);
   end LCD_Put_Char;

   --------------------
   -- LCD_Put_String --
   --------------------

   procedure LCD_Put_String (S : String) is
   begin
      for i in S'Range loop
         LCD_Put_Char(S(i));
      end loop;
   end LCD_Put_String;

   --------------------
   -- LCD_Put_String --
   --------------------

   procedure LCD_Put_String (X : Byte; Y : Byte; S : String) is
   begin
      LCD_Goto(X, Y);
      LCD_Put_String(S);
   end LCD_Put_String;

   ----------------
   -- Print_Hexa --
   ----------------

   procedure Print_Hexa is
      type String_Char is array (Integer range <>) of Character;
      Hexa_Char : constant String_Char (0 .. 15) :=
                    ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');
   begin
      LCD_Clear;
      for y in 0 .. 1 loop
         LCD_Goto (0, byte(y));
         for x in Hexa_Char'Range loop
            LCD_Put_Char (Hexa_Char(x));
         end loop;
      end loop;
   end Print_Hexa;

end LCD;

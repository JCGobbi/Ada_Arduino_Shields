with Ada.Real_Time; use Ada.Real_Time;
with Interfaces;
with Ada.Unchecked_Conversion;

package LCD is

   pragma Elaborate_Body;

   type Byte is new Interfaces.Unsigned_8;   -- for shift/rotate
   type Bits is array (Natural range <>) of Boolean with Pack;
   subtype Bits_8 is Bits (0 .. 7);

   function B8_From_B is
     new Ada.Unchecked_Conversion (Source => Byte,
                                   Target => Bits_8);

   DISP_INIT   : Constant Byte := 16#30#; -- 8 bits, 1 line, 5x8 font
   DISP_4BITS  : Constant Byte := 16#20#; -- 4 bits, 1 line, 5x8 font
   DISP_ON     : Constant Byte := 16#0F#; -- Display on, cursor on, blink on
   DISP_OFF    : Constant Byte := 16#08#; -- Display off
   DISP_CLR    : Constant Byte := 16#01#; -- Clear display
   DISP_EMS    : Constant Byte := 16#06#; -- Entry mode set with increment
   DISP_CONFIG : Constant Byte := 16#28#; -- 4 bits, 2 lines, 5x8 font

   DD_RAM_ADDR  : constant Byte := 16#00#; -- Displays with 1 lines
   DD_RAM_ADDR2 : constant Byte := 16#40#; -- Displays with 2 lines
--   DD_RAM_ADDR3 : constant Byte := 16#14#; -- Displays with 3 lines
--   DD_RAM_ADDR4 : constant Byte := 16#54#; -- Displays with 4 lines

   LCD_DATA_XOR : constant Byte := 16#F0#; -- inverts LO-going D4..D7

   procedure Wait_Until (S : Time_Span);
   procedure LCD_Lo (Mask : Byte) with Inline;
   procedure LCD_Hi (Mask : Byte) with Inline;
   procedure LCD_strobe;
   procedure LCD_Write_4x2Bits(C : Character);
   procedure LCD_Write_4x2Bits(D : Byte);
   procedure LCD_Write_4x1Bits(D : Byte);
   procedure LCD_Cmd(Cmd : Byte);
   procedure LCD_Init;
   procedure LCD_Clear;
   procedure LCD_Goto (X : Byte; Y : Byte);
   procedure LCD_Put_Char (C : Character);
   procedure LCD_Put_String (S : String);
   procedure LCD_Put_String (X : Byte; Y : Byte; S : String);
   procedure Print_Hexa;

end LCD;

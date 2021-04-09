with Ada.Unchecked_Conversion;
with Interfaces;

package Seven_Seg is

   type Bits is array (Natural range <>) of Boolean with Pack;
   subtype Bits_8 is Bits (0 .. 7);
   type Byte is new Interfaces.Unsigned_8;   -- for shift/rotate

   function B_From_B8 is
     new Ada.Unchecked_Conversion (Source => Bits_8,
                                   Target => Byte);

   function B8_From_B is
     new Ada.Unchecked_Conversion (Source => Byte,
                                   Target => Bits_8);

   -- The 7-segment refresh of four digits maintains the last digit bright
   -- between each refresh, so with five counts the last one is out of display
   -- and the bright of the four digits is equal.
   type DIGIT is mod 5;               -- four digits + one no-digit

   Blank : constant := 10;            -- next one after digit 9
   type SEG_INDEX is range 0..Blank;  -- digits 0..9 and Blank
   for SEG_INDEX'Size use 8;          -- represent as a byte

   type UPDATE_RATE is range 1..100;  -- display updates/sec
   Per_Sec   : UPDATE_RATE := 100;
   type DISP_VAL is mod 10_000;       -- all >0 values that fit into 4 digits

   procedure Set_Value (Value : DISP_VAL; Blank_LZ : Boolean);
   procedure SRCLK_Strobe;
   procedure RCLK_Strobe;
   procedure Put_Digit (Digit_Value : SEG_INDEX; Digit_Number : DIGIT);
   procedure Put_Number;
   procedure Display_Number (Value : DISP_VAL; Blank_LZ : Boolean);
   procedure Clear_Display;

end Seven_Seg;

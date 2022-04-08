with STM32.GPIO;          use STM32.GPIO;
with Multifunction_Shield; use Multifunction_Shield;

package body Seven_Seg is

   Digit_Byte : constant array (DIGIT) of Byte := (16#01#, 16#02#, 16#04#, 16#08#, 16#00#);
   --  The 4 digit enable bits, in the same order as Digit_Vals below.

   Digit_Vals  : array (DIGIT) of SEG_INDEX := (others => SEG_INDEX'Last);
   --  The 4 digits to be displayed.  These are indexes into array Segs below.

   Segments  : constant array (SEG_INDEX) of Byte := (16#3F#, 16#06#, 16#5B#, 16#4F#, 16#66#,
                                                      16#6D#, 16#7D#, 16#07#, 16#7F#, 16#6F#,
                                                      16#00#);
   --  Segment patterns for 0 to 9 and Blank (Segment A is LSB).

   ----------------
   -- Wait_Until --
   ----------------

   procedure Wait_Until (S : Time_Span) is
      T : constant Time := Clock + S;
   begin
      while Clock < T loop
         null;
      end loop;
   end Wait_Until;

   ---------------
   -- Set_Value --
   ---------------

   procedure Set_Value (Value : DISP_VAL; Blank_LZ : Boolean) is
      Val       : Natural;
      Digit_Val : Natural;
      Digit     : Natural;
      BLZ       : Boolean := Blank_LZ;
   begin
      Val := Natural (Value);
      Digit_Val := Val / 1000;
      if (Digit_Val = 0) and BLZ then
         Digit := Blank;
      else
         Digit := Digit_Val;
         BLZ := False;
      end if;
      Digit_Vals (0) := SEG_INDEX (Digit);

      Val := Val mod 1000;
      Digit_Val := Val / 100;
      if (Digit_Val = 0) and BLZ
      then
         Digit := Blank;
      else
         Digit := Digit_Val;
         BLZ := False;
      end if;
      Digit_Vals (1) := SEG_INDEX (Digit);

      Val := Val mod 100;
      Digit_Val := Val / 10;
      if (Digit_Val = 0) and BLZ
      then
         Digit := Blank;
      else
         Digit := Digit_Val;
      end if;
      Digit_Vals (2) := SEG_INDEX (Digit);

      Val := Val mod 10;
      Digit := Val;
      Digit_Vals (3) := SEG_INDEX (Digit);
   end Set_Value;

   ------------------
   -- SRCLK_Strobe --
   ------------------

   --  Shift register clock on rising edge for 74HC595
   procedure SRCLK_Strobe is
   begin
      SS_SRCLK.Set;
      Wait_Until (Nanoseconds (200));
      SS_SRCLK.Clear;
   end SRCLK_Strobe;

   -----------------
   -- RCLK_Strobe --
   -----------------

   --  Storage register clock on rising edge for 74HC595
   procedure RCLK_Strobe is
   begin
      SS_RCLK.Set;
      Wait_Until (Nanoseconds (200));
      SS_RCLK.Clear;
   end RCLK_Strobe;

   ---------------
   -- Put_Digit --
   ---------------

   --  Two shift registers with data and address
   procedure Put_Digit (Digit_Value : SEG_INDEX; Digit_Number : DIGIT) is
      Segment : constant Bits_8 := B8_From_B (Segments (Digit_Value));
      Digit   : constant Bits_8 := B8_From_B (Digit_Byte (Digit_Number));
   begin
      --  8 bit data for each 7-segment + dot
      for I in reverse 0 .. 7 loop -- Last bit first
         Drive (SS_SER, Condition => not Segment (I)); -- Commom Anode 7-segments
         SRCLK_Strobe;
      end loop;
      --  8 bit address for each digit
      for I in reverse 0 .. 7 loop -- Last bit first
         Drive (SS_SER, Condition => Digit (I)); -- Address of four digits
         SRCLK_Strobe;
      end loop;
      RCLK_Strobe;
   end Put_Digit;

   ----------------
   -- Put_Number --
   ----------------

   procedure Put_Number is
   begin
      for I in DIGIT'Range loop
         Put_Digit (Digit_Vals (I), I); -- Value and position of digit
      end loop;
   end Put_Number;

   --------------------
   -- Display_Number --
   --------------------

   procedure Display_Number (Value : DISP_VAL; Blank_LZ : Boolean) is
   begin
      Set_Value (Value, Blank_LZ);
      Put_Number;
   end Display_Number;

   -------------------
   -- Clear_Display --
   -------------------

   procedure Clear_Display is
   begin
      Set_Value (0, True);
      Put_Number;
   end Clear_Display;

end Seven_Seg;

with STM32.ADC;        use STM32.ADC;

with LCD_Keypad_Shield; use LCD_Keypad_Shield;

package body Keypad is

   --------------
   -- Positive --
   --------------

   function Positive (A : UInt32) return UInt32 is
   begin
      if A > 0 then
         return A;
      else
         return 0;
      end if;
   end Positive;

   -----------------------
   -- Keypad_ADC_Update --
   -----------------------

   procedure Keypad_ADC_Update is
      Successful : Boolean;
   begin
      --  Get Keypad voltage between 0 - 500 Volts, within 0 (minimum) to 4095 (maximum)
      Start_Conversion (Keypad_ADC);
      Poll_For_Status (Keypad_ADC, Regular_Channel_Conversion_Complete, Successful);

      if not Successful then
         null;
      else
         Volts := Voltage (Positive (UInt32 (Conversion_Value (Keypad_ADC)) * 500 / 4095)); -- update voltage
      end if;
   end Keypad_ADC_Update;

   --------------------
   -- Keypad_ADC_Sel --
   --------------------

   procedure Keypad_ADC_Sel is
      --  The five keys are selected by an analog voltage.
      --  The exact voltages are given below with descending order:
      --  5 V   : No switch pressed
      --  3.62 V: Select switch
      --  2.47 V: Left switch
      --  1.61 V: Down switch
      --  0.71 V: Up switch
      --  0.0 V : Right switch

   begin
      case Volts is
         when 0 .. 35 => -- 0 .. 0.35 V := Right switch
            Key := "Right ";
            X_Pos := X_Pos  + 1;
            if X_Pos > 15 then
               X_Pos := 0;
            end if;
         when 36 .. 116 => -- 0.36 .. 1.16 V := Up switch
            Key := "Up    ";
            Y_Pos := Y_Pos  + 1;
            if Y_Pos > 1 then
               Y_Pos := 0;
            end if;
         when 117 .. 204 => -- 1.17 .. 2.04 V := Down switch
            Key := "Down  ";
            Y_Pos := Y_Pos  - 1;
            if Y_Pos < 0 then
               Y_Pos := 0;
            end if;
         when 205 .. 304 => -- 2.05 .. 3.04 V := Left switch
            Key := "Left  ";
            X_Pos := X_Pos  - 1;
            if X_Pos < 0 then
               X_Pos := 0;
            end if;
         when 305 .. 431 => -- 3.05 .. 4.31 V := Select switch
            Key := "Select";
         when 432 .. 500 => -- 4.32 .. 5.00 V := No switch
            Key := "No key";
         when others =>
            Key := "None  ";
      end case;
   end Keypad_ADC_Sel;

end Keypad;

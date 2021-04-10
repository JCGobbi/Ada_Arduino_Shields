with STM32.ADC;        use STM32.ADC;
with Multifunction_Shield; use Multifunction_Shield;

package body Potentiometer is

   --------------
   -- Positive --
   --------------

   function Positive (Pos : UInt32) return Uint32 is
   begin
      if Pos > 0 then
         return Pos;
      else
         return 0;
      end if;
   end Positive;

   ----------------
   -- Pot_Update --
   ----------------

   procedure Pot_Update is
      Successful : Boolean;
   begin
      -- Get potentiometer voltage in percent of the maximum: within 0 (minimum) to 4095 (maximum)
      Start_Conversion (Pot_ADC);
      Poll_For_Status (Pot_ADC, Regular_Channel_Conversion_Complete, Successful);

      if not Successful then
         null;
      else
         Volts := Voltage(Positive(UInt32(Conversion_Value (Pot_ADC)) * 100 / 4095)); -- update voltage
      end if;
   end Pot_Update;

end Potentiometer;

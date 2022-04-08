with HAL;          use HAL;

package Keypad is

   type Voltage is new Natural;
   Volts : Voltage := 0;

   Key : String (1 .. 6) := "------";

   X_Pos : Integer := 0;
   Y_Pos : Integer := 0;

   function Positive (A : UInt32) return UInt32;
   procedure Keypad_ADC_Update;
   procedure Keypad_ADC_Sel;

end Keypad;

with HAL;          use HAL;

Package KeyPad is

   type Voltage is new Natural;
   Volts : Voltage := 0;

   Key : String (1 .. 6) := "------";

   X_Pos : Integer := 0;
   Y_Pos : Integer := 0;

   function Positive (A : UInt32) return Uint32;
   Procedure Keypad_ADC_Update;
   Procedure Keypad_ADC_Sel;

end KeyPad;

with HAL;          use HAL;

Package Potentiometer is

   type Voltage is new Natural;
   Volts : Voltage := 0;

   function Positive (Pos : UInt32) return Uint32;
   Procedure Pot_Update;

end Potentiometer;

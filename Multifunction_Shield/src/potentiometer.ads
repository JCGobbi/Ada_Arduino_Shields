with HAL;          use HAL;

package Potentiometer is

   type Voltage is new Natural;
   Volts : Voltage := 0;

   function Positive (Pos : UInt32) return UInt32;
   procedure Pot_Update;

end Potentiometer;

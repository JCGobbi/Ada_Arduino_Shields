with Ada.Real_Time;        use Ada.Real_Time;
with STM32.GPIO;           use STM32.GPIO;
with System;

with Multifunction_Shield; use Multifunction_Shield;
with Seven_Seg;            use Seven_Seg;
with Button;               use Button;
with Potentiometer;        use Potentiometer;

procedure Multifunction_Demo is
   DN : constant DISP_VAL := 0567;
   pragma Priority (System.Priority'First);
begin
   LED_Init_Bus;
   Buzzer_Init_Bus;
   Button_Init_Bus;
   SevenSeg_Init_Bus;
   Clear_Display;
   Pot_Init_Bus;

   for I in LED_Points'Range loop
      Led_Set (LED_Points(I));
      delay until Clock + Milliseconds(1000);
      Led_Clear (LED_Points(I));
      delay until Clock + Milliseconds(1000);
   end loop;

   for I in 1 ..3 loop
      Buzzer_Set (Buz_Point);
      delay until Clock + Milliseconds(500);
      Buzzer_Clear (Buz_Point);
      delay until Clock + Milliseconds(500);
   end loop;

   for I in 1 .. 4000 loop
      Display_Number (DN, False);
      delay until Clock + Microseconds(250);
   end loop;

   loop
      Pot_Update;
      if (X_Pressed) then
         Display_Number (DISP_VAL(Volts + 1000), True);
      elsif (not SW2.Set) then
         Display_Number (DISP_VAL(Volts + 2000), True);
         Y_Pressed := False;
      elsif (not SW3.Set) then
         Display_Number (DISP_VAL(Volts + 3000), True);
         Z_Pressed := False;
      else
         Display_Number (DISP_VAL(Volts), True);
      end if;

      delay until Clock + Microseconds(250); -- refresh rate of display
   end loop;

end Multifunction_Demo;

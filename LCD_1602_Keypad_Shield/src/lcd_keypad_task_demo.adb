with Ada.Real_Time; use Ada.Real_Time;

with LCD;           use LCD;
with Keypad;        use Keypad;
with LCD_Keypad_Task; pragma Unreferenced (LCD_Keypad_Task);

procedure LCD_Keypad_Task_Demo is
begin
   loop
      Keypad_ADC_Update;
      Keypad_ADC_Sel;
      LCD_Goto(0, 1);
      LCD_Put_String(Key);
      delay until Clock + Milliseconds (200); -- slow it down to ease reading
      --null;
      --delay until Ada.Real_Time.Time_Last;
   end loop;
end LCD_Keypad_Task_Demo;

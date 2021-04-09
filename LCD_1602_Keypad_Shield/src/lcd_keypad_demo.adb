with Ada.Real_Time;     use Ada.Real_Time;

with LCD_Keypad_Shield; use LCD_Keypad_Shield;
with LCD;               use LCD;
with Keypad;            use Keypad;

procedure LCD_Keypad_Demo is

begin
   LCD_Init_Bus;
   LCD_Init;
   Keypad_Init_Bus;
   LCD_Put_Char('A');
   LCD_Goto(5, 1);
   LCD_Put_String("Hello World!");
   Wait_Until(Seconds(3));
   LCD_Clear;
   Print_Hexa;
   Wait_Until(Seconds(3));
   LCD_Clear;
   LCD_Goto (0, 0);
   LCD_Put_String("Press a key:");
   loop
      Keypad_ADC_Update;
      Keypad_ADC_Sel;
      LCD_Goto(0, 1);
      LCD_Put_String(Key);
      delay until Clock + Milliseconds (200); -- slow it down to ease reading
   end loop;

end LCD_Keypad_Demo;

with Ada.Real_Time;     use Ada.Real_Time;

with LCD_Keypad_Shield; use LCD_Keypad_Shield;
with LCD;               use LCD;
--  with Keypad;            use Keypad;

package body LCD_Keypad_Task is

   task body LCD_Keypad_Controller is

   begin
      LCD_Put_Char ('A');
      LCD_Goto (5, 1);
      LCD_Put_String ("Hello World!");
      Wait_Until (Seconds (3));
      LCD_Clear;
      Print_Hexa;
      Wait_Until (Seconds (3));
      LCD_Clear;
      LCD_Goto (0, 0);
      LCD_Put_String ("Press a key:");
      --  The Keypad_ADC_Update procedure don't execute inside this task, so this
      --  loop was put inside the LCD_Keypad_Task_Demo procedure.
      --  loop
      --     Keypad_ADC_Update;
      --     Keypad_ADC_Sel;
      --     LCD_Goto (0, 1);
      --     LCD_Put_String (Key);
      --     delay until Clock + Milliseconds (200); -- slow it down to ease reading
      --  end loop;
   end LCD_Keypad_Controller;

begin
   --  Initialization code for the LCD_Keypad_Task package.
   --  This will be executed before the tasks are run.
   LCD_Init_Bus;
   LCD_Init;
   Keypad_Init_Bus;

end LCD_Keypad_Task;

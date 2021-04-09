with STM32.GPIO; use STM32.GPIO;

package LED_Buzzer is

   procedure Led_Set (This : in out GPIO_Point) renames STM32.GPIO.Clear;
   -- GPIO = 0 => LED ON, GPIO = 1 => LED OFF.

   Procedure Led_Clear (This : in out GPIO_Point) renames STM32.GPIO.Set;
   -- GPIO = 0 => LED ON, GPIO = 1 => LED OFF.

   procedure Buzzer_Set (This : in out GPIO_Point) renames STM32.GPIO.Clear;
   -- GPIO = 0 => buzzer ON, GPIO = 1 => buzzer OFF.

   Procedure Buzzer_Clear (This : in out GPIO_Point) renames STM32.GPIO.Set;
   -- GPIO = 0 => buzzer ON, GPIO = 1 => buzzer OFF.

end LED_Buzzer;

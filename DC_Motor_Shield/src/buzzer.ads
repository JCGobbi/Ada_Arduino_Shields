with STM32.GPIO; use STM32.GPIO;

package Buzzer is

   procedure Buzzer_Set (Buz : in out GPIO_Point);
   Procedure Buzzer_Clear (Buz : in out GPIO_Point);

end Buzzer;

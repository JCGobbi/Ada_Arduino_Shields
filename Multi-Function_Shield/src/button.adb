with STM32.EXTI; use STM32.EXTI;

package body Button is

   Debounce_Time : constant Time_Span := Milliseconds (300);

   protected body Button_Int is

      ------------------------------
      -- Button_Interrupt_Handler --
      ------------------------------

      procedure Button_Interrupt_Handler is
         Now : constant Time := Clock;
      begin
         --  Clear the raised interrupt by writing "Occurred" to the correct
         --  position in the EXTI Pending Register.
         if External_Interrupt_Pending (SW1_EXTI_Line) then
            Clear_External_Interrupt (SW1_EXTI_Line);
         end if;
         if External_Interrupt_Pending (SW1_EXTI_Line) then
            Clear_External_Interrupt (SW2_EXTI_Line);
         end if;
         if External_Interrupt_Pending (SW1_EXTI_Line) then
            Clear_External_Interrupt (SW3_EXTI_Line);
         end if;

         -- Debouncing. Key pressed => GPIO = 0; not pressed => GPIO = 1.
         if Now - Last_Time >= Debounce_Time then

            if not SW1.Set then
               -- Put here your code for SW1 pressed
               X_Pressed := not X_Pressed;
            end if;

            if not SW2.Set then
               -- Put here your code for SW2 pressed
               Y_Pressed := True;
            end if;

            if not SW3.Set then --ok
               -- Put here your code for SW3 pressed
               Z_Pressed := True;
            end if;
            Last_Time := Now;
         end if;

      end Button_Interrupt_Handler;

   end Button_Int;

end Button;

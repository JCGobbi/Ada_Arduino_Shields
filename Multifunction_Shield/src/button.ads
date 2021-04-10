with Ada.Real_Time;        use Ada.Real_Time;

with Multifunction_Shield; use Multifunction_Shield;

package Button is

   X_Pressed : Boolean := False;
   Y_Pressed : Boolean := False;
   Z_Pressed : Boolean := False;

   protected Button_Int is
      pragma Interrupt_Priority;

   private
      procedure Button_Interrupt_Handler with
        Attach_Handler => SW1_Interrupt;
      --  The handler for the interrupt generated when the User Button 1 is pressed.

      Last_Time : Time := Clock;
   end Button_Int;

end Button;

with STM32.GPIO;        use STM32.GPIO;
with Ada.Real_Time;     use Ada.Real_Time;

with Four_Relay_Shield; use Four_Relay_Shield;

package body Four_Relay_Task is

   ----------------------
   -- Relay_Controller --
   ----------------------

   task body Relay_Controller is
   begin
      for I in 1 .. 3 loop
         for J in Relay_Points'Range loop
            Relay_Set (Relay_Points(J));
            delay until Clock + Milliseconds(1000);
            Relay_Clear (Relay_Points(J));
            delay until Clock + Milliseconds(1000);
         end loop;
         delay until Clock + Milliseconds(3000);
      end loop;

   end Relay_Controller;

begin
   --  Initialization code for the Four_Relay_Task package.
   --  This will be executed before the tasks are run.
   Relay_Init_Bus;

end Four_Relay_Task;

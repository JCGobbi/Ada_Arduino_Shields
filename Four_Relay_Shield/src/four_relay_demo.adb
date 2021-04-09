with STM32.GPIO;        use STM32.GPIO;
with Ada.Real_Time;     use Ada.Real_Time;

with Four_Relay_Shield; use Four_Relay_Shield;

procedure Four_Relay_Demo is
begin
   Relay_Init_Bus;

   for I in 1 .. 3 loop
      for J in Relay_Points'Range loop
         Relay_Set (Relay_Points(J));
         delay until Clock + Milliseconds(1000);
         Relay_Clear (Relay_Points(J));
         delay until Clock + Milliseconds(1000);
      end loop;
      delay until Clock + Milliseconds(3000);
   end loop;

   loop
      delay until Ada.Real_Time.Time_Last;
   end loop;

end Four_Relay_Demo;

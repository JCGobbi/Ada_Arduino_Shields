with Four_Relay_Task; pragma Unreferenced (Four_Relay_Task);

with Ada.Real_Time;

procedure Four_Relay_Task_Demo is
begin
   loop
      delay until Ada.Real_Time.Time_Last;
   end loop;
end Four_Relay_Task_Demo;

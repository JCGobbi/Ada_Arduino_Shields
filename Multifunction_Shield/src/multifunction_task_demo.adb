with Ada.Real_Time;        use Ada.Real_Time;

with Multifunction_Task; pragma Unreferenced (Multifunction_Task);

procedure Multifunction_Task_Demo is
begin
   loop
      delay until Ada.Real_Time.Time_Last;
   end loop;
end Multifunction_Task_Demo;

with DC_Motor_Task; pragma Unreferenced (DC_Motor_Task);

with Ada.Real_Time;

procedure DC_Motor_Task_Demo is
begin
   loop
      --  null;
      delay until Ada.Real_Time.Time_Last;
   end loop;
end DC_Motor_Task_Demo;

with Ada.Real_Time;   use Ada.Real_Time;

with DC_Motor;        use DC_Motor;

package DC_Motor_Task is

   function Encoder_Delta (This : Basic_Motor;  Sample_Interval : Time_Span)
      return Motor_Encoder_Counts;
   --  Returns the encoder count delta for This motor over the Sample_Interval
   --  time. Delays the caller for the Interval since it waits that amount of
   --  time between taking the two samples used to calculate the delta.

   procedure Panic with No_Return;
   --  Flash the LEDs to indicate disaster, forever.

   procedure All_Stop (This : in out Basic_Motor);
   --  Powers down This motor and waits for rotations to cease by polling the
   --  motor's encoder.

   procedure Motor_Cycle (Driven_Motor : out Basic_Motor; Direction : Directions);
   -- Cycle between forward and backward directions varying speed between
   -- 0 and 100%.

   task DC_Motor_Controller;

end DC_Motor_Task;

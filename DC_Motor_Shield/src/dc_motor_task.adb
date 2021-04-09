with STM32.Board;     use STM32.Board;

with DC_Motor_Shield; use DC_Motor_Shield;

package body DC_Motor_Task is

   Throttle_Setting : DC_Motor.Power_Level := 0;
   --  Power setting for controlling motor speed

   Encoder_Sampling_Interval : constant Time_Span := Seconds (1);
   --  Sampling interval for computing encoder counts per second. You can
   --  change this but will then need to compute the rate per second.

   --  These subtypes represent categories of rotation rates. The ranges are
   --  dependent on both the battery level and the motor.
   subtype Stopped  is Motor_Encoder_Counts range 0 .. 0;
   subtype Slow     is Motor_Encoder_Counts range Stopped'Last + 1 .. 600;
   subtype Cruising is Motor_Encoder_Counts range Slow'Last + 1 .. 1400;
   subtype Fast     is Motor_Encoder_Counts range Cruising'Last + 1 .. 1600;
   subtype Redline  is Motor_Encoder_Counts range Fast'Last + 1 .. 10_000;

   -----------
   -- Panic --
   -----------

   procedure Panic is
   begin
      loop
         --  When in danger, or in doubt, run in circles, scream and shout.
         All_LEDs_Off;
         delay until Clock + Milliseconds (250); -- arbitrary
         All_LEDs_On;
         delay until Clock + Milliseconds (250); -- arbitrary
      end loop;
   end Panic;

   -------------------
   -- Encoder_Delta --
   -------------------

   function Encoder_Delta (This : Basic_Motor; Sample_Interval : Time_Span)
      return Motor_Encoder_Counts
   is
      Start_Sample, Stop_Sample : Motor_Encoder_Counts;
   begin
      Start_Sample := This.Encoder_Count;
      delay until Clock + Sample_Interval;
      Stop_Sample := This.Encoder_Count;
      return abs (Stop_Sample - Start_Sample);  -- they can rotate backwards...
   end Encoder_Delta;

   --------------
   -- All_Stop --
   --------------

   procedure All_Stop (This : in out Basic_Motor) is
      Stopping_Time : constant Time_Span := Milliseconds (50);  -- WAG
   begin
      This.Coast;
      --This.Stop;
      loop
         exit when Encoder_Delta (This, Sample_Interval => Stopping_Time) = 0;
      end loop;
   end All_Stop;

   -----------------
   -- Motor_Cycle --
   -----------------

   procedure Motor_Cycle (Driven_Motor : out Basic_Motor; Direction : Directions) is
      Dir_Motor : Directions := Direction;
   begin
      for i in 1 .. 2 loop
         for j in 1 .. 5 loop
            Throttle_Setting := (if Throttle_Setting = 100 then 0 else Throttle_Setting + 25);

            if Throttle_Setting = 0 then
               All_Stop (Driven_Motor);
            else
               Driven_Motor.Engage (Dir_Motor, Power => Throttle_Setting);
            end if;

            --  note that the following function call delays for the Sample_Interval
            case Encoder_Delta (Driven_Motor, Sample_Interval => Encoder_Sampling_Interval) is
               when Stopped  => All_LEDs_Off;
               --when Slow     => Blue_LED.Set;
               when Cruising => Green_LED.Set;
               --when Fast     => Orange_LED.Set;
               when Redline  => Red_LED.Set;
               when others   => Panic;
            end case;
            delay until Clock + Milliseconds(1000);
         end loop;
         Dir_Motor := (if Dir_Motor = Forward then Backward else Forward);
         Throttle_Setting := 0;
      end loop;
   end Motor_Cycle;

   -------------------------
   -- DC_Motor_Controller --
   -------------------------

   task body DC_Motor_Controller is
   begin
      loop
         Motor_Cycle (Engine_Motor, Forward);
         Motor_Cycle (Steering_Motor, Forward);
      end loop;
   end DC_Motor_Controller;

begin
   --  Initialization code for the DC_Motor_Task package.
   --  This will be executed before the tasks are run.
   Initialize_Motor_Shield (Steering_Motor, Engine_Motor);
   STM32.Board.Initialize_LEDs;
   STM32.Board.All_LEDs_Off;

   Buzzer_Init_Bus;
   for i in 1 ..3 loop
      Buzzer_Set (Buz_Point);
      delay until Clock + Milliseconds(500);
      Buzzer_Clear (Buz_Point);
      delay until Clock + Milliseconds(500);
   end loop;

end DC_Motor_Task;

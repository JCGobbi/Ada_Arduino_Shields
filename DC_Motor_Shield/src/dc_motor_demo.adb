with Ada.Real_Time;   use Ada.Real_Time;

with DC_Motor;        use DC_Motor;
with DC_Motor_Shield; use DC_Motor_Shield;

procedure DC_Motor_Demo is

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
   --  Cycle between forward and backward directions varying speed between
   --  0 and 100%.

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
      Start_Sample, End_Sample : Motor_Encoder_Counts;
   begin
      Start_Sample := This.Encoder_Count;
      delay until Clock + Sample_Interval;
      End_Sample := This.Encoder_Count;
      return abs (End_Sample - Start_Sample);  -- they can rotate backwards...
   end Encoder_Delta;

   --------------
   -- All_Stop --
   --------------

   procedure All_Stop (This : in out Basic_Motor) is
      Stopping_Time : constant Time_Span := Milliseconds (50);  -- WAG
   begin
      This.Coast;
      --  This.Stop;
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
               when Slow     => Blue_LED.Set;
               when Cruising => Green_LED.Set;
               --  when Fast     => Orange_LED.Set;
               when Redline  => Red_LED.Set;
               when others   => Panic;
            end case;
            delay until Clock + Milliseconds (1000);
         end loop;
         Dir_Motor := (if Dir_Motor = Forward then Backward else Forward);
         Throttle_Setting := 0;
      end loop;
   end Motor_Cycle;

begin
   Initialize_Motor_Shield (Steering_Motor, Engine_Motor);
   Initialize_LEDs;
   All_LEDs_Off;

   Buzzer_Init_Bus;
   for i in 1 .. 3 loop
      Buzzer_Set (Buz_Point);
      delay until Clock + Milliseconds (500);
      Buzzer_Clear (Buz_Point);
      delay until Clock + Milliseconds (500);
   end loop;

   loop
      Motor_Cycle (Engine_Motor, Forward);
      Motor_Cycle (Steering_Motor, Forward);
   end loop;

end DC_Motor_Demo;

with Ada.Unchecked_Conversion;
with STM32.Device; use STM32.Device;

package body DC_Motor is

   procedure Configure_Polarity_Control (This : GPIO_Point);
   --  Configures the GPIO port/pin pair as a discrete output to the motor
   --  Shield. These outputs control the polarity of the power provided to the
   --  motors, thereby controlling their direction, as well as whether they
   --  coast to a stop or come to an immediate halt.

   --------------
   -- Throttle --
   --------------

   function Throttle (This : Basic_Motor) return Power_Level is
   begin
      return This.Power_Plant.Current_Duty_Cycle;
   end Throttle;

   ------------
   -- Engage --
   ------------

   procedure Engage
     (This      : in out Basic_Motor;
      Direction : Directions;
      Power     : Power_Level)
   is
   begin
      case Direction is
         when Forward  =>
            Set (This.H_Bridge_1);
            Clear (This.H_Bridge_2);
         when Backward =>
            Clear (This.H_Bridge_1);
            Set (This.H_Bridge_2);
      end case;
      This.Power_Plant.Set_Duty_Cycle (Power);
   end Engage;

   ----------
   -- Stop --
   ----------

   procedure Stop (This : in out Basic_Motor) is
   begin
      Set (This.H_Bridge_1);
      Set (This.H_Bridge_2);
      This.Power_Plant.Set_Duty_Cycle (100);  -- full power to lock position
   end Stop;

   -----------
   -- Coast --
   -----------

   procedure Coast (This : in out Basic_Motor) is
   begin
      This.Power_Plant.Set_Duty_Cycle (0);  -- do not lock position
   end Coast;

   ------------------------
   -- Rotation_Direction --
   ------------------------

   function Rotation_Direction (This : Basic_Motor) return Directions is
   begin
      case Current_Direction (This.Encoder) is
         when Up   => return Forward;
         when Down => return Backward;
      end case;
   end Rotation_Direction;

   -------------------------
   -- Reset_Encoder_Count --
   -------------------------

   procedure Reset_Encoder_Count (This : in out Basic_Motor) is
   begin
      Reset_Count (This.Encoder);
   end Reset_Encoder_Count;

   -------------------
   -- Encoder_Count --
   -------------------

   function Encoder_Count (This : Basic_Motor) return Motor_Encoder_Counts is
      function As_Motor_Encoder_Counts is new Ada.Unchecked_Conversion
        (Source => UInt32, Target => Motor_Encoder_Counts);
   begin
      return As_Motor_Encoder_Counts (Current_Count (This.Encoder));
   end Encoder_Count;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (This                 : in out Basic_Motor;
      --  motor encoder I/O
      Encoder_Input1       : GPIO_Point;
      Encoder_Input2       : GPIO_Point;
      Encoder_Timer        : not null access Timer;
      Encoder_AF           : GPIO_Alternate_Function;
      --  motor power control
      PWM_Timer            : not null access Timer;
      PWM_Output_Frequency : UInt32; -- in Hertz
      PWM_AF               : GPIO_Alternate_Function;
      PWM_Output           : GPIO_Point;
      PWM_Output_Channel   : Timer_Channel;
      --  discrete outputs to NXT Shield that control motor direction
      Polarity1            : GPIO_Point;
      Polarity2            : GPIO_Point)
   is
   begin
      --  First set up the PWM for the motors' power control.
      --  We do this configuration here because we are not sharing the timer
      --  across other PWM generation clients
      Configure_PWM_Timer (PWM_Timer, PWM_Output_Frequency);

      This.Power_Plant.Attach_PWM_Channel
        (PWM_Timer,
         PWM_Output_Channel,
         PWM_Output,
         PWM_AF);

      This.Power_Plant.Enable_Output;

      This.Power_Channel := PWM_Output_Channel;

      --  Now set up the motor encoders

      Initialize_Encoder
        (This.Encoder,
         Encoder_Input1,
         Encoder_Input2,
         Encoder_Timer,
         Encoder_AF);

      Reset_Count (This.Encoder);

      --  Finally, configure the output points for controlling the H-Bridge
      --  circuits that control the rotation direction as well as stopping
      --  the rotation entirely (via procedure Stop)

      This.H_Bridge_1 := Polarity1;
      This.H_Bridge_2 := Polarity2;

      Enable_Clock (This.H_Bridge_1);
      Enable_Clock (This.H_Bridge_2);

      Configure_Polarity_Control (This.H_Bridge_1);
      Configure_Polarity_Control (This.H_Bridge_2);
   end Initialize;

   --------------------------------
   -- Configure_Polarity_Control --
   --------------------------------

   procedure Configure_Polarity_Control (This : GPIO_Point) is
      Configuration : GPIO_Port_Configuration;
   begin
      Configuration := (Mode        => Mode_Out,
                        Output_Type => Push_Pull,
                        Resistors   => Pull_Down,
                        Speed       => Speed_100MHz);

      This.Configure_IO (Configuration);

      This.Lock;
   end Configure_Polarity_Control;

end DC_Motor;

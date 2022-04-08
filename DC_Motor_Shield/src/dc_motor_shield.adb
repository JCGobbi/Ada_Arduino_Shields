with HAL; use HAL;

package body DC_Motor_Shield is

   -----------------------------
   -- Initialize_Motor_Shield --
   -----------------------------

   procedure Initialize_Motor_Shield (Motor1, Motor2 : out Basic_Motor) is
   begin
      Motor1.Initialize
        (Encoder_Input1       => Motor1_Encoder_Input1,
         Encoder_Input2       => Motor1_Encoder_Input2,
         Encoder_Timer        => Motor1_Encoder_Timer,
         Encoder_AF           => Motor1_Encoder_AF,
         PWM_Timer            => Motor1_PWM_Timer,
         PWM_Output_Frequency => Motor_PWM_Frequency,
         PWM_AF               => Motor1_PWM_AF,
         PWM_Output           => Motor1_PWM_Output,
         PWM_Output_Channel   => Motor1_PWM_Output_Channel,
         Polarity1            => Motor1_Polarity1,
         Polarity2            => Motor1_Polarity2);

      Motor2.Initialize
        (Encoder_Input1       => Motor2_Encoder_Input1,
         Encoder_Input2       => Motor2_Encoder_Input2,
         Encoder_Timer        => Motor2_Encoder_Timer,
         Encoder_AF           => Motor2_Encoder_AF,
         PWM_Timer            => Motor2_PWM_Timer,
         PWM_Output_Frequency => Motor_PWM_Frequency,
         PWM_AF               => Motor2_PWM_AF,
         PWM_Output           => Motor2_PWM_Output,
         PWM_Output_Channel   => Motor2_PWM_Output_Channel,
         Polarity1            => Motor2_Polarity1,
         Polarity2            => Motor2_Polarity2);
   end Initialize_Motor_Shield;

   ---------------------
   -- Buzzer_Init_Bus --
   ---------------------

   procedure Buzzer_Init_Bus is
   begin
      Enable_Clock (Buz_Point);
      Configure_IO
        (Buz_Point,
         (Mode        => Mode_Out,
          Output_Type => Push_Pull,
          Speed       => Speed_100MHz,
          Resistors   => Floating));
      Set (Buz_Point); -- GPIO = 1 => buzzer OFF
   end Buzzer_Init_Bus;

   ---------------------
   -- Initialize_LEDs --
   ---------------------

   procedure Initialize_LEDs is
   begin
      Enable_Clock (All_LEDs);

      Configure_IO
        (All_LEDs,
         (Mode        => Mode_Out,
          Output_Type => Push_Pull,
          Speed       => Speed_100MHz,
          Resistors   => Floating));
   end Initialize_LEDs;

   ------------------
   -- All_LEDs_Off --
   ------------------

   procedure All_LEDs_Off is
   begin
      Clear (All_LEDs);
   end All_LEDs_Off;

   -----------------
   -- All_LEDs_On --
   -----------------

   procedure All_LEDs_On is
   begin
      Set (All_LEDs);
   end All_LEDs_On;

end DC_Motor_Shield;

package body LCD_Keypad_Shield is

   ------------------
   -- LCD_Init_Bus --
   ------------------

   procedure LCD_Init_Bus is
   begin
      Enable_Clock (LCD_Bus);
      Configure_IO
        (LCD_Bus,
         (Mode        => Mode_Out,
          Output_Type => Push_Pull,
          Speed       => Speed_100MHz,
          Resistors   => Floating));
   end LCD_Init_Bus;

   ---------------------
   -- Keypad_Init_Bus --
   ---------------------

   procedure Keypad_Init_Bus is
      All_Regular_Conversions : constant Regular_Channel_Conversions :=
                                  (1 => (Channel => Keypad_Channel, Sample_Time => Sample_144_Cycles));

   begin
      --  Configure analog input
      Enable_Clock (Keypad_Point);
      Configure_IO (Keypad_Point, (Mode => Mode_Analog, Resistors => Floating));

      Enable_Clock (Keypad_ADC);

      Reset_All_ADC_Units;

      Configure_Common_Properties
        (Mode           => Independent,
         Prescalar      => PCLK2_Div_2,
         DMA_Mode       => Disabled,
         Sampling_Delay => Sampling_Delay_5_Cycles);

      Configure_Unit
        (Keypad_ADC,
         Resolution => ADC_Resolution_12_Bits,
         Alignment  => Right_Aligned);

      Configure_Regular_Conversions
        (Keypad_ADC,
         Continuous  => False,
         Trigger     => Software_Triggered,
         Enable_EOC  => True,
         Conversions => All_Regular_Conversions);

      Enable (Keypad_ADC);
   end Keypad_Init_Bus;

end LCD_Keypad_Shield;

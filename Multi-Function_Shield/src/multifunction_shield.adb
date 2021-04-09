package body Multifunction_Shield is

   ------------------
   -- LED_Init_Bus --
   ------------------

   procedure LED_Init_Bus is
   begin
      Enable_Clock (LED_Points);
      Configure_IO
        (LED_Points,
         (Mode        => Mode_Out,
          Output_Type => Open_Drain,
          Speed       => Speed_100MHz,
          Resistors   => Floating));
      Set (LED_Points); -- GPIO = 1 => LED OFF
   end LED_Init_Bus;

   ---------------------
   -- Buzzer_Init_Bus --
   ---------------------

   procedure Buzzer_Init_Bus is
   begin
      Enable_Clock (Buz_Point);
      Configure_IO
        (Buz_Point,
         (Mode        => Mode_Out,
          Output_Type => Open_Drain,
          Speed       => Speed_100MHz,
          Resistors   => Floating));
      Set (Buz_Point); -- GPIO = 1 => buzzer OFF
   end Buzzer_Init_Bus;

   ---------------------
   -- Button_Init_Bus --
   ---------------------

   procedure Button_Init_Bus is
   begin
      Enable_Clock (SW_Points);
      Configure_IO
        (SW_Points,
         (Mode        => Mode_In,
          Resistors   => Floating)); -- The buttons have pull-up resistors
      --  Connect the button's pin to the External Interrupt Handler
      Configure_Trigger
        (SW_Points,
         Trigger => SW_Edge);
   end Button_Init_Bus;

   ------------------
   -- Pot_Init_Bus --
   ------------------

   procedure Pot_Init_Bus is
      All_Regular_Conversions : constant Regular_Channel_Conversions :=
                                  (1 => (Channel => Pot_Channel, Sample_Time => Sample_144_Cycles));

   begin
      Enable_Clock (Pot_Point);
      Configure_IO (Pot_Point, (Mode => Mode_Analog, Resistors => Floating));

      Enable_Clock (Pot_ADC);

      Reset_All_ADC_Units;

      Configure_Common_Properties
        (Mode           => Independent,
         Prescalar      => PCLK2_Div_2,
         DMA_Mode       => Disabled,
         Sampling_Delay => Sampling_Delay_5_Cycles);

      Configure_Unit
        (Pot_ADC,
         Resolution => ADC_Resolution_12_Bits,
         Alignment  => Right_Aligned);

      Configure_Regular_Conversions
        (Pot_ADC,
         Continuous  => False,
         Trigger     => Software_Triggered,
         Enable_EOC  => True,
         Conversions => All_Regular_Conversions);

      Enable (Pot_ADC);
   end Pot_Init_Bus;

   -----------------------
   -- SevenSeg_Init_Bus --
   -----------------------

   procedure SevenSeg_Init_Bus is
   begin
      Enable_Clock (SS_Points);
      Configure_IO
        (SS_Points,
         (Mode        => Mode_Out,
          Output_Type => Push_Pull,
          Speed       => Speed_100MHz,
          Resistors   => Floating));
   end SevenSeg_Init_Bus;

end Multifunction_Shield;

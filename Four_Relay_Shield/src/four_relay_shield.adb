package body Four_Relay_Shield is

   --------------------
   -- Relay Init_Bus --
   --------------------

   procedure Relay_Init_Bus is
   begin
      Enable_Clock (Relay_Points);
      Configure_IO
        (Relay_Points,
         (Mode        => Mode_Out,
          Output_Type => Push_Pull,
          Speed       => Speed_100MHz,
          Resistors   => Floating));
   end Relay_Init_Bus;

end Four_Relay_Shield;

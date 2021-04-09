package body Buzzer is

   ----------------
   -- Buzzer_Set --
   ----------------

   -- GPIO = 0 => buzzer OFF, GPIO = 1 => buzzer ON.
   Procedure Buzzer_Set (Buz : in out GPIO_Point) is
   begin
      Buz.Set;
   end Buzzer_Set;

   ------------------
   -- Buzzer_Clear --
   ------------------

   -- GPIO = 0 => buzzer OFF, GPIO = 1 => buzzer ON.
   Procedure Buzzer_Clear (Buz : in out GPIO_Point) is
   begin
      Buz.Clear;
   end Buzzer_Clear;

end Buzzer;

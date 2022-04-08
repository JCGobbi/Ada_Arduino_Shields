with STM32.Device;  use STM32.Device;
with STM32.GPIO;    use STM32.GPIO;

package Four_Relay_Shield is

   --------------------------
   -- Relay Configurations --
   --------------------------

   RL_4 : GPIO_Point renames PF14;
   --  PF14 corresponds to D4 of Arduino connector CN10 from Nucleo_F429ZI
   --  This pin corresponds to Relay 4 from Four Relay Shield
   RL_3 : GPIO_Point renames PE11;
   --  PE11 corresponds to D5 of Arduino connector CN10 from Nucleo_F429ZI
   --  This pin corresponds to Relay 3 from Four Relay Shield
   RL_2 : GPIO_Point renames PE9;
   --  PE9 corresponds to D6 of Arduino connector CN10 from Nucleo_F429ZI
   --  This pin corresponds to Relay 2 from Four Relay Shield
   RL_1 : GPIO_Point renames PF13;
   --  PF13 corresponds to D7 of Arduino connector CN10 from Nucleo_F429ZI
   --  This pin corresponds to Relay 1 from Four Relay Shield

   Relay_Points : GPIO_Points := RL_1 & RL_2 & RL_3 & RL_4;

   procedure Relay_Init_Bus;

   procedure Relay_Set (This : in out GPIO_Point) renames STM32.GPIO.Set;
   --  GPIO = 0 => relay OFF, GPIO = 1 => relay ON.

   procedure Relay_Clear (This : in out GPIO_Point) renames STM32.GPIO.Clear;
   --  GPIO = 0 => relay OFF, GPIO = 1 => relay ON.

   procedure Relay_Toggle (This : in out GPIO_Point) renames STM32.GPIO.Toggle;

end Four_Relay_Shield;

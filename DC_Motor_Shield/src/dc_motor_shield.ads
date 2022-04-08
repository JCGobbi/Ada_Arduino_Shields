--  The Fundumoto motor shield (Keyes)
--
--  Function                 Data Bit
--
--  Motor 1 PWM              D10
--  Motor 1 Direction        D12
--  Motor 2 PWM              D11
--  Motor 2 Direction        D13
--  Buzzer                   D4
--  Ping connector           +5 D8 D7 GND (+ R T G)
--  Servo connector          GND +5 D9 (G +5 9)
--  PIN 2 I/O connector      GND +5 D2 (G + S)
--  Digital connector        +5 D6 D5 GND D3 (+ B G - R)
--  BT2 connector            +5 GND D0 D1 (+ - T R) Bluetooth
--  Analog connectors        GND +5 A0-A5

with STM32;               use STM32;
with STM32.Device;        use STM32.Device;
with STM32.GPIO;          use STM32.GPIO;
with STM32.Timers;        use STM32.Timers;

with DC_Motor;            use DC_Motor;

package DC_Motor_Shield is

   ---------------------------
   -- Motors Configurations --
   ---------------------------

   --  The hardware on the STM32 board used by the two motors (on the
   --  NXT_Shield)

   Motor_PWM_Frequency : constant := 490;

   --  the steering motor (per vehicle.ads and actual wiring)

   Motor1_Encoder_Input1     : GPIO_Point renames PD15; -- D9 from Arduino shield
   Motor1_Encoder_Input2     : GPIO_Point renames PE11; -- D5 from Arduino shield (not used)
   Motor1_Encoder_Timer      : constant access Timer := Timer_2'Access;
   Motor1_Encoder_AF         : constant STM32.GPIO_Alternate_Function := GPIO_AF_TIM2_1;
   Motor1_PWM_Timer          : constant access Timer := Timer_4'Access;
   Motor1_PWM_AF             : constant STM32.GPIO_Alternate_Function := GPIO_AF_TIM4_2;
   Motor1_PWM_Output         : GPIO_Point renames PD14; -- D10 from Arduino shield
   Motor1_PWM_Output_Channel : constant Timer_Channel := Channel_3;
   Motor1_Polarity1          : GPIO_Point renames PA6; -- D12 from Arduino shield
   Motor1_Polarity2          : GPIO_Point renames PB9; -- D14 from Arduino shield (not used)

   --  the engine (per vehicle.ads and actual wiring)

   Motor2_Encoder_Input1     : GPIO_Point renames PF15; -- D2 from Arduino shield
   Motor2_Encoder_Input2     : GPIO_Point renames PE9; -- D6 from Arduino shield (not used)
   Motor2_Encoder_Timer      : constant access Timer := Timer_5'Access;
   Motor2_Encoder_AF         : constant STM32.GPIO_Alternate_Function := GPIO_AF_TIM5_2;
   Motor2_PWM_Timer          : constant access Timer := Timer_3'Access;
   Motor2_PWM_AF             : constant STM32.GPIO_Alternate_Function := GPIO_AF_TIM3_2;
   Motor2_PWM_Output         : GPIO_Point renames PA7; -- D11 from Arduino shield
   Motor2_PWM_Output_Channel : constant Timer_Channel := Channel_2;
   Motor2_Polarity1          : GPIO_Point renames PA5; -- D13 from Arduino shield
   Motor2_Polarity2          : GPIO_Point renames PB8; -- D15 from Arduino shield (not used)

   Steering_Motor : Basic_Motor;  -- this is Motor1, as physically connected
   Engine_Motor   : Basic_Motor;  -- this is Motor2, as physically connected

   procedure Initialize_Motor_Shield (Motor1, Motor2 : out Basic_Motor);

   ---------------------------
   -- Buzzer Configurations --
   ---------------------------

   Buz_Point : GPIO_Point renames PF14;
   --  PF14 corresponds to D4 of Arduino connector CN10 from Nucleo_F429ZI
   --  This pin corresponds to Buzzer from DC Motor Shield

   procedure Buzzer_Init_Bus;

   procedure Buzzer_Set (This : in out GPIO_Point) renames STM32.GPIO.Set;
   --  GPIO = 0 => buzzer OFF, GPIO = 1 => buzzer ON.

   procedure Buzzer_Clear (This : in out GPIO_Point) renames STM32.GPIO.Clear;
   --  GPIO = 0 => buzzer OFF, GPIO = 1 => buzzer ON.

   procedure Buzzer_Toggle (This : in out GPIO_Point) renames STM32.GPIO.Toggle;

   ---------------------------------
   -- Nucleo Board Configurations --
   ---------------------------------
   --  The procedures bellow are extracted from STM32.Board (STM32F429disco)
   --  and addressed to the NUCLEOF429ZI LEDs.

   Blue_LED  : GPIO_Point renames PB7;
   Green_LED : GPIO_Point renames PB0;
   Red_LED   : GPIO_Point renames PB14;

   All_LEDs  : GPIO_Points := Blue_LED & Green_LED & Red_LED;

   procedure Initialize_LEDs;
   --  MUST be called prior to any use of the LEDs unless initialization is
   --  done by the app elsewhere.

   procedure Turn_On  (This : in out GPIO_Point) renames STM32.GPIO.Set;
   procedure Turn_Off (This : in out GPIO_Point) renames STM32.GPIO.Clear;
   procedure Toggle   (This : in out GPIO_Point) renames STM32.GPIO.Toggle;

   procedure All_LEDs_Off with Inline;
   procedure All_LEDs_On  with Inline;

   procedure Toggle_LEDs (These : in out GPIO_Points) renames STM32.GPIO.Toggle;

end DC_Motor_Shield;

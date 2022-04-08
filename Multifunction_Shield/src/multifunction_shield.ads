with STM32.Device;   use STM32.Device;
with STM32.GPIO;     use STM32.GPIO;
with STM32.ADC;      use STM32.ADC;
with STM32.EXTI;     use STM32.EXTI;
with Ada.Interrupts; use Ada.Interrupts;
with Ada.Interrupts.Names;

package Multifunction_Shield is

   -------------------------
   -- LEDs Configurations --
   -------------------------

   LED_D1 : GPIO_Point renames PA5;
   --  PA5 corresponds to D13 of Arduino connector CN7 from Nucleo_F429ZI
   --  This pin corresponds to LED D1 from Multi-function Shield
   LED_D2 : GPIO_Point renames PA6;
   --  PA6 corresponds to D12 of Arduino connector CN7 from Nucleo_F429ZI
   --  This pin corresponds to LED D2 from Multi-function Shield
   LED_D3 : GPIO_Point renames PA7;
   --  PA7 corresponds to D11 of Arduino connector CN7 from Nucleo_F429ZI
   --  This pin corresponds to LED D3 from Multi-function Shield
   LED_D4 : GPIO_Point renames PD14;
   --  PD14 corresponds to D10 of Arduino connector CN7 from Nucleo_F429ZI
   --  This pin corresponds to LED D4 from Multi-function Shield

   LED_Points : GPIO_Points := LED_D1 & LED_D2 & LED_D3 & LED_D4;

   procedure LED_Init_Bus;

   procedure Led_Set (This : in out GPIO_Point) renames STM32.GPIO.Clear;
   --  GPIO = 0 => LED ON, GPIO = 1 => LED OFF.

   procedure Led_Clear (This : in out GPIO_Point) renames STM32.GPIO.Set;
   --  GPIO = 0 => LED ON, GPIO = 1 => LED OFF.

   procedure Led_Toggle (This : in out GPIO_Point) renames STM32.GPIO.Toggle;

   ---------------------------
   -- Buzzer Configurations --
   ---------------------------

   Buz_Point : GPIO_Point renames PE13;
   --  PE13 corresponds to D3 of Arduino connector CN10 from Nucleo_F429ZI
   --  This pin corresponds to Buzzer from Multi-function Shield

   procedure Buzzer_Init_Bus;

   procedure Buzzer_Set (This : in out GPIO_Point) renames STM32.GPIO.Clear;
   --  GPIO = 0 => buzzer ON, GPIO = 1 => buzzer OFF.

   procedure Buzzer_Clear (This : in out GPIO_Point) renames STM32.GPIO.Set;
   --  GPIO = 0 => buzzer ON, GPIO = 1 => buzzer OFF.

   procedure Buzzer_Toggle (This : in out GPIO_Point) renames STM32.GPIO.Toggle;

   ---------------------------
   -- Buttons Configurations --
   ---------------------------

   SW1 : GPIO_Point renames PC0;
   --  PC0 corresponds to A1 of Arduino connector CN9 from Nucleo_F429ZI
   --  This pin corresponds to Switch 1 from Multi-function Shield
   --  and has additional function ADC123_IN10
   SW2 : GPIO_Point renames PC3;
   --  PC3 corresponds to A2 of Arduino connector CN9 from Nucleo_F429ZI
   --  This pin corresponds to Switch 2 from Multi-function Shield
   --  and has additional function ADC123_IN13
   SW3 : GPIO_Point renames PF3;
   --  PF3 corresponds to A3 of Arduino connector CN9 from Nucleo_F429ZI
   --  This pin corresponds to Switch 3 from Multi-function Shield
   --  and has additional function ADC3_IN9

   SW_Points : GPIO_Points := SW1 & SW2 & SW3;

   --  PC0 is linked to Interrupt 0; PC3 and PF3 are linked to Interrupt 3
   --  Here we only use Interrupt 0 with the SW1 button
   SW1_Interrupt : constant Interrupt_ID := Ada.Interrupts.Names.EXTI0_Interrupt;

   SW1_EXTI_Line : constant External_Line_Number := SW1.Interrupt_Line_Number;
   SW2_EXTI_Line : constant External_Line_Number := SW2.Interrupt_Line_Number;
   SW3_EXTI_Line : constant External_Line_Number := SW3.Interrupt_Line_Number;

   SW_Edge : constant STM32.EXTI.External_Triggers := Interrupt_Falling_Edge;

   procedure Button_Init_Bus;

   ----------------------------------
   -- Potentiometer Configurations --
   ----------------------------------

   Pot_ADC     : Analog_To_Digital_Converter renames ADC_1;
   Pot_Channel : constant Analog_Input_Channel := 3;
   Pot_Point   : constant GPIO_Point := PA3;
   --  PA3 corresponds to A0 of Arduino connector CN9 from Nucleo-F429ZI
   --  This pin corresponds to Potentiometer from Multi-function Shield
   --  and has additional function ADC123_IN3

   procedure Pot_Init_Bus;

   ----------------------------------
   -- 4 x 7-Segment Configurations --
   ----------------------------------

   SS_SER : GPIO_Point renames PF12;
   --  PF12 corresponds to D8 of Arduino connector CN10 from Nucleo_F429ZI
   --  This pin corresponds to SER of 74HC595 shift register from Multi-function Shield
   SS_SRCLK : GPIO_Point renames PF13;
   --  PF13 corresponds to D7 of Arduino connector CN10 from Nucleo_F429ZI
   --  This pin corresponds to SRCLK of 74HC595 shift register from Multi-function Shield
   SS_RCLK : GPIO_Point renames PF14;
   --  PF14 corresponds to D4 of Arduino connector CN10 from Nucleo_F429ZI
   --  This pin corresponds to RCLK of 74HC595 shift register from Multi-function Shield

   type SS_Bus_Type is array (Natural range <>) of GPIO_Point;
   SS_Points : GPIO_Points := SS_SER & SS_SRCLK & SS_RCLK;

   procedure SevenSeg_Init_Bus;

end Multifunction_Shield;

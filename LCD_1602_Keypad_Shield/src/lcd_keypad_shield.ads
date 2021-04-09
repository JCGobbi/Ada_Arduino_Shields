with STM32.Device;  use STM32.Device;
with STM32.GPIO;    use STM32.GPIO;
with STM32.ADC;    use STM32.ADC;

package LCD_Keypad_Shield is

   ------------------------
   -- LCD Configurations --
   ------------------------

   LCD_DB4 : GPIO_Point renames PF14;
   -- PF14 corresponds to D4 of Arduino connector CN10 from Nucleo_F429ZI
   -- This pin corresponds to DB4 of HD44780 display from LCD Keypad Shield
   LCD_DB5 : GPIO_Point renames PE11;
   -- PE11 corresponds to D5 of Arduino connector CN10 from Nucleo_F429ZI
   -- This pin corresponds to DB5 of HD44780 display from LCD Keypad Shield
   LCD_DB6 : GPIO_Point renames PE9;
   -- PE9 corresponds to D6 of Arduino connector CN10 from Nucleo_F429ZI
   -- This pin corresponds to DB6 of HD44780 display from LCD Keypad Shield
   LCD_DB7 : GPIO_Point renames PF13;
   -- PF13 corresponds to D7 of Arduino connector CN10 from Nucleo_F429ZI
   -- This pin corresponds to DB7 of HD44780 display from LCD Keypad Shield
   LCD_RS : GPIO_Point renames PF12;
   -- PF12 corresponds to D8 of Arduino connector CN7 from Nucleo_F429ZI
   -- This pin corresponds to Register Select of HD44780 display from LCD Keypad Shield
   LCD_E : GPIO_Point renames PD15;
   -- PD15 corresponds to D9 of Arduino connector CN7 from Nucleo_F429ZI
   -- This pin corresponds to Enable of HD44780 display from LCD Keypad Shield
   LCD_BKLT : GPIO_Point renames PD14;
   -- PD14 corresponds to D10 of Arduino connector CN7 from Nucleo_F429ZI
   -- This pin corresponds to LCD Backlight Control of HD44780 display from LCD Keypad Shield

   LCD_Data : GPIO_Points := LCD_DB4 & LCD_DB5 & LCD_DB6 & LCD_DB7;
   LCD_Bus : GPIO_Points := LCD_Data & LCD_RS & LCD_E & LCD_BKLT;

   procedure LCD_Init_Bus;

   ---------------------------
   -- Keypad Configurations --
   ---------------------------

   Keypad_ADC     : Analog_To_Digital_Converter renames ADC_1;
   Keypad_Channel : constant Analog_Input_Channel := 3;
   Keypad_Point   : constant GPIO_Point := PA3;
   -- PA3 corresponds to A0 of Arduino connector CN9 from Nucleo-F429ZI
   -- This pin corresponds to Keys Up, Down, Left, Right and Select from
   -- Multi-function Shield and has additional function ADC123_IN3

   procedure Keypad_Init_Bus;

end LCD_Keypad_Shield;

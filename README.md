# Ada Arduino Shields

This repository contains Ada software to play with four Arduino shields:
- Four Relay Shield;
- Multifunction Shield;
- LCD 1602 Keypad Shield;
- DC Motor Shield.

The software is based on the [Ada Drivers Library](https://www.github.com/Adacore/Ada_Drivers_Library) from [Adacore](https://www.adacore.com). The main board where these shields are attached is the NUCLEO-F429ZI, from [ST Microelectronics](https://www.st.com), that has connectors for Arduino shields. If you want to use other nucleo boards, do the **Project Wizard** that comes with the Ada Drivers Library choosing your board. You will need to change the hardware addresses of the `*_shield.ads` files inside the `src` folder of each shield directory.

You may use the GNAT Programming Studio from Adacore or Visual Studio Code from Microsoft to cross-compile these sources. For VSCode, each board directory has a `.vscode/tasks.json` file that permits to check syntax and semantic, compile, build, clean, convert elf to hex and bin files and flash hex and bin files to board. Both IDEs need the [ST-LINK](https://github.com/stlink-org/stlink) to flash the executable to the nucleo board.

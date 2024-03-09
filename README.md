![](http://img.youtube.com/vi/AibY_IDPayM/0.jpg)

FLAPPY BIRD for MSX
===================
This is a *demake* of .GEARS Studio's [Flappy Bird](https://en.wikipedia.org/wiki/Flappy_Bird) and my first public program coded entirely in Z80 assembly -- **Yay! I'm a Hacker now!**

This game works on any MSX model (PAL or NTSC/PAM-M). The screen refresh rate is detected during initialization and the game speed automatically adjusted. If you're using a MSX turbo R the R800 mode will be enabled.

Building
--------
To build it you need to have **PASMO Assembler** and **GNU MAKE** previously installed, and just type:
* ```make bin``` to create a binary file to be loaded on real MSX
computer by BLOAD "FLAPPY BIRD.BIN",R or
* ```make rom``` to create a ROM image to run under emulators, ROM loaders or build your ouw physical cartridge.

More information
----------------
In my [itch.io](https://crunchworks.itch.io/flappybird-for-msx) page you can find more information about this game itself and others. This program and other related files are licensed under terms of GPL (GNU General Public License) version 3. Changes, suggestions and improvement are welcomed.

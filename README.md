![](http://img.youtube.com/vi/AibY_IDPayM/0.jpg)

# FLAPPY BIRD for MSX

This is a *demake* of .GEARS Studio's [Flappy Bird](https://en.wikipedia.org/wiki/Flappy_Bird) and my first public program coded entirely in Z80 assembly -- Yay! I'm a Hacker now! This game works on any MSX model (PAL or NTSC/PAM-M).
Screen refresh is detected and the game speed adjusted automatically. If you're using a MSX turbo R the R800 mode will be enabled.

Build using **PASMO Assembler** and **GNU MAKE** with:
* ```make bin``` to create a binary file to be loaded on real MSX
computer by BLOAD "FLAPPY BIRD.BIN",R or
* ```make rom``` to create a ROM image to run under emulators, ROM loader or build a physical cartridge.

In my [blog](https://giovannireisnunes.wordpress.com/meu-software/flappy-bird-para-msx/) you will find more information about the game and the binaries to be downloaded.

This program and other related files are licensed under terms of GPL (GNU General Public License). Changes, suggestions and improvement are welcomed.


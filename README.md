# ada-ncurses-snake
The snake game made with ada and ncurses. I made it as an exercise to practice the ada language.
## License
I release this code under the GPL V3 license, the text of this license is in LICENSE.txt.
## Building
I didn't spend many time on the building system, it's only tested on Debian 9. The file **build.gpr** may require modification to work on your system

This project require the following librairies/packages:
- libncurses
- libncurses-dev
- libcursesada
- libcursesada-dev

Type `gprbuild -p` to run the build.


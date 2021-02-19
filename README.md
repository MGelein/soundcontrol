# SoundControl V3
The third rewrite of SoundControl in 3 years. We now have the following history:
- Version 1: Electron based, was a bitch to distribute
- Version 2: Processing (Java) based, still quite large and performance problems
- Version 3: Love2D (lua & SDL) based. Major performance increase and enormous shrinking of the distribution file

Whereas the second rewrite was mostly targeted at distribution, the third rewrite was mostly targeted at performance. For some reason the Processing application was using too much GPU power and something more lightweight was needed. The ridicilously small overhead of 
Love2D proved to be the solution. We have now gained:

- &lt; 500KB total file size for the complete program
- __Much__ faster startup times
- __Much__ lower CPU usage (&lt; 50% of our previous usage)
- __Much__ lower GPU usage (&lt; 25% of our previous usage)

## How To Use
Simply download the provided executable and put it in a folder with some music files. We support `.wav`, `.mp3`, and `.ogg`.
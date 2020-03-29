# SoundControl v.2
This second version of the SoundControl program is a complete rewrite of the original. After more than a year of intensive use for my own D&D sessions I have identified some faults and issues with the original program.

### Reasons For The Rewrite:
1. Electron is not easily distributed. I know there are probably some packages out there that can help. But I've given up on easy Electron distribution.
2. Electron and the NPM ecosystem are not something I am very familiar with or __want__ to be familiar with.
3. The codebase was never meant for long-term maintenance and was slowly becoming a complete mess. 
4. New insights into things like remote-control, allowing one instance to control multiple over the internet necessitated a new way of thinking.
5. More people outside of me needed to be able to use this program without having any programming experience.

### What is SoundControl
SoundControl is a simple soundboard-like program with smooth fading between tracks. That is about it. You load a `.tsv` file by specifying the file in the `settings.ini` inside of the data folder. 
The `.tsv` file describes a simple button as folows, separated by tabs:
```
Html_Color_Code	Button_Title	Music_File_URL	
```
These three parts are separated by a tab. The music file url is relative to the `.tsv` file. 
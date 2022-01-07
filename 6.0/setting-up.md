**How do I import Scribble into my game?**

GameMaker Studio 2 allows you to import assets, including scripts and shaders, directly into your project via the "Local Package" system. From the [Releases](https://github.com/JujuAdams/scribble/releases) tab for this repo, download the .yymp file for the latest version. In the GMS2 IDE, load up your project and click on "Tools" on the main window toolbar. Select "Import Local Package" from the drop-down menu then import all scripts and shaders from the Scribble package.

&nbsp;

**How do I set up Scribble using GML?**

Scribble requires that you explicitly initialise fonts for use with Scribble. This is a three-step process:

1) Add a normal GameMaker font resource through the IDE
2) Click the `Regenerate` button in font dialogue inside the GameMaker IDE
3) Add the font's .yy file as an Included File (found in the font's folder in the project directory)
4) Add some code that instructs Scribble to use the font

Let's take this step by step. You're hopefully already familiar with adding resources to the GameMaker IDE.

Scribble needs to access information that GameMaker generates. All this information is contained in a single .yy file in the font's folder on disk inside the project directory. This file can sometimes be frustrating to locate, but fortunately there's a shortcut we can take. In the IDE, Navigate to the font resource you wish to add and right click on it. From the drop-down menu, select "Show In Explorer". A window will open showing various files for the font resource. You can drag-and-drop the .yy file into the GameMaker IDE to add it as an Included File.

***Please note** that if you change any font properties then the font will need to be regenerated, and the associated .yy file in Included Files will need to be updated too.*

Finally, we need to add some code that tells Scribble how to initialise the font. This is done through with two functions: [`scribble_init()`](scribble_init) and [`scribble_add_font()`](scribble_add_font). Call [`scribble_init()`](scribble_init) first, and then add fonts with [`scribble_add_font()`](scribble_add_font).

```gml
//Start initialisation:
//  The font directory is set as the root of the sandbox
//  The default font is set as "fnt_dialogue"
//  Automatic scanning for fonts ("autoscan") is turned off
scribble_init("", "fnt_dialogue", false);

//Add the font called "fnt_dialogue" to Scribble
scribble_add_font("fnt_dialogue");

//Add the font called "fnt_title" to Scribble
scribble_add_font("fnt_title");
```

If you don't want to type out all the font names one by one, you can set `scribble_init()` to automatically scan the designated font directory and load fonts for you.

&nbsp;

**How do I use spritefonts?**

Spritefonts work similarly to standard fonts and they are interchangeable when drawing text. They do, however, have some key differences during setup:

1) Spritefonts use a sprite asset rather than a font asset
2) Spritefonts do not require a .yy file to be added as an included file
3) Spritefonts will not be found using the autoscan feature of [`scribble_init()`](scribble_init) and must be added manually in code
4) Use [`scribble_add_spritefont()`](scribble_add_spritefont) (instead of [`scribble_add_font()`](scribble_add_font))
5) Collision mask mode set to **Automatic**
6) Collision mask type set to **Precise Per Frame (Slow)**
7) "Separate Texture Page" set to **off**
8) The sprite must have at least a 1 pixel transparent border around the edge

Here is an example of the code required to initialise a spritefont in Scribble:

```gml
//Start initialisation:
//  The font directory is set as the root of the sandbox
//  The default font is set as "fnt_score"
//  Automatic scanning for fonts ("autoscan") is turned off
scribble_init("", "fnt_score", false);

//Add the spritefont called "fnt_score" to Scribble
scribble_add_spritefont("fnt_score", "abcdefghijklmnopqrstuvwxyz", 0);
```
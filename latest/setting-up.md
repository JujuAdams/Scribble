# Setting Up

&nbsp;

## How do I import Scribble into my game?

GameMaker Studio 2 allows you to import assets, including scripts and shaders, directly into your project via the "Local Package" system. From the [Releases](https://github.com/JujuAdams/scribble/releases) tab for this repo, download the .yymp file for the latest version. In the GMS2 IDE, load up your project and click on "Tools" on the main window toolbar. Select "Import Local Package" from the drop-down menu then import all scripts and shaders from the Scribble package.

&nbsp;

## How do I set up Scribble?

Once added to your project, Scribble will automatically initialise its core functionality when you load the game. There's no "master" initialisation function that you need to run. However, you will very likely want to customise Scribble; take a look at the [Configuration page](Functions-(Configuration)) for more information on how to do that.

In addition to this, Scribble requires that you explicitly add fonts for use with Scribble. This is a four step process:

1. Add a normal GameMaker font resource through the IDE
2. Click the Regenerate button in font dialogue inside the GameMaker IDE
3. Open the fonts folder (can be done by right clicking on the font and pressing "Open in Explorer")
4. Add the font's .yy file as an Included File (via datafiles in the project directory, or by the "Included Files" menu)
5. Add some code that instructs Scribble to use the font

&nbsp;

Scribble needs to access information that GameMaker generates. All this information is contained in a single .yy file in the font's folder on disk inside the project directory. This file can sometimes be frustrating to locate, but fortunately there's a shortcut we can take. In the IDE, Navigate to the font resource you wish to add and right click on it. From the drop-down menu, select "Show In Explorer". A window will open showing various files for the font resource. You can drag-and-drop the .yy file into the GameMaker IDE to add it as an Included File.

***Please note** that if you change any font properties then the font will need to be regenerated, and the associated .yy file in Included Files will need to be updated too.*

Finally, we need to add some code that tells Scribble how to initialise the font. This is done with [`scribble_font_add()`](Functions-(Font-Setup)#scribble_font_addfontname-yypath-texture). Make sure to call [`scribble_font_add()`](Functions-(Font-Setup)#scribble_font_addfontname-yypath-texture) once at the start of the game for each of the fonts you want to use. By default, Scribble will use the first added font as the default font to use for text elements. The default font can be changed by using [`scribble_font_set_default()`](Functions-(Font-Setup)#scribble_font_set_defaultfontname).

```gml
//Add the font called "fnt_dialogue" to Scribble
scribble_font_add("fnt_dialogue");

//Add the font called "fnt_title" to Scribble
scribble_font_add("fnt_title");

//The default font will be fnt_dialogue as it was added first
//Set the default to "fnt_title"
scribble_font_set_default("fnt_title");
```

For large projects, typing out lots of font names is boring and clumsy. By calling [`scribble_font_add_all()`](Functions-(Font-Setup)#scribble_font_add_all), Scribble will try to add all fonts in your project.

&nbsp;

## What next?

Now you're ready to start drawing text with Scribble! The best way to learn is, as always, to read existing code. The main project file found in the repo has lots of examples and test cases for you to learn from.

Alternatively, if you want to simplify some of your existing text drawing that you've done using native GameMaker functions, [here's a brief overview of ways Scribble makes that easier](Coming-from-Native-GM). There's a lot you can do with Scribble, either by using [in-line commands](Text-Formatting) or by controlling behaviour with [methods](scribble()-Methods).

&nbsp;

## How do I use spritefonts?

Spritefonts work similarly to standard fonts and they are interchangeable when drawing text. They do, however, have some key differences during setup:

1) Spritefonts use a sprite asset rather than a font asset
2) Spritefonts do not require a .yy file to be added as an included file
3) Spritefonts will not be found using [`scribble_font_add_all()`](https://github.com/JujuAdams/Scribble/wiki/Functions-(Font-Setup)#scribble_font_add_all) and must be added manually in code
4) Use [`scribble_font_add_from_sprite()`](Functions-(Font-Setup)#scribble_font_add_from_spritefontname-mapstring-separation-spacewidth-proportional)
5) The sprite's collision mask mode must be set to **Automatic**
6) The sprite's collision mask type must be set to **Precise Per Frame (Slow)**
7) "Separate Texture Page" must be set to **off** for the sprite
8) The sprite must have at least a 1 pixel transparent border around the edge
9) Origin of the sprite should be set to top-left (unless you want to bulk offset your spritefont glyphs)

Here is an example of the code required to initialise a spritefont in Scribble:

```gml
//Add the spritefont called "fnt_score" to Scribble
scribble_font_add_from_sprite("fnt_score", "abcdefghijklmnopqrstuvwxyz", 0);
```

&nbsp;

## How do I use MSDF fonts?

[MSDF fonts](MSDF-Fonts) are an alternate way to draw text in a way that improves how text looks when it's scaled. This not only reduces texture page usage but it's very helpful when drawing text on mobile devices. Scribble's implementation of MSDF fonts also supports borders and drop shadows. MSDF fonts are useful but relatively complex; please read the dedicated [MSDF font page](MSDF-Fonts) for more information.
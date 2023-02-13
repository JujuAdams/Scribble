# Setting Up

## How do I import Scribble into my game?

GameMaker Studio 2 allows you to import assets, including scripts and shaders, directly into your project via the "Local Package" system. From the [Releases](https://github.com/JujuAdams/scribble/releases) tab for this repo, download the .yymp file for the latest version. In the GMS2 IDE, load up your project and click on "Tools" on the main window toolbar. Select "Import Local Package" from the drop-down menu then import all scripts and shaders from the Scribble package.

## How do I set up Scribble?

Once added to your project, Scribble will automatically initialise its core functionality when you load the game. There's no "master" initialisation function that you need to run. However, you will very likely want to customise Scribble; take a look at the [Configuration page](configuration) for more information on how to do that.

Unlike in previous versions, using standard fonts with Scribble is totally automatic and no additional code is needed.

By default, Scribble will use the first added font as the default font to use for text elements. The default font can be changed by using [`scribble_font_set_default()`](fonts?id=scribble_font_set_defaultfontname).

## What next?

Now you're ready to start drawing text with Scribble! The best way to learn is, as always, to read existing code. The main project file found in the repo has lots of examples and test cases for you to learn from.

Alternatively, if you want to simplify some of your existing text drawing that you've done using native GameMaker functions, [here's a brief overview of ways Scribble makes that easier](coming-from-native-gm). There's a lot you can do with Scribble, either by using [in-line commands](text-formatting) or by controlling behaviour with [methods](scribble-methods).

## How do I use spritefonts?

Spritefonts work similarly to standard fonts and they are interchangeable when drawing text. They do, however, require that you use [`font_add_sprite`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Fonts/font_add_sprite.htm) or [`font_add_sprite_ext`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Fonts/font_add_sprite.htm) to define the spritefont before using them with Scribble. The name of the spritefont in Scribble is the same as the name of the sprite asset.

## How do I use MSDF fonts?

[MSDF fonts](msdf-fonts) are an alternate way to draw text in a way that improves how text looks when it's scaled. This not only reduces texture page usage but it's very helpful when drawing text on mobile devices. Scribble's implementation of MSDF fonts also supports borders and drop shadows. MSDF fonts are useful but relatively complex; please read the dedicated [MSDF font page](msdf-fonts) for more information.

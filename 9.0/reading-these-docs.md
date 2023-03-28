# Reading These Docs

&nbsp;

Scribble's documentation is written in a "feature first" style. The sidebar contains a number of topics that relate to the implementation of features. Each page is separated into a number of subheadings, each describing part of Scribble's API that relate to that feature.

Features can be interacted with in four ways:

1. **Configuration macros** are found in scripts called `__scribble_config_*`. Configuration macros are applied when the game is compiled and cannot be changed at runtime. Configuration macros affect the operation of Scribble throughout your game.

2. **Global functions** are standard GameMaker functions that modifies Scribble's state everywhere. Global functions can typically be called anywhere at any time.

3. **Text element methods** are called by executing the named function on a struct returned by `scribble()`. The impact of text element methods are limited to that text element.

4. **Command tags** are instructions that are passed to Scribble by inserting them into a string that's being drawn. Any change in formatting via command tags is limited to subsequent characters in the string.

Generally speaking, global functions override configuration macros, text element methods override global functions, and command tags override text element methods.

```
macros < global functions < methods < command tags
```
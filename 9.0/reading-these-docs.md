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

Here are some examples:

&nbsp;

### Configuration Macros

`SCRIBBLE_DEFAULT_COLOR` can be found in `__scribble_config_behaviours()`:

```gml
#macro SCRIBBLE_DEFAULT_COLOR  c_white
```

This means that, by default, text drawing by Scribble will be white. Changing this macro to `c_black` will make text drawn by Scribble to be black by default.

&nbsp;

### Global Functions

`scribble_anim_shake()` is a global function that sets the animation properties for the `[shake]` command tag. Executing this function with new values will immediately change the appearance of text that is set to shake.

&nbsp;

### Text Element Methods

`.layout_wrap()` is a method that sets up automatic line wrapping for a text element.

```gml
var _element = scribble("Some text to draw inside a textbox and wrap around.");
_element.layout_wrap(sprite_width-30);
_element.draw(x, y);
```

By executing this function, the maximum width of the text element is set. This maximum width only applies to this specific text element.

&nbsp;

### Command Tags

`[rainbow]` is a command tag that causes subsequent characters to take on an animated rainbow colour.

```gml
scribble("Here comes the [rainbow]RAINBOW TEXT[/rainbow]!").draw(x, y);
```

The rainbow effect only applies to characters after the command tag (and the `[/rainbow]` tag turns off the effect for the final piece of punctuation).
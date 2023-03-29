# Reading these Docs

&nbsp;

Scribble's documentation is written in a "feature first" style. The sidebar contains a number of topics that relate to the implementation of features. Each page is separated into a number of subheadings, each describing part of Scribble's API that relate to that feature.

Features can be interacted with in four ways:

1. **Configuration macros** are found in scripts that start with `__scribble_config_*`. Configuration macros are applied when the game is compiled and cannot be changed at runtime. Configuration macros affect the operation of Scribble throughout your game. Configuration macros start with `SCRIBBLE_*` and are formatted using `SCREAMING_SNAKE_CASE`.

2. **Global functions** are standard GameMaker functions that modifies Scribble's state everywhere. Global functions can typically be called anywhere at any time. Scribble's global functions fit the pattern `scribble_*()` and are formatted in `snake_case`.

3. **Methods** are called by executing the named function on a struct returned by `scribble()`, `scribble_unique()`, or `scribble_typist()`. The impact of methods are limited to that struct. Methods include `.font()` and `.layout_wrap()` - they never start with `scribble`and always start with a dot `.`, and otherwise look like functions.

4. **Command tags** are instructions that are passed to Scribble by inserting them into a string that's being drawn. Any change in formatting via command tags is limited to subsequent characters in the string. Command tags are formatted as a command inside `[squareBrackets]` in Scribble's documentation, the same text that you'll need to insert into strings to apply the command tag.


&nbsp;

## Examples

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

By executing this function, the maximum width of the text element is set. Any text that exceeds this width will be put ("wrapped") on a new line. This maximum width only applies to this specific text element.

&nbsp;

### Command Tags

`[rainbow]` is a command tag that causes subsequent characters to take on an animated rainbow colour.

```gml
scribble("Here comes the [rainbow]RAINBOW TEXT[/rainbow]!").draw(x, y);
```

The rainbow effect only applies to characters after the command tag (and the `[/rainbow]` tag turns off the effect for the final piece of punctuation).
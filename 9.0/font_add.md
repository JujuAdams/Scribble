# `font_add()`

&nbsp;

Scribble supports GameMaker's native `font_add()` function by wrapping it in some bespoke logic. To work around some limitations with GameMaker's internal font caching, Scribble operates its own internal cache. You can manually force a fetch of particular glyphs for a dynamic font by using `scribble_font_fetch()`.

!> Scribble does not work out of the box with `font_add()`. To add dynamic fonts with Scribble, please use `scribble_font_add()`.

?> When adding a dynamic font with `scribble_font_add()` you will need to specify a name. You should **always** use this name to refer to font when using Scribble's functions.

Scribble allows you to change font in two ways: via `.font()` and via a command tag. Here's some examples of how to use a spritefont with those features:

<!-- tabs:start -->

#### **Native GameMaker**

```js
///Game Start Event
global.fnt_cyrillic = font_add("cyrillic.ttf", 24, false, false, 1024, 1279);

///Draw Event
draw_set_font(global.fnt_cyrillic);
draw_text(10, 10, "всем привет");
draw_set_font(-1);
```

#### **`.font()`**

```js
///Game Start Event
scribble_font_add("fnt_cyrillic", "cyrillic.ttf", 24, [1024, 1279], false);

///Draw Event
scribble("всем привет").font("fnt_cyrillic").draw(10, 10);
```

#### **`Command Tag`**

```js
///Game Start Event
scribble_font_add("fnt_cyrillic", "cyrillic.ttf", 24, [1024, 1279], false);

///Draw Event
scribble("[fnt_cyrillic]всем привет").draw(10, 10);
```

<!-- tabs:end -->

&nbsp;

## `scribble_font_add()`

**Full Signature:** `scribble_font_add(name, filename, size, glyphRange, SDF, [spread], [bold=false], [italic=false])`

**Returns:** N/A (`undefined`)

|Name        |Datatype|Purpose                           |
|------------|--------|----------------------------------|
|`name`      |string  |                                  |
|`filename`  |string  |                                  |
|`size`      |number  |                                  |
|`glyphRange`|        |                                  |
|`SDF`       |boolean |                                  |
|`[spread]`  |number  |                                  |
|`[bold]`    |boolean |                                  |
|`[italic]`  |boolean |                                  |

&nbsp;

## `scribble_font_fetch()`

**Full Signature:** `scribble_font_add(name, glyphRange)`

**Returns:** N/A (`undefined`)

|Name        |Datatype|Purpose                           |
|------------|--------|----------------------------------|
|`name`      |string  |                                  |
|`glyphRange`|        |                                  |
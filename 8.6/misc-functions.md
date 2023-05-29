# Miscellaneous 

&nbsp;

## `scribble_is_text_element(value)`

**Returns:** Boolean, whether the provided value is a Scribble text element

|Name   |Datatype|Purpose      |
|-------|--------|-------------|
|`value`|any     |Value to test|

&nbsp;

## `scribble_typists_add_event(name, function)`

**Returns:** N/A (`undefined`)

|Name      |Datatype|Purpose                                                                                  |
|----------|--------|-----------------------------------------------------------------------------------------|
|`name`    |string  |Name of the new formatting tag to add e.g. `"portrait"` adds the tag `[portrait]` for use|
|`function`|function|Function to execute                                                                      |

Events are scripts that are executed during a [typewriter fade in](scribble()-Methods#typewriter_inspeed-smoothness) animation. As each character is revealed, Scribble will check if any events are present at that position in the text and, if so, Scribble will **immediately** execute that function. This can be used for many purposes including changing character portraits, starting movement of instances, starting weather effects, giving the player items, and so on.

It is possible to send parameters into an executed script from your text. **Parameters passed into event functions are only ever strings.** The syntax is similar to normal GameMaker functions; `[popup,0.1,0.2,hello world]` has three parameters: `0.1`, `0.2`, and `hello world`, all of which are strings.

&nbsp;

Event scripts are executed with two arguments:

|Argument|Name            |Purpose                                                                        |
|--------|----------------|-------------------------------------------------------------------------------|
|0       |`element`       |Text element that caused the script to be executed                             |
|1       |`parameterArray`|An array of strings that contains the parameters defined in the text. See above|
|2       |`characterIndex`|Which character has been revealed (1-indexed)                                  |

Your script should be formatted such that they can unpack parameters from the provided array. Scripts are executed in the scope of the instance that ran the [`.draw()`](scribble-methods?id=drawx-y) method, and in the associated GameMaker object event (typically the Draw event).

&nbsp;

Here's an example. Let's say we run this code in the Create event of an object:
```
scribble_typists_add_event("rumble", callbackRumble);
element = scribble("Here's some[rumble,0.2] rumble!");
typist = scribble_typist();
typist.in(0.5, 0);
```
And then in the Draw event we run:
```
element.draw(x, y, typist);
```
The object will draw the text `Here's some rumble!`, slowly revealling the text character by character. When the `e` of the word `some` is displayed, Scribble will automatically call the script `callbackRumble()`.

```
/// @description callbackRumble(element, parameterArray, characterIndex)
/// @param element
/// @param parameterArray
/// @param characterIndex

function callbackRumble(_element, _parameter_array, _character_index)
{
    var _amount = real(_parameter_array[0]);
    gamepad_set_vibration(global.current_gamepad, _amount, _amount);
}
```

Here, `callbackRumble()` will fetch the parameter from the array and use it to vibrate the player's gamepad. Given that the formatting tag was `[rumble,0.2]`, the function `gamepad_set_vibration()` will be given `0.2` as its input value.

&nbsp;

## `scribble_add_macro(name, function)`

**Returns:** N/A (`undefined`)

|Name      |Datatype|Purpose                                     |
|----------|--------|--------------------------------------------|
|`name`    |string  |Name of the macro command tag               |
|`function`|function|Function to execute when the macro is parsed|

Macros are a way to inject text into the Scribble parser as an input string is being parsed. The function attached to a macro must return a string. The macro tag, when parsed, will be replaced by the string returned by the function. Macro functions can take arguments in a similar fashion to custom typist events or formatting tags. Macro arguments are always passed to the function as strings.

The following example shows how to use a macro to insert a series of sprites into a string:
```gml
///Create
scribble_add_macro("coin_gen", function(_count)
{
    var _string = "";
    repeat(_count) _string += "[spr_coin]";
    return _string;
});



///Draw
scribble("You find [coin_gen,4] lying on the floor!").draw(x, y);
```

The final string that Scribble will draw is equivalent to `"You find [spr_coin][spr_coin][spr_coin][spr_coin] lying on the floor!"` in this case.

!> If you read a variable in your macro function to control part of its behaviour, and that variable later changes whilst text is being drawn, there is no guarantee that Scribble will reflect that change. If you want to use a variable that can potentially change whilst text is being displayed, make sure you pass in that variable's value as a macro argument by modifying the input string.

&nbsp;

## `scribble_markdown_format(string)`

**Returns:** String, the modified string containing Scribble formatting tags

|Name    |Datatype|Purpose                                                    |
|--------|--------|-----------------------------------------------------------|
|`string`|number  |Markdown-formatted string to reformat for use with Scribble|

Reformats a Markdown-formatted string such that Scribble can render it natively. You can set the formatting styles to use with `scribble_markdown_set_styles()` (see below).

The following Markdown features are supported:
- Body text
- Header text, three different weights
- Bold / italic / bold & italic styles
- Unordered and ordered lists
- Links (implemented as Scribble regions)
- Quotes

This Markdown parser is not intended as a full or even accurate reformatter. Instead, this function is made available to make layout of larger blocks of text more familiar for non-programmers and more comfortable in general. Uses cases might be larger quantities of text for patch notes or extended descriptions of items, characters, locations, and so on.

?> This is potentially a slow function so care should be taken to cache results where appropriate.

&nbsp;

## `scribble_markdown_set_styles(struct, [fastMode])`

**Returns:** N/A (`undefined`)

|Name      |Datatype|Purpose                                                                                                                                                                 |
|----------|--------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`struct`  |struct  |Markdown-formatted string to reformat for use with Scribble                                                                                                             |
|`fastMode`|boolean |Whether to perform validation of the input struct. Defaults to `true`. Set this to `false` if you require faster processing and are confident that the struct is correct|

This function sets the styling rules for `scribble_markdown_format()` (see above).

The following Markdown features are supported:
- Body text
- Header text, three different weights
- Bold / italic / bold & italic styles
- Unordered and ordered lists
- Links (implemented as Scribble regions)
- Quotes

The input struct must be laid out in a specific way. You can see an example below. The following top-level member variable names are permitted:

|Member Variable|Associated Markdown Style|Formatting Example                         |
|---------------|-------------------------|-------------------------------------------|
|`.body`        |Regular body text        |                                           |
|`.header1`     |Largest size of header   |`# Page Title`                             |
|`.header2`     |Middle size of header    |`## Section Title`                         |
|`.header3`     |Smallest size of header  |`### Subsection Title`                     |
|`.bold`        |Bold text                |`**embiggens the smallest man**`           |
|`.italic`      |Italic text              |`*woah*` or `_woah_`                       |
|`.bold_italic` |Bold & italic combined   |`***mandatory***` or `_**mandatory**_` etc.|
|`.quote`       |Quotation                |`> 'twas brillig'`                         |
|`.link`        |Embedded URL link        |`[Text for link](region name)`             |

In addition to these top-level member variables, you may also specify a bulletpoint sprite for unordered lists. This sprite is defined using the `.bullet_sprite` member variable and should be set to a sprite index (_not_ a sprite name as a string).

Top-level member variables (excepting `.bullet_sprite`, see above) should contain a struct which in turn defines Scribble's behaviour for that style. The following parameters are available:

|Member Variable|Datatype|Default    |Usage                                                                                                                                                                    |
|---------------|--------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`.font`        |string  |`undefined`|Name of the font to set when entering the style. If not specified, then `[/font]` is inserted when entering the style                                                    |
|`.color`       |integer |`undefined`|Colour to set for this style. This should be a standard GameMaker colour. If not specified, then `[/color]` is inserted when entering the style                          |
|`.bold`        |boolean |`false`    |Whether to set the `[b]` tag. This allows Scribble to leverage [font style families](fonts?id=scribble_font_set_style_familyregular-bold-italic-bolditalic) to set a font|
|`.italic`      |boolean |`false`    |Whether to set the `[i]` tag. This allows Scribble to leverage [font style families](fonts?id=scribble_font_set_style_familyregular-bold-italic-bolditalic) to set a font|
|`.scale`       |number  |`1`        |Scale of text in this style, using the `[scale]` tag. If the scale is set to `1`, then `[/scale]` is inserted when entering the style                                    |
|`.prefix`      |string  |`""`       |Text to insert when entering the style. This can be used to inject formatting tags such as `[rainbow]` to access Scribble features in conjunction with Markdown          |
|`.suffix`      |string  |`""`       |Text to insert when leaving the style. This can be used to inject formatting tags such as `[/rainbow]` to reset Scribble features                                        |

The following struct is what Scribble uses by default. Note that no font is specified for any style; this means that Scribble's default behaviour is to rely on a font style family to control what font to use for bold / italic / bold & italic styles. You can set up font style families use [`scribble_font_set_style_family()`](fonts?id=scribble_font_set_style_familyregular-bold-italic-bolditalic).

```gml
{
    body: {
    },
    
    header1: {
        bold:   true,
        italic: true,
        scale:  1.6,
    },
    
    header2: {
        bold:  true,
        scale: 1.4,
    },
    
    header3: {
        italic: true,
        scale:  1.2,
    },
    
    quote: {
        color:  #E7E7E7,
        italic: true,
        scale:  0.9,
        prefix: "  ",
    },
    
    bold: {
        bold: true,
    },
    
    italic: {
        italic: true,
    },
    
    bold_italic: {
        bold:   true,
        italic: true,
    },
    
    link: {
        bold:  true,
        color: #DF9FFF,
    },
    
    bullet_sprite: scribble_fallback_bulletpoint, //A small arrowhead
}
```

&nbsp;

## `scribble_external_sound_add(soundID, alias)`

**Returns:** N/A (`undefined`)

|Name     |Datatype                                                          |Purpose                                                       |
|---------|------------------------------------------------------------------|--------------------------------------------------------------|
|`soundID`|[sound](https://manual.yoyogames.com/The_Asset_Editors/Sounds.htm)|The sound to target                                           |
|`alias`  |string                                                            |A string to use to refer to the sound ID in Scribble functions|

Adds a sound that can be referenced in Scribble functions using the given alias. This is intended for use with externally added sounds via `audio_create_stream()` or `audio_create_buffer_sound()`.

&nbsp;

## `scribble_external_sound_remove(alias)`

**Returns:** N/A (`undefined`)

|Name     |Datatype|Purpose                                         |
|---------|--------|------------------------------------------------|
|`alias`  |string  |The external sound alias to remove from Scribble|

&nbsp;

## `scribble_external_sound_exists(alias)`

**Returns:** Boolean, whether the alias has been added by `scribble_external_sound_add()`

|Name     |Datatype|Purpose                              |
|---------|--------|-------------------------------------|
|`alias`  |string  |The external sound alias to check for|

&nbsp;

## `scribble_flush_everything()`

**Returns:** N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Frees all memory that Scribble text elements and text models are currently using. You will not normally need to call this function (Scribble automatically garbage collects resources that haven't been used recently) but it's occasionally useful when you need memory to be available immediately, or you want to make sure memory is being freed.

&nbsp;

## `scribble_refresh_everything()`

**Returns:** N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Forces every Scribble text element to refresh their text model. This may be useful if some global property has changed, such as a change in default font or a macro has changed.

&nbsp;

## `scribble_msdf_thickness_offset(offset)`

**Returns:** N/A (`undefined`)

|Name    |Datatype|Purpose                                                                         |
|--------|--------|--------------------------------------------------------------------------------|
|`offset`|number  |The global MSDF font thickness offset to apply. The default offset values is `0`|

Applies a global thickness adjustment to MSDF fonts. An offset less than `0` will make MSDF glyphs thinner, an offset greater than `0` will make MSDF glyphs thicker. The offset value is very sensitive and values of `+/- 0.01` may make a significant difference to the appearance of glyphs.

# Markdown

&nbsp;

## `scribble_markdown_format()`

**Global Function:** `scribble_markdown_format(string)`

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

## `scribble_markdown_set_styles()`

**Global Function:** `scribble_markdown_set_styles(struct, [fastMode=true])`

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
|`.quote`       |Quotation                |`> 'twas brillig`                          |
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
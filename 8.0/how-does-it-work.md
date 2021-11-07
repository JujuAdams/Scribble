# How Does It Work?

&nbsp;

## Introduction

Scribble is a complex library. Data and parameters that are passed into Scribble go through a complex process to be turned into text to be drawn on the screen. A lot of the techniques that Scribble use have been accumulated over half a decade of tinkering in my free time.

## What Even Is A String Anyway?

Strings in GameMaker null-terminated and encoded using UTF-8. Exactly how strings are stored changes from platform to platform, but it's helpful to think of a string as an array of bytes. Each character (letter) in the string is made up of 1, 2, 3, or 4 bytes. The bytes are ordered in the string such that the order of bytes corresponds to the order of the letters. To indicate that the string has no more information in it beyond a certain point, we use a "null" (a byte with a value of `0`, which you'll sometimes see written as `0x00`) to mark the end of the string. We call this a "null terminator", hence the name "null terminated string".

Each byte holds a value from 0 to 255. Clearly this isn't enough to describe every symbol in every language written by human-beings. This is where the variance in the number of bytes per character comes in. Exactly what set of byte values corresponds to what output character is defined by UTF-8, a system devised by the [Unicode Consortium](https://en.wikipedia.org/wiki/Unicode_Consortium) to transmit text that follows the [Unicode Standard](https://en.wikipedia.org/wiki/Unicode). UTF-8 is used (at the time of writing) on over 97% of websites worldwide. It is, needless to say, extremely popular.

Within UTF-8, English letters, Arabic numerals, and a bunch of common symbols only take up 1 byte per character. Letters and symbols from other languages often require two or more bytes per character. For example, Cyrillic is encoded using two bytes per character and Simplified Chinese is encoded using three bytes per character. Sumerian Cuneiform, should you need to call upon on its muddy, earthern charm, requires four bytes per character. Character encodings can get incredibly complicated! Whilst each character in Arabic requires only two bytes, symbols are often joined together to make visually distinct shapes. Devanagari (used for Hindi) has potentially hundreds of possible variants depending on the style being used. In fact, Devanagari has so many permutations that Unicode doesn't bother encoding all of them and instead only specifies the basic consonant and vowel sounds!

UTF-8 isn't perfect but its simplicity allows us to draw text from a wide variety of writing cultures with really very little trouble. What's important to remember about a string is that it's just numbers combined in such a way that it can be interpreted as text. There's nothing in a string that implies what each character looks like, how text should be laid out, or how to space things in a visually appealling way. For that we need fonts and a text layout system.

## Font Rasterization and Glyphs

Font authoring is a highly specialist field with a [myriad terms](https://www.monotype.com/resources/studio/typography-terms). I don't understand all of them myself and, even if I did, it would be overkill to explain it all here. To understand text in GameMaker we don't need to be fully fluent in the lingo nor do we need to understand how exactly to design and create fonts ourselves. What we do need to know, however, is the process that GameMaker uses to render fonts.

Fonts are defined using geometric shapes that can be scaled up and down to whatever size you want. There's a lot of nuance as to how that happens (especially at low resolutions) because those pure geometric shapes have to be crushed down to pixels to be drawn. This is called **rasterization** and it's a relatively slow process. You definitely *can* perform rasterization in realtime but it doesn't leave you much CPU time for anything else, like, for example, the game part of your game.

We can improve on this expensive process by doing all the rasterization work when we build the game, rather than when the game runs. Languages built on an [alphabet](https://en.wikipedia.org/wiki/Alphabet), [abjad](https://en.wikipedia.org/wiki/Abjad), or [abugida](https://en.wikipedia.org/wiki/Abugida) typically repeat characters frequently so we can rasterize those characters once and then re-use that result. In fact, rasterization is _so_ expensive that we should rasterize all the symbols as well. We can store all the characters we need into a big image, store that image somewhere, and then later draw individual parts of the image to the screen for each character that's needed.

Not every language is [segmental](https://en.wikipedia.org/wiki/List_of_writing_systems#Segmental_scripts) though. For languages that have thousands of characters that could be used - Chinese and Japanese being the two really common ones - we need to be more selective in the characters that we cache. This pre-rendering process is still benefitial, however. It's faster to draw bits from a texture page than to handle the raw font shapes for every character, even if the texture page takes up substantially more memory.

Some scripts, such as Arabic, require additional and meaningful graphics to be drawn in and around characters in order to convey the correct meaning. We use a specific term for all the various shapes and doodles that a font might contain, even if they're not strictly "a letter": we call them **glyphs**. The vast majority of the time, text display requires many more glyphs than the 26 letters an English-speaking reader might be familiar with.

And that's how GameMaker works - when you define a font and set the rendering parameters (size, bold/italic etc.) GameMaker runs [some software](https://freetype.org/) in the background that rasterizes all the glyphs for the new font. The image that FreeType spits out is then stored on a [texture page](https://manual.yoyogames.com/Settings/Texture_Information/Texture_Pages.htm) ready for use in your game. When you call `draw_text()` (or [associated functions](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/Text.htm)) then GameMaker will grab glyphs off of the texture page and draw them in the right order to produce readable text.

?> Once you've rendered glyphs from your font at a certain size, you're locked in. Unless we redraw the entire set of glyphs, we cannot change the size of what's been cached. We can scale the rasterized graphics up and down but this rarely looks good. This means that if you want to vary text size in GameMaker, you need to create different font assets for each size, which is annoying. [MSDF fonts](msdf-fonts) go a long way to solving this, a feature that is only available in Scribble.

## Text Layout

Determining how to lay out glyphs on the screen is a surprisingly involved and complex process. In games we're spared most of the unpleasant details compared to book publishing or academic journal publishing, but we still have plenty of challenges nonetheless. Text layout for games, at least for our purposes, has three main components:

**1. Horizontal Position and Kerning**
	
	The most basic task for drawing text is positioning the glyphs side by side. The way this is done is to have a "head" position, a variable that tracks the x-position of the next glyph to draw. At the very start of a string, the head position is at position 0. After drawing a glyph, the head position moves a certain number of pixels across, typically moving to the right. The distance that the head moves is called the **separation** (or **advance**) value for the glyph. Some glyphs have a separation of zero, other glyphs have a separation value greater than zero despite not drawing anything at all (notably the space glyph). More generally, we call the space between glyphs **kerning** when we're not talking specifically about the numeric values involved.
	
	Unfortunately, it turns out that having a constant separation value for a glyph looks a bit weird. A good example is how `A` and `W` look together. Compare "AL" and "AW". In most fonts, `A` will have a different kerning depending on whether it's followed by `L` or `W`. This extra level of polish can make text a lot more comfortable to read, especially if text is being displayed in large quantities. Well-designed fonts will have entire tables of kerning data. The more recent versions of GameMaker do support kerning adjustment for glyph pairs, but this has been a recent addition.

**2. Line Spacing and Text Wrapping**
	
	Usually line height is defined as a percentage of the point size (or just "size") of a font. The space between lines of text, measured from the baseline of one line to the baseline of the next, is called **leading**, a curious term borrowed from the era of [metal printing](https://www.thisiscolossal.com/2016/09/a-fascinating-film-about-the-last-day-of-hot-metal-typesetting-at-the-new-york-times/). This value is defined by the font, and all GameMaker has to do is space lines accordingly. This is done in a similar way to horizontal positioning - when a new line is needed, we move down to a new line by travelling the required distance. The line height for a given font is consistent no matter what glyphs are drawn on the given line.
	
	Manually inserting line breaks into strings is tedious work and, whilst you can sort of get away with it if you're only supporting one language in your game, as soon as you look to localise your work you'll need to add manual line breaks for *every language*. This isn't feasible. As a result, automatic text wrapping is a very common feature. Latin-based scripts (and many others) don't allow for linebreaks in the middle of a word so extra processing must be done to figure out where best to place a newline character, usually by replacing a space, to maintain legibility whilst fitting text inside the given width.

?> You may have seen two different types of linebreak if you've compared text output from Windows and Linux/macOS. Windows uses `\r\n` (`0x0d` `0x0a`) whereas Unix-based systems use `\n` (`0x0a`). The reasons for this are outside the scope of this discussion (and honestly I find the situation frustrating). Generally, `\r` can be ignored as a zero-width whitespace character, and `\n` is used as the primary newline character instead in Scribble.

**3. Ligatures and Glyph Substitutions**
	
	Ligatures are not natively supported by GameMaker's own text-drawning functions but are a commonly-deployed feature. A ligature is when two (or sometimes more) glyphs are replaced by a different, singular glyph. The traditional example in English is `a` and `e` combining to form `æ`, for example "archæology". It's rare to see ligatures in modern printed English, except in situations where the publication or work is borrowing a classic, or perhaps even archaic, style. It is mostly a nice-to-have feature for Latin-based languages.
	
	&nbsp;
	
	Ligatures are a special case of the more general practice of glyph substitution. Glyph substitution is where a glyph is replaced by another for the purposes of meaning or aesthetics. Whilst glyph substitutions are mostly for style only in Latin script, some scripts depend on glyph substitution to even make sense. Ligatures are absolutely essential for text rendering in Arabic, Devanagari, and Bengali, three of the most [widely-used scripts](https://www.britannica.com/list/the-worlds-5-most-commonly-used-writing-systems) in the world. It is regretable that GameMaker doesn't support these features natively, but Scribble can.

The calculations required to appropriately position glyphs in an attractive manner, when added together, become something of a time hog. Like everything with text rendering, what seems like a simple problem to solve is remarkably difficult due to the existing expectations of players, and the need for clarity and comfort whilst reading. When calling `draw_text()` (or `draw_text_ext()` for text wrapping), GameMaker has to redo all these calculations _every frame for every call_. Even without the overhead of performing kerning, line spacing, text wrapping, and glyph substitution, a slice of dialogue drawn in a textbox can easily be 200 glyphs. That means GameMaker needs to draw, effectively, 200 sprite images. This is work that is done again and again every frame even though the output doesn't change.

## Text Elements, Text Models, and Caching

Scribble uses two tiers of caching, one for **text elements** and another for **text models**. Both elements and models are automatically cached by Scribble, allowing for text layout to happen _once_ and then be reused for subsequent frames. This dramatically lowers the cost of drawing text after the text layout step has been completed. This is a similar solution to pre-rendering glyphs onto a texture page, though the caching that Scribble does is performed when the game is running rather than when the game compiles. Both text elements and text models can be reused in different ways and exist in two different cache pools.

The distinction between text elements and text models is critical to Scribble:

|Text Element                                                 |Text Model                                                     |
|-------------------------------------------------------------|---------------------------------------------------------------|
|Holds variables, and a reference to a text model             |Holds vertex buffer data                                       |
|Stores text state, such as page or text wrapping width       |Uses state values from a text element to generate graphics data|
|Has [public methods](scribble-methods)                       |Has no public methods at all                                   |
|Dynamic, can be modified by calling methods                  |Static/read-only, cannot be modified once created              |
|Does no drawing itself; draw commands are passed to the model|Able to submit text to the GPU for rendering                   |
|Holds values to be sent to Scribble's shader                 |Configures Scribble's shader using values from a text element  |
|Garbage collected after both:<br>1. It hasn't been drawn for a few frames<br>2. No reference to it exists elsewhere in memory|Garbage collected when no text elements reference it|

**Text Models**

Being able to cache text model results between frames means that Scribble can deliver a whole bunch of relatively expensive features without damaging performance. A new model is created by an element when the model cache contains no model with the exact desired properties. These properties are things like font size and text wrapping width, things that fundamentally change the layout of glyphs. Anything marked as a **regenerator** on the [`scribble()` methods page](scribble-methods) is modifying a text element property that would cause a new model to be needed. If a regenerator method is called on an element then the element will mark itself as "dirty". When the text element is next drawn (or a model property is requested), the text element will discard its previous reference to its old model, and try to find a new model in the cache, creating a new model if necessary. If no other elements hold references to the old model then the old model will be automatically garbage collected by Scribble after a few frames. Creating text models is easily the most demanding operation for Scribble.

**Text Elements**

Models are created when an element needs them, and similarly a text element is created when _you_ need them. `scribble()` is a function that checks the cache of text elements and, if a match exists, then the already extant element is returned. If no text element exists then a new one is created and returned. The search string that is used is very simple: it's the text passed into `scribble()` plus the [unique ID](scribble-methods?id=scribblestring-uniqueid), if one is specified. This has the side effect of two calls to `scribble()` that use the same input text occasionally getting confused with each other. This is rarer than you'd think, and the unique ID option is provided to disambiguate text elements when it comes up.

Unlike models, elements are public and the developer can create and hold references to them. Developers can also **not** hold references to them! For example:

```GML
///Draw
scribble("Here's a volatile text element.").draw(x, y);
```

This line of code by itself requires an element to exist which, in turn, requires a model to be created so that the text can be drawn. There is no reference to it, however, since the return value from `scribble()` is not being assigned to a variable or placed in a data structure etc. The next frame, we don't want to create a brand new text element and a brand new text model, we want to use the element and model we created in the last frame. Since there's no reference hanging around for this element, we call it a **volatile text element**.

```GML
///Create
stash = scribble("Here's a stashed text element");

///Draw
stashed.draw(x, y);
```

In this situation, we create an element and then store a reference to it in a variable. This keeps the reference alive and, as we would expect, also keeps the text element alive too. This is called a **stashed text element**. The text element will never be garbage collected and any text model that it references will also never be garbage collected.

?> A stashed text element will still be in the global cache. Calling `scribble("Here's a stashed text element")` elsewhere will return the stashed text element. It is, unfortunately, not possible to differentiate volatile and stashed elements programmatically. It is recommended that you use unique IDs with stashed elements.

In this situation, the text model won't be generated until the Draw event because Scribble doesn't generate models until they're essential to allow for regenerator methods to be called on an element without causing lots of model creation when it's not needed. Consider:

```GML
///Create
stashed = scribble("Here's a stashed text element with lots of regenerator methods");
stashed.starting_format(fntComicSans, c_fuchsia);
stashed.wrap(400);

///Draw
statshed.draw(x, y);
```

We're calling two [regenerator methods](scribble-methods) here. If we generated a model as soon as possible, we'd have to generate three models - for `scribble()`, for `.starting_format()`, and for `.wrap()` - so it's going to require less time overall if we only generate a model once when we need it. However, sometimes it _is_ useful to build a text model up front and not wait until a Draw event to do that work. This is where the [`.build()` method](scribble-methods?id=buildfreeze) comes in:

```GML
///Create
stashed = scribble("Here's a stashed text element with lots of regenerator methods");
stashed.starting_format(fntComicSans, c_fuchsia);
stashed.wrap(400);
stashed.build(true); //Force creation of a model, and freeze it for extra FPS

///Draw
stashed.draw(x, y); //Scribble won't generate a model, one already exists
```

## String Parsing

## Text Wrapping, Revisited

## Animation

## Vertex Buffers and The Scribble Shader

## Typewriter and Events

## Arabic

## Bezièr Curves

## MSDF

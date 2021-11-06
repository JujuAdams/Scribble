# How Does It Work?

&nbsp;

## Introduction

Scribble is a complex library. Data and parameters that are passed into Scribble go through a complex process to be turned into text to be drawn on the screen. A lot of the techniques that Scribble use have been accumulated over half a decade of tinkering in my free time.

## What Even Is A String Anyway?

Strings in GameMaker null-terminated and encoded using UTF-8. Exactly how strings are stored changes from platform to platform, but it's helpful to think of a string as an array of bytes. Each character (letter) in the string is made up of 1, 2, 3, or 4 bytes. The bytes are ordered in the string such that the order of bytes corresponds to the order of the letters. To indicate that the string has no more information in it beyond a certain point, we use a "null" (a byte with a value of `0`, which you'll sometimes see written as `0x00`) to mark the end of the string. We call this a "null terminator", hence the name "null terminated string".

Each byte holds a value from 0 to 255. Clearly this isn't enough to describe every symbol in every language written by human-beings. This is where the variance in the number of bytes per character comes in. Exactly what set of byte values corresponds to what output character is defined by UTF-8, a system devised by the [Unicode Consortium](https://en.wikipedia.org/wiki/Unicode_Consortium) to transmit text that follows the [Unicode Standard](https://en.wikipedia.org/wiki/Unicode). UTF-8 is used (at the time of writing) on over 97% of websites worldwide. It is, needless to say, extremely popular.

Within UTF-8, English letters, Arabic numerals, and a bunch of common symbols only take up 1 byte per character. Letters and symbols from other languages often require two or more bytes per character. For example, Cyrillic is encoded using two bytes per character and Simplified Chinese is encoded using three bytes per character. Sumerian Cuneiform, should you need to call upon on its muddy, earthern charm, requires four bytes per character. Character encodings can get incredibly complicated! Whilst each character in Arabic requires only two bytes, symbols are often joined together to make visually distinct shapes. Hindi (specifically Devanagari script) has potentially hundreds of possible variants depending on the style being used. In fact, Devanagari has so many permutations that Unicode doesn't bother encoding all of them and instead only specifies the basic consonant and vowel sounds!

UTF-8 isn't perfect but its simplicity allows us to draw text from a wide variety of writing cultures with really very little trouble. What's important to remember about a string is that it's just numbers combined in such a way that it can be interpreted as text. There's nothing in a string that implies what each character looks like, how text should be laid out, or how to space things in a visually appealling way. For that we need fonts and typesetting.

## Font Rasterization and Glyphs

Font authoring is a highly specialist field with a [myriad terms](https://www.monotype.com/resources/studio/typography-terms). I don't understand all of them myself and, even if I did, it would be overkill to explain it all here. To understand text in GameMaker we don't need to be fully fluent in the lingo nor do we need to understand how exactly to design and create fonts ourselves. What we do need to know, however, is the process that GameMaker uses to render fonts.

Fonts are defined using geometric shapes that can be scaled up and down to whatever size you want. There's a lot of nuance as to how that happens (especially at low resolutions) because those pure geometric shapes have to be crushed down to pixels to be drawn. This is called **rasterization** and it's a relatively slow process. You definitely *can* perform rasterization in realtime but it doesn't leave you much CPU time for anything else, like, for example, the game part of your game.

We can improve on this expensive process by doing all the rasterization work when we build the game, rather than when the game runs. Languages built on an [alphabet](https://en.wikipedia.org/wiki/Alphabet), [abjad](https://en.wikipedia.org/wiki/Abjad), or [abugida](https://en.wikipedia.org/wiki/Abugida) typically repeat characters frequently so we can rasterize those characters once and then re-use that result. In fact, rasterization is _so_ expensive that we should rasterize all the symbols as well. We can store all the characters we need into a big image, store that image somewhere, and then later draw individual parts of the image to the screen for each character that's needed.

Not every language is [segmental](https://en.wikipedia.org/wiki/List_of_writing_systems#Segmental_scripts) though. For languages that have thousands of characters that could be used - Chinese and Japanese being the two really common ones - we need to be more selective in the characters that we cache. This pre-rendering process is still benefitial, however. It's faster to draw bits from a texture page than to handle the raw font shapes for every character, even if the texture page takes up substantially more memory.

Some scripts, such as Arabic, require additional and meaningful graphics to be drawn in and around characters in order to convey the correct meaning. We use a specific term for all the various shapes and doodles that a font might contain, even if they're not strictly "a letter": we call them **glyphs**. The vast majority of the time, text display requires many more glyphs than the 26 letters an English-speaking reader might be familiar with.

And that's how GameMaker works - when you define a font and set the rendering parameters (size, bold/italic etc.) GameMaker runs [some software](https://freetype.org/) in the background that rasterizes all the glyphs for the new font. The image that FreeType spits out is then stored on a [texture page](https://manual.yoyogames.com/Settings/Texture_Information/Texture_Pages.htm) ready for use in your game. When you call `draw_text()` (or [associated functions](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/Text.htm)) then GameMaker will grab glyphs off of the texture page and draw them in the right order to produce readable text.

?> Once you've rendered glyphs from your font at a certain size, you're locked in. Unless we redraw the entire set of glyphs, we cannot change the size of what's been cached. We can scale the rasterized graphics up and down but this rarely looks good. This means that if you want to vary text size in GameMaker, you need to create different font assets for each size, which is annoying. [MSDF fonts](msdf-fonts) go a long way to solving this, a feature that is only available in Scribble.

## Typesetting

## Text Elements and Caching

## String Parsing

## Text Wrapping

## Vertex Buffers

## Animation

## Typewriter and Events

## Arabic

## Bezièr Curves

## MSDF

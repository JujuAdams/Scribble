# How Does It Work?

&nbsp;

## Introduction

Scribble is a complex library. Data and parameters that are passed into Scribble go through a complex process to be turned into text to be drawn on the screen. A lot of the techniques that Scribble use have been accumulated over half a decade of tinkering in my free time.

## What Even Is A String Anyway?

Strings in GameMaker null-terminated and encoded using UTF-8. Exactly how strings are stored changes from platform to platform, but it's helpful to think of a string as an array of bytes. Each character (letter) in the string is made up of 1, 2, 3, or 4 bytes. The bytes are ordered in the string such that the order of bytes corresponds to the order of the letters. To indicate that the string has no more information in it beyond a certain point, we use a "null" (a byte with a value of `0`, which you'll sometimes see written as `0x00`) to mark the end of the string. We call this a "null terminator", hence the name "null terminated string".

Exactly what set of byte values corresponds to what output character is defined by UTF-8, a system devised by the [Unicode Consortium](https://en.wikipedia.org/wiki/Unicode_Consortium) to transmit text that follows the [Unicode Standard](https://en.wikipedia.org/wiki/Unicode). UTF-8 is used (at the time of writing) on over 97% of websites worldwide. It is, needless to say, extremely popular.

Within UTF-8, English letters, Arabic numerals, and a bunch of common symbols only take up 1 byte per character. Letters and symbols from other languages often require two or more bytes per character. For example, Cyrillic is encoded using two bytes per character and Simplified Chinese is encoded using three bytes per character. Sumerian Cuneiform, should you need to call upon on its muddy, earthern charm, requires four bytes per character. Character encodings can get incredibly complicated! Whilst each character in Arabic requires only two bytes, symbols are often joined together to make visually distinct shapes. Hindi (specifically Devanagari script) has potentially hundreds of possible variants depending on the style being used. In fact, Devanagari has so many permutations that Unicode doesn't encode nearly all of them!

UTF-8 isn't perfect but, 90% of the time, its simplicity allows to draw text from a wide variety of writing cultures with really very little trouble. What's important to remember about a string is that it's just numbers combined in such a way that it can be interpreted as text. There's nothing in a string that implies how text should be laid out or how to space things in a visually appealling way. Instead, we rely on typefaces to provide that information.

## Font Renderering (in general)

## Text Wrapping

## Vertex Buffers

## Typewriter and Events

## MSDF

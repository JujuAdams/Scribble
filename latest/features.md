# Features

---

Scribble is a comprehensive text rendering library designed to replace GameMaker's native [`draw_text()` functions](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/drawing/text/) without adding unnecessary complexity. Scribble's design should feel familiar and intuitive for GameMaker users.

There are a multitude of very useful features available:
- In-line colour and font swapping
- In-line sprites, including animation
- Text wrapping (including CJK-compatible wrapping)
- Typewriter
- Events, such as triggering sound effects and screenshake directly from typewriter text
- Automatic [pagination](https://en.wikipedia.org/wiki/Pagination)
- High performance caching
- Font effect baking
- Resolution-independent [MSDF fonts](MSDF-Fonts)

Scribble supports all GameMaker export modules, including consoles, with the exception that **HTML5 is not supported** due to [bugs in GameMaker's JavaScript runner](https://github.com/JujuAdams/scribble/issues/18).

Scroll down to read more about each feature.

&nbsp;

## In-line Text Formatting & Sprites

One of the biggest problems with GameMaker's native [`draw_text()` function](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/drawing/text/) is the clumsy and limited text formatting options. Draw state can only ever be applied to entire strings and splitting strings up to apply certain effects to specific parts is tedious and, more importantly, hard to do efficiently.

Scribble offers flexible in-line formatting. Using a BBCode-like syntax for its in-line formatting, Scribble allows you to change colour, alignment, and font easily. In addition to in-line formatting, Scribble also has a selection of GameMaker-like [drawing options](scribble()-Methods) that affect the entire textbox.

Sometimes, instead of using words to describe something, using an in-line sprite does the job much more clearly. Scribble lets you insert sprites into the middle of strings with a single formatting tag: you just type the name of the sprite enclosed with brackets e.g. `[sprCoin]`. The relevant sprite will be drawn right there in the text and even animates automatically. I've seen this used as a way to handle button prompts on console, for emojis, and to indicate resources e.g. for a strategy game.

You can read more about [text formatting here](Text-Formatting).

&nbsp;

## Text Wrapping & Pages

Text wrapping is a standard feature for lots of text renderers, and Scribble is no different. The [`.wrap()`](scribble()-Methods#wrapmaxwidth-maxheight-characterwrap-regenerator) method allows you to set the maximum width and height of your textbox. If Scribble sees that your text is going off the end of a line, it'll simply wrap around the text to the next line down.

East Asian languages (Chinese, Japanese, Korean etc.) sometimes use different text wrapping rules to Latin and Cyrillic languages. Scribble supports this too - just set the `characterWrap` argument to `true` when using [`.wrap()`](scribble()-Methods#wrapmaxwidth-maxheight-characterwrap-regenerator) to allow Scribble to wrap text per character rather than per word.

Scribble also features automatic page breaks as well as automatic line breaks. Page breaks are useful for lots of situations - when dealing with localised text where you don't know how many extra words will be needed, textboxes that might not always be the same size due to different device sizes, simplifying your writing process to totally remove needing to check where to split up text to fit into textboxes.

Pages can be created two ways. Most people will want to let Scribble handle page breaks automatically: [`.wrap()`](scribble()-Methods#wrapmaxwidth-maxheight-characterwrap-regenerator) has an optional `maxHeight` argument. Any text that would be drawn outside the textbox is instead pushed onto a new page. For those looking for a little more control, the text formatting command `[/page]` can be used to manually create a new page. Manual page breaks with `[/page]` are useful when localising to help language feel more natural.

&nbsp;

## Typewriter & Events

A common use case for Scribble, though by no means its only use, is to draw dialogue text. It's very common, especially in retro-styled games, to reveal text slowly to the user, often character-by-character. This has a lot of names but it's usually known as a "typewriter effect".

Setting up a typewriter effect is simple - Precache the string you're using with a single call to [`scribble()`](scribble()-Methods), then call [`.typewriter_in()`](scribble()-Methods#typewriter_inspeed-smoothness) once. Now every frame that you draw the string using [`.draw()`](scribble()-Methods#drawx-y) it'll slowly reveal the text.

Sometimes you'll want to execute code, such as triggering a screenshake or changing a character's portrait, in the middle of revealing text. [`scribble_typewriter_add_event()`](Functions-(Miscellaneous)#scribble_typewriter_add_eventname-function) lets you define your own custom event which you can insert anywhere in a string. When Scribble reaches that point as it reveals text, it'll execute the function. This is an extremely powerful feature!

&nbsp;

## High Performance Caching

People have spent a lot of time making text renders for GameMaker, Scribble is hardly the first custom system. But all previous systems have a substantial weakness - because they rely on GameMaker's internal text drawing functions, they all end up being slow or limited (or both!). Many of them perform lots of string manipulation which is awful for performance.

At its core, Scribble uses cached vertex buffers to render text for high performance across all platforms. When a string is drawn for the first time, Scribble will build a vertex buffer that describes exactly how that string should be drawn - the location of each letter, their colour and font, how to animate them, and so on. When Scribble draws some text, it simply draws the pre-calculated vertex buffer. This means Scribble can offer beautiful, complex rendering at a fraction of the performance cost of the traditional approach.
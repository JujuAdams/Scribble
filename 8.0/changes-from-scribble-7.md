# Coming from Scribble 7.1

Version 8 is, on the surface, rather similar to version 7.1. Calling methods on text elements is still the primary way of interacting with Scribble. However, under the surface, the text parser that powers Scribble has undergone a complete rewrite. Thanks to features added in GameMaker 2.3.4 (and lateR), Scribble can now cut out some of the font definition tedium. Typewriters have changed too, dropping the clumsy and error-prone `.typewriter_*()` functions in preference for a new "typist" system. This is just the start - Scribble version 8 has close to 500 commits between it and version 7.1, making it the most substantial version upgrade to date.

In pursuit of an easier-to-use yet more powerful library, some breaking changes have had to be made.

- .yy files for standard fonts no longer need to be included in the project. Scribble will automatically parse and set up fonts on boot. No font definition function calls are needed for standard fonts
- Spritefonts should now be added using GameMaker's native `font_add_sprite()` and/or `font_add_sprite_ext()`. No Scribble-specific functions exist to add spritefonts; Scribble will now use GameMaker's own spritefont data
- Scribble is now supported on Opera GX (but not HTML5! Waiting on fixes from YYG still)
- MSDF fonts no longer require a function call to set up, though there is still some setup work to be done. Please check the MSDF documentation for more information
- `.get_glyph_data()` method has been added to text elements. This allows you to get the position of a glyph in a text element, and which unicode character it is exactly
- `.get_text()` method has been added to text elements. This returns the raw text for a page of text, stripped of formatting and command tags
- CJK text now automatically wraps per-character instead of per-word. This was a feature in previous versions, but it is fully automated now with no effort required on behalf of the developer
- Added superfonts to allow for fonts (especially those covering different languages or charactersets) to be combined together transparently
- Animation methods have been removed from text elements and are now globally-scoped. This was a hard decision to make as the people who were using this feature will likely suffer... Sorry. This change has been done to optimise the drawing pipeline as constantly updating shader uniforms is slow, and per-element animation settings were hard to cache
- Right-to-left text rendering
- Support for Hebrew
- Beta support for Arabic. Some rendering behaviours may not be perfect, please report issues as you see them
- Partial support for Thai - requires "C90" Thai fonts to be used)

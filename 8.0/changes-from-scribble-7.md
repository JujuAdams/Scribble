# Coming from Scribble 7.1

Version 8 is, on the surface, rather similar to version 7.1. Calling methods on text elements is still the primary way of interacting with Scribble. However, under the surface, the text parser that powers Scribble has undergone a complete rewrite. Thanks to features added in GameMaker 2.3.4 (and lateR), Scribble can now cut out some of the font definition tedium. Typewriters have changed too, dropping the clumsy and error-prone `.typewriter_*()` functions in preference for a new "typist" system. This is just the start - Scribble version 8 has close to 500 commits between it and version 7.1, making it the most substantial version upgrade to date.

In pursuit of an easier-to-use yet more powerful library, some breaking changes have had to be made.

- .yy files for standard fonts no longer need to be included in the project. Scribble will automatically parse and set up fonts on boot. No font definition function calls are needed for standard fonts
- Spritefonts should now be added using GameMaker's native `font_add_sprite()` and/or `font_add_sprite_ext()`. No Scribble-specific functions exist to add spritefonts; Scribble will now use GameMaker's own spritefont data
- Added `draw_text_scribble()` and `draw_text_scribble_ext()` for immediate plug-and-play usage. These functions are useful for drawing formatted text without needing to navigate Scribble's fluent interface
- Scribble is now supported on Opera GX (but not HTML5! Waiting on fixes from YYG still)
- Drawing text should now be faster than before thanks to some additional streamlining and caching
- Typewriter methods on text elements have been removed in preference for typists
- Typewriter character delay is now more customisable, and has been moved to a method on typists. Per-character delay can now accept a pair of characters to look for
- ...and if you want to ignore all of the delays set up in your text, you now can using the power of the `.ignore_delay()` method for typists (useful for rapidly skipping through text without going all the way to using `.skip()`)
- If you don't want to use typists and would instead like to implement typewriter behaviour yourself, `.reveal()` and `.get_reveal()` allow you to take control yourself. Additionally, `.get_events()` has been added to help find and trigger events if you wish
- MSDF fonts no longer require a function call to set up, though there is still some setup work to be done. Please check the MSDF documentation for more information
- MTSDF fonts can now be used with Scribble, though the alpha channel is not used for anything at the moment
- MSDF drop shadows can now be softened
- Adds text regions via the `[region]` command tag. Regions can be detected using `.region_detect()` and regions can be highlighted using `.region_set_active()`. Text regions are very useful for tooltips and hyperlinks
- Adds `scribble_msdf_thickness_offset()` to dynamically alter the thickness of MSDF fonts. This is useful to tweak the appearance of different fonts to match each other
- Some edge case spritefont issues, including character occasionally being garbled, have now been fixed
- Right-to-left text rendering is now supported
- Beta support for Arabic and Hebrew. Some rendering behaviours may not be perfect, please report issues as you see them
- Partial support for Thai (requires "C90" Thai fonts to be used)
- `.get_glyph_data()` method has been added to text elements. This allows you to get the position of a glyph in a text element, and which unicode character it is exactly
- `.get_text()` method has been added to text elements. This returns the raw text for a page of text, stripped of formatting and command tags
- Scribble configuration has been split into three separate scripts to help guide people to what they're looking for faster
- CJK text now automatically wraps per-character instead of per-word. This was a feature in previous versions, but it is fully automated now with no effort required on behalf of the developer
- Added superfonts to allow for fonts (especially those covering different languages or charactersets) to be combined together transparently
- Fonts can now have bilinear filtering forced on per font. This is useful for rendering clean pixel fonts in high res games, or visa versa
- Added `scribble_font_get_glyph_ranges()` to help debug font support for different languages
- Font outline baking has been simplified down into `scribble_font_bake_outline_4dir`, `..._outline_8dir()`, and `..._outline_8dir_2px()`. This makes the feature easier to use, as well as being a key step in enabling compilation for Opera GX
- Baking shadows into fonts, much like baking outlines, is now possible using the new `scribble_font_bake_shadow()` function
- Fonts can now be renamed (at least for use with Scribble) by using `scribble_font_rename()`
- Animation methods have been removed from text elements and are now globally-scoped. This was a hard decision to make as the people who were using this feature will likely suffer... sorry. This change has been done to optimise the drawing pipeline as constantly updating shader uniforms is slow, and per-element animation settings were hard to cache
- Added `.line_spacing()` to customise the mechanics of spacing out lines
- In addition to `.fit_to_box()` being many, many times faster than previously, the new `.scale_to_box()` method allows for an even faster way to scale text inside a bounding box
- Padding is now baked into text elements using the `.padding()` method. `.get_bbox()` no longer has padding arguments as a result
- `.get_bbox_revealed()` has been added to text elements to allow calculation of the bounding box for only the revealed text
- Removes `SCRIBBLE_SKIP_SPEED_THRESHOLD` as it was a bad idea to begin with
- `SCRIBBLE_IGNORE_PAUSE_BEFORE_PAGEBREAK` can now be turned on or off to automatically disable `[pause]` commands that occur immediately before a natural or forced (`[/page]`) pagebreak
- `.fog()` has been removed since no one was using this feature
- `.z()` can now be used to set the z-coordinate that text elements are drawn at. This will probably end up the same as `.fog()` but you never know...
- Text element templates are now forcibly scoped to the text element when applied to avoid nasty scope-related bugs
- Virtually all constructor variables are now prefixed with `__` in a vain attempt to clean up the global namespace for GameMaker's intellisense
- `[slant]` formatting has now been promoted to a full GPU-accelerated effect. Congratulations `[slant]`, you made it
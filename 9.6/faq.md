# FAQ

---

## What platforms does Scribble Deluxe support?

Everything apart from HTML5. You might run into edge cases on platforms that I don't regularly test; please [report any bugs](https://github.com/JujuAdams/Scribble/issues) if and when you find them.

&nbsp;

## What versions of GameMaker does Scribble Deluxe support?

Version 9 of Scribble Deluxe primarily supports GameMaker 2024.8, and in theory supports every version of GameMaker later than that. Later versions of GameMaker may change functionality in a way that Scribble is not forwards-compatible with, but Scribble uses only native GameMaker functions so is in the best possible position for long-term compatibility.

&nbsp;

## Does this library support GMRT / "new runtime"?

No, GMRT is not supported by this library.

&nbsp;

## What kinds of fonts can Scribble Deluxe draw?

Anything that GameMaker natively supports as a font resource, including spritefonts. Scribble additionally supports SDF fonts which are very useful for mobile games or any game which might have a wide variety of text sizes. Scribble unfortunately doesn't (yet) support fonts added via `font_add()`.

&nbsp;

## Does Scribble Deluxe work with GMLive?

Scribble was confirmed to work with [GMLive](https://yellowafterlife.itch.io/gamemaker-live) using version 7.1.2. At the time of writing, version 8 has not been tested with GMLive.

&nbsp;

## What's the difference between Scribble Junior and Scribble Deluxe?

[Scribble Junior](https://github.com/JujuAdams/ScribbleJunior) is a stripped back lighter text rendering solution compared to Scribble Deluxe. The focus for Scribble Junior is static text that doesn't need to animate where performance is the primary concern. Scribble Deluxe is oriented towards complex text effects where there's a lot of animation and fancy effects going on.

&nbsp;

## Fonts on dynamic texture pages sometimes don't appear!

Previous versions of Scribble had issues with all fonts in dynamic texture groups appearing as invisible even after loading the texture group. This is due to an upstream bug in GameMaker where unloaded texture pages will return invalid dimensions until their texture group has been loaded (and/or fetched). This then leads to glyph UVs being invalid which causes glyphs to appear invisible. Scribble 9.6 adds some glyph UV correction when caching a text model provided that dynamic texture groups for fonts have been loaded.

!> Scribble cannot automatically fix text models that have been cached with invalid data because a dynamic texture group wasn't loaded at the time the text was cached. You must ensure that you're only caching text that relies on dynamic texture group fonts *after* that texture group was loaded.

You can force all text models to refresh themselves with `scribble_refresh_everything()`. After calling this function, all text models will rebuild themselves, correcting any skewiff UV coordinates if they can. You will very likely want to use this after a related dynamic texture group has been loaded to ensure all text models are up to date.

&nbsp;

## I can't use `font_add()` fonts with Scribble Deluxe but I can with Scribble Junior. What's that about?

Scribble Junior is performing a sleight of hand to support `font_add()`. if you use a dynamic font with Scribble Junior then it turns off all of the optimisations and the library instead functions as a nice interface for what is ultimately GameMaker's native text drawing with some extra features. For other types of font, Scribble Junior makes vertex buffers and renders at maximum efficiency.

Scribble Deluxe requires that all text use a custom vertex buffer. This is to support all the animation and other fancy rendering features that Scribble Junior doesn't have. Whilst it's possible to put `font_add()` text into a vertex buffer, it's also 1) slow 2) liable to break. Many people have tried in the past but no one's cracked it just yet. i consider it an open problem.

tl;dr - Scribble Junior gets away with slower rendering when using `font_add()`, Scribble Deluxe cannot use that slower renderer path.

&nbsp;

## Can I use Scribble Junior alongside Scribble Deluxe?

Yes! In fact, I encourage it. [Scribble Junior](https://github.com/JujuAdams/ScribbleJunior) is excellent for static UI text whereas Scribble Deluxe is geared more towards dialogue and animated text.

&nbsp;

## How is Scribble Deluxe licensed? Can I use it for commercial projects?

[Scribble is released under the MIT license](https://github.com/JujuAdams/Scribble/blob/master/LICENSE). This means you can use it for whatever purpose you want, including commercial projects. It'd mean a lot to me if you'd drop my name in your credits (Juju Adams) and/or say thanks, but you're under no obligation to do so.

&nbsp;

## What games are using Scribble Deluxe?

Scribble is being used in [Shovel Knight Pocket Dungeon](https://www.yachtclubgames.com/games/shovel-knight-pocket-dungeon), [Wally and the Fantastic Predators](https://store.steampowered.com/app/1077450/Wally_and_the_FANTASTIC_PREDATORS/), [Stargrove](https://twitter.com/FauxOperative), [Wizarducks](https://twitter.com/wizarducks1) and [many others](https://www.youtube.com/watch?v=KvakyfLhvfU). Scribble gets a lot of real world testing!

&nbsp;

## I think you're missing a useful feature and I'd like you to implement it!

Great! Please make a [feature request](https://github.com/JujuAdams/scribble/issues). Feature requests make Scribble a more fun tool to use and gives me something to think about when I'm bored on public transport.

&nbsp;

## I found a bug, and it both scares and mildly annoys me. What is the best way to get the problem solved?

Please make a [bug report](https://github.com/JujuAdams/scribble/issues). Juju checks GitHub every day and bug fixes usually go out a couple days after that.

&nbsp;

## How do I fix weird spacing on the left hand side when my font wraps to the next line?

I've not yet found a really good solution for this bug, but I did make a workaround. Set the `SCRIBBLE_SPRITEFONT_ALIGN_GLYPHS_LEFT` macro to `true` and this should solve your problems. If it doesn't, please file a [bug report](https://github.com/JujuAdams/scribble/issues) and/or yell at me on the [Discord server](https://discord.gg/8krYCqr).

&nbsp;

## Scribble creates little hangs in my game when I draw lots and lots of text and it's making me sad :(

Efficient text parsing is hard work in any language, but GML makes it even more strenuous. Scribble is about as fast as I can make it. The best thing to do to work around the text caching speed is to pre-cache large amount of text by using the [`.build()`](scribble-methods?id=buildfreeze) method. I recommend pre-caching text during a loading screen or other such pause in gameplay.

&nbsp;

## How do I adjust the height of a line break?

All line breaks in Scribble - either forced line breaks using `\n` or natural line breaks caused by [wrapping text](scribble-methods?id=wrapmaxwidth-maxheight-characterwrap-regenerator) - derive their height from the "height" of the space character in the font currently being used. You can adjust the height of a line break by using [`scribble_glyph_set()`](fonts?id=scribble_glyph_setfontname-character-property-value-relative) and targeting the space character (`" "`).

If you'd only like to adjust the line spacing for a single text element, use the [`.line_height()`](scribble-methods?id=line_heightmin-max-regenerator) method instead.

&nbsp; 

## Can I send you donations? Are you going to start a Patreon?

Thank you for wanting to show your appreciation - it really does mean a lot to me personally - but I'm fortunate enough to have a stable income from gamedev. I'm not looking to join Patreon as a creator at this moment in time. If you'd like to support my work then drop me a credit in your game and/or gimme a shout-out on the social media platform of your choice.

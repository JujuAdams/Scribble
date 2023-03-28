<img src="https://raw.githubusercontent.com/JujuAdams/scribble/master/LOGO.png" width="50%" style="display: block; margin: auto;" />
<h1 align="center">Scribble 9.0</h1>
<p align="center">A modern text renderer for GameMaker 2023.4 by <a href="https://twitter.com/jujuadams" target="_blank">Juju Adams</a></p>

<p align="center"><a href="https://github.com/JujuAdams/scribble/releases/">Download the .yymps</a></p>
<p align="center">Chat about Scribble on the <a href="https://discord.gg/8krYCqr">Discord server</a></p>

&nbsp;

## What is Scribble?

Scribble is a comprehensive text rendering library designed to replace GameMaker's native [`draw_text()` functions](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/Text.htm) without adding unnecessary complexity.

There are a multitude of useful features available:
- Cross-platform, including Opera GX
- In-line colour and font swapping
- In-line sprites, including animation
- Text wrapping (including CJK-compatible wrapping)
- Typewriter
- Events, such as triggering sound effects and screenshake directly from typewriter text
- Automatic [pagination](https://en.wikipedia.org/wiki/Pagination)
- High performance caching
- Font effect baking
- Resolution-independent [SDF fonts](font-sdf)
- Arabic and Hebrew support, and limited Thai and Hindi (Devanagari) support

&nbsp;

## What platforms does Scribble support?

Everything! You might run into edge cases on platforms that I don't regularly test; please [report any bugs](https://github.com/JujuAdams/Scribble/issues) if and when you find them. Please note that diagnosing HTML5 bugs in particular can be frustrating due to the generally patchy nature of GameMaker's JS runtime.

&nbsp;

## What versions of GameMaker does Scribble support?

Version 8 of Scribble primarily supports GameMaker LTS 2022, and in theory supports every version of GameMaker later than that. Later versions of GameMaker may change functionality in a way that Scribble is not forwards-compatible with, but Scribble uses only native GameMaker functions so is in the best possible position for long-term compatibility.

&nbsp;

## How is Scribble licensed? Can I use it for commercial projects?

[Scribble is released under the MIT license](https://github.com/JujuAdams/Scribble/blob/master/LICENSE). This means you can use it for whatever purpose you want, including commercial projects. It'd mean a lot to me if you'd drop my name in your credits (Juju Adams) and/or say thanks, but you're under no obligation to do so.

&nbsp;

## What games are using Scribble?

Scribble is being used in [Shovel Knight Pocket Dungeon](https://www.yachtclubgames.com/games/shovel-knight-pocket-dungeon), [Wally and the Fantastic Predators](https://store.steampowered.com/app/1077450/Wally_and_the_FANTASTIC_PREDATORS/), [Stargrove](https://twitter.com/FauxOperative), [Wizarducks](https://twitter.com/wizarducks1) and [many others](https://www.youtube.com/watch?v=KvakyfLhvfU). Scribble gets a lot of real world testing!

&nbsp;

## I think you're missing a useful feature and I'd like you to implement it!

Great! Please make a [feature request](https://github.com/JujuAdams/scribble/issues). Feature requests make Scribble a more fun tool to use and gives me something to think about when I'm bored on public transport.

&nbsp;

## I found a bug, and it both scares and mildly annoys me. What is the best way to get the problem solved?

Please make a [bug report](https://github.com/JujuAdams/scribble/issues). Juju checks GitHub every day and bug fixes usually go out a couple days after that. You can also grab me on the [Discord server](https://discord.gg/8krYCqr), but that's not a replacement for a nice clear bug report.

&nbsp;

## Who made Scribble?

Scribble is built and maintained by [@jujuadams](https://twitter.com/jujuadams) who has a long history of fiddling with text engines. Juju's worked on a lot of [commercial GameMaker games](http://www.jujuadams.com/). Many, many other people have contributed bug reports and feature requests over the years, too many to list here. Scribble wouldn't exist without them and Juju is eternally grateful for their creativity and patience.

&nbsp;

## Can I send you donations? Are you going to start a Patreon?

Thank you for wanting to show your appreciation - it really does mean a lot to me personally - but I'm fortunate enough to have a stable income from gamedev. I'm not looking to join Patreon as a creator at this moment in time. If you'd like to support my work then drop me a credit in your game and/or gimme a shout-out on the social media platform of your choice.
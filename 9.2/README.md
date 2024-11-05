<img src="https://raw.githubusercontent.com/JujuAdams/scribble/master/LOGO.png" width="50%" style="display: block; margin: auto;" />
<h1 align="center">Scribble Deluxe 9.2</h1>
<p align="center">A modern text renderer for GameMaker by <a href="https://www.jujuadams.com/" target="_blank">Juju Adams</a></p>

<p align="center"><a href="https://github.com/JujuAdams/scribble/releases/">Download the .yymps</a></p>

&nbsp;

## Features

Scribble Deluxe is a comprehensive text rendering library designed to replace GameMaker's native [`draw_text()` functions](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/Text.htm) without adding unnecessary complexity. Scribble's design should feel familiar and intuitive for GameMaker users.

There are a multitude of very useful features available:
- In-line colour and font swapping
- In-line sprites, including animation
- Text wrapping (including CJK-compatible wrapping)
- Typewriter
- Events, such as triggering sound effects and screenshake directly from typewriter text
- Automatic [pagination](https://en.wikipedia.org/wiki/Pagination)
- High performance caching
- Font effect baking
- Resolution-independent SDF fonts
- Arabic and Hebrew support, and limited Thai and Hindi (Devanagari) support

&nbsp;

## Updating

Releases go out once in while, typically expedited if there is a serious bug. This library uses [semantic versioning](https://semver.org/). In short, if the left-most number in the version is increased then this is a "major version increase". Major version increases introduce breaking changes and you'll almost certainly have to rewrite some code. However, if the middle or right-most number in the version is increased then you probably won't have to rewrite any code. For example, moving from `1.1.0` to `2.0.0` is a major version increase but moving from `1.1.0` to `1.2.0` isn't.

?> Please always read patch notes. Very occasionally a minor breaking change in an obscure feature may be introduced by a minor version increase.

At any rate, the process to update is as follows:

1. **Back up your whole project using source control!**
2. Back up the contents of your configuration scripts (`__scribble_config*`) within your project. Duplicating scripts is sufficient
3. Delete all library scripts from your project. Unless you've moved things around, this means deleting the library folder from the asset browser
4. Import the latest [.yymps](https://github.com/JujuAdams/Scribble/releases/)
5. Restore your configuration scripts from the back-up line by line

!> Because configuration macros might be added or removed between versions, it's important to restore your configuration scripts carefully.

## About & Support

Scribble Deluxe supports all GameMaker export platforms, with the exception of HTML5. Scribble Deluxe supports GameMaker 2024.8 (and later). If you'd like to report a bug or suggest a feature, please use the repo's [Issues page](https://github.com/JujuAdams/scribble/issues). Scribble is constantly being maintained and upgraded; bugs are usually addressed within a few days of being reported.

Scribble Deluxe is built and maintained by [Juju Adams](https://www.jujuadams.com/jujuadams) who has a long history of fiddling with text engines. Juju's worked on a lot of commercial GameMaker games. Many, many other people have contributed bug reports and feature requests over the years, too many to list here. Scribble wouldn't exist without them and Juju is eternally grateful for their creativity and patience.

This library will never truly be finished because contributions and suggestions from new users are always welcome. Scribble wouldn't be the same without [your](https://tenor.com/search/whos-awesome-gifs) input! Make a suggestion on the repo's [Issues page](https://github.com/JujuAdams/scribble/issues) if you'd like a feature to be added.

## License

Scribble Deluxe is licensed under the [MIT License](https://github.com/JujuAdams/Scribble/blob/master/LICENSE).

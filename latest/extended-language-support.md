# Extended Lanuage Support

Scribble fully supports Latin, Cyrillic, Simplified Chinese, Traditional Chinese, Japanese, Korean, and Hebrew scripts. Arabic support has been partially tested; Scribble aims to support it fully. Thai script is partially supported. Devanagari and Bengali scripts are not currently supported. Please continue reading for further details.

&nbsp;

## Cyrillic and Other Non-Latin Alphabetic Scripts

Scribble natively supports the vast majority of alphabetic languages. Some ligatures (a glyph that combines two or more component glyphs) will not be supported by Scribble, but they can be added on request. When supporting non-Latin languages please remember to choose a font that contains the necessary glyphs and, additionally, ensure that the font asset you've created inside the GameMaker IDE has the correct character range for the glyphs you wish to draw.

All non-Latin languages are presumed by Scribble to be written from left to right, with the exception of Hebrew which is written from right to left. Again, this can be modified on request. Left-to-right and right-to-left fonts can be combined as you see fit.

&nbsp;

## Chinese, Japanese, and Korean

As with non-Latin alphabetic scripts, Chinese, Japanese, and Korean are natively supported by Scribble. To draw CJK text, you will need to choose an appropriate font and you will also need to define the necessary character range for the glyphs that you need to draw.

!> Chinese and Japanese charactersets in particular tend to get very large which can cause problems. Only add glyphs that you definitely need to your font asset.

CJK text has the additional property where words can be split in the middle when performing text wrapping. This is in contrast to Western languages where words must be kept in one piece and line breaks are added between words. This behaviour can be overridden (for both CJK and non-CJK fonts) by setting the `characterWrap` argument for the `.wrap()` and `.fit_to_box()` text element method.

&nbsp;

## Arabic (beta)

Arabic script represents a significant technical challenging owing to both its right-to-left ordering and the heavy use of ligatures to produce cursive text with a strong, unbroken base line. Scribble currently supports Arabic as a beta feature, pending testing and finessing. As with all non-Latin languages, you will need to pay attention to the font you're using and the character range you have set up. All fonts that contain the requisite glyphs should render Arabic properly. Arabic and non-Arabic text can be mixed as you see fit. Scribble does not automatically subsitute Indo-Arabic numerals in place of Western numerals.

?> There are a handful of Arabic glyph ranges. Scribble requires that "Arabic Presentation Forms B" is available, which lies from`0xFE70` to `0xFEFF` (or `65136` to `65279`). You may also want to add the "Arabic" range too (`0x0600` to `0x6FF`, or `1536` to `1791`). Arabic text renderers, including Scribble, will not generally use glyphs from the "Arabic Presentation Forms A" range unless those glyphs are specifically present in the input text.

&nbsp;

## Thai (limited support)

Regretably, Thai is very difficult to support owing to a myriad of glyph combinations. Whilst I've not had the time to fully implement a Thai renderer (using GSUB and GPOS tables), Scribble does support the legacy "C90" specification for Thai fonts. This means it is possible to render Thai, albeit only using a very limited set of fonts. You can find extensive documentation on how the C90 Thai font fortmate works [here](https://www.sys.kth.se/docs/texlive/texmf-dist/doc/fonts/enc/c90/c90.pdf). Exactly how it works is beyond the scope of this document; the important point is that this technique only works for certain fonts.

?> When rendering Thai, please use a font from [this collection](https://linux.thai.net/pub/thailinux/software/fonts-tlwg/fonts/) of C90 fonts. To be quite honest, I'm not sure which package is the "best" so I chose `ttf-tlwg-0.7.3.zip`. NECTEC, the national technology centre for Thailand, [suggests](https://www.nectec.or.th/pub/review-software/font/national-fonts.html) using Garuda, Kinnari, Loma, or Norasi fonts. The collection I've linked here has a few extra but I am not sure if they all work.

Additionally, Thai script does not customarily put spaces between words as in many other languages. Instead, words visually run into each other. Thai does **not** behave like CJK scripts however and when performing text wrapping, it is expected that words are not split in the middle. This understandably can cause serious issues when trying to text wrap Thai script - if there are no spaces, how do we know where to split words? This is, believe it or not, still an unsolved problem in AI.

Ultimately, the best solution available to us is for zero-width spaces to be inserted between words. If you're using Scribble professionally and in conjunction with a localisation team, please direct them to add zero-width spaces between words. This ensures that the parser understands where to split a line of text for the purposes of text wrapping whilst also ensuring that text is familiar for a native Thai speaker.

&nbsp;

## Devanagari/Hindi (unsupported)

At this time, Devanagari script is not supported by Scribble. In the near future, the "Krutidev" algorithm may make an appearance in Scribble.

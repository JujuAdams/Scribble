# Standard Fonts

&nbsp;

Scribble supports GameMaker's native fonts out of the box with no additional configuration required. Scribble aims to render text as close as possible to what GameMaker natively renders with `draw_text()`. All the same rules and principles apply, including glyph ranges and other font rasterization settings.

Standard fonts can also be used with [superfonts](font-superfont) and [baked effects](font-baking). Please see the relevant pages for information on these features.

?> When specifying a font with Scribble's functions, you should **always** refer to a font by using the **name of the font** as a **string**.

Scribble allows you to change font in two ways: via `.font()` and via a command tag. Here's some examples of how to use a spritefont with those features:

<!-- tabs:start -->

#### **Native GameMaker**

```js
draw_set_font(fnt_large);
draw_text(10, 10, "Hello world");
draw_set_font(-1);
```

#### **`.font()`**

```js
scribble("Hello world").font("fnt_large").draw(10, 10);
```

#### **`Command Tag`**

```js
scribble("[fnt_large]Hello world").draw(10, 10);
```

<!-- tabs:end -->
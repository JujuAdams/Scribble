# Spritefonts

&nbsp;

Scribble supports GameMaker's native spritefonts out of the box with no addition configuration required. Scribble aims to render text as close as possible to what GameMaker natively renders with `draw_text()`.

Standard fonts can also be used with [superfonts](font-superfont) and [baked effects](font-baking). Please see the relevant pages for information on these features.

Scribble allows you to change font in two ways: via `.font()` and via a command tag. When specifying a font with Scribble's functions, you should **always** refer to a font by using the the **name of the sprite** as a **string**.

!> Do not try to use the retuned value from `font_sprite_add()` or `font_sprite_add_ext()` with Scribble, it won't work; use the name of the sprite instead.

<!-- tabs:start -->

#### **Native GameMaker**

```js
///Game Start Event
global.font = font_add_sprite_ext(spr_pixely, "0123456789+-*/=ABCDEFGHIJKLMNOPQRSTUVWXYZ", true, 2);

///Draw Event
draw_set_font(fnt_large);
draw_text(10, 10, "Hello world");
draw_set_font(-1);
```

#### **`.font()`**

```js
///Game Start Event
font_add_sprite_ext(spr_pixely, "0123456789+-*/=ABCDEFGHIJKLMNOPQRSTUVWXYZ", true, 2);

//DRaw Event
scribble("Hello world").font("spr_pixely").draw(10, 10);
```

#### **`Command Tag`**

```js
///Game Start Event
font_add_sprite_ext(spr_pixely, "0123456789+-*/=ABCDEFGHIJKLMNOPQRSTUVWXYZ", true, 2);

///Draw Event
scribble("[spr_pixely]Hello world").draw(10, 10);
```

<!-- tabs:end -->
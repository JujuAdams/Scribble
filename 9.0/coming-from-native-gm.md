# Coming from Native GM

&nbsp;

Scribble offers a [lot of advantages](features) over GameMaker's native text renderer. However, this library can take some time to get used to. This short article serves as a guide to implementing common GameMaker functions.

For very simple use, you can use the stripped-back [`draw_text_scribble()` and `draw_text_scribble_ext()` functions](quick-functions). To achieve more complex effects, you'll need to use Scribble's method-based [fluent interface](scribble-methods) to draw text exactly how you want.

&nbsp;

## draw_set_font() ###

<!-- tabs:start -->

#### **GameMaker Native**

```js
draw_set_font(fnt_large);
draw_text(10, 10, "Hello world!");
draw_set_font(-1);
```

#### **`draw_text_scribble()`**

```js
draw_text_scribble(10, 10, "[fnt_large]Hello world!");
```

#### **`scribble()`**

```js
scribble("[fnt_large]Hello world!").draw(10, 10);
```

<!-- tabs:end -->

&nbsp;

## draw_set_halign() ###

<!-- tabs:start -->

#### **GameMaker Native**

```js
draw_set_halign(fa_center);
draw_text(10, 10, "Hello world!");
draw_set_halign(fa_left);
```

#### **`draw_text_scribble()`**

```js
draw_text_scribble(10, 10, "[fa_center]Hello world!");
```

#### **`scribble()`**

```js
scribble("[fa_center]Hello world!").draw(10, 10);
```

<!-- tabs:end -->

&nbsp;

## draw_set_color() ###

<!-- tabs:start -->

#### **GameMaker Native**

```js
draw_set_color(c_red);
draw_text(10, 10, "Hello world!");
draw_set_color(c_white);
```

#### **`draw_text_scribble()`**

```js
draw_text_scribble(10, 10, "[c_red]Hello world!");
```

#### **`scribble()`**

```js
scribble("[c_red]Hello world!").draw(10, 10);
```

<!-- tabs:end -->

&nbsp;

## draw_set_font() + draw_set_halign() + draw_set_color() ###

<!-- tabs:start -->

#### **GameMaker Native**

```js
draw_set_font(fnt_large);
draw_set_halign(fa_center);
draw_set_color(c_red);
draw_text(10, 10, "Hello world!");
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_color(c_white);
```

#### **`draw_text_scribble()`**

```js
draw_text_scribble(10, 10, "[fnt_large][fa_center][c_red]Hello world!");
```

#### **`scribble()`**

```js
scribble("[fnt_large][fa_center][c_red]Hello world!").draw(10, 10);
```

<!-- tabs:end -->

&nbsp;

## Partial Text Colouring ###

<!-- tabs:start -->

#### **GameMaker Native**

```js
draw_text(10, 10, "Hello");
draw_set_color(c_red);
draw_text(10 + string_width("Hello"), 10, " world!");
draw_set_color(c_white);
```

#### **`draw_text_scribble()`**

```js
draw_text_scribble(10, 10, "Hello[c_red] world!");
```

#### **`scribble()`**

```js
scribble("Hello[c_red] world!").draw(10, 10);
```

<!-- tabs:end -->

&nbsp;

## In-line Sprites ###

<!-- tabs:start -->

#### **GameMaker Native**

```js
var _x = 10;
draw_text(_x, 10, "This weapon costs ");
_x += string_width("This weapon costs ");
draw_sprite(spr_coin, 0, _x, 10);
_x += sprite_get_width(spr_coin);
draw_text(_x, 10, "1,200");
```

#### **`draw_text_scribble()`**

```js
draw_text_scribble(10, 10, "This weapon costs [spr_coin,0]1,200");
```

#### **`scribble()`**

```js
scribble("This weapon costs [spr_coin,0]1,200").draw(10, 10);
```

<!-- tabs:end -->

&nbsp;

## draw_set_valign() ###

<!-- tabs:start -->

#### **GameMaker Native**

```js
draw_set_valign(fa_bottom);
draw_text(10, room_height-10, "Hello world!");
draw_set_valign(fa_top);
```

#### **`draw_text_scribble()`**

```js
draw_text_scribble(10, room_height-10, "[fa_bottom]Hello world!");
```

#### **`scribble()`**

```js
scribble("[fa_bottom]Hello world!").draw(10, room_height-10);
```

<!-- tabs:end -->

&nbsp;

## Textbox Borders ###

<!-- tabs:start -->

#### **GameMaker Native**

```js
var _w = string_width("Hello world!");
var _h = string_height("Hello world!");
draw_set_color(c_white);
draw_rectangle(5, 5, 15 + _w, 15 + _h, false); //5px border
draw_set_color(c_black);
draw_text(10, 10, "Hello world!");
```

#### **`draw_text_scribble()`**

```js
var _w = string_width_scribble("Hello world!");
var _h = string_height_scribble("Hello world!");
draw_set_color(c_white);
draw_rectangle(5, 5, 15 + _w, 15 + _h, false); //5px border
draw_set_color(c_black);
draw_text_scribble(10, 10, "Hello world!");
```

#### **`scribble()`**

```js
var _text = scribble("[c_black]Hello world!").padding(5, 5, 5, 5);
var _bbox = _text.get_bbox(10, 10);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, false);
_text.draw(10, 10);
```

<!-- tabs:end -->
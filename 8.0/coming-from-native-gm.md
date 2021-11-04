# Coming from Native GM

&nbsp;

Scribble offers a [lot of advantages](features) over GameMaker's native text renderer. However, this library can take some time to get used to. This short article serves as a guide to implementing common GameMaker functions. Scribble has many more text formatting commands that you can use, check out the [Text Formatting](text-formatting) article.

&nbsp;

-----

## draw_set_font() / draw_set_halign() / draw_set_color() ###

GameMaker:
```GML
draw_set_color(c_red);
draw_set_halign(fa_center);
draw_set_font(fnt_large);
draw_text(10, 10, "Hello world!");
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_font(-1);
```

Scribble:
```GML
scribble("[fnt_large][c_red][fa_left]Hello world!").draw(10, 10);
```

&nbsp;

## Partial Text Colouring ###

GameMaker:
```GML
draw_text(10, 10, "Hello");
draw_set_color(c_red);
draw_text(10 + string_width("Hello"), 10, " world!");
draw_set_color(c_white);
```

Scribble:
```GML
scribble("Hello[c_red] world!").draw(10, 10);
```

&nbsp;

## In-line Sprites ###

GameMaker:
```GML
var _x = 10;
draw_text(_x, 10, "This weapon costs ");
_x += string_width("This weapon costs ");
draw_sprite(spr_coin, 0, _x, 10);
_x += sprite_get_width(spr_coin);
draw_text_x, 10, "1,200");
```

Scribble:
```GML
scribble("This weapon costs [spr_coin,0]1,200").draw(10, 10);
```

&nbsp;

## draw_set_valign() ###

GameMaker:
```GML
draw_set_valign(fa_bottom);
draw_text(10, room_height - 10, "Hello world!");
draw_set_valign(fa_top);
```

Scribble:
```GML
scribble("[fa_bottom]Hello world!").draw(10, room_height - 10);
```

&nbsp;

## Text Borders ###

GameMaker:
```GML
var _w = string_get_width("Hello world!");
var _h = string_get_height("Hello world!");
draw_set_color(c_white);
draw_rectangle(5, 5, 15 + _w, 15 + _h, false); //5px border
draw_set_color(c_black);
draw_text(10, 10, "Hello world!");
```

Scribble:
```GML
var _text = scribble("[c_black]Hello world!");
var _bbox = _text.get_bbox(10, 10, 5, 5, 5, 5);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, false);
_text.draw(10, 10);
```
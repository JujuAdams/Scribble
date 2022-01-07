Scribble offers a [lot of advantages](https://github.com/JujuAdams/ScribbleOldDocs/wiki/(6.0.0)-Features) over GameMaker's native text renderer. However, this library can take some time to get used to. This short article serves as a guide to implementing common GameMaker functions using Scribble.

&nbsp;

-----

### draw_set_font() / draw_set_halign() / draw_set_color() ###

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

Scribble, using [`scribble_set_starting_format()`](https://github.com/JujuAdams/ScribbleOldDocs/wiki/(6.0.0)-scribble_set_starting_format):
```GML
scribble_set_starting_format("fnt_large", c_red, fa_left);
scribble_draw(10, 10, "Hello world!");
scribble_reset();
```

&nbsp;

-----

### Partial Text Colouring ###

GameMaker:
```GML
draw_text(10, 10, "Hello");
draw_set_color(c_red);
draw_text(10 + string_width("Hello"), 10, " world!");
draw_set_color(c_white);
```

Scribble, using [`scribble_draw()`](https://github.com/JujuAdams/ScribbleOldDocs/wiki/(6.0.0)-scribble_draw):
```GML
scribble_draw(10, 10, "Hello[c_red] world!");
```

&nbsp;

-----

### In-line Sprites ###

GameMaker:
```GML
var _x = 10;
draw_text(_x, 10, "This weapon costs ");
_x += string_width("This weapon costs ");
draw_sprite(spr_coin, 0, _x, 10);
_x += sprite_get_width(spr_coin);
draw_text_x, 10, "1,200");
```

Scribble, using [`scribble_draw()`](https://github.com/JujuAdams/ScribbleOldDocs/wiki/(6.0.0)-scribble_draw):
```GML
scribble_draw(10, 10, "This weapon costs [spr_coin,0]1,200");
```

&nbsp;

-----

### draw_set_valign() ###

GameMaker:
```GML
draw_set_valign(fa_bottom);
draw_text(10, room_height - 10, "Hello world!");
draw_set_valign(fa_top);
```

Scribble, using [`scribble_scribble_set_box_align()`](https://github.com/JujuAdams/ScribbleOldDocs/wiki/(6.0.0)-scribble_set_box_align):
```GML
scribble_scribble_set_box_align(undefined, fa_bottom);
scribble_draw(10, room_height - 10, "Hello world!");
scribble_reset();
```

&nbsp;

-----

### Text Borders ###

GameMaker:
```GML
var _w = string_get_width("Hello world!");
var _h = string_get_height("Hello world!");
draw_set_color(c_white);
draw_rectangle(5, 5, 15 + _w, 15 + _h, false); //5px border
draw_set_color(c_black);
draw_text(10, 10, "Hello world!");
```

Scribble, using [`scribble_get_bbox()`](https://github.com/JujuAdams/ScribbleOldDocs/wiki/(6.0.0)-scribble_get_bbox):
```GML
var _bbox = scribble_get_bbox(10, 10, "Hello world!", 5, 5, 5, 5); //5px border
draw_set_color(c_white);
draw_rectangle(_bbox[0], _bbox[1], _bbox[2], _bbox[3], false);
scribble_draw(10, 10, "[c_black]Hello world!");
```
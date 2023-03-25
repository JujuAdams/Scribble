var _x = 10;
var _y = 10;

var _element = scribble("scribble_blend_sprites_get() = ", scribble_blend_sprites_get(), " (hold SPACE to toggle)");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble(@"[spr_coin] <-- basic animation
[c_red][spr_white_coin] <-- red coin![/]
[rainbow][spr_white_coin] <-- rainbow coin![/]
[cycle, 60, 100, 0, 200][spr_white_coin] <-- colour cycle coin!
[scale,2][spr_vertical_spacing][/scale] <-- vertically spaced sprite").draw(_x, _y);
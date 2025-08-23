// Feather disable all

image_angle += 0.5;

draw_self();

scribble("Here's some text")
.align("pin_center", fa_top)
.wrap(sprite_width, sprite_height) //or fit_to_box() or scale_to_box()
.origin(sprite_xoffset, sprite_yoffset)
.transform(1, 1, image_angle)
.blend(c_black, 1)
.draw(x, y);
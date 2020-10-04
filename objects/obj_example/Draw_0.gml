var _x = (room_width - (textbox_width + textbox_height + 50)) div 2;
var _y = (room_height - (textbox_height + 30)) div 2;

//Draw main text body
draw_set_colour($422D32);
draw_rectangle(_x, _y, _x + textbox_width + 20, _y + textbox_height + 20, false);
draw_set_colour(c_white);

text_element.draw(_x + 10, _y + 10);

//Draw portrait
draw_set_colour($422D32);
draw_rectangle(_x + textbox_width + 30, _y, _x + textbox_width + textbox_height + 50, _y + textbox_height + 20, false);
draw_set_colour(c_white);

if (sprite_exists(textbox_portrait))
{
    draw_sprite(textbox_portrait, 0, _x + textbox_width + 40, _y + 10);
}

if (textbox_name != undefined)
{
    //Draw name tag
    var _element = scribble(textbox_name).align(fa_right, fa_bottom);
    var _name_box = _element.get_bbox(_x + textbox_width + 10, _y - 20, 10, 10, 10, 10);
    
    draw_set_colour($422D32);
    draw_rectangle(_name_box.left, _name_box.top, _name_box.right, _name_box.bottom, false);
    draw_set_colour(c_white);
    
    _element.draw(_x + textbox_width + 10, _y - 20);
}

//Draw a little icon once the text has finished displaying, or if text display is paused
if ((text_element.get_typewriter_state() >= 1) || text_element.get_typewriter_paused())
{
    draw_sprite(spr_white_coin, 0, _x + textbox_width + 20, _y + textbox_height + 20);
}
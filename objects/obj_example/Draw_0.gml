var _x = (room_width - (textbox_width + textbox_height + 50)) div 2;
var _y = (room_height - (textbox_height + 30)) div 2;

//Draw main text body
draw_set_colour($422D32);
draw_rectangle(_x, _y, _x + textbox_width + 20, _y + textbox_height + 20, false);
draw_set_colour(c_white);

scribble_draw(_x + 10, _y + 10, text_element);

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
    scribble_set_box_align(fa_right, fa_bottom);
    var _name_box = scribble_get_bbox(_x + textbox_width + 10, _y - 20, textbox_name, 10, 10, 10, 10);
    
    draw_set_colour($422D32);
    draw_rectangle(_name_box[0], _name_box[1], _name_box[2], _name_box[3], false);
    draw_set_colour(c_white);
    
    scribble_draw(_x + textbox_width + 10, _y - 20, textbox_name);
    scribble_reset();
}

//Draw a little icon once the text has finished displaying, or if text display is paused
if ((scribble_autotype_get(text_element) >= 1) || scribble_autotype_is_paused(text_element))
{
    draw_sprite(spr_white_coin, 0, _x + textbox_width + 20, _y + textbox_height + 20);
}
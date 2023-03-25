scribble("aaaaaaaaaaaaaaaaaaaa \nc").draw(410, 10);



exit;



var _demo_string = "[pin_center][scale,1.4]Contrary to popular belief,[/]\n\n[fa_justify]Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet...\", comes from a line in section 1.10.32.";

//var _demo_string = "a bc\nd ef";
//var _wrap = 35;

if (keyboard_check(vk_space))
{
    wrap_x = mouse_x;
    wrap_y = mouse_y;
}

var _element = scribble(_demo_string).layout_wrap_split_pages(wrap_x, wrap_y);

if (mouse_check_button_pressed(mb_left)) page++;
if (mouse_check_button_pressed(mb_right)) page--;

page = clamp(page, 0, _element.get_page_count()-1);

_element.page(page);
_element.draw(10, 10);

draw_line(10, 0, 10, room_height);
draw_line(0, 10, room_width, 10);
draw_line(10 + wrap_x, 0, 10 + wrap_x, room_height);
draw_line(0, 10 + wrap_y, room_width, 10 + wrap_y);
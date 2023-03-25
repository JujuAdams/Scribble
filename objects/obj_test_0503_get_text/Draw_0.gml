if (!SCRIBBLE_ALLOW_TEXT_GETTER)
{
    draw_text(10, 10, "SCRIBBLE_ALLOW_TEXT_GETTER must be set to <true> for this test case");
    return;
}

var _text = "[fa_middle][c_red]Hi world[/page]oijwagow\n\ngawoijgawj egonawegh";

var _element = scribble(_text).layout_wrap(50);
if (keyboard_check_pressed(vk_up  )) _element.page(_element.get_page()-1);
if (keyboard_check_pressed(vk_down)) _element.page(_element.get_page()+1);

var _page_text = _element.get_text(_element.get_page());
draw_set_font(scribble_fallback_font);
draw_text(10, 10, _page_text);
draw_rectangle(10, 10, 10 + string_width(_page_text), 10 + string_height(_page_text), true);

_element.draw(10, 150);
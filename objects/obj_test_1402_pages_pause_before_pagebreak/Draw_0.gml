var _element = scribble("[fa_center]First page, we should skip the pause[pause][/page]Second page. we should *not* skip the pause[pause][sdm,test][/page]Third page");
_element.draw(room_width/2, room_height/2, typist);

draw_set_font(scribble_fallback_font);
draw_text(10, 10, typist.GetTypePaused()? "PAUSED" : "");

if (typist.GetTypePaused())
{
    if (keyboard_check_pressed(vk_space)) typist.TypeUnpause();
}
else if (typist.GetTypeState() == 1)
{
    if (keyboard_check_pressed(vk_space))
    {
        var _page = (_element.get_page() + 1) mod _element.get_page_count();
        _element.page(_page);
    }
}
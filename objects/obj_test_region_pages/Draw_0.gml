var _element = scribble("This examples shows how to move between pages using regions. [region,1]Click here to move to the next page[/region].[/page]This is second page. [region,2]This clickable region[/page]spreads over two pages[/region]. Please [region,0]click here[/region] to return to the first page.");
_element.draw(10, 10);

var _region = _element.region_detect(10, 10, mouse_x, mouse_y);
_element.region_set_active(_region, c_red, 0.5);

if (is_string(_region) && mouse_check_button_pressed(mb_left))
{
    show_debug_message("Click region " + _region);
    _element.page(real(_region));
}
var _string = string_join("\n",
    $"block size = {element.get_block_size()} lines",
    $"block count = {element.get_block_count()}",
);
draw_text(10, 10, _string);

element.debug_draw_bbox(10, 200, c_white, 0.3, false);
element.debug_draw_blocks(10, 200);

if (element.get_point_inside(350, 200, mouse_x, mouse_y))
{
    element.debug_draw_bbox(350, 200, c_white, 0.3, false);
}

element.draw(350, 200);
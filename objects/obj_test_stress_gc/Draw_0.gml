if (toggle)
{
    test_text = "[fa_middle][fa_center]";
    repeat(1000) test_text += chr(choose(irandom_range(32, 90), irandom_range(94, 126)));
    
    var _t = get_timer();
    scribble(test_text).wrap(500).draw(room_width div 2, room_height div 2);
    _t = get_timer() - _t;
    
    counter++;
    smoothed_time = lerp(smoothed_time, _t, 0.01);
}

var _cache_state = __scribble_initialize().__cache_state;

draw_set_font(scribble_fallback_font);
draw_text(10,  10, "models cached = " + string(variable_struct_names_count(_cache_state.__mcache_dict)));
draw_text(10,  30, "elements cached = " + string(array_length(_cache_state.__ecache_array)) + "/" + string(variable_struct_names_count(_cache_state.__ecache_dict)));
draw_text(10,  50, "vertex buffers cached = " + string(array_length(_cache_state.__gc_vbuff_refs)) + "/" + string(array_length(_cache_state.__gc_vbuff_ids)));
draw_text(10,  70, "glyph grids cached = " + string(array_length(_cache_state.__gc_grid_refs)) + "/" + string(array_length(_cache_state.__gc_grid_ids)));
draw_text(10,  90, "counter = " + string(counter));
               
draw_text(10, 130, "time taken = " + string(smoothed_time));
draw_text(10, 150, "fps_real = " + string(fps_real));
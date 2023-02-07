#macro __draw_texture_flush__  draw_texture_flush
#macro draw_texture_flush      __scribble_draw_texture_flush

function __scribble_draw_texture_flush()
{
    __draw_texture_flush__();
    
    if (SCRIBBLE_VERBOSE) __scribble_trace("Warning! Rebuilding all font_add() caches because draw_texture_flush() was called");
    
    //FIXME - This is a workaround for behaviour of draw_texture_flush() on Windows in 2023.1
    //        Calling draw_texture_flush() clears all surfaces but doesn't actually destroy them
    //        This means we'll have surfaces lying around without any contents
    //        Code below forces all font_add() caches to rebuild themselves by wiping their glyph map
    static _font_add_cache_array = __scribble_get_state().__font_add_cache_array;
    var _i = 0;
    repeat(array_length(_font_add_cache_array))
    {
        var _weak_ref = _font_add_cache_array[_i];
        if (!weak_ref_alive(_weak_ref))
        {
            array_delete(_font_add_cache_array, _i, 1);
        }
        else
        {
            _weak_ref.ref.__rebuild_surface();
            ++_i;
        }
    }
}
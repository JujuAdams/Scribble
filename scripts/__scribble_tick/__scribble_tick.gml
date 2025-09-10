// Feather disable all

function __scribble_tick()
{
    static _scribble_state = __scribble_system().__state;
    static _cache_state = __scribble_system().__cache_state;
    
    static _vbuff_index   = 0;
    static _gc_vbuff_refs = _cache_state.__gc_vbuff_refs;
    static _gc_vbuff_ids  = _cache_state.__gc_vbuff_ids;
    
    static _grid_index   = 0;
    static _gc_grid_refs = _cache_state.__gc_grid_refs;
    static _gc_grid_ids  = _cache_state.__gc_grid_ids;
    
    if (__userTickSize == undefined)
    {
        __tickSize = clamp(delta_time / 16667, 1/5, 5);
    }
    
    _scribble_state.__frames++;
    
    //If there's been a change in os_is_paused() state then force a refresh of shader uniforms
    static _os_is_paused = undefined;
    if (os_is_paused() != _os_is_paused)
    {
        _os_is_paused = os_is_paused();
        
        static _scribble_state = __scribble_system().__state;
        with(_scribble_state)
        {
            __shader_anim_desync            = true;
            __shader_anim_desync_to_default = true;
        }
    }
    
    
    
    #region Check through vertex buffer weak references to clean anything up
    
    var _size = array_length(_gc_vbuff_refs);
    _vbuff_index = min(_vbuff_index, _size);
    
    repeat(max(__SCRIBBLE_GC_STEP_SIZE, ceil(sqrt(_size)))) //Choose a step size that scales with the size of the cache, but doesn't get too big
    {
        _vbuff_index--;
        if (_vbuff_index < 0)
        {
            _vbuff_index += array_length(_gc_vbuff_refs);
            if (_vbuff_index < 0)
            {
                _vbuff_index = 0;
                break;
            }
        }
        
        var _weak = _gc_vbuff_refs[_vbuff_index];
        if (!weak_ref_alive(_weak))
        {
            if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Cleaning up vertex buffer ", _gc_vbuff_ids[_vbuff_index]);
            vertex_delete_buffer(_gc_vbuff_ids[_vbuff_index]);
            array_delete(_gc_vbuff_refs, _vbuff_index, 1);
            array_delete(_gc_vbuff_ids,  _vbuff_index, 1);
        }
    }
    
    #endregion
    
    
    
    #region Check through glyph grid weak references to clean anything up
    
    var _size = array_length(_gc_grid_refs);
    _grid_index = min(_grid_index, _size);
    
    repeat(max(__SCRIBBLE_GC_STEP_SIZE, ceil(sqrt(_size)))) //Choose a step size that scales with the size of the cache, but doesn't get too big
    {
        _grid_index--;
        if (_grid_index < 0)
        {
            _grid_index += array_length(_gc_grid_refs);
            if (_grid_index < 0)
            {
                _grid_index = 0;
                break;
            }
        }
        
        var _weak = _gc_grid_refs[_grid_index];
        if (!weak_ref_alive(_weak))
        {
            if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Cleaning up glyph grid ", _gc_grid_ids[_grid_index]);
            ds_grid_destroy(_gc_grid_ids[_grid_index]);
            array_delete(_gc_grid_refs, _grid_index, 1);
            array_delete(_gc_grid_ids,  _grid_index, 1);
        }
    }
    
    #endregion
}

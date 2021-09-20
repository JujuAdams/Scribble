function __scribble_class_page() constructor
{
    __text = "";
    
    __character_count = 0;
    
    __glyph_start = undefined;
    __glyph_end   = undefined;
    
    __vertex_buffer_array           = [];
    __texture_to_vertex_buffer_dict = {};
    
    __events = {};
    
    static __get_vertex_buffer = function(_texture, _font_data, _for_text, _model_struct)
    {
        var _pointer_string = string(_texture);
        var _data = __texture_to_vertex_buffer_dict[$ _pointer_string];
        if (_data == undefined)
        {
            if (_font_data == undefined)
            {
                var _font_msdf_range = undefined;
            }
            else
            {
                var _font_msdf_range = _font_data.msdf_range;
            }
            
            if (_font_msdf_range == undefined)
            {
                _model_struct.uses_standard_font = true;
                var _shader = __shd_scribble;
            }
            else
            {
                _model_struct.uses_msdf_font = true;
                var _shader = __shd_scribble_msdf;
            }
            
            var _vbuff = vertex_create_buffer(); //TODO - Can we preallocate this? i.e. copy "for text" system we had in the old version
            vertex_begin(_vbuff, global.__scribble_vertex_format);
            
            var _data = array_create(__SCRIBBLE_VERTEX_BUFFER.__SIZE);
            _data[@ __SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER] = _vbuff;
            _data[@ __SCRIBBLE_VERTEX_BUFFER.TEXTURE      ] = _texture;
            _data[@ __SCRIBBLE_VERTEX_BUFFER.MSDF_RANGE   ] = _font_msdf_range;
            _data[@ __SCRIBBLE_VERTEX_BUFFER.TEXEL_WIDTH  ] = texture_get_texel_width(_texture);
            _data[@ __SCRIBBLE_VERTEX_BUFFER.TEXEL_HEIGHT ] = texture_get_texel_height(_texture);
            _data[@ __SCRIBBLE_VERTEX_BUFFER.SHADER       ] = _shader;
            
            __scribble_gc_add_vbuff(self, _vbuff);
            __vertex_buffer_array[@ array_length(__vertex_buffer_array)] = _data;
            __texture_to_vertex_buffer_dict[$ _pointer_string] = _data;
            
            return _vbuff;
        }
        else
        {
            return _data[__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER];
        }
    }
    
    static __finalize_vertex_buffers = function(_freeze)
    {
        var _i = 0;
        repeat(array_length(__vertex_buffer_array))
        {
            var _vbuff = __vertex_buffer_array[_i][__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER];
            vertex_end(_vbuff);
            if (_freeze) vertex_freeze(_vbuff);
            
            ++_i;
        }
    }
    
    static __flush = function()
    {
        var _i = 0;
        repeat(array_length(__vertex_buffer_array))
        {
            var _vbuff = __vertex_buffer_array[_i][__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER];
            vertex_delete_buffer(_vbuff);
            __scribble_gc_remove_vbuff(_vbuff);
            
            ++_i;
        }
        
        __texture_to_vertex_buffer_dict = {};
        array_resize(__vertex_buffer_array, 0);
    }
    
    static __submit = function(_element)
    {
        var _shader = undefined;
        var _i = 0;
        repeat(array_length(__vertex_buffer_array))
        {
            var _data = __vertex_buffer_array[_i];
            
            if (_data[__SCRIBBLE_VERTEX_BUFFER.SHADER] != _shader)
            {
                _shader = _data[__SCRIBBLE_VERTEX_BUFFER.SHADER];
                shader_set(_shader);
            }
            
            if (_shader == __shd_scribble_msdf)
            {
                //Force texture filtering when using MSDF fonts
                var _old_tex_filter = gpu_get_tex_filter();
                gpu_set_tex_filter(true);
                
                //Set shader uniforms unique to the MSDF shader
                shader_set_uniform_f(global.__scribble_msdf_u_vTexel, _data[__SCRIBBLE_VERTEX_BUFFER.TEXEL_WIDTH], _data[__SCRIBBLE_VERTEX_BUFFER.TEXEL_HEIGHT]);
                shader_set_uniform_f(global.__scribble_msdf_u_fMSDFRange, _element.msdf_feather_thickness*_data[__SCRIBBLE_VERTEX_BUFFER.MSDF_RANGE]);
                
                vertex_submit(_data[__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER], pr_trianglelist, _data[__SCRIBBLE_VERTEX_BUFFER.TEXTURE]);
                
                //Reset the texture filtering
                gpu_set_tex_filter(_old_tex_filter);
            }
            else
            {
                //Other shaders don't need extra work
                vertex_submit(_data[__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER], pr_trianglelist, _data[__SCRIBBLE_VERTEX_BUFFER.TEXTURE]);
            }
            
            ++_i;
        }
        
        shader_reset();
    }
}
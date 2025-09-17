// Feather disable all
/// Creates a new font with an outline based on a given source font
///
/// @param sourceFontName              Name, as a string, of the font to use as a basis for the effect
/// @param newFontName                 Name of the new font to create, as a string
/// @param shader                      Shader to use
/// @param emptyOutlineSize            Outline around the outside of every output glyph, in pixels. A value of 2 is typical
/// @param leftPad                     Padding around the outside of every *input* glyph. Positive values give more space. e.g. For a shader that adds a outline of 2px around the entire glyph, *all* padding arguments should be set to <2>
/// @param topPad                      "
/// @param rightPad                    "
/// @param bottomPad                   "
/// @param separationDelta             Change in every glyph's SCRIBBLE_GLYPH_SEPARATION value. For a shader that adds a outline of 2px around the entire glyph, this value should be 4px
/// @param smooth                      Set to <true> to turn on linear interpolation
/// @param [surfaceSize=2048]          Size of the surface to use. Defaults to 2048x2048
/// @param [markAsRasterEffect=false]

function scribble_font_bake_shader(_sourceFontName, _newFontName, _shader, _outline, _padL, _padT, _padR, _padB, _separation, _smooth, _textureSize = 2048, _markAsRasterEffect = false)
{
    static _vertexFormat = (function()
    {
            vertex_format_begin();
            vertex_format_add_position();
            vertex_format_add_color();
            vertex_format_add_texcoord();
            return vertex_format_end();
    })();
    
    if (!is_string(_sourceFontName))
    {
        __ScribbleError("Fonts should be specified using their name as a string.\n(Input was an invalid datatype)");
        exit;
    }
    
    if (!is_string(_newFontName))
    {
        __ScribbleError("Fonts should be specified using their name as a string.\n(Input was an invalid datatype)");
        exit;
    }
    
    if (_sourceFontName == _newFontName)
    {
        __ScribbleError("Source font and new font cannot share the same name");
        return undefined;
    }

    static _fontDataMap = __ScribbleSystem().__fontDataMap;
    var _srcFontData = _fontDataMap[? _sourceFontName];
    if (!is_struct(_srcFontData))
    {
        __ScribbleError("Source font \"", _sourceFontName, "\" not found\n\"", _newFontName, "\" will not be available");
        return undefined;
    }
    
    if (_srcFontData.__renderType == __SCRIBBLE_RENDER_RASTER_WITH_EFFECTS)
    {
        __ScribbleError("Source font cannot already have effects baked into it");
        return undefined;
    }
    
    if (_srcFontData.__renderType == __SCRIBBLE_RENDER_SDF)
    {
        __ScribbleError("Source font cannot be an SDF font");
        return undefined;
    }
    
    _srcFontData.__EnsureMaterialTexturesFetched();
    _srcFontData.__EnsureTexelData();
    
    var _srcGlyphGrid = _srcFontData.__glyphDataGrid;
    var _glyphCount = ds_grid_width(_srcGlyphGrid);
    
    //Create a new font
    var _newFontData = new __ScribbleClassFont(_newFontName, _glyphCount, undefined, false, true,
                                                 _srcFontData.__underlineY + _padT + _padB,
                                                 _srcFontData.__strikeY    + _padT + _padB);
    _newFontData.__bilinear = _smooth;
    _newFontData.__runtime  = true;
    _newFontData.__height   = _srcFontData.__height + _padT + _padB;
    
    var _newGlyphsGrid = _newFontData.__glyphDataGrid;
    
    //Copy the raw data over from the source font (this include the glyph map, glyph grid, and other assorted properties)
    _srcFontData.__CopyTo(_newFontData, false);
    
    if (_markAsRasterEffect) _newFontData.__renderType = __SCRIBBLE_RENDER_RASTER_WITH_EFFECTS;
    
    
    
    //We spin up vertex buffers on demand based on what textures are being used
    var _vbuffDataMap = ds_map_create();
    
    var _lineX      = 0;
    var _lineY      = 0;
    var _lineHeight = 0;
    
    var _i = 0;
    repeat(_glyphCount)
    {
        var _material = _srcGlyphGrid[# _i, __SCRIBBLE_GLYPH_PROPR_MATERIAL];
        var _texture = _material.__texture;
        
        if (not texture_is_ready(_texture))
        {
            __ScribbleError($"Font \"{_sourceFontName}\" texture {string(_texture)} not ready.\nIs the source graphic in an unloaded or unfetched dynamic texture group?\nMaterial debug name:\"{_material.__debugFontName}\"\nMaterial key:\"{_material.__key}\"");
        }
        
        //Ignore any glyphs with invalid textures
        if (_texture == undefined)
        {
            ++_i;
            continue;
        }
        
        var _width  = _srcGlyphGrid[# _i, __SCRIBBLE_GLYPH_PROPR_WIDTH ];
        var _height = _srcGlyphGrid[# _i, __SCRIBBLE_GLYPH_PROPR_HEIGHT];
        var _u0     = _srcGlyphGrid[# _i, __SCRIBBLE_GLYPH_PROPR_U0    ];
        var _v0     = _srcGlyphGrid[# _i, __SCRIBBLE_GLYPH_PROPR_V0    ];
        var _u1     = _srcGlyphGrid[# _i, __SCRIBBLE_GLYPH_PROPR_U1    ];
        var _v1     = _srcGlyphGrid[# _i, __SCRIBBLE_GLYPH_PROPR_V1    ];
        
        var _widthExt  = _width  + _outline + _padL + _padR;
        var _heightExt = _height + _outline + _padT + _padB;
        
        //Check to see if we have space on this texture page
        if (_lineY + _heightExt >= _textureSize)
        {
            __ScribbleError("No space left on ", _textureSize, "x", _textureSize, " texture page\nPlease increase the size of the texture page");
            vertex_end(_vbuff);
            vertex_delete_buffer(_vbuff);
            return;
        }
        
        //Line wrap glyphs
        if (_lineX + _widthExt >= _textureSize)
        {
            _lineX       = 0;
            _lineY      += _lineHeight;
            _lineHeight  = 0;
        }
        
        //Find a vertex buffer for this particular glyph's texture
        var _vbuffData = _vbuffDataMap[? string(_texture)];
        if (_vbuffData == undefined)
        {
            //If we don't have a vertex buffer for this texture, create a new one and store a reference to it
            var _vbuff = vertex_create_buffer();
            vertex_begin(_vbuff, _vertexFormat);
            
            _vbuffDataMap[? string(_texture)] = {
                __vertexBuffer: _vbuff,
                __texture: _texture,
            };
        }
        else
        {
            var _vbuff = _vbuffData.__vertexBuffer;
        }
        
        var _l = _padL + _lineX;
        var _t = _padT + _lineY;
        var _r = _l + _width;
        var _b = _t + _height;
        
        vertex_position(_vbuff, _l, _t); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u0, _v0);
        vertex_position(_vbuff, _r, _t); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
        vertex_position(_vbuff, _l, _b); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
        
        vertex_position(_vbuff, _r, _t); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
        vertex_position(_vbuff, _r, _b); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u1, _v1);
        vertex_position(_vbuff, _l, _b); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
            
        _newGlyphsGrid[# _i, __SCRIBBLE_GLYPH_PROPR_U0] = _lineX;
        _newGlyphsGrid[# _i, __SCRIBBLE_GLYPH_PROPR_V0] = _lineY;
        _newGlyphsGrid[# _i, __SCRIBBLE_GLYPH_PROPR_U1] = _lineX + _width  + _padL + _padR;
        _newGlyphsGrid[# _i, __SCRIBBLE_GLYPH_PROPR_V1] = _lineY + _height + _padT + _padB;
        
        _lineX += _widthExt;
        _lineHeight = max(_lineHeight, _heightExt);
        
        ++_i;
    }
    
    //Draw the vertex buffers to a surface, then bake that surface into a sprite
    var _surface0 = surface_create(_textureSize, _textureSize);
    
    //Draw the source glyphs to a surface
    surface_set_target(_surface0);
    draw_clear_alpha(c_white, 0.0);
    gpu_set_blendenable(false);
    
    //Iterate over all vertex buffers we created and draw those vertex buffers to the first surface
    var _vbuff_data_array = ds_map_values_to_array(_vbuffDataMap);
    var _i = 0;
    repeat(array_length(_vbuff_data_array))
    {
        var _vbuffData = _vbuff_data_array[_i];
        var _vbuff = _vbuffData.__vertexBuffer;
        
        vertex_end(_vbuff);
        vertex_submit(_vbuff, pr_trianglelist, _vbuffData.__texture);
        vertex_delete_buffer(_vbuff);
        
        ++_i;
    }
    
    ds_map_destroy(_vbuffDataMap);
    var _surface1 = surface_create(_textureSize, _textureSize);
    
    gpu_set_blendenable(true);
    surface_reset_target();
    
    var _texture = surface_get_texture(_surface0);
    
    //Draw one surface to another using the shader
    surface_set_target(_surface1);
    draw_clear_alpha(c_white, 0.0);
    
    var _oldFilter = gpu_get_tex_filter();
    gpu_set_tex_filter(_smooth);
    gpu_set_blendenable(false);
    
    shader_set(_shader);
    shader_set_uniform_f(shader_get_uniform(_shader, "u_vTexel"), texture_get_texel_width(_texture), texture_get_texel_height(_texture));
    draw_surface(_surface0, 0, 0);
    shader_reset();
    
    gpu_set_tex_filter(_oldFilter);
    gpu_set_blendenable(true);
    surface_reset_target();
    
    surface_free(_surface0);
    
    //Make a sprite from the effect surface to make the texture stick
    var _sprite = sprite_create_from_surface(_surface1, 0, 0, _textureSize, _textureSize, false, false, 0, 0);
    _newFontData.__sourceSprite = _sprite;
    surface_free(_surface1);
    
    //Create a new material for this font
    var _newMaterial = __ScribbleGetMaterial(_newFontName, __ScribbleSpriteGetTextureIndex(_sprite, 0), _newFontData.__renderType, undefined, undefined, _newFontData.__bilinear);
    
    //Make bulk corrections to various glyph properties based on the input parameters
    ds_grid_add_region(_newGlyphsGrid, 0, __SCRIBBLE_GLYPH_PROPR_X_OFFSET,    _glyphCount-1, __SCRIBBLE_GLYPH_PROPR_X_OFFSET,    -_padL);
    ds_grid_add_region(_newGlyphsGrid, 0, __SCRIBBLE_GLYPH_PROPR_Y_OFFSET,    _glyphCount-1, __SCRIBBLE_GLYPH_PROPR_Y_OFFSET,    -_padT);
    ds_grid_add_region(_newGlyphsGrid, 0, __SCRIBBLE_GLYPH_PROPR_WIDTH,       _glyphCount-1, __SCRIBBLE_GLYPH_PROPR_WIDTH,       _padL + _padR);
    ds_grid_add_region(_newGlyphsGrid, 0, __SCRIBBLE_GLYPH_PROPR_HEIGHT,      _glyphCount-1, __SCRIBBLE_GLYPH_PROPR_HEIGHT,      _padT + _padB);
    ds_grid_add_region(_newGlyphsGrid, 0, __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT, _glyphCount-1, __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT, _padT + _padB);
    ds_grid_add_region(_newGlyphsGrid, 0, __SCRIBBLE_GLYPH_PROPR_SEPARATION,  _glyphCount-1, __SCRIBBLE_GLYPH_PROPR_SEPARATION,  _separation);
    ds_grid_set_region(_newGlyphsGrid, 0, __SCRIBBLE_GLYPH_PROPR_MATERIAL,    _glyphCount-1, __SCRIBBLE_GLYPH_PROPR_MATERIAL,    _newMaterial);
    
    //Figure out the new UVs using some bulk commands
    var _spriteUVs = sprite_get_uvs(_sprite, 0);
    var _spriteU0 = _spriteUVs[0];
    var _spriteV0 = _spriteUVs[1];
    var _spriteU1 = _spriteUVs[2];
    var _spriteV1 = _spriteUVs[3];
    
    ds_grid_multiply_region(_newGlyphsGrid, 0, __SCRIBBLE_GLYPH_PROPR_U0, _glyphCount-1, __SCRIBBLE_GLYPH_PROPR_V1, 1/_textureSize);
    ds_grid_multiply_region(_newGlyphsGrid, 0, __SCRIBBLE_GLYPH_PROPR_U0, _glyphCount-1, __SCRIBBLE_GLYPH_PROPR_U1, _spriteU1 - _spriteU0); //Note we're adjusting U0 and U1 in the same pass
    ds_grid_multiply_region(_newGlyphsGrid, 0, __SCRIBBLE_GLYPH_PROPR_V0, _glyphCount-1, __SCRIBBLE_GLYPH_PROPR_V1, _spriteV1 - _spriteV0); //Note we're adjusting V0 and V1 in the same pass
    ds_grid_add_region(_newGlyphsGrid, 0, __SCRIBBLE_GLYPH_PROPR_U0, _glyphCount-1, __SCRIBBLE_GLYPH_PROPR_U1, _spriteU0); //Note we're adjusting U0 and U1 in the same pass
    ds_grid_add_region(_newGlyphsGrid, 0, __SCRIBBLE_GLYPH_PROPR_V0, _glyphCount-1, __SCRIBBLE_GLYPH_PROPR_V1, _spriteV0); //Note we're adjusting V0 and V1 in the same pass
    
    //All texels are automatically valid
    ds_grid_set_region(_newGlyphsGrid, 0, __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID, _glyphCount-1, __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID, true);
    
    _newFontData.__EnsureAdditionalCharacters();
}

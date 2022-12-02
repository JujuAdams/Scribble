/// Adds a space character to a font
/// 
/// @param fontName  The target font, as a string
/// @param width     Width of the empty character

function scribble_glyph_add_space(_font, _width)
{
    if (!ds_map_exists(global.__scribble_font_data, _font))
    {
        __scribble_error("Font \"", _font, "\" not found");
        exit;
    }
    
    var _font_data = global.__scribble_font_data[? _font];
    
    var _grid = _font_data.__glyph_data_grid;
    var _map  = _font_data.__glyphs_map;
    
    if (ds_grid_width(_grid) <= 0)
    {
        __scribble_error("Font \"", _font, "\" must have glyphs before setting the space width");
        return;
    }
    
    //Ensure a space character exists
    var _index = _map[? 32];
    if (_index == undefined)
    {
        var _index = ds_grid_width(_grid);
        ds_grid_resize(_grid, ds_grid_width(_grid)+1, ds_grid_height(_grid));
        _map[? 32] = _index;
    }
    
    _grid[# _index, SCRIBBLE_GLYPH.CHARACTER            ] = " ";
    
    _grid[# _index, SCRIBBLE_GLYPH.UNICODE              ] = 0x20;
    _grid[# _index, SCRIBBLE_GLYPH.BIDI                 ] = __SCRIBBLE_BIDI.WHITESPACE;
    
    _grid[# _index, SCRIBBLE_GLYPH.X_OFFSET             ] = 0;
    _grid[# _index, SCRIBBLE_GLYPH.Y_OFFSET             ] = 0;
    _grid[# _index, SCRIBBLE_GLYPH.WIDTH                ] = _width;
    _grid[# _index, SCRIBBLE_GLYPH.HEIGHT               ] = _grid[# 0, SCRIBBLE_GLYPH.HEIGHT];
    _grid[# _index, SCRIBBLE_GLYPH.FONT_HEIGHT          ] = _grid[# 0, SCRIBBLE_GLYPH.FONT_HEIGHT];
    _grid[# _index, SCRIBBLE_GLYPH.SEPARATION           ] = _width;
    _grid[# _index, SCRIBBLE_GLYPH.LEFT_OFFSET          ] = 0;
    _grid[# _index, SCRIBBLE_GLYPH.FONT_SCALE           ] = 1;
    
    _grid[# _index, SCRIBBLE_GLYPH.TEXTURE              ] = _grid[# 0, SCRIBBLE_GLYPH.TEXTURE];
    _grid[# _index, SCRIBBLE_GLYPH.U0                   ] = 0;
    _grid[# _index, SCRIBBLE_GLYPH.V0                   ] = 0;
    _grid[# _index, SCRIBBLE_GLYPH.U1                   ] = 0;
    _grid[# _index, SCRIBBLE_GLYPH.V1                   ] = 0;
    
    _grid[# _index, SCRIBBLE_GLYPH.MSDF_PXRANGE         ] = undefined;
    _grid[# _index, SCRIBBLE_GLYPH.MSDF_THICKNESS_OFFSET] = undefined;
    _grid[# _index, SCRIBBLE_GLYPH.BILINEAR             ] = undefined;
}
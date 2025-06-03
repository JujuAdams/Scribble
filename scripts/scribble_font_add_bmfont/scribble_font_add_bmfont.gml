// Feather disable all

/// @desc Adds a BMFont (.fnt) file to Scribble.
/// @param bmfontPath       Path to the .fnt file
/// @param spriteAsset      Sprite asset to use for the font texture
/// @param [fontName]       Name to give the font (if not specified, will use the name in the .fnt file)
/// @param [mapString]      Optional string for character mapping (only for compatibility with older BMFont files)
function scribble_font_add_bmfont(_bmfont_path, _sprite_asset, _font_name = undefined, _map_string = undefined)
{
    // Make sure the sprite exists
    if (!sprite_exists(_sprite_asset))
    {
        __scribble_error("Sprite asset doesn't exist");
        return;
    }
    
    // Make sure the BMFont file exists
    if (!file_exists(_bmfont_path))
    {
        __scribble_error("BMFont file \"", _bmfont_path, "\" doesn't exist");
        return;
    }
    
    if (SCRIBBLE_VERBOSE) __scribble_trace("Adding BMFont from \"", _bmfont_path, "\" with sprite ", sprite_get_name(_sprite_asset));
    
    // Parse the BMFont data
    var _font_info = __scribble_process_bmfont(_bmfont_path, _sprite_asset, _map_string);
    
    // Use provided font name or the one from the BMFont file
    if (_font_name == undefined) _font_name = _font_info.name;
    
    if (_font_info.texture == undefined)
    {
        __scribble_error("Failed to create texture for BMFont");
        return;
    }
    
    // Get the texture dimensions
    var _texture_width  = texture_get_width(_font_info.texture);
    var _texture_height = texture_get_height(_font_info.texture);
    
    // Create texture UVs array [u0, v0, u1, v1]
    var _texture_uvs = [0, 0, 1, 1];
    
    // Add the font to Scribble
    __scribble_font_add_from_info(_font_name, _texture_uvs, _font_info, false, false);
    
    return _font_name;
}

/// @desc Internal function to parse a BMFont file
/// @param bmfontPath    Path to the .fnt file
/// @param spriteAsset   Sprite asset to use for the font texture
/// @param mapString     Character map string (optional)
function __scribble_process_bmfont(_bmfont_path, _sprite_asset, _map_string)
{
    // Open BMFont file
    var _file = file_text_open_read(_bmfont_path);
    if (_file == -1)
    {
        __scribble_error("Failed to open BMFont file \"", _bmfont_path, "\"");
        return undefined;
    }
    
    // Create the font info structure that will be returned
    var _font_info = {
        texture: undefined,
        glyphs: {},
        ascenderOffset: 0,
        sdfEnabled: false,
        size: 0
    };
    
    // Variables to store BMFont metadata
    var _base_line = 0;
    var _line_height = 0;
    var _chars = {};
    var _kernings = [];
    
    // Get the texture from the sprite
    _font_info.texture = sprite_get_texture(_sprite_asset, 0);
    
    // Parse the BMFont file line by line
    while (!file_text_eof(_file))
    {
        var _line = file_text_read_string(_file);
        file_text_readln(_file);
        
        // Skip empty lines
        if (_line == "") continue;
        
        // Parse BMFont tags
        var _parts = string_split(_line, " ");
        var _tag = _parts[0];
        
        // Extract key-value parameters from the line
        var _params = {};
        var _i = 1;
        repeat(array_length(_parts) - 1)
        {
            var _param = _parts[_i];
            var _pos = string_pos("=", _param);
            if (_pos > 0)
            {
                var _key = string_copy(_param, 1, _pos - 1);
                var _value = string_copy(_param, _pos + 1, string_length(_param) - _pos);
                
                // Remove quotes if present
                if (string_char_at(_value, 1) == "\"" && string_char_at(_value, string_length(_value)) == "\"")
                {
                    _value = string_copy(_value, 2, string_length(_value) - 2);
                }
                
                _params[$ _key] = _value;
            }
            _i++;
        }
        
        // Process each tag type
        switch (_tag)
        {
            case "info":
                _font_info.name = _params[$ "face"] ?? "bmfont";
                _font_info.size = real(_params[$ "size"] ?? "0");
                break;
                
            case "common":
                _line_height = real(_params[$ "lineHeight"] ?? "0");
                _base_line = real(_params[$ "base"] ?? "0");
                _font_info.ascenderOffset = _line_height - _base_line;
                break;
                
            case "char":
                var _char_id = real(_params[$ "id"] ?? "0");
                _chars[$ string(_char_id)] = {
                    x: real(_params[$ "x"] ?? "0"),
                    y: real(_params[$ "y"] ?? "0"),
                    width: real(_params[$ "width"] ?? "0"),
                    height: real(_params[$ "height"] ?? "0"),
                    xoffset: real(_params[$ "xoffset"] ?? "0"),
                    yoffset: real(_params[$ "yoffset"] ?? "0"),
                    xadvance: real(_params[$ "xadvance"] ?? "0"),
                    page: real(_params[$ "page"] ?? "0")
                };
                break;
                
            case "kerning":
                array_push(_kernings, {
                    first: real(_params[$ "first"] ?? "0"),
                    second: real(_params[$ "second"] ?? "0"),
                    amount: real(_params[$ "amount"] ?? "0")
                });
                break;
        }
    }
    
    file_text_close(_file);
    
    // Convert BMFont character data to Scribble's glyph format
    var _char_names = variable_struct_get_names(_chars);
    var _i = 0;
    repeat(array_length(_char_names))
    {
        var _char_id = _char_names[_i];
        var _char_data = _chars[$ _char_id];
        var _unicode = real(_char_id);
        
        // Create the glyph entry in the format Scribble expects
        var _glyph = {
            char: _unicode,
            x: _char_data.x,
            y: _char_data.y,
            w: _char_data.width,
            h: _char_data.height,
            offset: _char_data.xoffset,
            shift: _char_data.xadvance,
            yoffset: _char_data.yoffset  // Store yoffset for use in font creation
        };
        
        // Add kerning data if available
        if (array_length(_kernings) > 0)
        {
            var _kerning_array = [];
            var _j = 0;
            repeat(array_length(_kernings))
            {
                var _kerning = _kernings[_j];
                if (_kerning.second == _unicode)
                {
                    array_push(_kerning_array, _kerning.first);   // First character
                    array_push(_kerning_array, _kerning.amount);  // Kerning amount
                }
                _j++;
            }
            
            if (array_length(_kerning_array) > 0)
            {
                _glyph.kerning = _kerning_array;
            }
        }
        
        // Store the glyph in the font info
        _font_info.glyphs[$ chr(_unicode)] = _glyph;
        
        _i++;
    }
    
    return _font_info;
}

/// Helper function to split a string
/// @param {string} string_to_split - The string to split
/// @param {string} delimiter - The delimiter to split on
/// @returns {array} Array of split strings
function string_split(_string, _delimiter)
{
    var _result = [];
    var _pos = 0;
    var _delimiter_length = string_length(_delimiter);
    
    // Handle empty string
    if (_string == "") return [_string];
    
    // Split the string
    while (true)
    {
        var _next_pos = string_pos_ext(_delimiter, _string, _pos);
        if (_next_pos == 0)
        {
            // Add the last substring
            array_push(_result, string_copy(_string, _pos + 1, string_length(_string) - _pos));
            break;
        }
        else
        {
            // Add the substring
            array_push(_result, string_copy(_string, _pos + 1, _next_pos - _pos - 1));
            _pos = _next_pos + _delimiter_length - 1;
        }
    }
    
    return _result;
}
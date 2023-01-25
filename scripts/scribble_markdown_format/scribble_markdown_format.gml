/// @param string

#macro __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE  _next_value = buffer_peek(_buffer, buffer_tell(_buffer)-1, buffer_u8);

var _string = "";
_string += "# Header\n";
_string += "Some text\n";
_string += "## Header 2\n";
_string += "- list\n";
_string += "- list\n";
_string += "- list\n";
_string += "### Header 3\n";
_string += "\n";

show_message(scribble_markdown_format(_string));

function scribble_markdown_format(_string)
{
    __scribble_initialize();
    
    static _func_modify_buffer = function(_buffer_a, _buffer_size, _delete_size, _insert_string, _write_pos = buffer_tell(_buffer_a)-2)
    {
        static _buffer_b = __scribble_get_buffer_b();
        
        var _copy_pos  = _write_pos + _delete_size;
        var _copy_size = _buffer_size - _copy_pos;
        
        var _insert_size = string_byte_length(_insert_string);
        var _recopy_size = _insert_size + _copy_size;
        
        buffer_poke(_buffer_b, 0, buffer_text, _insert_string);
        buffer_copy(_buffer_a, _copy_pos, _copy_size, _buffer_b, _insert_size);
        buffer_copy(_buffer_b, 0, _recopy_size, _buffer_a, _write_pos);
        
        buffer_seek(_buffer_a, buffer_seek_relative, _insert_size-1);
        
        return _insert_size - _delete_size;
    }
    
    static _func_character_ends_word = function(_value)
    {
        static _bidi_map = __scribble_get_glyph_data().__bidi_map;
        var _bidi = _bidi_map[? _value];
        return ((_bidi == __SCRIBBLE_BIDI.WHITESPACE) || (_bidi == __SCRIBBLE_BIDI.SYMBOL));
    }
    
    static _buffer = __scribble_get_buffer_a();
    
    static _markdown_styles_struct = __scribble_get_state().__markdown_styles_struct;
    var _start_body        = "[fnt_body]";
    var _start_header1     = "[fnt_header1]";
    var _start_header2     = "[fnt_header2]";
    var _start_header3     = "[fnt_header3]";
    var _start_body        = "[fnt_body]";
    var _start_italic      = "[fnt_italic]";
    var _start_bold        = "[fnt_bold]";
    var _start_bold_italic = "[fnt_bold_italic]";
    var _start_bullet      = "[spr_image]" + _start_body;
    var _start_quote       = "[indent]" + _start_body;
    var _end_quote         = "[/indent]";
    
    buffer_seek(_buffer, buffer_seek_start, 0);
    buffer_write(_buffer, buffer_text, _start_body); //Prefix the whole string with the body text
    buffer_write(_buffer, buffer_string, _string);
    var _buffer_size = buffer_tell(_buffer);
    buffer_seek(_buffer, buffer_seek_start, string_byte_length(_start_body));
    
    var _newline      = true;
    var _italic       = false;
    var _bold         = false;
    var _quote        = false;
    var _header_level = 0;
    
    var _prev_value = 0;
    var _value      = 0;
    var _next_value = buffer_read(_buffer, buffer_u8);
    
    while(true)
    {
        if (_next_value == 0) break;
        
        _value = _next_value;
        var _next_value = buffer_read(_buffer, buffer_u8);
        
        //Newline
        if ((_value == 10) || (_value == 13))
        {
            _newline = true;
            
            if (_quote)
            {
                _quote = false;
                
                _buffer_size += _func_modify_buffer(_buffer, _buffer_size, 0, _end_quote);
                __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
            }
            else if (_header_level > 0)
            {
                _header_level = 0;
                
                _buffer_size += _func_modify_buffer(_buffer, _buffer_size, 0, _start_body);
                __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
            }
            
            continue;
        }
        
        //Searching for the first character on a line
        if (_newline)
        {
            if ((_value == ord(">")) && (_next_value == 0x20))
            {
                //Insert quote block
                _buffer_size += _func_modify_buffer(_buffer, _buffer_size, 2, _start_quote);
                __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                
                _italic = false;
                _bold   = false;
                
                _newline = false;
                continue;
            }
            else if (_value == ord("#"))
            {
                _header_level = 1;
                var _header_peek = buffer_tell(_buffer)-1;
                
                while(true)
                {
                    var _header_next_value = buffer_peek(_buffer, _header_peek, buffer_u8);
                    if (_header_next_value == ord(" "))
                    {
                        break;
                    }
                    else if (_header_next_value != ord("#"))
                    {
                        _header_level = 0;
                        break;
                    }
                    
                    ++_header_level;
                    ++_header_peek;
                }
                
                if (_header_level > 0)
                {
                    if (_header_level == 1)
                    {
                        _buffer_size += _func_modify_buffer(_buffer, _buffer_size, 2, _start_header1);
                    }
                    else if (_header_level == 2)
                    {
                        _buffer_size += _func_modify_buffer(_buffer, _buffer_size, 3, _start_header2);
                    }
                    else if (_header_level >= 3)
                    {
                        _buffer_size += _func_modify_buffer(_buffer, _buffer_size, 4, _start_header3);
                    }
                    
                    __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                    
                    _italic = false;
                    _bold   = false;
                    
                    _newline = false;
                    continue;
                }
            }
            else if ((_value == ord("-")) && (_next_value == 0x20))
            {
                //Insert unordered list indent
                _buffer_size += _func_modify_buffer(_buffer, _buffer_size, 1, _start_bullet);
                __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                
                _italic = false;
                _bold   = false;
                
                _newline = false;
                continue;
            }
            else if ((_value >= 48) && (_value <= 57))
            {
                var _is_ordered_list = false;
                var _number_peek = buffer_tell(_buffer);
                
                while(true)
                {
                    var _number_next_value = buffer_peek(_buffer, _number_peek, buffer_u8);
                    if ((_number_next_value == ord(".")) || (_number_next_value == ord(")")))
                    {
                        _is_ordered_list = true;
                        break;
                    }
                    else if ((_number_next_value < 48) || (_number_next_value > 57))
                    {
                        break;
                    }
                    
                    ++_number_peek;
                }
                
                if (_is_ordered_list)
                {
                    //TODO - Insert ordered list indent
                    _italic = false;
                    _bold   = false;
                }
                
                _newline = false;
                continue;
            }
            
            if (_value <= 0x20) continue;
            
            _newline = false;
            //Fall through to parse the first character
        }
        
        //Parse text
        if ((_value == ord("*")) && (_func_character_ends_word(_prev_value) || _func_character_ends_word(_next_value)))
        {
            if (_next_value == ord("*"))
            {
                _bold = !_bold;
                var _delete_size = 2;
            }
            else
            {
                _italic = !_italic;
                var _delete_size = 1;
            }
            
            if (_italic)
            {
                if (_bold)
                {
                    //Insert [bi] tag
                    _buffer_size += _func_modify_buffer(_buffer, _buffer_size, _delete_size, _start_bold_italic);
                    __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                }
                else
                {
                    //Insert [i] tag
                    _buffer_size += _func_modify_buffer(_buffer, _buffer_size, _delete_size, _start_italic);
                    __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                }
            }
            else
            {
                if (_bold)
                {
                    //Insert [b] tag
                    _buffer_size += _func_modify_buffer(_buffer, _buffer_size, _delete_size, _start_bold);
                    __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                }
                else
                {
                    //Insert [/b] tag
                    _buffer_size += _func_modify_buffer(_buffer, _buffer_size, _delete_size, _start_body);
                    __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                }
            }
        }
        else if ((_value == ord("_")) && (_func_character_ends_word(_prev_value) || _func_character_ends_word(_next_value)))
        {
            _italic = !_italic;
            
            if (_italic)
            {
                if (_bold)
                {
                    //Insert [bi] tag
                    _buffer_size += _func_modify_buffer(_buffer, _buffer_size, 1, _start_bold_italic);
                    __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                }
                else
                {
                    //Insert [i] tag
                    _buffer_size += _func_modify_buffer(_buffer, _buffer_size, 1, _start_italic);
                    __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                }
            }
            else
            {
                if (_bold)
                {
                    //Insert [b] tag
                    _buffer_size += _func_modify_buffer(_buffer, _buffer_size, 1, _start_bold);
                    __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                }
                else
                {
                    //Insert [/b] tag
                    _buffer_size += _func_modify_buffer(_buffer, _buffer_size, 1, _start_body);
                    __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                }
            }
        }
        else if ((_value == ord("!")) && (_next_value == ord("[")))
        {
            //TODO - Insert image
        }
        else if (_value == ord("\\"))
        {
            if (_next_value == 0) return;
            
            //Delete \
            _buffer_size += _func_modify_buffer(_buffer, _buffer_size, 1, "");
            __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
        }
        else
        {
            if (_value == ord("["))
            {
                var _is_link = false;
                
                //TODO - Check for region
                
                if (_is_link)
                {
                    
                }
                else
                {
                    _prev_value = _value;
                }
            }
            else
            {
                _prev_value = _value;
            }
        }
    }
    
    buffer_seek(_buffer, buffer_seek_start, 0);
    return buffer_read(_buffer, buffer_string);
}
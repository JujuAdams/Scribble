/// @param string
/// @param [insertMacros=false]

#macro __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE  _next_value = buffer_peek(_buffer, buffer_tell(_buffer)-1, buffer_u8);

#macro __SCRIBBLE_MARKDOWN_TOGGLE_BOLD  if (_new_style == "body")\
                                        {\
                                            _new_style = "bold";\
                                        }\
                                        else if (_new_style == "bold")\
                                        {\
                                            _new_style = "body";\
                                        }\
                                        else if (_new_style == "italic")\
                                        {\
                                            _new_style = "bold_italic";\
                                        }\
                                        else if (_new_style == "bold_italic")\
                                        {\
                                            _new_style = "italic";\
                                        }\
                                        if (_old_style != _new_style) _write_style = true;

#macro __SCRIBBLE_MARKDOWN_TOGGLE_ITALIC  if (_new_style == "body")\
                                          {\
                                              _new_style = "italic";\
                                          }\
                                          else if (_new_style == "italic")\
                                          {\
                                              _new_style = "body";\
                                          }\
                                          else if (_new_style == "bold")\
                                          {\
                                              _new_style = "bold_italic";\
                                          }\
                                          else if (_new_style == "bold_italic")\
                                          {\
                                              _new_style = "bold";\
                                          }\
                                          if (_old_style != _new_style) _write_style = true;


#macro __SCRIBBLE_MARKDOWN_SET_STYLE  if (_write_style)\
                                      {\
                                          _write_style = false;\
                                          ;\
                                          if (_insert_macros)\
                                          {\
                                              _buffer_size += _func_insert_buffer(_buffer, _buffer_size, ((_old_style == undefined)? "" : "[/" + string(_old_style) + "]") + "[" + string(_new_style) + "]");\
                                          }\
                                          else\
                                          {\
                                              var _old_style_struct = (_old_style == undefined)? {} : (_markdown_styles_struct[$ _old_style] ?? _fallback_styles_struct[$ _old_style]);\
                                              var _new_style_struct = _markdown_styles_struct[$ _new_style] ?? _fallback_styles_struct[$ _new_style];\
                                              ;\
                                              var _insert_string = _old_style_struct[$ "suffix"] ?? "";\
                                              ;\
                                              var _old_value = _old_style_struct[$ "font"];\
                                              var _new_value = _new_style_struct[$ "font"];\
                                              if (_old_value != _new_value) _insert_string += (_new_value == undefined)? "[/font]" : ("[" + _new_value + "]");\
                                              ;\
                                              _old_value = _old_style_struct[$ "scale"] ?? 1;\
                                              _new_value = _new_style_struct[$ "scale"] ?? 1;\
                                              if (_old_value != _new_value) _insert_string += (_new_value == 1)? "[/scale]" : ("[scale," + string(_new_value) + "]");\
                                              ;\
                                              _old_value = _old_style_struct[$ "color"];\
                                              _new_value = _new_style_struct[$ "color"];\
                                              if (_old_value != _new_value) _insert_string += (_new_value == undefined)? "[/color]" : ("[d#" + _new_value + "]");\
                                              ;\
                                              _old_value = (_old_style_struct[$ "italic"] ?? 0) | (2*(_old_style_struct[$ "bold"] ?? 0));\
                                              _new_value = (_new_style_struct[$ "italic"] ?? 0) | (2*(_new_style_struct[$ "bold"] ?? 0));\
                                              if (_old_value != _new_value)\
                                              {\
                                                  if (_new_value == 0)\
                                                  {\
                                                      if (_old_value == 1)\
                                                      {\
                                                          _insert_string += "[/i]";\
                                                      }\
                                                      else if (_old_value == 2)\
                                                      {\
                                                          _insert_string += "[/b]";\
                                                      }\
                                                      else if (_old_value == 3)\
                                                      {\
                                                          _insert_string += "[/bi]";\
                                                      }\
                                                  }\
                                                  else if (_new_value == 1)\
                                                  {\
                                                      _insert_string += "[i]";\
                                                  }\
                                                  else if (_new_value == 2)\
                                                  {\
                                                      _insert_string += "[b]";\
                                                  }\
                                                  else if (_new_value == 3)\
                                                  {\
                                                      _insert_string += "[bi]";\
                                                  }\
                                              }\
                                              ;\
                                              _insert_string += _new_style_struct[$ "prefix"] ?? "";\
                                              ;\
                                              _buffer_size += _func_insert_buffer(_buffer, _buffer_size, _insert_string);\
                                          }\
                                          ;\
                                          __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE\
                                          ;\
                                          _old_style = _new_style;\
                                      }



function scribble_markdown_format(_string, _insert_macros = false)
{
    __scribble_initialize();
    
    static _func_delete_buffer = function(_buffer_a, _buffer_size, _delete_size, _pos = buffer_tell(_buffer_a)-2)
    {
        static _buffer_b = __scribble_get_buffer_b();
        
        var _copy_pos  = _pos + _delete_size;
        var _copy_size = _buffer_size - _copy_pos;
        
        buffer_copy(_buffer_a, _copy_pos, _copy_size, _buffer_b, 0);
        buffer_copy(_buffer_b, 0, _copy_size, _buffer_a, _pos);
        
        buffer_seek(_buffer_a, buffer_seek_relative, -1);
        
        return -_delete_size;
    }
    
    static _func_insert_buffer = function(_buffer_a, _buffer_size, _insert_string, _write_pos = buffer_tell(_buffer_a)-2)
    {
        static _buffer_b = __scribble_get_buffer_b();
        
        var _insert_size = string_byte_length(_insert_string);
        if (_insert_size <= 0) return 0;
        
        var _copy_size   = _buffer_size - _write_pos;
        var _recopy_size = _insert_size + _copy_size;
        
        buffer_poke(_buffer_b, 0, buffer_text, _insert_string);
        buffer_copy(_buffer_a, _write_pos, _copy_size, _buffer_b, _insert_size);
        buffer_copy(_buffer_b, 0, _recopy_size, _buffer_a, _write_pos);
        
        buffer_seek(_buffer_a, buffer_seek_relative, _insert_size-1);
        
        return _insert_size;
    }
    
    static _func_delete_and_insert_buffer = function(_buffer_a, _buffer_size, _delete_size, _insert_string = "", _write_pos = buffer_tell(_buffer_a)-2)
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
    
    static _markdown_styles_struct = __scribble_get_state().__markdown_styles_struct;
    
    static _fallback_styles_struct = undefined;
    if (_fallback_styles_struct == undefined)
    {
        _fallback_styles_struct = {
            body: {
            },
            
            header1: {
                bold:   true,
                italic: true,
                scale:  1.6,
            },
            
            header2: {
                bold:  true,
                scale: 1.4,
            },
            
            header3: {
                italic: true,
                scale:  1.2,
            },
            
            quote: {
                italic: true,
                scale:  1.1,
            },
            
            bold: {
                bold: true,
            },
            
            italic: {
                italic: true,
            },
            
            bold_italic: {
                bold:   true,
                italic: true,
            },
            
            bullet_sprite: spr_coin,
            
            link: {
                bold:  true,
                color: c_blue,
            },
        };
    }
    
    static _buffer = __scribble_get_buffer_a();
    
    buffer_seek(_buffer, buffer_seek_start, 0);
    buffer_write(_buffer, buffer_string, _string);
    var _buffer_size = buffer_tell(_buffer);
    buffer_seek(_buffer, buffer_seek_start, 0);
    
    var _old_style   = undefined;
    var _new_style   = "body";
    var _write_style = true;
    
    var _newline = true;
    var _indent  = false;
    
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
            
            if (_indent)
            {
                _indent = false;
                _buffer_size += _func_insert_buffer(_buffer, _buffer_size, "[/indent]", buffer_tell(_buffer)-2);
                __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
            }
            
            if (!_write_style
            && ((_old_style == "quote")
             || (_old_style == "header1")
             || (_old_style == "header2")
             || (_old_style == "header3")))
            {
                _new_style = "body";
                _write_style = true;
            }
            
            continue;
        }
        
        //Searching for the first character on a line
        if (_newline)
        {
            if ((_value == ord(">")) && (_next_value == 0x20))
            {
                _new_style = "quote";
                if (_old_style != _new_style) _write_style = true;
                
                if (_indent)
                {
                    __scribble_trace("Warning! Found stacked indentation");
                    _buffer_size += _func_delete_buffer(_buffer, _buffer_size, 2);
                }
                else
                {
                    _indent = true;
                    _buffer_size += _func_delete_and_insert_buffer(_buffer, _buffer_size, 2, "[indent]");
                }
                
                __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                
                _newline = false;
                continue;
            }
            else if (_value == ord("#"))
            {
                var _header_level = 1;
                var _header_peek = buffer_tell(_buffer)-1;
                
                while(true)
                {
                    var _header_next_value = buffer_peek(_buffer, _header_peek, buffer_u8);
                    if (_header_next_value == 0x00)
                    {
                        _header_level = 0;
                        break;
                    }
                    else if (_header_next_value == ord(" "))
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
                        _new_style = "header1";
                    }
                    else if (_header_level == 2)
                    {
                        _new_style = "header2";
                    }
                    else if (_header_level >= 3)
                    {
                        _new_style = "header3";
                    }
                    
                    if (_old_style != _new_style) _write_style = true;
                    
                    _buffer_size += _func_delete_buffer(_buffer, _buffer_size, _header_level+1);
                    __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                    
                    _newline = false;
                    continue;
                }
            }
            else if ((_value == ord("-")) && (_next_value == 0x20))
            {
                _new_style = "body";
                if (_old_style != _new_style)
                {
                    _write_style = true;
                    __SCRIBBLE_MARKDOWN_SET_STYLE
                    buffer_seek(_buffer, buffer_seek_relative, 1);
                }
                
                var _bullet_sprite = _markdown_styles_struct[$ "bullet_sprite"] ?? _fallback_styles_struct[$ "bullet_sprite"];
                
                if (_indent)
                {
                    __scribble_trace("Warning! Found stacked indentation");
                    _buffer_size += _func_delete_and_insert_buffer(_buffer, _buffer_size, 2, (_bullet_sprite == undefined)? "" : "[" + sprite_get_name(_bullet_sprite) + "]");
                }
                else
                {
                    _indent = true;
                    _buffer_size += _func_delete_and_insert_buffer(_buffer, _buffer_size, 2, (_bullet_sprite == undefined)? "[indent]" : "[" + sprite_get_name(_bullet_sprite) + "][indent]");
                }
                
                __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                
                _newline = false;
                continue;
            }
            else if ((_value >= 48) && (_value <= 57))
            {
                var _number_size = 1;
                var _number_peek = buffer_tell(_buffer)-1;
                
                while(true)
                {
                    var _number_next_value = buffer_peek(_buffer, _number_peek, buffer_u8);
                    if (_number_next_value == 0x00)
                    {
                        _number_size = 0;
                        break;
                    }
                    else if ((_number_next_value == ord(".")) || (_number_next_value == ord(")")))
                    {
                        break;
                    }
                    else if ((_number_next_value < 48) || (_number_next_value > 57))
                    {
                        _number_size = 0;
                        break;
                    }
                    
                    ++_number_size;
                    ++_number_peek;
                }
                
                if (_number_size > 0)
                {
                    _new_style = "body";
                    if (_old_style != _new_style)
                    {
                        _write_style = true;
                        __SCRIBBLE_MARKDOWN_SET_STYLE
                        buffer_seek(_buffer, buffer_seek_relative, 1);
                    }
                    
                    buffer_seek(_buffer, buffer_seek_relative, _number_size+1);
                    
                    if (_indent)
                    {
                        __scribble_trace("Warning! Found stacked indentation");
                    }
                    else
                    {
                        _indent = true;
                        _buffer_size += _func_insert_buffer(_buffer, _buffer_size, "[indent]");
                    }
                    
                    __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                    
                    _indent = true;
                }
                
                _newline = false;
                continue;
            }
            
            if (_value <= 0x20) continue;
            
            _newline = false;
            //Fall through to parse the first character
        }
        
        //Parse text
        if (_value == ord("*"))
        {
            if (_next_value == ord("*"))
            {
                __SCRIBBLE_MARKDOWN_TOGGLE_BOLD
                var _delete_size = 2;
            }
            else
            {
                __SCRIBBLE_MARKDOWN_TOGGLE_ITALIC
                var _delete_size = 1;
            }
            
            _buffer_size += _func_delete_buffer(_buffer, _buffer_size, _delete_size);
            __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
        }
        else if ((_value == ord("_")) && ((_prev_value <= 0x20) || (_next_value <= 0x20)))
        {
            __SCRIBBLE_MARKDOWN_TOGGLE_ITALIC
            
            _buffer_size += _func_delete_buffer(_buffer, _buffer_size, 1);
            __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
        }
        else if ((_value == ord("!")) && (_next_value == ord("[")))
        {
            //Delete !
            _buffer_size += _func_delete_buffer(_buffer, _buffer_size, 1);
            __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
        }
        else if (_value == ord("\\"))
        {
            if (_next_value == 0) return;
            
            //Delete \
            _buffer_size += _func_delete_buffer(_buffer, _buffer_size, 1);
            buffer_seek(_buffer, buffer_seek_relative, 1); //Skip the next character
            __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
        }
        else
        {
            if (_value == ord("["))
            {
                #region [text](region)
                /*
                var _is_link    = false;
                var _link_size  = 1;
                var _link_start = buffer_tell(_buffer)-2;
                var _link_peek  = _link_start+1;
                
                while(true)
                {
                    var _link_next_value = buffer_peek(_buffer, _link_peek, buffer_u8);
                    if (_link_next_value == 0x00)
                    {
                        break;
                    }
                    else if (_link_next_value == ord("]"))
                    {
                        ++_link_peek;
                        if (buffer_peek(_buffer, _link_peek, buffer_u8) == ord("(")) _is_link = true;
                        break;
                    }
                    
                    ++_link_size;
                    ++_link_peek;
                }
                
                if (_is_link)
                {
                    var _region_start = _link_peek+1;
                    var _region_end   = _region_start;
                    
                    while(true)
                    {
                        var _region_next_value = buffer_peek(_buffer, _region_end, buffer_u8);
                        if ((_region_next_value == 0x00) || (_region_next_value == ord(")"))) break;
                        ++_region_end;
                    }
                    
                    buffer_poke(_buffer, _region_end, buffer_u8, 0x00);
                    var _region_name = buffer_peek(_buffer, _region_start, buffer_string);
                    
                    var _delta = _func_modify_buffer(_buffer, _buffer_size, 3 + _region_end - _region_start, "[/region]", _region_start-2);
                    _buffer_size += _delta;
                    _region_end  += _delta;
                    
                    _delta = _func_modify_buffer(_buffer, _buffer_size, 0, "region," + _region_name + "]", _link_start+1);
                    _buffer_size += _delta;
                    _region_end  += _delta;
                    
                    buffer_seek(_buffer, buffer_seek_start, _region_end+2);
                    __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                    
                    continue;
                }
                */
                #endregion
            }
            
            _prev_value = _value;
            
            if (_value > 0x20)
            {
                __SCRIBBLE_MARKDOWN_SET_STYLE
            }
        }
    }
    
    buffer_seek(_buffer, buffer_seek_start, 0);
    return buffer_read(_buffer, buffer_string);
}
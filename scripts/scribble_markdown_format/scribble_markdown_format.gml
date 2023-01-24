/// @param string

#macro __SCRIBBLE_MARKDOWN_SWAP_BUFFERS  var _temp = _bufferA;\
                                         _bufferA = _bufferB;\
                                         _bufferB = _temp;

function scribble_markdown_format(_string)
{
    static _inBufferA = __scribble_get_buffer_a();
    static _inBufferB = __scribble_get_buffer_b();
    
    var _bufferA = _inBufferA;
    var _bufferB = _inBufferB;
    
    buffer_seek(_bufferA, buffer_seek_start, 0);
    buffer_write(_bufferA, buffer_string, _string);
    
    while(true)
    {
        var _value = buffer_read(_bufferA, buffer_u8);
        if (_value == 0) return;
    }
    
    buffer_seek(_bufferA, buffer_seek_start, 0);
    return buffer_read(_bufferA, buffer_string);
}
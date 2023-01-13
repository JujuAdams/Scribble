function __scribble_get_buffer_b()
{
    static _buffer = buffer_create(1024, buffer_grow, 1);
    return _buffer;
}
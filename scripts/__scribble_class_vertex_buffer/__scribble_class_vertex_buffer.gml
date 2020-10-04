enum __SCRIBBLE_VERTEX_BUFFER
{
	BUFFER,
	VERTEX_BUFFER,
	TEXTURE,
	CHAR_START_TELL,
	WORD_START_TELL,
	WORD_X_OFFSET,
	LINE_START_LIST,
	TEXEL_WIDTH,
	TEXEL_HEIGHT,
	__SIZE
}

function __scribble_class_vertex_buffer(_texture, _for_glyphs) constructor
{
    texture      = _texture;
    texel_width  = texture_get_texel_width( texture);
    texel_height = texture_get_texel_height(texture);
    
    buffer = buffer_create(__SCRIBBLE_GLYPH_BYTE_SIZE*(_for_glyphs? __SCRIBBLE_EXPECTED_GLYPHS : 1), buffer_grow, 1);
    line_start_list = ds_list_create();
    
    vertex_buffer   = undefined;
    char_start_tell = undefined;
    word_start_tell = undefined;
    word_x_offset   = undefined;
}
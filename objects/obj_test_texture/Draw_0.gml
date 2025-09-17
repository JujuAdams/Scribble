var _tex_id = sprite_get_info(spr_portrait).frames[0].texture;
var _tex_uv = sprite_get_uvs(spr_portrait, 0)

var _textureTexelW = texture_get_texel_width(_tex_id);
var _textureTexelH = texture_get_texel_height(_tex_id);

var _tex_x = _tex_uv[0]/_textureTexelW;
var _tex_y = _tex_uv[1]/_textureTexelH;
var _tex_w = _tex_uv[2]/_textureTexelW - _tex_x;
var _tex_h = _tex_uv[3]/_textureTexelH - _tex_y;
scribble($"[texture, {_tex_id}, {_tex_x},{_tex_y},{_tex_w},{_tex_h}] is a pretty cool guy!").draw(24, 24)
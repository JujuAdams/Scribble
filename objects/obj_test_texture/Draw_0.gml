var _tex_id = sprite_get_info(spr_portrait).frames[0].texture;
var _tex_uv = sprite_get_uvs(spr_portrait, 0)

var _textureTexelW = texture_get_texel_width(_tex_id);
var _textureTexelH = texture_get_texel_height(_tex_id);

var _texX = _tex_uv[0]/_textureTexelW;
var _texY = _tex_uv[1]/_textureTexelH;
var _texW = _tex_uv[2]/_textureTexelW - _texX;
var _texH = _tex_uv[3]/_textureTexelH - _texY;
scribble($"[texture, {_tex_id}, {_texX},{_texY},{_texW},{_texH}] is a pretty cool guy!").draw(24, 24)
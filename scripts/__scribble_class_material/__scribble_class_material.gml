/// @param materialAlias

function __scribble_class_material(_material_alias) constructor
{
    static __scribble_state = __scribble_get_state();
    
    
    
    __material_alias = _material_alias;
    
    __texture      = undefined;
    __texel_width  = 0;
    __texel_height = 0;
    
    __bilinear      = false;
    __baked_effects = false;
    
    __sdf                  = false;
    __sdf_spread           = 0;
    __sdf_softness         = 1;
    __sdf_thickness_offset = 0;
    
    
    
    static __set_sdf_thickness_offset = function(_offset, _relative)
    {
        if (_relative)
        {
            __sdf_thickness_offset += _offset;
        }
        else
        {
            __sdf_thickness_offset = _offset;
        }
    }
    
    static __get_sdf_thickness_offset = function()
    {
        return __sdf_thickness_offset;
    }
    
    static __set_texture = function(_texture)
    {
        __texture      = _texture;
        __texel_width  = texture_get_texel_width(_texture);
        __texel_height = texture_get_texel_height(_texture);
    }
}
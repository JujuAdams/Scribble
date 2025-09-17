// Feather disable all

/// @param textureGroup

function __ScribbleTextureGroupGetReady(_texture_group)
{
    return ((_texture_group == undefined)
         || (texturegroup_get_status(_texture_group) == texturegroup_status_loaded)
         || (texturegroup_get_status(_texture_group) == texturegroup_status_fetched));
}
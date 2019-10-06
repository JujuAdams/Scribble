const float PI        = 3.14159265359;
const float angleIncr = 2.0*PI/8.0; //8 repeats
const float radiusMax = 2.0;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    
    //vec4 centre = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    //
    //vec2 texel = vec2(1.0/1024.0, 1.0/2048.0);
    //
    ////Square Outline
    //float sampleMax = texture2D(gm_BaseTexture, v_vTexcoord).a;
    //for(float offsetY = -radiusMax; offsetY <= radiusMax; offsetY += 1.0)
    //{
    //    for(float offsetX = -radiusMax; offsetX <= radiusMax; offsetX += 1.0)
    //    {
    //        sampleMax = max(sampleMax, texture2D(gm_BaseTexture, v_vTexcoord + texel*vec2(offsetX, offsetY)).a);
    //    }
    //}
    //gl_FragColor = mix(vec4(1.0, 1.0, 1.0, sampleMax), centre, centre.a);
    
    ////Rounded outline
    //float sampleMax = texture2D(gm_BaseTexture, v_vTexcoord).a;
    //for(float radius = 1.0; radius <= 3.0; radius += 1.0)
    //{
    //    for(float angle = radius*angleIncr*0.5; angle < 2.0*PI; angle += angleIncr/radius)
    //    {
    //        sampleMax = max(sampleMax, texture2D(gm_BaseTexture, v_vTexcoord + texel*radius*vec2(cos(angle), sin(angle))).a);
    //    }
    //}
    //gl_FragColor = mix(vec4(1.0, 1.0, 1.0, sampleMax), centre, centre.a);
    
    ////Square inner outline
    //float sampleMin = texture2D(gm_BaseTexture, v_vTexcoord).a;
    //for(float offsetY = -radiusMax; offsetY <= radiusMax; offsetY += 1.0)
    //{
    //    for(float offsetX = -radiusMax; offsetX <= radiusMax; offsetX += 1.0)
    //    {
    //        sampleMin = min(sampleMin, texture2D(gm_BaseTexture, v_vTexcoord + texel*vec2(offsetX, offsetY)).a);
    //    }
    //}
    //gl_FragColor = vec4(mix(vec3(1.0, 1.0, 1.0), centre.rgb, sampleMin), centre.a);
    
    ////Rounded inner outline
    //float sampleMin = texture2D(gm_BaseTexture, v_vTexcoord).a;
    //for(float radius = 1.0; radius <= radiusMax; radius += 1.0)
    //{
    //    for(float angle = angleIncr*0.5; angle < 2.0*PI; angle += angleIncr/radius)
    //    {
    //        sampleMin = min(sampleMin, texture2D(gm_BaseTexture, v_vTexcoord + texel*radius*vec2(cos(angle), sin(angle))).a);
    //    }
    //}
    //gl_FragColor = vec4(mix(vec3(1.0, 1.0, 1.0), centre.rgb, sampleMin), centre.a);
}
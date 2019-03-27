#extension GL_OES_standard_derivatives : enable

varying vec2  v_vTexcoord;
varying vec4  v_vColour;
varying float v_fThickness;

uniform float u_fPremultiplyAlpha;
uniform vec3  u_vBorderColour;
uniform vec2  u_vTexel;
uniform vec2  u_vTextureSize;


float medianRGB( vec3 v )
{
    return max( min(v.x, v.y), min(max(v.x, v.y), v.z) );
}

float linearStep(float a, float b, float x)
{
    return clamp( (x-a)/(b-a), 0.0, 1.0 );
}

vec2 safeNormalize( in vec2 v )
{
    float len = length( v );
    len = ( len > 0.0 ) ? 1.0 / len : 0.0;
    return v * len;
}

void main()
{
    vec3 sample = texture2D( gm_BaseTexture, v_vTexcoord ).rgb;
    float signedDist = medianRGB(sample);
    
    
    ////Hard edge
    //float alpha = step( 0.5, v_fThickness*signedDist );
    //gl_FragColor = vec4( v_vColour.rgb, v_vColour.a*alpha );
    
    
    ////AA Method 1
    //float width = fwidth( signedDist );
    //float alpha = smoothstep( 0.5 - width, 0.5 + width, (1.0+v_fThickness)*signedDist );
    //gl_FragColor = vec4( v_vColour.rgb, v_vColour.a*alpha );
    
    
    ////AA Method 2
    //float dx = dFdx(v_vTexcoord.x)*u_vTextureSize.x;
    //float dy = dFdy(v_vTexcoord.y)*u_vTextureSize.y;
    //float alpha = clamp( (1.0+v_fThickness)*0.5 + 4.0*inversesqrt(dx*dx + dy*dy)*(signedDist-0.5), 0.0, 1.0 );
    //gl_FragColor = vec4( v_vColour.rgb, v_vColour.a*alpha );
    
    
    ////AA Method 3
    //float alpha = clamp(dot(u_vTexel, 1.0/fwidth(v_vTexcoord))*((1.0+v_fThickness)*signedDist - 0.5) + 0.5, 0.0, 1.0);
    //gl_FragColor = vec4(v_vColour.rgb, v_vColour.a*alpha);
    
    
    //AA Method 4
    float scale     = dot(fwidth(v_vTexcoord), u_vTextureSize);
    float pxRange   = 2.0;
    float pixelSize = min(scale*0.5/pxRange, 0.25);
    
    float balancedDist = v_fThickness + 2.0*signedDist - 1.0;
    float alpha = linearStep(-pixelSize, pixelSize, balancedDist);
    gl_FragColor = vec4(v_vColour.rgb, alpha);
    
    
    ////Border
    //float scale     = dot(fwidth(v_vTexcoord), u_vTextureSize);
    //float border    = 0.00;
    //float pxRange   = 2.0;
    //float pixelSize = min(scale*0.5/pxRange, 0.25);
    //
    //float balancedDist = v_fThickness + border + 2.0*signedDist - 1.0;
    //float alpha = linearStep( -pixelSize-border, pixelSize-border, balancedDist );
    //float borderBlend = (border > 0.0)? linearStep( border-pixelSize, border+pixelSize, balancedDist ) : 1.0;
    //gl_FragColor = vec4( mix(u_vBorderColour, v_vColour.rgb, borderBlend), alpha );
    
    
    ////Border and Drop Shadow
    //float scale         = dot(fwidth(v_vTexcoord), u_vTextureSize);
    //vec2  shadowVector  = scale*vec2(1.0*u_vTexel.x, 1.0*u_vTexel.y);
    //float shadowOpacity = 1.0;
    //
    //float border    = 0.0;
    //float pxRange   = 2.0;
    //float pixelSize = min(scale*0.5/pxRange, 0.25);
    //
    //
    //vec3  shadowSample       = texture2D( gm_BaseTexture, v_vTexcoord-shadowVector ).rgb;
    //float shadowSignedDist   = medianRGB(shadowSample);
    //float shadowBalancedDist = v_fThickness + border + 2.0*shadowSignedDist - 1.0;
    //float shadowAlpha        = shadowOpacity*linearStep( -pixelSize, pixelSize, shadowBalancedDist );
    //vec4  shadowColour       = vec4(vec3(0.0), shadowAlpha);
    //
    //
    //float balancedDist = v_fThickness + border + 2.0*signedDist - 1.0;
    //float alpha        = linearStep( -pixelSize-border, pixelSize-border, balancedDist );
    //float borderBlend  = (border > 0.0)? linearStep( border-pixelSize, border+pixelSize, balancedDist ) : 1.0;
    //vec4  textColour   = vec4(mix(u_vBorderColour, v_vColour.rgb, borderBlend), alpha);
    //
    //gl_FragColor = mix(mix(textColour, shadowColour, shadowColour.a), textColour, textColour.a);
    //gl_FragColor.a *= v_vColour.a;
    
    
    if ( u_fPremultiplyAlpha > 0.5 ) gl_FragColor.rgb *= gl_FragColor.a;
}
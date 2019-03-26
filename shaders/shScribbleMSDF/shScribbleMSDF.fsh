#extension GL_OES_standard_derivatives : enable

varying vec2  v_vTexcoord;
varying vec4  v_vColour;
varying float v_fThickness;

uniform float u_fPremultiplyAlpha;
uniform vec2  u_vTexel;
uniform vec2  u_vTextureSize;

float median( float a, float b, float c )
{
    return max( min(a, b), min( max(a, b), c ) );
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
    float dist = median( sample.r, sample.g, sample.b );
    
    //Hard edge
    //float alpha = step( 0.5, v_fThickness*dist );
    
    //AA Method 1
    //float width = fwidth( dist );
    //float alpha = smoothstep( 0.5 - width, 0.5 + width, v_fThickness*dist );
    
    //AA Method 2
    float dx = dFdx(v_vTexcoord.x)*u_vTextureSize.x;
    float dy = dFdy(v_vTexcoord.y)*u_vTextureSize.y;
    float alpha = clamp( v_fThickness*0.5 + 4.0*inversesqrt(dx*dx + dy*dy)*(dist-0.5), 0.0, 1.0 );
    
    //AA Method 3
    //float alpha = clamp( dot(u_vTexel, 1.0/fwidth(v_vTexcoord))*(v_fThickness*dist - 0.5) + 0.5, 0.0, 1.0);
    
    gl_FragColor = vec4( v_vColour.rgb, v_vColour.a*alpha );
    if ( u_fPremultiplyAlpha > 0.5 ) gl_FragColor.rgb *= gl_FragColor.a;
}
//   @jujuadams   v10.0.0   2025-08-24
precision highp float;

#define PALETTE_SIZE  16.0

#define REACTIVE_SDF_RANGE true
#define PREMULTIPLY_ALPHA false
#define USE_ALPHA_FOR_DISTANCE true

varying vec2  v_vModelPosition;
varying vec2  v_vTexcoord;
varying vec4  v_vColourIndexes;
varying vec2  v_vCycle;
varying float v_fGradient;
varying float v_fCycleOffset;

uniform sampler2D u_sCycle;
uniform sampler2D u_sPalette;

uniform float u_fRenderType;
uniform vec4  u_vFlash;

uniform vec4  u_vColourBlend;
uniform vec4  u_vGradientColour;
uniform vec4  u_vShadowColour;
uniform vec3  u_vOutlineColour;
uniform float u_fSecondDraw;
uniform vec4  u_vClip;

//SDF-only
uniform vec2  u_vTexel;
uniform float u_fSDFRange;
uniform float u_fSDFThicknessOffset;
uniform vec3  u_vShadowOffsetAndSoftness;
uniform float u_fOutlineThickness;

float SDFValue(vec2 texcoord)
{
    vec4 sample = texture2D(gm_BaseTexture, texcoord);
    return (USE_ALPHA_FOR_DISTANCE? sample.a : max(sample.r, max(sample.g, sample.b))) + u_fSDFThicknessOffset;
}

vec4 PaletteColour(float index)
{
    return texture2D(u_sPalette, vec2((mod(index, PALETTE_SIZE) + 0.5) / PALETTE_SIZE, (floor(index / PALETTE_SIZE) + 0.5) / PALETTE_SIZE));
}

vec3 OutlineColour()
{
    return (v_vColourIndexes.y <= 0.0)? u_vOutlineColour : PaletteColour(v_vColourIndexes.z).rgb;
}

void main()
{
    vec2 inside = step(u_vClip.zw, v_vModelPosition) - step(u_vClip.xy, v_vModelPosition);
    if (inside.x*inside.y <= 0.0)
    {
        discard;
    }
    
    //Handle base colour
    vec4 colour;
    if (v_vCycle.y >= 0.0) //Cycle
    {
        colour = texture2D(u_sCycle, v_vCycle);
    }
    else if (v_vColourIndexes.x < 0.0) //SCRIBBLE_PALETTE_NO_COLOR is negative
    {
        colour = vec4(1.0); //Use white
    }
    else if (v_vColourIndexes.x == 0.0) //Use the blend colour
    {
        colour = vec4(u_vColourBlend.rgb, 1.0);
    }
    else
    {
        colour = PaletteColour(v_vColourIndexes.x); //Read a colour from the palette
    }
    
    //Apply gradient if required
    vec4 gradientColour;
    if (v_fGradient > 0.0)
    {
        if (v_vColourIndexes.y == 0.0)
        {
            gradientColour = u_vGradientColour;
        }
        else
        {
            gradientColour = PaletteColour(v_vColourIndexes.y);
        }
        
        colour.rgb = mix(colour.rgb, gradientColour.rgb, pow(v_fGradient*gradientColour.a, 2.0));
    }
    
    //Apply alpha
    colour.a *= v_vColourIndexes.a*u_vColourBlend.a;
    
    if (u_fRenderType == 0.0)
    {
        //Standard raster rendering (standard fonts, spritefonts, sprites, surfaces)
        gl_FragColor = colour*texture2D(gm_BaseTexture, v_vTexcoord);
    }
    else if (u_fRenderType == 1.0)
    {
        //Font with effects baked in
        vec4 sample = texture2D(gm_BaseTexture, v_vTexcoord);
        gl_FragColor = colour*vec4(1.0, 1.0, 1.0, sample.r);
        
        if (u_fSecondDraw < 0.5)
        {
            float outAlpha = gl_FragColor.a + sample.g*(1.0 - gl_FragColor.a);
            gl_FragColor.rgb = (gl_FragColor.rgb*gl_FragColor.a + OutlineColour()*sample.g*(1.0 - gl_FragColor.a)) / outAlpha;
            gl_FragColor.a = outAlpha;
            
            if (u_vShadowColour.a > 0.0)
            {
                float outAlpha = gl_FragColor.a + u_vShadowColour.a*sample.b*(1.0 - gl_FragColor.a);
                gl_FragColor.rgb = (gl_FragColor.rgb*gl_FragColor.a + u_vShadowColour.rgb*u_vShadowColour.a*sample.b*(1.0 - gl_FragColor.a)) / outAlpha;
                gl_FragColor.a = outAlpha;
            }
        }
        
        gl_FragColor.a *= colour.a;
    }
    else
    {
        //SDF rendering
        float smoothness = 0.5;
        
        float baseDist = SDFValue(v_vTexcoord);
        float spread = max(fwidth(baseDist), 0.001);    
        
        float alpha = smoothstep(0.5 - smoothness*spread, 0.5 + smoothness*spread, baseDist);   
        gl_FragColor = vec4(colour.rgb, alpha*colour.a);
        
        if (u_fSecondDraw < 0.5)
        {
            float outlineOffset;
            if (REACTIVE_SDF_RANGE)
            {
                outlineOffset = u_fOutlineThickness*length(fwidth(v_vTexcoord)/u_vTexel)/(sqrt(2.0)*u_fSDFRange);
            }
            else
            {
                outlineOffset = u_fOutlineThickness / (2.0*u_fSDFRange);
            }
            
            if (u_fOutlineThickness > 0.0)
            {
                gl_FragColor.rgb = mix(OutlineColour(), gl_FragColor.rgb, gl_FragColor.a);
                gl_FragColor.a = max(gl_FragColor.a, smoothstep(0.5 - smoothness*spread, 0.5 + smoothness*spread, baseDist + outlineOffset));
            }
            
            if ((u_vShadowColour.a > 0.0) && !all(equal(u_vShadowOffsetAndSoftness.xy, vec2(0.0))))
            {
                float shadowDist;
                if (REACTIVE_SDF_RANGE)
                {
                    shadowDist = SDFValue(v_vTexcoord - u_vShadowOffsetAndSoftness.xy*fwidth(v_vTexcoord));
                }
                else
                {
                    shadowDist = SDFValue(v_vTexcoord - u_vShadowOffsetAndSoftness.xy*0.5*u_vTexel);
                }
                
                float shadowSoftness = spread*u_vShadowOffsetAndSoftness.z;
                float alphaShadow = u_vShadowColour.a*smoothstep(0.5 - shadowSoftness, 0.5 + shadowSoftness, shadowDist + outlineOffset);
                
                float outAlpha = gl_FragColor.a + alphaShadow*(1.0 - gl_FragColor.a);
                gl_FragColor.rgb = (gl_FragColor.rgb*gl_FragColor.a + u_vShadowColour.rgb*alphaShadow*(1.0 - gl_FragColor.a)) / outAlpha;
                gl_FragColor.a = outAlpha;
            }
        }
        
        gl_FragColor.a *= colour.a;
    }
    
    //Apply flash effect
    gl_FragColor.rgb = mix(gl_FragColor.rgb, u_vFlash.rgb, u_vFlash.a);
    
    if (PREMULTIPLY_ALPHA)
    {
        gl_FragColor.rgb *= gl_FragColor.a;
    }
}
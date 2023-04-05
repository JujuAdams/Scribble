precision highp float;

#define USE_ALPHA_FOR_DISTANCE true

varying vec2  v_vPosition;
varying float v_fObjectY;
varying vec2  v_vTexcoord;
varying vec2  v_vCycleTexcoord;
varying vec4  v_vColour;
varying float v_fPremultiplyAlpha; //Boolean flag
varying float v_fBakedEffects;     //Boolean flag
varying float v_fSDF;              //Boolean flag
varying float v_fSecondDraw;       //Boolean flag

uniform vec4  u_vColourLerp;
uniform vec4  u_vCrop;
uniform vec2  u_vScrollCrop;

uniform sampler2D u_sCycle;

//SDF-only
uniform vec2  u_vTexel;
uniform float u_fSDFRange;
uniform float u_fSDFThicknessOffset;
uniform vec4  u_vShadowColour;
uniform vec3  u_vShadowOffsetAndSoftness;
uniform vec3  u_vBorderColour;
uniform float u_fBorderThickness;

float SDFValue(vec2 texcoord)
{
    vec4 sample = texture2D(gm_BaseTexture, texcoord);
    return (USE_ALPHA_FOR_DISTANCE? sample.a : max(sample.r, max(sample.g, sample.b))) + u_fSDFThicknessOffset;
}

void main()
{
    vec4 vertexColour = v_vColour;
    if (v_vCycleTexcoord.y > 0.0) vertexColour *= texture2D(u_sCycle, vec2(mod(v_vCycleTexcoord.x, 1.0), v_vCycleTexcoord.y));
    
    if (((length(u_vCrop) > 0.0) && ((v_vPosition.x < u_vCrop.x) || (v_vPosition.y < u_vCrop.y) || (v_vPosition.x > u_vCrop.z) || (v_vPosition.y > u_vCrop.w)))
    ||  ((length(u_vScrollCrop) > 0.0) && ((v_fObjectY < u_vScrollCrop.x) || (v_fObjectY > u_vScrollCrop.y))))
    {
        gl_FragColor = vec4(0.0);
    }
    else
    {
        if (v_fSDF < 1.0)
        {
            //Standard rendering (standard fonts, spritefonts, sprites, surfaces)
            gl_FragColor = texture2D(gm_BaseTexture, v_vTexcoord);
            
            if (v_fBakedEffects < 1.0)
            {
                gl_FragColor *= vertexColour;
            }
            else
            {
                vec4 sample = gl_FragColor;
                gl_FragColor = vec4(0.0);
                
                if (v_fSecondDraw < 1.0)
                {
                    //Shadow
                    vec4 shadowColour = u_vShadowColour;
                    shadowColour.a   *= sample.b;
                    shadowColour.rgb *= shadowColour.a;
                    gl_FragColor = mix(shadowColour, gl_FragColor, 1.0 - shadowColour.a);
                    
                    //Outline
                    vec4 outlineColour = vec4(u_vBorderColour, step(0.5, u_fBorderThickness));
                    outlineColour.a   *= sample.g;
                    outlineColour.rgb *= outlineColour.a;
                    gl_FragColor = mix(outlineColour, gl_FragColor, 1.0 - outlineColour.a);
                }
                
                //Base
                vec4 baseColour = vertexColour;
                baseColour.a   *= sample.r;
                baseColour.rgb *= baseColour.a;
                gl_FragColor = mix(baseColour, gl_FragColor, 1.0 - baseColour.a);
            }
        }
        else
        {
            //SDF rendering
            float smoothness = 1.0;
            
            float baseDist = SDFValue(v_vTexcoord);
            float spread = max(fwidth(baseDist), 0.001);    
            
            float alpha = smoothstep(0.5 - smoothness*spread, 0.5 + smoothness*spread, baseDist);   
            gl_FragColor = vec4(vertexColour.rgb, alpha*vertexColour.a);
            
            if (v_fSecondDraw < 1.0)
            {
                float borderOffset = u_fBorderThickness*length(fwidth(v_vTexcoord)/u_vTexel)/(sqrt(2.0)*u_fSDFRange);
                
                if (u_fBorderThickness > 0.0)
                {
                    gl_FragColor.rgb = mix(u_vBorderColour, gl_FragColor.rgb, gl_FragColor.a);
                    gl_FragColor.a = max(gl_FragColor.a, smoothstep(0.5 - smoothness*spread, 0.5 + smoothness*spread, baseDist + borderOffset));
                }
                
                if (u_vShadowColour.a > 0.0)
                {
                    float alphaShadow = u_vShadowColour.a*smoothstep(0.5 - spread*u_vShadowOffsetAndSoftness.z, 0.5 + spread*u_vShadowOffsetAndSoftness.z, SDFValue(v_vTexcoord - u_vShadowOffsetAndSoftness.xy*fwidth(v_vTexcoord)) + borderOffset);
                    
                    float outAlpha = gl_FragColor.a + alphaShadow*(1.0 - gl_FragColor.a);
                    gl_FragColor.rgb = (gl_FragColor.rgb*gl_FragColor.a + u_vShadowColour.rgb*alphaShadow*(1.0 - gl_FragColor.a)) / outAlpha;
                    gl_FragColor.a = outAlpha;
                }
            }
            
            gl_FragColor.a *= vertexColour.a;
        }
        
        //Apply colour lerp and premultiply alpha
        gl_FragColor.rgb = mix(gl_FragColor.rgb, u_vColourLerp.rgb, u_vColourLerp.a) * (1.0 - v_fPremultiplyAlpha*(1.0 + gl_FragColor.a));
    }
}
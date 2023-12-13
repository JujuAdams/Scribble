//   @jujuadams   v8.0.0   2021-12-15
precision highp float;

////Pre-computed sqrt(0.5)
#define HALF_ROOT 0.70710678

varying vec2 v_vTexcoord;
varying vec4 v_vColor;

uniform vec2 u_vTexel;
uniform vec3 u_vOutlineColor;

void main()
{
    vec4 outlineColor = vec4(u_vOutlineColor, 1.0);
	
	//Precompute offsets
	const vec4 offset = vec4(1.0, 0.0, HALF_ROOT, -HALF_ROOT);
	
	//Sample in 8 directions (45 degree increments)
	outlineColor.a *= texture2D(gm_BaseTexture, v_vTexcoord + u_vTexel * offset.xy).a;
	outlineColor.a *= texture2D(gm_BaseTexture, v_vTexcoord + u_vTexel * offset.zw).a;
	outlineColor.a *= texture2D(gm_BaseTexture, v_vTexcoord - u_vTexel * offset.yx).a;
	outlineColor.a *= texture2D(gm_BaseTexture, v_vTexcoord - u_vTexel * offset.zz).a;
	outlineColor.a *= texture2D(gm_BaseTexture, v_vTexcoord - u_vTexel * offset.xy).a;
	outlineColor.a *= texture2D(gm_BaseTexture, v_vTexcoord - u_vTexel * offset.zw).a;
	outlineColor.a *= texture2D(gm_BaseTexture, v_vTexcoord + u_vTexel * offset.yx).a;
	outlineColor.a *= texture2D(gm_BaseTexture, v_vTexcoord + u_vTexel * offset.zz).a;
    
    
    vec4 sample = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = v_vColor*mix(outlineColor, sample, sample.a);
}
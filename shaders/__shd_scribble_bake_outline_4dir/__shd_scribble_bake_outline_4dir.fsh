//   @jujuadams   v8.0.0   2021-12-15
precision highp float;

varying vec2 v_vTexcoord;
varying vec4 v_vColor;

uniform vec2 u_vTexel;
uniform vec3 u_vOutlineColor;

void main()
{
    vec4 outlineColor = vec4(u_vOutlineColor, 1.0);
	
	const vec2 offset = vec2(1, 0);
	//Sample in right, up, left and down
	outlineColor.a *= texture2D(gm_BaseTexture, v_vTexcoord + u_vTexel * offset.xy).a;
	outlineColor.a *= texture2D(gm_BaseTexture, v_vTexcoord - u_vTexel * offset.yx).a;
	outlineColor.a *= texture2D(gm_BaseTexture, v_vTexcoord - u_vTexel * offset.xy).a;
	outlineColor.a *= texture2D(gm_BaseTexture, v_vTexcoord + u_vTexel * offset.yx).a;
    
    vec4 sample = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = v_vColor * mix(outlineColor, sample, sample.a);
}
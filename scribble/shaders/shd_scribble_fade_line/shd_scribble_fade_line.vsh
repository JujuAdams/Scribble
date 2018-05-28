attribute vec3 in_Position;
attribute vec2 in_TextureCoord;
attribute vec4 in_Colour;
attribute vec3 in_Normal;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying float v_fLine;
varying float v_fIndex;

uniform vec2 u_vShakeTime;
uniform float u_fWaveTime;

//Look, I'm not above copy-pasting code aite
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
    v_fIndex = float( int( in_Position.z / 256.0 ) );
    v_fLine = in_Position.z - v_fIndex*256.0;
    v_vNormal = in_Normal;
    
    vec4 object_space_pos = vec4( in_Position.xy, 0.0, 1.0);
    
    if ( in_Normal.y > 0.0 ) {
        object_space_pos.x += 5.0*(rand( vec2( v_fIndex + u_vShakeTime.x ) )-0.5);
        object_space_pos.y += 5.0*(rand( vec2( v_fIndex + u_vShakeTime.y ) )-0.5);
    }
    
    if ( in_Normal.z > 0.0 ) {
        object_space_pos.y += 3.0*sin( 10.0*u_fWaveTime + v_fIndex );
    }
    
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
}
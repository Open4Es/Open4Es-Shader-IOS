#version 130
 
#define SHADOW_MAP_BIAS 0.85
 
varying vec4 texcoord;
 
void main() {
    vec4 position = gl_ModelViewMatrix * gl_Vertex;
	gl_Position = gl_ProjectionMatrix * position;
    float dist = length(gl_Position.xy);
    float distortFactor = (1.0 - SHADOW_MAP_BIAS ) + dist * SHADOW_MAP_BIAS ;
    gl_Position.xy /= distortFactor;
    texcoord = gl_MultiTexCoord0;
}
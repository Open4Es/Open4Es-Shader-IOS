#version 120

uniform sampler2D texture;

varying vec4 color;
varying vec4 texcoord;
varying vec4 lmcoord;

/* DRAWBUFFERS:7 */


void main() {
	
	vec4 tex = texture2D(texture, texcoord.xy)*color;
	gl_FragData[0] = tex;
}
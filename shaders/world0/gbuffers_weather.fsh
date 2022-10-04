#version 130

varying vec4 color;
varying vec4 texcoord;
varying vec4 lmcoord;

uniform sampler2D gtexture;

void main() {
	
/* DRAWBUFFERS:7 */
	
	vec4 tex = texture(gtexture, texcoord.xy)*color;
	gl_FragData[0] = tex;
}
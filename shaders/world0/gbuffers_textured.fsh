#version 130

uniform sampler2D gtexture;

varying vec4 color;
varying vec4 texcoord;

/* DRAWBUFFERS:0 */
void main() {
	gl_FragData[0] = texture(gtexture, texcoord.st) * color;
}
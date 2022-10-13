#version 130

uniform sampler2D gtexture;

varying vec4 color;
varying vec4 texcoord;
varying vec4 lmcoord;
varying vec2 normal;

/* DRAWBUFFERS:02 */
void main() {
	vec4 tex = texture(gtexture, texcoord.xy)*color;
	gl_FragData[0] = tex;
	gl_FragData[1] = vec4(normal, 0.0, 1.0);
}
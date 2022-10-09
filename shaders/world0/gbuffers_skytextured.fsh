#version 130

uniform sampler2D gtexture;

varying vec2 texcoord;
varying vec4 glcolor;
varying vec2 normal;
 

void main() {
	vec4 color = texture(gtexture, texcoord) * glcolor;

/* DRAWBUFFERS:02 */
	gl_FragData[0] = color; //gcolor
	gl_FragData[1] = vec4(normal, 0.0, 1.0);
}
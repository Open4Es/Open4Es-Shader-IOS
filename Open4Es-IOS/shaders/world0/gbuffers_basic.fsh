#version 120

uniform sampler2D lightmap;

varying vec2 lmcoord;
varying vec4 glcolor;

/* DRAWBUFFERS:0 */
void main() {
	vec4 color = glcolor;
	color *= texture2D(lightmap, lmcoord);
	gl_FragData[0] = color; //gcolor
}
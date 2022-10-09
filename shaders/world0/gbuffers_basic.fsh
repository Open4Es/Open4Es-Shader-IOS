#version 120

varying vec4 color;
varying vec2 normal;
 
/* DRAWBUFFERS:02 */
void main() {
	gl_FragData[0] = color;
	gl_FragData[1] = vec4(normal, 0.0, 1.0);
}
#version 130
#define torchColor vec3(1.5, 0.42 , 0.045) *4.0

uniform sampler2D lightmap;
uniform sampler2D gtexture;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec2 uv0;
varying vec2 uv1;

void main() {
	vec4 color = texture(gtexture, texcoord) * glcolor;
	color *= texture(lightmap, lmcoord);
    color.rgb += (uv1.x * 0.0002 * torchColor);
/* DRAWBUFFERS:0 */
	gl_FragData[0] = color; //gcolor
}
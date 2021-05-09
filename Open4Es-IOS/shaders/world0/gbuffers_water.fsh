#version 120
#define WaterColor vec3(0.1,0.4,0.6)

uniform sampler2D texture;
uniform sampler2D lightmap;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 color;
varying float waterFlag;

/* DRAWBUFFERS:0 */
void main() {
    vec4 color = texture2D(texture, texcoord) * color;
	color *= texture2D(lightmap, lmcoord);
    if(waterFlag >= 0.5){
    gl_FragData[0] = vec4(WaterColor,0.5); //Color
}else{
    gl_FragData[0] = color;}
}
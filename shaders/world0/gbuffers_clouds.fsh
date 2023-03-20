#version 130

//#define VANILLA_CLOUDS

uniform sampler2D gtexture;

uniform vec3 fogColor;
uniform vec3 skyColor;

uniform float far;

varying vec2 normal;
varying vec2 texcoord;
varying vec3 cPos;
varying vec3 wPos;
varying vec4 glcolor;

/* DRAWBUFFERS:02 */
void main(){
    #ifdef VANILLA_CLOUDS
    vec4 color=texture(gtexture,texcoord)*glcolor;
    color.rgb=mix(color.rgb,fogColor,smoothstep(0.,far,length(wPos.xz)));
    gl_FragData[0]=color;
    gl_FragData[1] = vec4(normal, 0.0, 1.0);
    #else
        discard;
    #endif
}
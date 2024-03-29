#version 120

#define SUNRISE 23200
#define SUNSET 12800
#define FADE_START 500
#define FADE_END 250

uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform vec3 cameraPosition;

uniform int worldTime;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
 
varying vec2 lmcoord;
varying vec2 texcoord;
varying vec3 lightPosition;
varying vec3 normal;

varying float extShadow;
 
void main() {
    vec4 position = gl_ModelViewMatrix * gl_Vertex;
	gl_Position = gl_ProjectionMatrix * position;
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    if(worldTime >= SUNRISE - FADE_START && worldTime <= SUNRISE + FADE_START)
    {
        extShadow = 0.0;
        if(worldTime < SUNRISE - FADE_END) extShadow -= float(SUNRISE - FADE_END - worldTime) / float(FADE_END); else if(worldTime > SUNRISE + FADE_END)
            extShadow -= float(worldTime - SUNRISE - FADE_END) / float(FADE_END);
    }
    else if(worldTime >= SUNSET - FADE_START && worldTime <= SUNSET + FADE_START)
    {
        extShadow = 1.0;
        if(worldTime < SUNSET - FADE_END) extShadow -= float(SUNSET - FADE_END - worldTime) / float(FADE_END); else if(worldTime > SUNSET + FADE_END)
            extShadow -= float(worldTime - SUNSET - FADE_END) / float(FADE_END);
    }
    else
        extShadow = 0.0;
     
    if(worldTime < SUNSET || worldTime > SUNRISE)
        lightPosition = normalize(sunPosition);
    else
        lightPosition = normalize(moonPosition);
}
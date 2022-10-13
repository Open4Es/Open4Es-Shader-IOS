#version 130
#define WaterColor vec3(0.1, 0.6, 0.9)
#define WaterWave
#define saturate(x) clamp(x,0.0,1.0)
uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2D noisetex;

uniform vec3 cameraPosition;
uniform vec3 fogColor;
uniform vec3 skyColor;

uniform mat4 gbufferModelViewInverse;

uniform int worldTime;
uniform int isEyeInWater;

uniform float near;
uniform float far;
uniform float rainStrength;
uniform float frameTimeCounter;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 cPos;
varying vec3 wPos;
varying vec2 uv1;
varying vec3 normal;
varying vec4 positionInViewCoord;

varying float waterHeight;
varying float waterFlag;

const int noiseTextureResolution = 128;

#ifdef WaterWave
vec3 getWave(vec3 color, vec4 positionInWorldCoord) {

    // wave
    float speed1 = float(worldTime) / 1920.0;
    vec3 coord1 = positionInWorldCoord.xyz / 128.0;
    coord1.x *= 3;
    coord1.x += speed1;
    coord1.z += speed1 * 0.2;
    float noise1 = texture(noisetex, coord1.xz).x;

    color *= noise1 * 0.6 + 0.4;

    return color;
}
#endif

void main() {
    vec4 color = texture(gtexture, texcoord) * glcolor;
	color *= texture2D(lightmap, lmcoord);
    #ifdef WaterWave
    vec4 positionInWorldCoord = gbufferModelViewInverse * positionInViewCoord;
    positionInWorldCoord.xyz += cameraPosition;
    vec3 finalColor = WaterColor;
    finalColor = getWave(WaterColor, positionInWorldCoord);
    float cosine = dot(normalize(positionInViewCoord.xyz), normalize(normal));
    cosine = clamp(abs(cosine), 0, 1);
    float factor = pow(1.0 - cosine, 4);
    if(waterFlag >= 0.5){
    gl_FragData[0] = vec4(mix(WaterColor*0.3,finalColor,factor),0.7); //Color
    return;
    }
    #endif
    /* DRAWBUFFERS:0 */
	gl_FragData[0] = color; //gcolor
}

#version 130
//#include "/lib/lib.glsl"
//#define WaterColor vec3(0.1, 0.6, 0.9)
#define WaterWave
#define Water_Red 0.1 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
#define Water_Green 0.6 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
#define Water_Blue 0.9 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
#define saturate(x) clamp(x,0.0,1.0)
uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2D noisetex;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform int worldTime;
uniform int isEyeInWater;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform float near;
uniform float far;
uniform float rainStrength;
uniform float frameTimeCounter;
varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 cPos;
varying vec3 wPos;
varying float waterHeight;
varying vec2 uv1;
varying float waterFlag;
varying vec3 normal;
varying vec4 positionInViewCoord;
varying vec3 mySkyColor;
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

    // mix
    float speed2 = float(worldTime) / 896.0;
    vec3 coord2 = positionInWorldCoord.xyz / 128.0;
    coord2.x *= 0.5;
    coord2.x -= speed2 * 0.15 + noise1 * 0.05;  // wave
    coord2.z -= speed2 * 0.7 - noise1 * 0.05;
    float noise2 = texture(noisetex, coord2.xz).x;

    color *= noise1 * 0.6 + 0.4;

    return color;
}
#endif
    vec3 WaterColor = vec3(Water_Red,Water_Green,Water_Blue); 

void main() {
    vec4 color = texture(gtexture, texcoord) * glcolor;
	color *= texture2D(lightmap, lmcoord);
    #ifdef WaterWave
    vec4 positionInWorldCoord = gbufferModelViewInverse * positionInViewCoord;
    positionInWorldCoord.xyz += cameraPosition;
    vec3 finalColor = vec3(WaterColor);
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
    //gl_FragData[2] = vec4(waterFlag, 0.0, 0.0, 1.0);
}

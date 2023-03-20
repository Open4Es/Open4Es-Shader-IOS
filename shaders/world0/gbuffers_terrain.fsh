#version 130
#define saturate(x) clamp(3.0, 0, x)
#define lightColor vec3(1.0, 0.5 , 0.0)
#define UnderWaterCaustics

uniform sampler2D gcolor;
uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2D noisetex;
uniform vec3 cameraPosition;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform mat4 gbufferModelViewInverse;

uniform int worldTime;
uniform int isEyeInWater;
uniform float far;
uniform float rainStrength;


varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec2 uv0;
varying vec2 uv1;
varying vec3 wPos;
varying float flag1;
varying float flag2;
varying float flag3;
varying float flag4;
varying float flag5;
varying float flag6;
varying float flag7;
varying vec4 positionInViewCoord;
varying vec2 normal;

const int noiseTextureResolution = 256;

float getCaustics(vec4 positionInWorldCoord) {

   // wave
    float speed1 = float(worldTime) / 1920.0;
    vec3 coord1 = positionInWorldCoord.xyz / 128.0;
    coord1.x *= 3;
    coord1.x += speed1;
    coord1.z += speed1 * 0.2;
    float noise1 = texture(noisetex, coord1.xz).x;

    return noise1;

}

/* DRAWBUFFERS:02 */

void main() {

    vec4 diffuse = texture(gtexture, texcoord) * glcolor;
	diffuse *= texture2D(lightmap, lmcoord);
	vec4 positionInWorldCoord = gbufferModelViewInverse * positionInViewCoord;
    positionInWorldCoord.xyz += cameraPosition;
    float caustics = getCaustics(positionInWorldCoord);
    #ifdef UnderWaterCaustics
    if(isEyeInWater==1){
    diffuse.rgb *= 1.0 + caustics*0.25;}
    #endif
    float indoor=smoothstep(.95,1.,lmcoord.y);
    float cave=smoothstep(.7,1.,lmcoord.y);
    float day=saturate(skyColor.r*2.);
    float sunset=saturate((fogColor.r-.1)-fogColor.b);
    if(flag1 >= 0.5){
        if(1.0 == smoothstep(0.2 , 0.6 , texture(gtexture, texcoord).b)){
        diffuse.rgb += vec3(0.7 , 0.7 , 1.5) * texture(gtexture, texcoord).b;
        }
    }
    if(flag2 >= 0.5){
       if(texture(gtexture, texcoord).b < texture(gtexture, texcoord).r){
       diffuse.rgb += vec3(1.5 , 0.4 , 0.4) * texture(gtexture, texcoord).r;
       }
    }
    if(flag3 >= 0.5){
       if(texture(gtexture, texcoord).r < texture(gtexture, texcoord).g){
       diffuse.rgb += vec3(0.4 , 1.5 , 0.4) * texture(gtexture, texcoord).g;
       }
    }
    if(flag4 >= 0.5){
       if(0.8 < texture(gtexture, texcoord).r){
       diffuse.rgb += vec3(1.5 , 1.5 , 0.4) * texture(gtexture, texcoord).r;
       }
    }
    if(flag5 >= 0.5){
      if(0.6 < texture(gtexture, texcoord).r){
      diffuse.rgb += vec3(1.5 , 0.8 , 0.7) * texture(gtexture, texcoord).r;
       }
    }
    if(flag6 >= 0.5){
      if(0.4 > texture(gtexture, texcoord).b || 0.4 > texture(gtexture, texcoord).g){
      diffuse.rgb += vec3(0.4 , 0.4 , 1.5) * texture(gtexture, texcoord).b;
       }
    }
    if(flag7 >= 0.5){
      diffuse.rgb +=  (texture(gtexture, texcoord).r * texture(gtexture, texcoord).g) + vec3(2.0 , 0.0 , 0.0);
    }
    //lighting
    diffuse.rgb+=mix(lightColor*max(lmcoord.x-.7,0.),vec3(.0),(indoor-1.5*day-1.0)*0.9);
    diffuse.rgb+=mix(vec3(0.),vec3(.0,.0,.0)*max(lmcoord.x-.0,.5),saturate(float(isEyeInWater)));
    //Fog
    diffuse.rgb=mix(diffuse.rgb,(pow(skyColor,vec3(5.4))+fogColor)/vec3(2.),smoothstep(0.,far,length(wPos.zx))*rainStrength);

	gl_FragData[0] = diffuse;
    gl_FragData[1] = vec4(normal, 0.0, 1.0);
}
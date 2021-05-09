#version 120

attribute vec4 mc_Entity;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 color;
varying vec2 normal;
varying float waterFlag;

vec2 normalEncode(vec3 n) {
    vec2 enc = normalize(n.xy) * (sqrt(-n.z*0.5+0.5));
    enc = enc*0.5+0.5;
    return enc;
}

void main() {
    gl_Position = ftransform();
    color = gl_Color;
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    normal = normalEncode(gl_NormalMatrix * gl_Normal);

    waterFlag = 0.0;

    if(mc_Entity.x == 8.0 || mc_Entity.x == 9.0){
    waterFlag = 1.0;}
}

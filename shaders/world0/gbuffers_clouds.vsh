#version 130

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

uniform vec3 sunPosition;
uniform vec3 cameraPosition;

varying vec2 normal;
varying vec2 texcoord;
varying vec3 cPos;
varying vec3 wPos;
varying vec4 glcolor;

 
vec2 normalEncode(vec3 n) {
    vec2 enc = normalize(n.xy) * (sqrt(-n.z*0.5+0.5));
    enc = enc*0.5+0.5;
    return enc;
}

void main(){
    vec4 position = gl_ModelViewMatrix * gl_Vertex;
    gl_Position = gl_ProjectionMatrix * position;
    normal = normalEncode(gl_NormalMatrix * gl_Normal);
    texcoord=(gl_TextureMatrix[0]*gl_MultiTexCoord0).xy;
    glcolor=gl_Color;
    vec4 pos=gbufferModelViewInverse*gl_ModelViewMatrix*gl_Vertex;
    cPos=pos.xyz+cameraPosition;
    wPos=pos.xyz;
    gl_Position=gl_ProjectionMatrix*gbufferModelView*pos;
}
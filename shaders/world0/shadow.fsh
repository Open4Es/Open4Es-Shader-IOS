#version 130
 
uniform sampler2D gtexture;
 
varying vec4 texcoord;
 
void main() {
    gl_FragData[0] = texture(gtexture, texcoord.st);
}
#version 120

varying vec2 texcoord;
 
void main() {
     vec4 position = gl_ModelViewMatrix * gl_Vertex;
	gl_Position = gl_ProjectionMatrix * position;
	
     texcoord = gl_MultiTexCoord0.st;
}

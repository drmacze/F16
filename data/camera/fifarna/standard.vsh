uniform   mat4 u_mvpMatrix;
attribute vec4 a_position;
attribute vec2 a_texCoord;
attribute vec4 a_vertexColor;

varying vec2 v_texCoord; 
varying vec4 v_color; 


void main()
{
	const vec4 litScale = vec4(1.5, 1.5, 1.5, 1.0);
	gl_Position = u_mvpMatrix * a_position;
	v_texCoord  = a_texCoord;
	v_color     = litScale * a_vertexColor; 
}
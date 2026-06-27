uniform lowp sampler2D s_texture;

varying lowp vec2 v_texCoord;
varying lowp vec4 v_color; 

void main()
{
	lowp vec4 texcolor = texture2D( s_texture, v_texCoord );
	gl_FragColor	= texcolor * v_color;
}
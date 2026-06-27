uniform lowp sampler2D s_texture;

varying lowp vec2 v_texCoord;
varying lowp vec4 v_color; 

void main()
{
		lowp vec4 t = texture2D(s_texture, v_texCoord);
	
	if(t.a <= 0.93)
	 	discard;
		
	gl_FragColor	= t * v_color;
}
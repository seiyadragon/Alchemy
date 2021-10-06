shader_type spatial;

uniform sampler2D noise_texture;
uniform vec4 leaf_color;
uniform vec4 bark_color;

varying vec4 out_color;

void vertex()
{
	if (VERTEX.y > 100.0)
	{
		VERTEX.x += sin(TIME * 1.0) * 5.0;
		VERTEX.z += sin(TIME * 1.0) * 5.0;
		out_color = leaf_color;
	}
	else
	{
		out_color = bark_color;
	}
	
	if (VERTEX.x <= 10.0 && VERTEX.x >= -10.0)
		if (VERTEX.z <= 10.0 && VERTEX.z >= -10.0)
			out_color = bark_color;
}

void fragment()
{
	ALBEDO = (out_color * texture(noise_texture, UV)).xyz;
}
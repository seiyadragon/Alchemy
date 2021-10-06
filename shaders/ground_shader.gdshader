shader_type spatial;

uniform sampler2D noise_texture;
uniform vec4 grass_color;

void fragment()
{
	ALBEDO = (grass_color * texture(noise_texture, UV)).xyz;
}
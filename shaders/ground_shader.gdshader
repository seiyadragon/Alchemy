shader_type spatial;
render_mode blend_mix, cull_back, depth_draw_opaque;

uniform sampler2D noise_texture;
uniform vec4 grass_color: source_color;

void fragment()
{
	ALBEDO = (grass_color * texture(noise_texture, UV)).xyz;
}
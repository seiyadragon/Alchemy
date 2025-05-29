shader_type spatial;
render_mode blend_mix, cull_back, depth_draw_opaque;

uniform sampler2D noise_texture;
uniform vec4 leaf_color : source_color;
uniform vec4 bark_color : source_color;

varying vec4 out_color;

void vertex() {
	if (VERTEX.y > 100.0) {
		VERTEX.x += sin(TIME * 1.0) * 5.0;
		VERTEX.z += sin(TIME * 1.0) * 5.0;
		out_color = leaf_color;
	} else {
		out_color = bark_color;
	}

	if (VERTEX.x <= 10.0 && VERTEX.x >= -10.0 && VERTEX.y <= 10.0 && VERTEX.y >= -10.0) {
		out_color = bark_color;
	}
}

void fragment() {
	ALBEDO = (out_color * texture(noise_texture, UV)).rgb;
}
shader_type canvas_item;
uniform sampler2D emission_texture;

void fragment() {
	vec4 current_color = texture(TEXTURE, UV);
	vec4 emission_color = texture(emission_texture, UV);
	
	if (emission_color.r > 0.0) {
		COLOR = (emission_color + vec4(1.0, 0, 0, 0));
	} else {
		COLOR = current_color;
	}
}

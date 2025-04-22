shader_type canvas_item;

uniform vec4 dest_color: source_color;
uniform float color_intencity = 0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color = mix(color, dest_color, color_intencity);
	COLOR = color;
}

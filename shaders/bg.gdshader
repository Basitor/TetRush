shader_type canvas_item;

uniform vec4 color_top : source_color = vec4(0.2, 0.3, 0.5, 1.0);
uniform vec4 color_bottom : source_color = vec4(0.9, 0.7, 0.5, 1.0);

void fragment() {
    float grad = UV.y;
    COLOR = mix(color_top, color_bottom, grad);
}
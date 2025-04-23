shader_type canvas_item;

uniform vec4 color_top : source_color = vec4(0.2, 0.3, 0.5, 1.0);
uniform vec4 color_bottom : source_color = vec4(0.9, 0.7, 0.5, 1.0);
uniform float vignette_strength : hint_range(0.0, 2.0) = 1.0;
uniform float vignette_width : hint_range(0.0, 1.0) = 0.4;

void fragment() {
    float grad = UV.y;
    vec4 base_color = mix(color_top, color_bottom, grad);
    
    float dist_from_center = abs(UV.x - 0.5);
    float vignette = smoothstep(vignette_width, 0.5, dist_from_center);
    float vignette_factor = 1.0 - vignette * vignette_strength;

    COLOR = base_color * vignette_factor;
}

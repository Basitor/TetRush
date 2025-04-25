shader_type canvas_item;

uniform float time : hint_range(0.0, 10.0);
uniform vec4 vignette_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float wave_width : hint_range(0.01, 0.5) = 0.1;
uniform float speed : hint_range(0.1, 10.0) = 1.0;

void fragment() {
    vec2 center = vec2(0.5);
    float dist = distance(UV, center);
    float radius = mod(time * speed, 1.5);

    float edge = smoothstep(radius - wave_width, radius, dist) * (1.0 - smoothstep(radius, radius + wave_width, dist));

	vec4 wave_color = vignette_color;
    wave_color.a *= edge;

    COLOR = wave_color;
}

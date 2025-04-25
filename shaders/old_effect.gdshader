shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float scanline_intensity = 0.02;

void fragment() {
    vec2 uv = UV * 2.0 - 1.0;
    vec2 distorted_uv = uv * 0.5 + 0.5;
    vec4 tex_color = vec4(0.0);
    if (distorted_uv.x >= 0.0 && distorted_uv.x <= 1.0 &&
        distorted_uv.y >= 0.0 && distorted_uv.y <= 1.0) {
        tex_color = texture(SCREEN_TEXTURE, distorted_uv);
        float scanline = sin(UV.y * 240.0 * 3.14159) * scanline_intensity;
        tex_color.rgb -= scanline;
    }
    COLOR = tex_color;
}

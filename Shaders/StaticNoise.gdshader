shader_type canvas_item;

uniform vec2 u_resolution;
uniform float distortion;
uniform float dark_value : hint_range(0, 1);
uniform float opacity : hint_range(0, 1);

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void fragment() {
    vec2 st = FRAGCOORD.xy/u_resolution.xy;

    float time = TIME-float(int(TIME));
    vec2 translate = vec2(distortion * time, 0);
    st += translate;

    vec2 ipos = floor(st);
    vec3 color = vec3(random(ipos * time / distortion));
	color += vec3(-dark_value);
    COLOR = vec4(color,opacity) * texture(TEXTURE, UV);
}

void vertex() {	
}

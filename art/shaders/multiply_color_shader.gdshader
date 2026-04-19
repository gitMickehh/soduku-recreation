shader_type canvas_item;

uniform vec3 my_color;

void fragment() {
	COLOR.rgb = my_color;
}

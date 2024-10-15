shader_type canvas_item;

uniform float scroll_speed = .05;

void vertex() {
	UV.x += TIME * scroll_speed;
	UV.y += TIME * scroll_speed;
}
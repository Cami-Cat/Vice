shader_type canvas_item;

uniform vec4 color : source_color;

uniform float progress : hint_range(0.0, 1.0);
uniform float diamond_size : hint_range(1.0,100.0) = 40;
uniform bool fill = true;

void fragment() {
	float x = abs(fract(FRAGCOORD.x/diamond_size)-0.5);
	float y = abs(fract(FRAGCOORD.y/diamond_size)-0.5);

	if (x + y + UV.x > progress * 2.0){
		if (fill){
			discard;
		}
	}
	else if (!fill){
		discard;
	}

	COLOR = color;
}

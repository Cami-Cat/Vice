shader_type canvas_item;

uniform vec2 tilt_amount = vec2(0.5, 0.5); // Max tilt intensity
uniform vec2 direction = vec2(0.5,0.5);
uniform float alpha = 1.0;

void vertex() {
    VERTEX.x += direction.x * tilt_amount.x * VERTEX.y;
    VERTEX.y += direction.y * tilt_amount.y * VERTEX.x;
}

void fragment() {
	COLOR.a *= alpha;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

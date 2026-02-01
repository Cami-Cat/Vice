shader_type canvas_item;
uniform sampler2D _texture;
uniform float progress = 0.0f;

void fragment() {
	vec4 color = COLOR;
	if (UV.x <= progress)
	{
		color = texture(_texture,UV);
	}
	COLOR = color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

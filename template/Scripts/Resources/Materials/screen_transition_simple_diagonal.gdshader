shader_type canvas_item;

uniform vec4 color : source_color = vec4(0.0,0.0,0.0,1.0);

uniform bool centered = false;

uniform float progress : hint_range(0.0,1.0);
uniform bool fill = true;

void fragment() {
	if (centered){
		if ((abs(UV.x - 0.5)*2.0) + (abs(UV.y - 0.5)*2.0) > progress * 2.0){
			if(fill){
				discard;
			}
		}
		else if (!fill){
			discard;
		}
	}
	else{
		if (UV.x + UV.y > progress * 2.0){
			if(fill){
				discard;
			}
		}
		else if (!fill){
			discard;
		}
	}

	COLOR = color;
}


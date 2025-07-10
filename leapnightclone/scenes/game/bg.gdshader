//se apllica a sprites shaders etc
shader_type canvas_item;


void vertex() {
	// accedemos al uv
	//DESPLAZAMIENTO del background
	UV.x += TIME * 0.3;
	UV.y += TIME * 0.3;
}


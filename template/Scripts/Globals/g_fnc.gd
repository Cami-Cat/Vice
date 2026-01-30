extends Node

func all_true(state:bool) -> bool:
	return state == true

func all_false(state:bool) -> bool:
	return state == false

func get_type_string(property : Variant = null) -> String:
	var return_string = type_string(typeof(property))
	return return_string

func iround_down_to(input:int,round_to_nearest:int) -> int:
	if input % round_to_nearest == 0:
		return input
	input -= input%round_to_nearest
	return input

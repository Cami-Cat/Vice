extends Node


## Section : Tweens

## Example usage of this method with multiple different callbacks for Parallel and Chain:
##
##		var tween = GFnc._tween_method(self, print_random_shit, from, to, length_seconds, Tween.TRANS_SINE)
##		GFnc._parallel_method(self, tween, make_number_go_up, 0, 100, length_seconds, Tween.TRANS_BOUNCE)
##		GFnc._chain_method(self, tween, print_random_shit, "oops", "hehe", length_seconds, Tween.TRANS_EXPO)
##		await GFnc.kill_tween(tween)
##
## Tweens will remain in the stack unless you call GFnc.kill_tween(tween) or if the object that the tween is bound to is then killed.
## Alternatively you can await for tween_finished before calling the next one, like such.
##
##		var tween = GFnc._tween_method(self, print_random_shit, from, to, length_seconds, Tween.TRANS_SINE)
##		await GFnc.tween_finished(tween)
##		... Code here ...
##
## But if you're going to await before executing another tween on the same object, just use _chain_property or _chain_method


func _tween_property(object : Node = null, property : NodePath = "position", to : Variant = null, time_in_seconds : float = 0.0, tween_transition_type : Tween.TransitionType = Tween.TRANS_LINEAR) -> Tween:
	var tween : Tween = create_tween()
	if !is_tween_valid(tween, object.get(str(property)), to) : return
	tween.bind_node(object)
	tween.tween_property(object, property, to, time_in_seconds).set_trans(tween_transition_type)
	return tween

func _tween_method(object : Node = null, method : Callable = call, from : Variant = null, to : Variant = null, time_in_seconds : float = 0.0, tween_transition_type : Tween.TransitionType = Tween.TRANS_LINEAR) -> Tween:
	var tween : Tween = create_tween()
	if !is_tween_valid(tween, from, to) : return
	tween.bind_node(object)
	tween.tween_method(method.bind(object), from, to, time_in_seconds).set_trans(tween_transition_type)
	return tween

func _chain_method(object : Node = null, in_tween : Tween = null, method : Callable = call, from : Variant = null, to : Variant = null, time_in_seconds : float = 0.0, tween_transition_type : Tween.TransitionType = Tween.TRANS_LINEAR) -> void:
	if !is_tween_valid(in_tween, from, to) : return
	in_tween.chain().tween_method(method.bind(object), from, to, time_in_seconds).set_trans(tween_transition_type)
	return

func _chain_property(object : Node = null, in_tween : Tween = null, property : NodePath = "position", to : Variant = null, time_in_seconds : float = 0.0, tween_transition_type : Tween.TransitionType = Tween.TRANS_LINEAR) -> void:
	if !is_tween_valid(in_tween, object.get(str(property)), to) : return
	in_tween.chain().tween_property(object, property, to, time_in_seconds).set_trans(tween_transition_type)
	return

func _parallel_property(object : Node = null, in_tween : Tween = null, property : NodePath = "position", to : Variant = null, time_in_seconds : float = 0.0, tween_transition_type : Tween.TransitionType = Tween.TRANS_LINEAR) -> void:
	if !is_tween_valid(in_tween, object.get(str(property)), to) : return
	in_tween.parallel().tween_property(object, property, to, time_in_seconds).set_trans(tween_transition_type)
	return

func _parallel_method(object : Node = null, in_tween : Tween = null, method : Callable = call, from : Variant = null, to : Variant = null, time_in_seconds : float = 0.0, tween_transition_type : Tween.TransitionType = Tween.TRANS_LINEAR) -> void:
	if !is_tween_valid(in_tween, from, to) : return
	in_tween.parallel().tween_method(method.bind(object), from, to, time_in_seconds).set_trans(tween_transition_type)
	return

func is_tween_valid(in_tween : Tween, from : Variant = null, to : Variant = null) -> bool:
	if in_tween == null:
		push_error(str(self), "Tween is not valid: Tween does not exist.")
		return false
	if typeof(from) != typeof(to):
		push_error(str(self), "The property: [%s] is not of the type: %s" % [GFnc.get_type_string(from), GFnc.get_type_string(to)])
		return false
	return true

func tween_finish(in_tween : Tween) -> void:
	if !in_tween:
		push_error(str(self), "No tween found. Aborting")
		return
	if in_tween.is_running() : await in_tween.finished
	return

func kill_tween(in_tween : Tween) -> bool:
	if !in_tween:
		push_error(str(self), "No tween found. Aborting")
		return false
	if in_tween.is_running() : await in_tween.finished
	in_tween.kill()
	push_error(str(self), "Tween killed.")
	return true

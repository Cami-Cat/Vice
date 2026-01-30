class_name Promise extends RefCounted

signal first(_signal:Signal,varient)
signal last(_signal:Signal,varient)
signal all

var signal_dict:Dictionary[Signal,bool]
var first_found:bool = false

func _init(signal_array:Array[Signal]) -> void:
	for _signal in signal_array:
		signal_dict[_signal] = false
		if !_signal.is_connected(signal_callback):
			_signal.connect(signal_callback.bind(_signal))

func signal_callback(args,_signal:Signal):
	var _signals_state:Array[bool] = signal_dict.values()
	if !first_found:
		if _signals_state.all(GFnc.all_false):
			first.emit(_signal,args)
	signal_dict[_signal] = true
	_signals_state = signal_dict.values()
	if _signals_state.all(GFnc.all_true):
		last.emit(_signal,args)
		all.emit()

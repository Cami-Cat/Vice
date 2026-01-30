class_name AutoLayer extends CanvasLayer

@export var _layer:GVar.LAYERS = GVar.LAYERS.DEBUG

func _ready() -> void:
	layer = GVar.LAYER_DICT[_layer]

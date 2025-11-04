extends Node

signal levelChanged(levelNum)

@export var levelNum = 0

var isHost = 0

func _on_host_pressed() -> void:
	isHost = 1
	emit_signal("levelChanged", levelNum)
	
func _on_join_pressed() -> void:
	isHost = 2
	emit_signal("levelChanged", levelNum)

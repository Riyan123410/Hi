extends Node

var sendStartSignal = Node

func _ready() -> void:
	sendStartSignal = $"/root/sceneSwitcher/startGameSignal"

func _on_button_pressed() -> void:
	sendStartSignal.start()
	queue_free()

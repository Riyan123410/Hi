extends interactable

@export var gameSetupWindow : PackedScene
var sceneSwitcher = Node

func _ready() -> void:
	sceneSwitcher = $"/root/sceneSwitcher"

func interactAction(player : CharacterBody3D):
	var gameSetupWindowInstance = gameSetupWindow.instantiate()
	sceneSwitcher.add_child(gameSetupWindowInstance)
	player._setPause(false)
	rpc("RPCdelete")

@rpc("any_peer", "call_local")
func RPCdelete():
	queue_free()

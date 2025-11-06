extends interactable

@export var gameSetupWindow : PackedScene
var sceneSwitcher = Node

func _ready() -> void:
	sceneSwitcher = get_parent().get_parent().get_parent()

func interactAction(player):
	var gameSetupWindowInstance = gameSetupWindow.instantiate()
	sceneSwitcher.add_child(gameSetupWindowInstance)
	player._setMovement(false)
	rpc("RPCdelete")

@rpc("any_peer", "call_local")
func RPCdelete():
	queue_free()

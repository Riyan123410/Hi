extends interactable

var player = null

func interactAction(_player : CharacterBody3D):
	if !usingControl:
		player = _player
		player.enableMovement = false
		usingControlLocal = true
		rpc("RPCusingControlTrue")

func _process(_delta: float) -> void:
	if usingControlLocal and Input.is_action_just_released("interact"):
		player.enableMovement = true
		usingControlLocal = false
		rpc("RPCusingControlFalse")

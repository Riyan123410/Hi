extends interactable

var isMoving = false

func interactAction(_player):
	isMoving = true

func _process(_delta: float) -> void:
	if Input.is_action_just_released("interact"):
		isMoving = false

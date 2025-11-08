extends interactable

var isSteering = false

func interactAction(player):
	isSteering = !isSteering
	if isSteering:
		player._setMovement(false)
	else:
		player._setMovement(true)

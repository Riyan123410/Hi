extends Node

var nextLevel = null

@onready var currentLevel = $MainMenu
@onready var anim = $AnimationPlayer

func _ready() -> void:
	$MainMenu.connect("levelChanged", Callable(self, "handleLevelChanged"))

func handleLevelChanged(currentLevelNum: int):
	var nextLevelName = ""
	
	match currentLevelNum:
		0:
			nextLevelName = "game"
		_:
			return
	nextLevel = load("res://scenes/worlds/" + nextLevelName + ".tscn").instantiate()
	anim.play("fadeIn")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"fadeIn":
			add_child(nextLevel)
			if nextLevel.has_signal("levelChanged"):
				nextLevel.connect("levelChanged", Callable(self, "handleLevelChanged"))
			
			transferDataBetweenScenes(currentLevel, nextLevel)
			
			currentLevel.queue_free()
			currentLevel = nextLevel
			nextLevel = null
			anim.play("fadeOut")

func transferDataBetweenScenes(oldScene, newScene):
	newScene.isHost = oldScene.isHost

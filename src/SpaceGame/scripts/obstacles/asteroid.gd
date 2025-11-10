class_name Asteroid extends MeshInstance3D

var sceneSwitcher = null
var tween:Tween

var radius = 1000

func _ready() -> void:
	sceneSwitcher = $"/root/sceneSwitcher"
	
	await get_tree().process_frame
	if global_position.distance_squared_to(Vector3(3850, 3850, 3850)) < radius * radius:
		var mat = self.get_active_material(0)
		if mat:
			mat = mat.duplicate()
			self.set_surface_override_material(0, mat)
			mat.albedo_color = Color(1, 0, 0)

func swell_in(target_scale:float) -> void:
	# Asteroids appear very small and tween their scale up
	# to full size, so it's less noticeable when distant
	# asteroids appear out of nowhere.
	tween = create_tween()
	tween.tween_property(self, 'scale',
		Vector3(target_scale, target_scale, target_scale),
		5.0) # 5 seconds

func shrink_out() -> void:
	# Asteroids shirink down to scale 1 before self deleting
	# to make it look better when the asteroid is getting removed,
	# in case the player is looking.
	if tween:
		tween.kill()
	# Shrink down then queue free
	tween = create_tween()
	tween.tween_property(self, 'scale',
		Vector3(1.0, 1.0, 1.0),
		5.0) # 5 seconds
	await tween.finished
	queue_free()











#extends Node
#
#var cubeSize = 20
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#var obstacle = get_parent()
	#if abs(obstacle.position.x) < cubeSize and abs(obstacle.position.y) < cubeSize and abs(obstacle.position.z) < cubeSize:
		#obstacle.queue_free()

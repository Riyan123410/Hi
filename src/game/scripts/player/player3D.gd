extends CharacterBody3D

# ===== Movement variables =====
@export var speed = 5.0
@export var jumpVelocity = 4.5
@export var acceleration = 4.0
@export var airAcceleration = 1.0
@export var friction = 5.0
@export var airFriction = 0.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
# ===== Camera variables =====
@export var mouseSensitivity = 0.002 # radians per pixel

# ===== Node references =====
@export var head: Node3D
@export var camera: Camera3D

# ===== Multiplayer =====
func _enter_tree():
	set_multiplayer_authority(get_parent().name.to_int())
	print(get_parent().name)

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.current = is_multiplayer_authority()

# ===== Mouse input =====
func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouseSensitivity)
		head.rotate_x(-event.relative.y * mouseSensitivity)
		head.rotation.x = clampf(head.rotation.x, deg_to_rad(-89.9), deg_to_rad(89.9))
	if Input.is_action_just_pressed("toggleCursor"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# ===== Movement =====
func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return  # Non-authority peers do not move locally

	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpVelocity

	# Movement
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var currentAcceleration = acceleration if is_on_floor() else airAcceleration
	var currentFriction = friction if is_on_floor() else airFriction

	if direction != Vector3.ZERO:
		velocity.x = move_toward(velocity.x, direction.x * speed, currentAcceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, currentAcceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, currentFriction * delta)
		velocity.z = move_toward(velocity.z, 0, currentFriction * delta)
		
	move_and_slide()

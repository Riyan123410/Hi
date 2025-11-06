extends CharacterBody3D

# ===== Movement variables =====
@export var speed = 5.0
@export var jumpVelocity = 4.5
@export var acceleration = 4.0
@export var airAcceleration = 1.0
@export var friction = 5.0
@export var airFriction = 0.5
@export var enableMovement = true
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# ===== Camera variables =====
@export var mouseSensitivity = 0.002 # radians per pixel
@export var interactTrace : RayCast3D

# ===== Node references =====
@export var head: Node3D
@export var camera: Camera3D
var sendStartSignal = Node

# ===== Interaction =====
var lookAt : Node

# ===== Multiplayer =====
func _enter_tree():
	set_multiplayer_authority(get_parent().name.to_int())

func _ready():
	sendStartSignal = $"/root/sceneSwitcher/startGameSignal"
	sendStartSignal.connect("startGame", Callable(self, "_setMovement").bind(true))
	self.visible = !is_multiplayer_authority()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.current = is_multiplayer_authority()
	
	velocity = Vector3.ZERO
	self.position = Vector3(0, 0, 0)

# ===== Mouse input =====
func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouseSensitivity)
		head.rotate_x(-event.relative.y * mouseSensitivity)
		head.rotation.x = clampf(head.rotation.x, deg_to_rad(-89.9), deg_to_rad(89.9))
		
# ===== Mouse renable debug =====
	if Input.is_action_just_pressed("toggleCursor"): 
		if enableMovement:
			_setMovement(false)
		else:
			_setMovement(true)
	


# ===== Movement =====
func _physics_process(delta: float) -> void:
	
	if not is_multiplayer_authority() or not enableMovement:
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

# ===== Interaction =====
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		lookAt = interactTrace.get_collider()
		if lookAt != null:
			lookAt = lookAt.get_parent()
			if lookAt.has_method("interactAction"):
				lookAt.interactAction(self)

# ===== Enable/Disable Movement =====
func _setMovement(setMovement):
	if (setMovement):
		enableMovement = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		enableMovement = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

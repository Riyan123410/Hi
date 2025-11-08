extends Node

@export var steering : Node3D
@export var shipSpeed : Node3D
var sendStartSignal = null

var begin = false

# steering
var direction = 0
var tilt = 0
var steeringSpeed = 0.5

# movemnt
var speed = 3
var moveDir = 0
var acceleration = 0

func _ready():
	sendStartSignal = $"/root/sceneSwitcher/startGameSignal"
	sendStartSignal.connect("startGame", Callable(self, "start"))

func _physics_process(delta: float) -> void:
	if !begin:
		return
	if steering.isSteering:
		steer(delta)

	if shipSpeed.isMoving:
		move(delta, 1)
	else:
		move(delta, -1)

func start():
	begin = true

func steer(delta):
	# inputs
	direction = int(Input.is_action_pressed("left")) - int(Input.is_action_pressed("right"))
	tilt = int(Input.is_action_pressed("forward")) - int(Input.is_action_pressed("backward"))
	
	self.rotation.y += direction * steeringSpeed * delta
	self.rotation.x += tilt * steeringSpeed * delta
	self.rotation.x = clamp(self.rotation.x, -0.5, 0.5)

# move relative
func move(delta, dir):
	moveDir = -self.transform.basis.z  # Node’s forward in world space
	acceleration = clamp(acceleration + (speed * delta * dir), 0, 15)
	self.position += moveDir * acceleration * delta

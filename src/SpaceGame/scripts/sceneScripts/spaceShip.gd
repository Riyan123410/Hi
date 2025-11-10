extends Node

@export var steering : Node3D
@export var shipSpeed : Node3D
var sendStartSignal = null

var begin = false

# steering
var direction = 0
var steeringSpeed = 0.5

# movemnt
var speed = 10
var moveDir = 0
var acceleration = 0
var maxAcc = 500

func _ready():
	sendStartSignal = $"/root/sceneSwitcher/startGameSignal"
	sendStartSignal.connect("startGame", Callable(self, "start"))

func _physics_process(delta: float) -> void:
	if !begin: # or !multiplayer.is_server()
		return
	
	if !shipSpeed.usingControl:
		rpc("move", delta, -1)
	elif shipSpeed.usingControlLocal:
		rpc("move", delta, 1)
	
	if steering.usingControlLocal:
		# inputs
		direction = int(Input.is_action_pressed("left")) - int(Input.is_action_pressed("right"))
		# rpc
		rpc("steer", direction, delta)

func start():
	begin = true
	var asteroidSpawner = $"/root/sceneSwitcher/world/stage/asteroidSpawner"
	asteroidSpawner.generate_field(self)

@rpc("any_peer", "call_local")
func steer(directionLocal : int, delta : float):
	# rotate
	self.rotation.y += directionLocal * steeringSpeed * delta

@rpc("any_peer", "call_local")
func move(delta : float, dir : int):
	# move forward
	moveDir = -self.transform.basis.z  # Node’s forward in world space
	acceleration = clamp(acceleration + (speed * delta * dir), 1, maxAcc)
	self.position += moveDir * acceleration * delta
	
	# tilt
	self.rotation.x += dir * steeringSpeed * delta
	self.rotation.x = clamp(self.rotation.x, -0.2, 0.5)

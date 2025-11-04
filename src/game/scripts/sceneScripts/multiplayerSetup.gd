extends Node3D

var isHost = 0
var loop = true

var peer = ENetMultiplayerPeer.new()
@export var playerScene : PackedScene

func _process(_delta: float) -> void:
	if loop:
		if isHost == 1:
			runHost()
			loop = false
		elif isHost == 2:
			runClient()
			loop = false

func runHost():
	peer.create_server(1024)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(addPlayer)
	addPlayer()
	
func runClient():
	peer.create_client("10.0.0.86", 1024)
	multiplayer.multiplayer_peer = peer
	
func addPlayer(id = multiplayer.get_unique_id()):
	var player = playerScene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	
func deletePlayer(id):
	rpc("_deletePlayer", id)

@rpc("any_peer", "call_local")
func _deletePlayer(id):
	get_node(str(id)).queue_free()
	
func exitGame(id):
	multiplayer.peer_disconnected.connect(deletePlayer)
	deletePlayer(id)

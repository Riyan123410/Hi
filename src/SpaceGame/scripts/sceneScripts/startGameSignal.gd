extends Node

signal startGame()

func start():
	rpc("RPCsignal")
	

@rpc("any_peer", "call_local")
func RPCsignal():
	emit_signal("startGame")

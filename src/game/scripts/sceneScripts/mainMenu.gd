extends Node

signal levelChanged(levelNum)

@export var levelNum = 0
@export var textIP : TextEdit
@export var textPort : TextEdit
@export var textPortHost : TextEdit

var isHost = 0
var IPjoin = "127.0.0.1"
var portJoin = "1024"
var portHost = "1024"

func _on_host_pressed() -> void:
	isHost = 1
	portHost = int(textPortHost.text)
	if (portHost != 0):
		emit_signal("levelChanged", levelNum)
	
func _on_join_pressed() -> void:
	isHost = 2
	IPjoin = textIP.text
	portJoin = int(textPort.text)
	if (IPjoin != "" && portJoin != 0):
		emit_signal("levelChanged", levelNum)
		
func _on_join_lobby_pressed() -> void:
	$CanvasLayer/joinLobby.visible = false
	$CanvasLayer/IP.visible = true
	$CanvasLayer/Join.visible = true
	$CanvasLayer/Port.visible = true
	
func _on_host_lobby_pressed() -> void:
	$CanvasLayer/hostLobby.visible = false
	$CanvasLayer/Host.visible = true
	$CanvasLayer/hostPort.visible = true

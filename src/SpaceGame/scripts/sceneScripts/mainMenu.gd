extends Node

signal levelChanged(levelNum)

@export var levelNum = 0

@export var textIP : LineEdit
@export var textPort : LineEdit
@export var textPortHost : LineEdit

@export var joinlobbyButton : Button
@export var hostLobbyButton : Button
@export var hostButton : Button
@export var joinButton : Button

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
	setJoinButtonVisibility(true)
	setHostButtonVisibility(false)
	
func _on_host_lobby_pressed() -> void:
	setHostButtonVisibility(true)
	setJoinButtonVisibility(false)
	
func setJoinButtonVisibility(show : bool):
	joinlobbyButton.visible = !show
	textIP.visible = show
	joinButton.visible = show
	textPort.visible = show
func setHostButtonVisibility(show : bool):
	hostLobbyButton.visible = !show
	hostButton.visible = show
	textPortHost.visible = show

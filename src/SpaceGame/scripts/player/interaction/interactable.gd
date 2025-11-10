class_name interactable
extends Node

var usingControl = false
var usingControlLocal = false

func interactAction(_player : CharacterBody3D):
	print("default interact")

@rpc("any_peer", "call_local",)
func RPCusingControlTrue():
	usingControl = true

@rpc("any_peer", "call_local")
func RPCusingControlFalse():
	usingControl = false

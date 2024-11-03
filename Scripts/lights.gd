extends Node2D

var states : int = 0

@export var ids : Array
@export var idToggles : Array
@export var outID : int
@export var lightNum : int

signal solved(id)

func _on_receive_id_signal(id):
	var index = -1
	for i in len(ids):
		if ids[i] == id:
			index = i
			break
	
	if(index == -1):
		return
	
	var toggle = idToggles[index]
	states ^= toggle
	for i in lightNum:
		get_child(i).frame = (states >> i) & 1
	
	if states == pow(lightNum, 2) - 1:
		solved.emit(outID)
		$AudioStreamPlayer.play()

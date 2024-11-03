extends Node2D

@export var activateId : int

func _on_turn_on(id):
	if(activateId == id):
		$AnimationPlayer.play("move")

func _on_turn_off(id):
	if(activateId == id):
		$AnimationPlayer.play_backwards("move")

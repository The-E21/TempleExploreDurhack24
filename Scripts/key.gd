extends Area2D

var id : int
var inArea : bool = false
var done : bool = false

signal pick_key(id)

func _input(event):
	if(event.is_action_pressed("interact") and inArea and not done):
		pick_key.emit(id)
		$AudioStreamPlayer.play()
		done = true
		visible = false

func _on_body_entered(body):
	inArea = true

func _on_body_exited(body):
	inArea = false

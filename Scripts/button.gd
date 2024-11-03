extends Area2D

signal press(id)

@export var id : int
var touching : bool

func _input(event):
	if(event.is_action_pressed("interact") and touching):
		press.emit(id)
		$AudioStreamPlayer.play()

func _on_body_entered(body):
	touching = true

func _on_body_exited(body):
	touching = false

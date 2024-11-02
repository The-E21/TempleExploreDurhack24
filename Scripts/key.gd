extends Area2D

var id : int
var inArea : bool = false

signal pick_key(id)

func _input(event):
	if(event.is_action_pressed("interact") and inArea):
		pick_key.emit(id)
		queue_free()

func _on_body_entered(body):
	inArea = true
	print(body)

func _on_body_exited(body):
	inArea = false
	print(body)

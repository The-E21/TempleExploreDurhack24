extends Area2D

signal press(id)
signal unpress(id)

@export var id : int

func _on_body_entered(body):
	press.emit(id)

func _on_body_exited(body):
	unpress.emit(id)

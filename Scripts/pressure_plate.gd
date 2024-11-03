extends Area2D

signal press(id)
signal unpress(id)

@export var id : int
var pressCount : int = 0

func _on_body_entered(body):
	if(pressCount == 0):
		press.emit(id)
	pressCount += 1

func _on_body_exited(body):
	pressCount -= 1
	if(pressCount == 0):
		unpress.emit(id)

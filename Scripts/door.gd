extends Area2D
var canOpenDoor =false
var doorOpen = false
var id 
var hasKey = false
var DoorOpen
@onready var animations = $AnimatedSprite2D


func input(event):
	if(event.is_action_pressed("interact") and hasKey == true):
		DoorOpen = true
		

func updateAnimation():
	if DoorOpen == false:
		animations.play('closed')
	
	else: 
		DoorOpen == true 
		animations.play('open')
	
	

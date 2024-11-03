extends StaticBody2D
var hasKey = false

@onready var animations = $AnimatedSprite2D

#func input(hasKey):
	#openDoor(0)
	#if(hasKey == true):
		#openDoor(1)
		#updateAnimation(hasKey)
	#else:
		#openDoor(0)
		
#func openDoor(hasKey):
	#$Area2D/CollisionShape2D.enabled = true
	#if hasKey > 0:
		#$Area2D/CollisionShape2D.disabled = true
		
	#if hasKey == 0:
		#$Area2D/CollisionShape2D.enabled = true
		

#func updateAnimation(inp):
	#if inp == false:
		#animations.play('closed')
	#else:
		#inp == true
		#animations.play('open')




func _on_player_send_inv(inventory):
	if len(inventory) != 0:
	
		hasKey = true
		print('Checking Key')
		print('hasKey = '+ str(hasKey))
		return hasKey
		


var isOverDoor = false


func _on_near_door_body_entered(body):
	isOverDoor = true
	print('entered Door')

func _on_near_door_body_exited(body) :
	isOverDoor = false
	print('Exited Door')

func _input(event) :
	print(isOverDoor)
	if isOverDoor and hasKey:
		
		$CollisionShape2D.disabled = true
		animations.play("open")
		print(hasKey)
		

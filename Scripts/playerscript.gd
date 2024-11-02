extends CharacterBody2D
@export var speed : float
@export var gravity : float = 9.8

#Horizontal movement
var leftRightInput : float
var leftRightAimVelocity : float
@export var accelerationMultiplier : float

func  _process(delta):
	leftRightInput = Input.get_axis("ui_left", "ui_right")
	
func _physics_process(delta):
	velocity += Vector2.DOWN * gravity * delta
	leftRightAimVelocity = leftRightInput * speed
	velocity += Vector2((leftRightAimVelocity - velocity.x) * accelerationMultiplier * delta, 0)
	move_and_slide()

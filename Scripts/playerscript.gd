extends CharacterBody2D
@export var speed : float
@export var gravity : float = 9.8

func _physics_process(delta):
	velocity += Vector2.DOWN * gravity * delta
	move_and_slide()

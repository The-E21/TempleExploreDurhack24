extends CharacterBody2D

#Horizontal movement
var leftRightInput : float
var leftRightAimVelocity : float
@export var speed : float
@export var accelerationMultiplier : float

#Vertical movement
var jumpDown : bool = false
@export var gravity : float = 9.8
var jumpPhase : int
@export var jumpHight : float
@export var apexPercentile : float
@export var jumpCut : float

@export var jumpTime : float
@export var apexTime : float
var jumpTimer : float
@export var coyoteTime : float
@export var jumpBufferTime : float
var jumpBufferTimer : float = -1

func _input(event):
	if event.is_action_pressed("jump"):
		jumpDown = true
		jumpBufferTimer = 0
	elif event.is_action_released("jump"):
		jumpDown = false

func  _process(delta):
	leftRightInput = Input.get_axis("ui_left", "ui_right")
	
func _physics_process(delta):
	manageJump(delta)	
	##Horizontal
	leftRightAimVelocity = leftRightInput * speed
	velocity += Vector2((leftRightAimVelocity - velocity.x) * accelerationMultiplier * delta, 0)
	move_and_slide()

func manageJump(delta):
	if(jumpBufferTimer != -1):
		jumpBufferTimer += delta
	if(jumpBufferTimer >= jumpBufferTime):
		jumpBufferTimer = -1
	
	match jumpPhase:
		0:
			if(not is_on_floor()):
				jumpPhase = 4
				jumpTimer = 0
			if(jumpBufferTimer != -1):
				jumpPhase = 1
				jumpTimer = 0
		1:
			var jumpSeed = jumpHight * apexPercentile / jumpTime
			velocity = Vector2(velocity.x, -jumpSeed)
			jumpTimer += delta
			
			if(not jumpDown):
				jumpPhase = 3
				velocity = Vector2(velocity.x, velocity.y * jumpCut)
				
			elif jumpTimer >= jumpTime:
				jumpPhase = 2
				jumpTimer = 0
				velocity = Vector2(velocity.x, -2 * (1 - apexPercentile) * jumpHight / (apexTime/2))
		2:
			velocity += Vector2(0,delta * 2 * (1 - apexPercentile) * jumpHight / pow(apexTime/2, 2))
			jumpTimer += delta
			if jumpTimer >= apexTime:
				jumpPhase = 3
			if not jumpDown:
				jumpPhase = 3
		3:
			velocity += Vector2.DOWN * gravity * delta
			jumpTimer += delta
			if(is_on_floor()):
				jumpPhase = 0
			if(jumpDown):
				jumpTimer = 0
		4:
			jumpTimer += delta
			if(jumpTimer >= coyoteTime):
				jumpPhase = 3
			velocity += Vector2.DOWN * gravity * delta
			if(is_on_floor()):
				jumpPhase = 0
			if(jumpBufferTimer != -1):
				jumpPhase = 1
				jumpTimer = 0
	

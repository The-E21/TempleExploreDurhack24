extends CharacterBody2D

#Constants
const PUSH_FORCE = 100
const MAX_VELOCITY = 150

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

#animation
@onready var animations = $AnimatedSprite2D
@export var flipOffset : float

#Collect Keys
var inventory = []
signal send_inv
func _input(event):
	if event.is_action_pressed("jump"):
		jumpDown = true
		jumpBufferTimer = 0
	elif event.is_action_released("jump"):
		jumpDown = false

func  _process(delta):
	leftRightInput = Input.get_axis("move_left", "move_right")
	
func _physics_process(delta):
	manageJump(delta)	
	##Horizontal
	leftRightAimVelocity = leftRightInput * speed
	velocity += Vector2((leftRightAimVelocity - velocity.x) * accelerationMultiplier * delta, 0)
	move_and_slide()
	updateAnimation()
	push_crate(delta)
	
func push_crate(delta):
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_crate = collision.get_collider()
		if collision_crate.is_in_group("crates") and abs(collision_crate.get_linear_velocity().x) < MAX_VELOCITY: collision_crate.apply_central_impulse(collision.get_normal() * -PUSH_FORCE)

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
				$JumpSound.play()
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
				$JumpSound.play()
				
func updateAnimation():
	var dir
	var direction
	dir = Input.get_axis("move_left", "move_right")
	direction = 'still'
	if dir == 0 :
		animations.play('still')
		if($Footsteps.playing):
			$Footsteps.playing = false
	
	else:
		direction  = 'still'
		if dir < 0: 
			direction = ''
			animations.flip_h = true
			animations.offset = Vector2(flipOffset, 0)
			animations.play('run')
			if(not $Footsteps.playing):
				$Footsteps.playing = true
		elif dir > 0:
			direction = ''
			animations.flip_h = false
			animations.offset = Vector2.ZERO
			animations.play('run')
			if(not $Footsteps.playing):
				$Footsteps.playing = true
				
		elif velocity.y > 0: 
			direction = 'Up' 
			animations.play('runUp')
		


func _on_key_pick_key(id):
	inventory.append(id)
	send_inv.emit(inventory)
func onopenDoor(id):
	
	print('Opened Door'+str(id))

#The following 4 functions are for testing only
func _on_pressure_plate_press(id):
	print("Activated pressure plate " + str(id))

func _on_pressure_plate_unpress(id):
	print("Deactivated pressure plate " + str(id))

func _on_button_press(id):
	print("Pressed button " + str(id))

func _on_lights_solved(id):
	print("Solved lights puzzle with id " + str(id))

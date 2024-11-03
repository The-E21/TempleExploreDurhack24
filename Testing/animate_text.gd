extends Node2D

@export var text : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.connect("body_entered", Callable(self, "play_animation")) #when player touches Area2D play animation
	$Label.visible = false #text is invisible before player touches Area2D
func play_animation(body):
	$Area2D.disconnect("body_entered", Callable(self, "play_animation")) #stops animation from being triggered again
	$Label.visible = true #text is visible once animation is triggered
	$AnimationPlayer.play('text_show') #plays the animation 'text_show'

extends Node2D

@export var text : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.connect("body_entered", Callable(self, "play_animation")) 
	$Label.visible = false
	$Label.text = text
	
func play_animation(body):
	$Area2D.disconnect("body_entered", Callable(self, "play_animation"))
	$Label.visible = true
	$AnimationPlayer.play('text_show')

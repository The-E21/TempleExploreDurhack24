extends Node2D

var timer = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("move")

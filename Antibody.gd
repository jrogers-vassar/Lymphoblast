extends KinematicBody2D

var velocity = Vector2(500, 0)
var covid = null

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	velocity = move_and_slide(velocity)
	
	if covid != null:
		scale = covid.scale/5

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

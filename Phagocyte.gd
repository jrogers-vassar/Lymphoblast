extends KinematicBody2D

onready var eating_area = $Hitbox

var target
var velocity = Vector2()
var engulfing = false
var speed = 200
var acceleration = 0.05
var friction = 0.01
var busy = false
var random_point = Vector2()

signal eating

func _ready():
	_choose_random_point()
	connect("eating", get_parent(), "_on_Phagocyte_Eating")

func _physics_process(_delta):
	if target != null:
		var direction = global_position.direction_to(target.global_position)
		look_at(direction)
		velocity = lerp(velocity, direction.normalized()*speed, acceleration)
		velocity = move_and_slide(velocity)
		

		if global_position.distance_to(target.global_position) < 5 and !engulfing:
			var _list_of_enemies = eating_area.get_overlapping_bodies()
			emit_signal("eating", target)
			engulfing = true
	else:
		var direction = global_position.direction_to(random_point)
		look_at(direction)
		velocity = lerp(velocity, direction.normalized()*speed, acceleration)
		velocity = move_and_slide(velocity)
		
		if global_position.distance_to(random_point) < 5:
			_choose_random_point()
		

func _choose_random_point():
	randomize()
	var x = rand_range(-1900, 1900)
	var y = rand_range(-1400, 1400)
	random_point = Vector2(x, y)

func _on_Hitbox_body_entered(_body):
	pass

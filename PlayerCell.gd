extends KinematicBody2D

onready var shotpos = $ShotPosition
onready var cooldown = $ShotCooldown

var shot_ready = false
var velocity = Vector2()
var speed = 300
var bullet_speed = 500
var acceleration = 0.1
var friction = 0.02
var ammo = 10

export (PackedScene) var antibody

func _ready():
	cooldown.start()

func _input(event):
	if event is InputEventMouseButton:
		shoot()

func shoot():
	if shot_ready and ammo != 0:
		var bullet = antibody.instance()
		bullet.transform = shotpos.global_transform
		bullet.velocity = bullet.velocity.rotated(rotation)
		owner.add_child(bullet)
		shot_ready = false
		cooldown.start()
		ammo -= 1
	

func get_input_velocity():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	return input_vector

func _physics_process(_delta):

	var direction = get_input_velocity()
	look_at(get_global_mouse_position())
	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized()*speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)



func _on_ShotCooldown_timeout():
	shot_ready = true

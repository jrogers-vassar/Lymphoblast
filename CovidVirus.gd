extends KinematicBody2D

onready var tween = $ShrinkTween
onready var animationplayer = $AnimationPlayer

var target
var velocity = Vector2()
var infecting = false
var neutralized = false
var engulfed = false
var speed = 75
var acceleration = 0.05
var friction = 0.01
var antibody = null

signal covid_hit(body)
signal covid_died(body)

func _ready():
	connect("covid_hit", get_parent(), "_on_Covid_Hit")
	connect("covid_died", get_parent(), "_on_Covid_Died")
	

func _physics_process(_delta):
	if target != null and infecting == false and neutralized == false:
		var direction = global_position.direction_to(target.global_position)
		look_at(direction)
		velocity = lerp(velocity, direction.normalized()*speed, acceleration)
		velocity = move_and_slide(velocity)

func _shrink():
	tween.interpolate_property(self, "scale",
		Vector2(1, 1), Vector2(0.05, 0.05), 2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_Hitbox_area_entered(_area):
	infecting = true



func _on_Hitbox_body_entered(body):
	if !neutralized:
		body.velocity = Vector2(0, 0)
		body.get_node("CollisionShape2D").call_deferred("set_disabled", true)
	else:
		body.queue_free()
	neutralized = true
	emit_signal("covid_hit", self)
	animationplayer.play("Flash")
	antibody = body
	antibody.covid = self
	


func _on_ShrinkTween_tween_all_completed():
	emit_signal("covid_died", self)
	if antibody != null:
		antibody.queue_free()
	queue_free()

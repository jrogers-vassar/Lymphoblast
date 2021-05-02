extends KinematicBody2D


var velocity = Vector2()
var speed = 15
var acceleration = 0.05
var friction = 0.005
var home = Vector2()
var target = Vector2(0, 0)
var being_infected = false
var num_viruses = 0

onready var infectiontimer = $InfectionTimer
onready var progress = $InfectionProgress

signal cell_died

func _ready():
	home = global_position
	choose_new_target()
	
	connect("cell_died", get_parent(), "_on_Cell_Died")


func _physics_process(_delta):
	if !being_infected:
		move_randomly()
	else:
		progress.value = 100-(100*infectiontimer.time_left/25)
		if progress.value >= 99:
			emit_signal("cell_died", self)
			$AnimationPlayer.play("Burst")
		

func move_randomly():
	var direction = global_position.direction_to(target)
	velocity = lerp(velocity, direction.normalized()*speed, acceleration)
	velocity = move_and_slide(velocity)
	
	if global_position.distance_to(target) <=5:
		choose_new_target()
	

func choose_new_target():
	randomize()
	target = Vector2(rand_range(home.x-100, home.x+100), rand_range(home.y-100, home.y+100))

func _on_BindingArea_area_entered(area):
	num_viruses += 1
	
	var virus = area.get_parent()
	match num_viruses:
		1:
			virus.global_position = Vector2(global_position.x, global_position.y+100)
		2:
			virus.global_position = Vector2(global_position.x+100, global_position.y)
		3:
			virus.global_position = Vector2(global_position.x, global_position.y-100)
		4:
			virus.global_position = Vector2(global_position.x-100, global_position.y)
	if num_viruses == 1:
		being_infected = true
		infectiontimer.start()

func _on_Burst_ended():
	queue_free()

func _on_BindingArea_area_exited(area):
	num_viruses -= 1
	if num_viruses == 0:
		being_infected = false
		infectiontimer.stop()
		progress.value = 0

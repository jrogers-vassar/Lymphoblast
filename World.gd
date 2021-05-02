extends Node2D


export (PackedScene) var covid
export (PackedScene) var targetcell
export (PackedScene) var phagocyte
export (PackedScene) var drop

onready var player = $PlayerCell

onready var spawn1 = $CovidSpawn
onready var spawn2 = $CovidSpawn2
onready var spawn3 = $CovidSpawn3
onready var spawn4 = $CovidSpawn4

onready var ph1 = $Phagocyte
onready var ph2 = $Phagocyte2
onready var ph3 = $Phagocyte3
onready var ph4 = $Phagocyte4

onready var tar1 = $TargetCell
onready var tar2 = $TargetCell2
onready var tar3 = $TargetCell3
onready var tar4 = $TargetCell4

onready var hud = $HUD

onready var countdown = $WaveTimerCountdown
onready var spawntimer = $CovidSpawnTimer
onready var droptimer = $DropTimer

var covids_list = []
var neutralized_list = []
var phagocytes_list = []
var cells_list = []

var wave_number = 1
var enemies_defeated = 0
var enemies_total : int = 5
var enemies_left_to_spawn = 5

var cur_drops = 0
var max_drops = 20

var acids_collected = 0

func _ready():
	phagocytes_list = [ph1, ph2, ph3, ph4]
	cells_list = [tar1, tar2, tar3, tar4]
	countdown.start()
	if God.vaccine:
		player.ammo = 15
	else:
		player.ammo = 0

func _physics_process(_delta):
	hud.set_wave(wave_number)
	hud.set_enemy(enemies_defeated, enemies_total)
	hud.set_ammo(player.ammo)
	hud.set_countdown(countdown.time_left)
	hud.set_acidcounter(acids_collected)
	hud.set_health(cells_list.size())
	
	for cov in covids_list:
		if cov.target == null:
			cov.infecting = false
			cov.target = _pick_random_cell()

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()

func _assign_Phagocyte():
	var shortest = null
	if neutralized_list.front() != null:
		var next_target = neutralized_list.front().global_position
		for ph in phagocytes_list:
			if !ph.busy:
				if shortest == null:
					shortest = ph
				elif ph.global_position.distance_to(next_target) < shortest.global_position.distance_to(next_target):
					shortest = ph
		if shortest != null:
			shortest.target = neutralized_list.pop_front()
			shortest.busy = true

func _on_Covid_Hit(body):
	if !neutralized_list.has(body):
		neutralized_list.append(body)
		_assign_Phagocyte()

func _on_Covid_Died(body):
	
	for ph in phagocytes_list:
		if ph.target == body:
			ph.target = neutralized_list.pop_front()
			ph.engulfing = false
			ph.busy = false
	covids_list.erase(body)
	enemies_defeated += 1
	if enemies_defeated == enemies_total:
		hud.animationplayer.play("GoodJobFadeIn")
		wave_number += 1
		enemies_defeated = 0
# warning-ignore:narrowing_conversion
		enemies_total *= 1.5
		enemies_left_to_spawn = enemies_total
		countdown.start()
		hud.countdown.show()


func _on_Phagocyte_Eating(body):
	body._shrink()
	


func _on_WaveTimerCountdown_timeout():
	spawntimer.start()
	droptimer.start()
	countdown.stop()
	hud.countdown.hide()
	


func _on_CovidSpawnTimer_timeout():
	var c = covid.instance()
	randomize()
	var rando = rand_range(0, 4)
	if rando <= 1:
		c.global_position = spawn1.global_position
	elif rando <= 2:
		c.global_position = spawn2.global_position
	elif rando <= 3:
		c.global_position = spawn3.global_position
	elif rando <= 4:
		c.global_position = spawn4.global_position
	
	c.target = _pick_random_cell()
	covids_list.append(c)
	add_child(c)
	enemies_left_to_spawn -= 1
	spawntimer.wait_time = rand_range(3, 8)
	if enemies_left_to_spawn == 0:
		spawntimer.stop()

func _on_DropTimer_timeout():
	if cur_drops != max_drops:
		var d = drop.instance()
		randomize()
		var x = rand_range(-1900, 1900)
		var y = rand_range(-1400, 1400)
		d.global_position = Vector2(x, y)
		droptimer.wait_time = rand_range(3, 8)
		cur_drops += 1
		add_child(d)

func _on_Drop_Grabbed():
	acids_collected += 1
	cur_drops -= 1
	if acids_collected == 3:
		player.ammo += 2
		hud.animationplayer.play("Complete")

func _pick_random_cell():
	if cells_list.size() != 0:
		cells_list.shuffle()
		return cells_list.front()
	return null

func _on_Cell_Died(body):
	cells_list.erase(body)
	if cells_list.size() == 0:
		hud.animationplayer.play("FadeIn")
		$GameOverTimer.start()
	for cov in covids_list:
		if cov.target == body:
# warning-ignore:standalone_expression
			cov.target == null
		if cov.target == null:
			cov.target = _pick_random_cell()
			cov.infecting = false



func _on_GameOverTimer_timeout():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://MainMenu.tscn")

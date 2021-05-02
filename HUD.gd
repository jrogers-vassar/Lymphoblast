extends CanvasLayer


onready var wave = $WaveLabel setget set_wave
onready var enemy = $EnemyLabel
onready var ammo = $AmmoLabel setget set_ammo
onready var countdown = $CountdownLabel
onready var acid = $AcidCounter
onready var animationplayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animationplayer.play("Complete")

func set_wave(num):
	wave.text = "Wave "+str(num)

func set_enemy(num, remaining):
	enemy.text = str(num)+"  i  "+str(remaining)

func set_ammo(num):
	ammo.text = str(num)

func set_countdown(num):
	num = int(num)
	countdown.text = "Covid encounter occurring in "+str(num)

func set_acidcounter(num):
	if num == 0:
		acid.texture = load("res://silouhette.png")
	elif num == 1:
		acid.texture = load("res://oneammo.png")
	elif num == 2:
		acid.texture = load("res://twoammo.png")
	elif num == 3:
		acid.texture = load("res://antibody.png")

func set_health(num):
	match num:
		4: 
			pass
		3:
			$Health4.hide()
		2: 
			$Health3.hide()
		1:
			$Health2.hide()
		0:
			$Health1.hide()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Complete":
		get_parent().acids_collected = 0
		

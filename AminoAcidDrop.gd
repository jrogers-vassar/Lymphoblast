extends StaticBody2D


onready var tween = $GrowTween
onready var collision = $Area2D/CollisionShape2D
onready var sprite = $Sprite

signal drop_grabbed

func _ready():
	connect("drop_grabbed", get_parent(), "_on_Drop_Grabbed")
	randomize()
	var rando = rand_range(0, 3)
	if rando <= 1:
		sprite.texture = load("res://amino4.png")
	elif rando <=2:
		sprite.texture = load("res://amino5.png")
	elif rando <=3:
		sprite.texture = load("res://amino6.png")
		
	tween.interpolate_property(self, "scale",
		Vector2(0.001, 0.001), Vector2(0.18, 0.18), 2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GrowTween_tween_all_completed():
	collision.disabled = false

func _on_Area2D_body_entered(_body):
	emit_signal("drop_grabbed")
	queue_free()

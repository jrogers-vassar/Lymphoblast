extends Control


var curscene = 0
var clickready = true

func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton and clickready:
		curscene += 1
		match curscene:
			1:
				$TextureRect.texture = load("res://CUTSCENE2.png")
			2:
				$TextureRect.texture = load("res://CUTzoom.png")
			3:
				$TextureRect.texture = load("res://CUTzoom2.png")
			4:
				$TextureRect.texture = load("res://cutscenee1.png")
				$ColorRect.show()
				$Text.show()
				$Text.text = "RNA is injected into the body"
			5:
				$TextureRect.texture = load("res://cutscenee2.png")
			6:
				$TextureRect.texture = load("res://cutscene3.png")
				$Text.text = "mRNA enters the cell"
			7:
				$TextureRect.texture = load("res://cutscene4.png")
				$Text.text = "Ribosomes use the mRNA as a blueprint for the Covid Spike Protein"
			8:
				$TextureRect.texture = load("res://cutscene5.png")
			9:
				$TextureRect.texture = load("res://cutscene6.png")
				$Text.text = "The cell displays the spike protein on its surface"
			10:
				$TextureRect.texture = load("res://cutscene7.png")
				$Text.text = "White blood cells recognize the foreign body"
			11:
				$TextureRect.texture = load("res://cutscene8.png")
				$Text.text = "and produces antibodies against the protein. . ."
			12:
				get_tree().change_scene("res://World.tscn")
		clickready = false
		$ClickCooldown.start()





func _on_ClickCooldown_timeout():
	clickready = true

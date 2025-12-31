extends Node2D
@onready var tile_map = $"../TileMapLayer"
@onready var penguin_a = $"../PenguinA"
@onready var penguin_b = $"../PenguinB"
@onready var penguin_c = $"../PenguinC"

var collect_played = false

func _process(_delta):
	var penguins = [penguin_a, penguin_b, penguin_c]
	var fish_loc : Vector2 = tile_map.local_to_map(global_position)
	for p in penguins:
		var penguin_loc : Vector2 = tile_map.local_to_map(p.global_position)
		if penguin_loc == fish_loc:
			if collect_played == false:
				$Collect.play()
				collect_played = true	
				Global.fish_score += 1
				self.hide()
			await $Collect.finished
			queue_free()
			print ("Collected!")
			

extends Node2D

@onready var tile_map = $"../TileMapLayer"
@onready var penguin_sprite = $PenguinSprite
@onready var penguin_c = $"../PenguinC"
@onready var penguin_a = $"../PenguinA"
@onready var freeze_timer = $FreezeTimer
@onready var splash = $"../Splash"


var is_moving = false
var freezing = true
var timer_start = false

func _physics_process(_delta):
	if is_moving == false:
		return
	if global_position == penguin_sprite.global_position:
		is_moving = false
		return
	#MOVE PENGUIN SPRITE
	penguin_sprite.global_position = penguin_sprite.global_position.move_toward(global_position, 7)

func _process(_delta):
	check_freezing()
	#FREEZING 
	if freezing == true:
		if timer_start == false:
			$Danger.show()
			freeze_timer.start()
			timer_start = true
	if freezing == false:
		$Danger.hide()
		freeze_timer.stop()
		timer_start = false
	
	if Global.game_over == false:
		if Global.selected_penguin == "B":
			if is_moving:
				return
			if Input.is_action_pressed("Up"):
				move(Vector2.UP)
			elif Input.is_action_pressed("Down"):
				move(Vector2.DOWN)
			elif Input.is_action_pressed("Left"):
				move(Vector2.LEFT)
			elif Input.is_action_pressed("Right"):
				move(Vector2.RIGHT)

func move(direction: Vector2):
	var current_tile : Vector2i = tile_map.local_to_map(global_position)
	var target_tile : Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)
	
	var tile_data : TileData = tile_map.get_cell_tile_data(target_tile)
	
	if tile_data == null:
		return
	elif tile_data.get_custom_data("Walkable") == false:
		self.hide()
		splash.play()
		Global.game_over = true
	
	elif target_tile == tile_map.local_to_map(penguin_a.global_position):
		return 
	elif target_tile == tile_map.local_to_map(penguin_c.global_position):
		return 	
	is_moving = true
	global_position = tile_map.map_to_local(target_tile)
	penguin_sprite.global_position = tile_map.map_to_local(current_tile)
	$Move.play()
	
	if not Global.iceberg_tracker.has(current_tile):
		Global.iceberg_tracker[current_tile] = 1
		tile_map.set_cell(current_tile, 0, Vector2i(4, 0), 0)
	elif Global.iceberg_tracker[current_tile] == 1:
		Global.iceberg_tracker[current_tile] += 1
		tile_map.set_cell(current_tile, 0, Vector2i(5, 0), 0)
	elif Global.iceberg_tracker[current_tile] == 2:
		tile_map.set_cell(current_tile, 0, Vector2i(0, 0), 0)
	else:
		return
	
func check_freezing():
	if Global.game_over == false:
		var current_tile : Vector2 = tile_map.local_to_map(global_position)
		var A_coords : Vector2 = tile_map.local_to_map(penguin_a.global_position)
		var C_coords : Vector2 = tile_map.local_to_map(penguin_c.global_position)
		
		var neighbor_offsets = [
			Vector2(0, 1),
			Vector2(0, -1),
			Vector2(-1, 0),
			Vector2(1, 0),
		]
		 
		for n in neighbor_offsets:
			var neighbor_coords = current_tile + n
			if A_coords == neighbor_coords: 
				freezing = false
				return
			elif C_coords == neighbor_coords:
				freezing = false
				return
			else:
				freezing = true
	 
func _on_freeze_timer_timeout():
	if Global.game_over == false:
		$PenguinSprite.play("Cold")
		print ("GAME OVER")
		Global.game_over = true
		$Danger.hide()
		$FreezeSound.play()

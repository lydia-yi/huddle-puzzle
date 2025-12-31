extends Node2D
@onready var tile_map = $TileMapLayer
@onready var penguin_a = $PenguinA
@onready var penguin_b = $PenguinB
@onready var penguin_c = $PenguinC

@onready var selected = $Selected

var penguins = ["A", "B", "C"]
var n = 0
var score = 0

func _process(_delta):
	# END GAME.
	if Global.game_over == true:
		$GameOver.show()
		$RestartButton.show()
		
	victory_check()
	select_penguin()
	
	# MOVE SELECTION INDICATOR
	if Global.selected_penguin == "A":
		selected.global_position = penguin_a.global_position 
	if Global.selected_penguin == "B":
		selected.global_position = penguin_b.global_position
	if Global.selected_penguin == "C":
		selected.global_position = penguin_c.global_position		
	# SET SCORE
	$Score/Score.text = "FISH: " + str(Global.fish_score)

func select_penguin():  
	if Input.is_action_just_pressed("Swap"):
		if n < 3:
			n += 1
		if n == 3:
			n = 0
		Global.selected_penguin = penguins[n]

func victory_check():
	if Global.fish_score == 10:
		get_tree().paused = true
		$Victory.show()
		$RestartButton.show()
			
func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	Global.game_over = false
	Global.iceberg_tracker = {}
	Global.selected_penguin = "A"
	Global.fish_score = 0	

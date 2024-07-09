extends TileMap
@onready var game_over = preload("res://scenes/gameover/gameOver.tscn") as PackedScene
#tetrominoes
var i_0 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)]
var i_90 := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2), Vector2i(2, 3)]
var i_180 := [Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2)]
var i_270 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(1, 3)]
var i := [i_0, i_90, i_180, i_270]

var t_0 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var t_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var t_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var t_270 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var t := [t_0, t_90, t_180, t_270]

var o_0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o_90 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o_180 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o_270 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o := [o_0, o_90, o_180, o_270]

var z_0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1)]
var z_90 := [Vector2i(2, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var z_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)]
var z_270 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(0, 2)]
var z := [z_0, z_90, z_180, z_270]

var s_0 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1)]
var s_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var s_180 := [Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2), Vector2i(1, 2)]
var s_270 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var s := [s_0, s_90, s_180, s_270]

var l_0 := [Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var l_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)]
var l_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2)]
var l_270 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2)]
var l := [l_0, l_90, l_180, l_270]

var j_0 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var j_90 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(1, 2)]
var j_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var j_270 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 2), Vector2i(1, 2)]
var j := [j_0, j_90, j_180, j_270]

var shapes := [i, t, o, z, s, l, j]
var shapes_full := shapes.duplicate()

#grid variables
const COLS : int = 11
const ROWS : int = 4

#movement variables
const directions := [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.UP]
const start_pos := Vector2i(4, -3)
var cur_pos : Vector2i

#game piece variables
var piece_type
var next_piece_type
var rotation_index : int = 0
var active_piece : Array
var piece_place_attempts : int = 2

#game variables
var score : int
const REWARD : int = 100
var lines_cleared : int
var game_running : bool

#tilemap variables
var tile_id : int = 0
var piece_atlas : Vector2i
var next_piece_atlas : Vector2i

#layer variables
var board_layer : int = 0
var active_layer : int = 1
var start_layer : int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	$HUD.get_node("New Game").pressed.connect(new_game)

func new_game():
	#reset variables
	score = 0
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score)
	lines_cleared = 0
	game_running = true
	#clear everything
	$HUD.get_node("GameOverLabel").hide()
	$HUD.get_node("New Game").hide()
	clear_board()
	clear_piece()
	piece_type = pick_piece()
	piece_atlas = Vector2i(randi_range(0,6), 0)
	next_piece_type = pick_piece()
	next_piece_atlas = Vector2i(randi_range(0,6), 0)
	create_piece()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if game_running:
		if Input.is_action_just_pressed("ui_left"):
			move_piece(directions[0])
		elif Input.is_action_just_pressed("ui_right"):
			move_piece(directions[1])
		elif Input.is_action_just_pressed("ui_down"):
			move_piece(directions[2])
		elif Input.is_action_just_pressed("ui_up"):
			move_piece(directions[3])
		elif Input.is_action_just_pressed("ui_shift"):
			rotate_piece()
		elif Input.is_action_just_pressed("ui_space"):
			place_piece()

func pick_piece():
	var piece
	if not shapes.is_empty():
		shapes.shuffle()
		piece = shapes.pop_front()
	else:
		shapes = shapes_full.duplicate()
		shapes.shuffle()
		piece = shapes.pop_front()
	return piece

func create_piece():
	#reset variables
	cur_pos = start_pos
	active_piece = piece_type[rotation_index]
	draw_piece(active_piece, cur_pos, piece_atlas)
	clear_next_piece()
	#show next piece
	draw_piece(next_piece_type[0], Vector2i(14, -3), next_piece_atlas)

func clear_piece():
	for index in active_piece:
		erase_cell(active_layer, cur_pos + index)

func draw_piece(piece, pos, atlas):
	for index in piece:
		set_cell(active_layer, pos + index, tile_id, atlas)

func rotate_piece():
	clear_piece()
	rotation_index = (rotation_index + 1) % 4
	active_piece = piece_type[rotation_index]
	draw_piece(active_piece, cur_pos, piece_atlas)

func move_piece(dir):
	clear_piece()
	cur_pos += dir
	draw_piece(active_piece, cur_pos, piece_atlas)


func is_free(pos):
	return get_cell_source_id(board_layer, pos) == -1 # get_cell_source_id returns -1 if cell is empty

func place_piece():
	var not_free_flag = false
	for i in active_piece:
		if get_cell_source_id(start_layer, cur_pos + i) != -1:
			print(cur_pos + i)
			print("place attempted in start zone")
			not_free_flag = true
		if not is_free(cur_pos + i):
			if not_free_flag == true:
				print(cur_pos + i)
				print("place attempted in start zone AND in occupied space")
				not_free_flag = true
			else:
				print(cur_pos + i)
				print("place attempted in occupied space")
				not_free_flag = true
		if (cur_pos + i).x > 11 || (cur_pos + i).x < -2 || (cur_pos + i).y > 5 || (cur_pos + i).y < -5:
			print(cur_pos + i)
			print("place attempted out of bounds space")
			not_free_flag = true
			
	if not_free_flag == false:
		print("place completed outside of start zone")
		piece_place_attempts = 3
		#remove each segment from the active layer and move to board layer
		for i in active_piece:
			print(cur_pos + i)
			erase_cell(active_layer, cur_pos + i)
			set_cell(board_layer, cur_pos + i, tile_id, piece_atlas)
		check_rows()
		piece_type = next_piece_type
		piece_atlas = next_piece_atlas
		next_piece_type = pick_piece()
		next_piece_atlas = Vector2i(randi_range(0,6), 0)
		create_piece()
	else:
		piece_place_attempts -= 1
		if piece_place_attempts == 0:
			clear_next_piece()
			$HUD.get_node("GameOverLabel").show()
			$HUD.get_node("New Game").show()
			game_running = false



func check_rows():
	var row : int = ROWS
	while row >= 0:
		var count = 0
		for i in range(COLS):
			if not is_free(Vector2i(i, row)):
				count += 1
		#if row is full then erase it
		if count == COLS:
			clear_row(row)
			lines_cleared += 1
			score += REWARD * lines_cleared
			row -= 1
			$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score)
		else:
			row -= 1
			
func clear_row(row):
	for i in range(COLS):
		erase_cell(board_layer, Vector2i(i, row))

func clear_board():
	var i: int = 0
	var j: int
	while i <= 10:
		j = -4
		while j <= 4:
			erase_cell(board_layer, Vector2i(i, j))
			j += 1
		i += 1

func clear_next_piece():
	var i: int = 12
	var j: int
	while i <= 17:
		j = -3
		while j <= -2:
			erase_cell(active_layer, Vector2i(i, j))
			j += 1
		i += 1

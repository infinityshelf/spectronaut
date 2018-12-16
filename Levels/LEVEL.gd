extends Spatial

#const CellWithOrientation = preload("res://CellWithOrientation.gd")

export(String) var _next_level_name

signal level_completed

var progress = 0

class CanMoveResult:
	func _init(l, m = false, f = null):
		color_locations = l
		can_move = m
		flat = f
	var color_locations = []
	var can_move = false
	var flat = null

onready var cam_root = $CameraRoot

#var cells = null
export(Color) var shade

func _ready():
	set_process(true)
	set_process_input(true)
	get_node("GZEMO").set_shade(shade)
	connect("level_completed", LevelSwitcher, "_on_level_complete")
	$ColorTiles.set_visible(false)
	assert(shade != null)

func _process(delta):
	pass

# takes a vector 3 which is the cell index for the next desired position
func check_can_move(v, source_color):
	var can_move = false
	var dest_color = null
	var off = cam_root.get_offset()
	
	var cells = $ColorTiles.get_filtered() #.flattened_to_z(off, v.z)
	var flat_cells = cells.cells_flattened_to_z(off, v.z)
	
	if flat_cells.has(v):
		print("flat_cells[" + var2str(v) + "]: " + var2str(flat_cells[v]))
		dest_color = flat_cells[v]
	if dest_color == Color(-1,-1,-1):
		emit_signal("level_completed", name, _next_level_name)
		dest_color = Color(1,1,1)
	can_move = dest_color != null && dest_color.r >= source_color.r && dest_color.g >= source_color.g && dest_color.b >= source_color.b
	
	#return CanMoveResult.new([v], can_move)
	var congruent_positions = cells.congruent_positions_at(v, off)
	var flat = cells.cell_flattened_to_z(v, off, v.z)
	return CanMoveResult.new(congruent_positions, can_move, flat)

func _input(event):
	if event.is_action_pressed("print_cam_offset"):
		#print (var2str(cam_root.get_offset()))
		pass
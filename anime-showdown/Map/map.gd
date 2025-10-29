extends Node2D

@onready var terrain_map = $%terrain
@onready var movement_map = $%movement_highlight
@onready var astar_map = $%astar_highlight
@onready var wall_map = $%wall
@onready var player = $Player;
@onready var menu = $DebugMenu;
var last_mouse_cell = Vector2i.ZERO;

func _ready() -> void:
	var tiles = terrain_map.get_used_cells()
	terrain_map.placeBoundary(tiles)

func _process(_delta: float) -> void:
	if player.state == Enums.PLAYER_STATE.READY_TO_MOVE && is_point_in_range(get_mouse_cell()) && get_mouse_cell() != last_mouse_cell:
		last_mouse_cell = get_mouse_cell();
		highlight_mouse_path();
	
func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
			menu.update_line_4("is point is range: " + str(is_point_in_range(get_mouse_cell())))
			if(get_mouse_cell() == player.get_player_tile() && player.state == Enums.PLAYER_STATE.IDLE):
				player.state = Enums.PLAYER_STATE.READY_TO_MOVE
				highlight_player_movement()
			elif is_point_in_range(get_mouse_cell()) && player.state == Enums.PLAYER_STATE.READY_TO_MOVE:
				movement_map.clear()
				astar_map.clear()
				move_player()
			elif player.state != Enums.PLAYER_STATE.MOVING:
				movement_map.clear()
				astar_map.clear()
				player.state = Enums.PLAYER_STATE.IDLE

func highlight_player_movement() -> void:
	var player_cell = player.get_player_tile();
	var range_x_neg = range(player_cell.x, (player_cell.x - player.movementRange-1),-1);
	var range_y_neg = range(player_cell.y, (player_cell.y - player.movementRange-1),-1);
	var range_x_pos = range(player_cell.x, player_cell.x + player.movementRange + 1, 1);
	var range_y_pos = range(player_cell.y, (player_cell.y + player.movementRange + 1),1);
	menu.update_line_3("Range x pos: " + str(range_x_pos))
	menu.update_line_4("Range y pos: " + str(range_y_pos))
	movement_map.clear();
	for i in range_x_neg:
		for j in range_y_neg:
			var delta_x = abs(i - player_cell.x);
			var delta_y = abs(j - player_cell.y);
			if abs(delta_x+delta_y) > player.movementRange:
				continue;
			if is_useable_tile(Vector2i(i,j)):
				movement_map.set_cell( Vector2i(i,j),11, Vector2i.ZERO)
	for i in range_x_neg:
		for j in range_y_pos:
			var delta_x = abs(i - player_cell.x);
			var delta_y = abs(j - player_cell.y);
			if abs(delta_x+delta_y) > player.movementRange:
				continue;
			if is_useable_tile(Vector2i(i,j)):
				movement_map.set_cell( Vector2i(i,j),11, Vector2i.ZERO)
	for i in range_x_pos:
		for j in range_y_pos:
			var delta_x = abs(i - player_cell.x);
			var delta_y = abs(j - player_cell.y);
			if abs(delta_x+delta_y) > player.movementRange:
				continue;
			if is_useable_tile(Vector2i(i,j)):
				movement_map.set_cell( Vector2i(i,j),11, Vector2i.ZERO)
	for i in range_x_pos:
		for j in range_y_neg:
			var delta_x = abs(i - player_cell.x);
			var delta_y = abs(j - player_cell.y);
			if abs(delta_x+delta_y) > player.movementRange:
				continue;
			if is_useable_tile(Vector2i(i,j)):
				movement_map.set_cell( Vector2i(i,j),11, Vector2i.ZERO)

func is_useable_tile(tile : Vector2i) -> bool :
	return terrain_map.isInLayer(tile) && !wall_map.isInLayer(tile)

func get_mouse_cell() -> Vector2i:
	var mouse_position_viewport = get_global_mouse_position()
	var mouse_local_pos = terrain_map.to_local(mouse_position_viewport)
	mouse_local_pos.x = floor(mouse_local_pos.x);
	mouse_local_pos.y = floor(mouse_local_pos.y);
	var mouse_cell = terrain_map.local_to_map(mouse_local_pos);
	return mouse_cell;

func is_point_in_range(cell_pos: Vector2i) -> bool:
	var player_cell = player.get_player_tile();
	var delta_x = cell_pos.x - player_cell.x
	var delta_y = cell_pos.y - player_cell.y
	return abs(delta_x) + abs(delta_y) <= player.movementRange

func astar_get_path(from:Vector2i,to:Vector2i) -> Array[Vector2i]:
	var astar_grid = AStarGrid2D.new();
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER;
	astar_grid.region = terrain_map.get_used_rect();
	astar_grid.cell_size = Vector2(32, 32);
	for i in wall_map.get_used_cells():
		astar_grid.set_point_solid(i)
	astar_grid.update()
	return astar_grid.get_id_path(from,to);

func move_player() -> void: 
	player.move_player_on_path(astar_get_path(player.get_player_tile(),get_mouse_cell()))
	
func highlight_mouse_path() -> void:
	astar_map.clear();
	var path = astar_get_path(player.get_player_tile(),get_mouse_cell())
	for i in path:
		if is_useable_tile(i):
			astar_map.set_cell( i, 10, Vector2i.ZERO)

extends Node2D

@onready var layer1 = $"%Layer 1"
@onready var layer2 = $"%Layer 2"
@onready var layer3 =$"%Layer 3"
@onready var player = $Player;
@onready var menu = $DebugMenu;

func _ready() -> void:
	var tiles = layer1.get_used_cells() + layer2.get_used_cells() + layer3.get_used_cells();
	layer1.placeBoundary(tiles)
	layer2.placeBoundary(tiles)
	layer3.placeBoundary(tiles)
	
func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
			if(get_mouse_cell() == player.get_player_tile()):
				highlight_player_movement()
			
	
	
func highlight_player_movement() -> void:
	var player_cell = player.get_player_tile();
	var range_x_neg = range(player_cell.x, (player_cell.x - player.movementRange-1),-1);
	var range_y_neg = range(player_cell.y, (player_cell.y - player.movementRange-1),-1);
	var range_x_pos = range(player_cell.x, player_cell.x + player.movementRange + 1, 1);
	var range_y_pos = range(player_cell.y, (player_cell.y + player.movementRange + 1),1);
	menu.update_line_3("Range x pos: " + str(range_x_pos))
	menu.update_line_4("Range y pos: " + str(range_y_pos))
	for i in range_x_neg:
		for j in range_y_neg:
			var delta_x = abs(i - player_cell.x);
			var delta_y = abs(j - player_cell.y);
			if abs(delta_x+delta_y) > player.movementRange:
				continue;
			set_tile_at_position(Vector2i(i,j),5)
	for i in range_x_neg:
		for j in range_y_pos:
			var delta_x = abs(i - player_cell.x);
			var delta_y = abs(j - player_cell.y);
			if abs(delta_x+delta_y) > player.movementRange:
				continue;
			set_tile_at_position(Vector2i(i,j),5)
	for i in range_x_pos:
		for j in range_y_pos:
			var delta_x = abs(i - player_cell.x);
			var delta_y = abs(j - player_cell.y);
			if abs(delta_x+delta_y) > player.movementRange:
				continue;
			set_tile_at_position(Vector2i(i,j),5)
	for i in range_x_pos:
		for j in range_y_neg:
			var delta_x = abs(i - player_cell.x);
			var delta_y = abs(j - player_cell.y);
			if abs(delta_x+delta_y) > player.movementRange:
				continue;
			set_tile_at_position(Vector2i(i,j),5)

func set_tile_at_position(cell_pos: Vector2i, tileId: int):
	if layer1.isInLayer(cell_pos):
		layer1.set_cell( cell_pos, tileId, Vector2i.ZERO)
	if layer2.isInLayer(cell_pos):
		layer2.set_cell( cell_pos, tileId, Vector2i.ZERO)
	if layer3.isInLayer(cell_pos):
		layer3.set_cell( cell_pos, tileId, Vector2i.ZERO)

func get_mouse_cell() -> Vector2i:
	var mouse_position_viewport = get_global_mouse_position()
	var mouse_local_pos = layer1.to_local(mouse_position_viewport)
	mouse_local_pos.x = floor(mouse_local_pos.x);
	mouse_local_pos.y = floor(mouse_local_pos.y);
	var mouse_cell = layer1.local_to_map(mouse_local_pos);
	return mouse_cell;

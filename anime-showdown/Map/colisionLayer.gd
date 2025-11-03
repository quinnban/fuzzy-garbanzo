extends TileMapLayer

var modulated_cells: Dictionary = {}

func  _ready() -> void:
	pass;

func set_cell_color(coords: Vector2i, color: Color):
	modulated_cells[coords] = color
	notify_runtime_tile_data_update()

func show_all_tiles():
	if modulated_cells.is_empty():
		return
	modulated_cells.clear()
	for coords in modulated_cells.keys():
		var source_id = get_cell_source_id(coords)
		var atlas_coords = get_cell_atlas_coords(coords) 
		# Calling set_cell() forces the engine to use the default TileSet data
		set_cell(coords, source_id, atlas_coords)
	notify_runtime_tile_data_update()

# The virtual functions must still be defined correctly
func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return modulated_cells.has(coords)

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData):
	tile_data.modulate = modulated_cells.get(coords, Color.WHITE)

func placeBoundary(tiles: Array) -> void:
	var ourTiles = get_used_cells()
	for tile: Vector2i in ourTiles:
		var aroundTiles := get_surrounding_cells(tile)
		for sourondingTile: Vector2i in aroundTiles:
			if tiles.find(sourondingTile) == -1:
				if get_cell_source_id(sourondingTile) == -1:
					set_cell(sourondingTile,9,Vector2i(2,0))
					
func isInLayer(tile:Vector2i) -> bool:
	var ourTiles = get_used_cells()
	if ourTiles.find(tile) != -1:
		var boundary = get_cell_tile_data(tile)
		return !boundary.get_custom_data('is_boundary')
	return false
	
func getTileId(tile:Vector2i) -> int:
	return get_cell_source_id(tile)

func getTileAtlas(tile:Vector2i) -> Vector2i:
	return get_cell_atlas_coords(tile)
		

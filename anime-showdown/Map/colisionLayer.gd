extends TileMapLayer

var hiddenTiles: Array[Vector2i] = [];
var modulated_cells: Dictionary = {}
func  _ready() -> void:
	set_cell_color(Vector2i(0, 0), Color(1, 1, 1, 0))
	set_cell_color(Vector2i(-2, 3), Color(1, 1, 1, 0))

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return modulated_cells.has(coords)

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData):
	tile_data.modulate = modulated_cells.get(coords, Color.WHITE)

func force_update_cell(coords: Vector2i):
	set_cell(coords,get_cell_source_id(coords),get_cell_atlas_coords(coords))

func set_cell_color(coords: Vector2i, color: Color):
	# Store the color for the tile at the given coordinates
	modulated_cells[coords] = color
	# Tell the tilemap to update the appearance of this cell
	force_update_cell(coords) # Assuming you are using layer 0

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
	
func showAll():
	for i in hiddenTiles:
		set_cell_color(i,Color(1, 1, 1, 1))
		

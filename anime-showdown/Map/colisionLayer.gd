extends TileMapLayer

#func _ready() -> void:
	#var tiles = get_used_cells()
	#for tile: Vector2i in tiles:
		#var aroundTiles := get_surrounding_cells(tile)
		#for sourondingTile: Vector2i in aroundTiles:
			#if get_cell_source_id(sourondingTile) == -1:
				#set_cell(sourondingTile,0,Vector2i.ZERO)

func placeBoundary(tiles: Array) -> void:
	var ourTiles = get_used_cells()
	for tile: Vector2i in ourTiles:
		var aroundTiles := get_surrounding_cells(tile)
		for sourondingTile: Vector2i in aroundTiles:
			if tiles.find(sourondingTile) == -1:
				if get_cell_source_id(sourondingTile) == -1:
					set_cell(sourondingTile,0,Vector2i.ZERO)
					
func isInLayer(tile:Vector2i) -> bool:
	var ourTiles = get_used_cells()
	if ourTiles.find(tile) != -1:
		var boundary = get_cell_tile_data(tile)
		return !boundary.get_custom_data('is_boundary')
	return false
	
func getTileId(tile:Vector2i) -> int:
	return get_cell_source_id(tile)

func clearLayer() -> void:
	var tiles = get_used_cells()
	for tile: Vector2i in tiles:
		set_cell(tile,-1,Vector2i.ZERO)
		

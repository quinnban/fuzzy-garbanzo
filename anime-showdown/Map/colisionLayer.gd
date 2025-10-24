extends TileMapLayer

func _ready() -> void:
	var tiles = get_used_cells()
	for tile: Vector2i in tiles:
		var aroundTiles := get_surrounding_cells(tile)
		for sourondingTile: Vector2i in aroundTiles:
			if get_cell_source_id(sourondingTile) == -1:
				set_cell(sourondingTile,0,Vector2i.ZERO)
		

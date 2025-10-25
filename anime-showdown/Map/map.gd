extends Node2D

func _ready() -> void:
	var layer1 = $"Layer 1";
	var layer2 =$"Layer 2";
	var layer3 =$"Layer 3";
	var tiles = layer1.get_used_cells() + layer2.get_used_cells() + layer3.get_used_cells();
	layer1.placeBoundary(tiles)
	layer2.placeBoundary(tiles)
	layer3.placeBoundary(tiles)
	
	

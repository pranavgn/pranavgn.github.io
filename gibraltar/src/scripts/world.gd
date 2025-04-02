extends Node2D

const width := 120
const height := 67
const sector_limit := 2
var layer0: TileMapLayer
var layer1: TileMapLayer
var cores: Array[CoreTile]
var grid: Array

func _ready() -> void:
	randomize()
	# generate quadrants
	var xSector = width / 2
	var ySector = height / 2
	var atl_counter := 0
	for i in sector_limit:
		for j in sector_limit:
			var x = round((randfn(0.5, 0.2) * xSector) + (i * xSector))
			var y = round((randfn(0.5, 0.2) * ySector) + (j * ySector))
			var temp := CoreTile.new(Vector2i(x, y),Vector2i(atl_counter, 0))
			%Greebles.set_cell(Vector2i(x, y), 0, Vector2i(atl_counter, 0))
			cores.push_back(temp)
			atl_counter += 1
	%LevelMap.generate_map()
	#layer0.get_cell_tile_data().get_custom_data("red")
	#layer0.get_cell_tile_data().set_custom_data()

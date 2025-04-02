class_name CoreTile extends Node

var tileCount: int
var x: int
var y: int
var tile: Vector2i

func _init(coord: Vector2i, atlas: Vector2i) -> void:
	x = coord.x
	y = coord.y
	tile = atlas

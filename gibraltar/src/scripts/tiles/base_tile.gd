class_name BaseTile extends Node

var x: int
var y: int
var tile: Vector2i
var power: int

func _init(coord: Vector2i, atlas: Vector2i) -> void:
	x = coord.x
	y = coord.y
	tile = atlas

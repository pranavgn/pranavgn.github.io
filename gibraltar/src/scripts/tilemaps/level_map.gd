class_name LevelMap extends TileMapLayer

var fnl := FastNoiseLite.new()
var width: int
var height: int

func _ready() -> void: 
	width = self.get_parent().width
	height = self.get_parent().height
	#randomize()
	#fnl.seed = randi()
	#fnl.noise_type = FastNoiseLite.TYPE_CELLULAR
	#fnl.cellular_distance_function = FastNoiseLite.DISTANCE_MANHATTAN
	#fnl.cellular_jitter = 3.31
	#fnl.frequency = 0.02
	#generate_map()

func _input(event) -> void:
	if event.is_action_pressed("restart"):
		randomize()
		fnl.seed = randi()
		generate_map()

func generate_map() -> void:
	#for x in width:
		#for y in height:
			#set_cell(Vector2i(x, y), 0, Vector2i(0,0))
	construct_grid()
	print('g1')
	construct_grid(0, 1)
	print('g2')
	construct_grid(1, 0)
	print('g3')
	construct_grid(1, 1)
	print('g4')
			
			
			
			#var noise_val = fnl.get_noise_2d(x,y)
			#noise_val += 1
			##	red
			#if noise_val < 0.2:
				#set_cell(Vector2i(x, y), 0, Vector2i(1,0))
			## green
			#elif noise_val < 0.4 && noise_val:
				#set_cell(Vector2i(x, y), 0, Vector2i(4,0))
			## blue
			#elif noise_val < 0.6 && noise_val > 0.4:
				#set_cell(Vector2i(x, y), 0, Vector2i(0,0))
			#elif noise_val < 0.95 && noise_val > 0.6:
				#set_cell(Vector2i(x, y), 0, Vector2i(3,0))
			#elif noise_val > 0.95:
				#set_cell(Vector2i(x, y), 0, Vector2i(2,0))


func construct_grid(oX := 0, oY := 0, tile:= Vector2i(0, 0)) -> void:
	var sizes_array := [1, 2, 3, 5]
	var width_array := [15, 20, 25, 30, 35]
	var splitH:int = height/2
	var splitW:int = width/2
	var bools : Array
	# initialize bools
	var wS:int = width_array.pick_random()
	var hS:int = width_array.pick_random()
	for i in range(splitW - wS):
		var column: Array
		for j in range(splitH - wS):
			column.push_back(true)
		bools.push_back(column)
	
	for i in (splitW - sizes_array.max() + 1 - wS):
		for j in (splitH - sizes_array.max() + 1 - hS):
			var xdim = sizes_array.pick_random()
			var ydim = sizes_array.pick_random()
			var fits := true
			# check if within bounds
			if i + xdim > splitW  || j + ydim > splitH :
				fits = false
			# check if rectangle overlaps with any other rectangle
			if fits:
				for u in range(i, i + xdim, 1):
					for v in range(j, j + ydim, 1):
						if(u > bools.size() - 1 || v > bools[u].size() - 1 || bools[u][v] == false):
							fits = false
			if fits:
				# mark area as occupied and draw
				for u in range(i, i + xdim, 1):
					for v in range(j, j + ydim, 1):
						if oX < 1:
							print(oX)
							print('y', oY)
							print(u + splitW*oX)
						self.set_cell(Vector2i(u + width/2*oX + wS, v + splitH*oY + hS), 0, tile)
						bools[u][v] = false
	#rectInfo.push(new makeRect(x,y,xdim,ydim))


func plot_line(x0: int, y0: int, x1: int, y1: int, tile:Vector2i) -> void:
	var dx = abs(x1 - x0)
	var sx = 1 if x0 < x1 else -1
	var dy = -abs(y1 - y0)
	var sy = 1 if y0 < y1 else -1
	var error = dx + dy
		
	while true:
		self.set_cell(Vector2(x0, y0), 0, tile)
		var e2 = 2 * error
		if e2 >= dy:
			if x0 == x1: break
			error = error + dy
			x0 = x0 + sx
		if e2 <= dx:
			if y0 == y1: break
			error = error + dx
			y0 = y0 + sy
	return

func plot_rect(x0: int,y0: int,x1: int,y1: int, tile: Vector2i) -> void:
	plot_line(x0, y0, x1, y0, tile)
	plot_line(x1, y0, x1, y1, tile)
	plot_line(x1, y1, x0, y1, tile)
	plot_line(x0, y1, x0, y0, tile)
	flood_fill(x0+1, y0+1, tile)
	return

func flood_fill(x0: int,y0: int, tile: Vector2i):
	if get_cell_tile_data(Vector2i(x0, y0)) != null:
		return
	set_cell(Vector2(x0, y0), 0, tile)
	#Perform Flood-fill one step to the south of node.
	flood_fill(x0, y0+1, tile)
	#Perform Flood-fill one step to the north of node
	flood_fill(x0, y0-1, tile)
	#Perform Flood-fill one step to the west of node
	flood_fill(x0-1, y0, tile)
	#Perform Flood-fill one step to the east of node
	flood_fill(x0+1, y0, tile)
	return

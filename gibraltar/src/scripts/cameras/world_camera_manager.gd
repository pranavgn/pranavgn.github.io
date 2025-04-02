extends Camera2D

var isPressed:= false
var _target_zoom = 1.0
var width: int
var height: int
const MIN_ZOOM := 0.1
const MAX_ZOOM := 2.0
const ZOOM_INCREMENT := 0.05
const ZOOM_RATE := 8.0


func _ready() -> void:
	width = self.get_parent().width
	height = self.get_parent().height
	self.offset = Vector2((width * 32) / 4, (height * 32) / 4)

func zoom_in() -> void:
	_target_zoom = max(_target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_physics_process(true)

func zoom_out() -> void:
	_target_zoom = min(_target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_physics_process(true)

func _physics_process(delta):
	zoom = lerp(
		zoom,
		_target_zoom * Vector2.ONE,
		ZOOM_RATE * delta
	)
	set_physics_process(
		not is_equal_approx(zoom.x, _target_zoom)
	)

func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_in()
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_out()
		# touch
		if (event.button_index == MOUSE_BUTTON_LEFT || event.button_index == MOUSE_BUTTON_MIDDLE) && event.pressed:
			isPressed = event.pressed
		else:
			isPressed = false
		

	if (event is InputEventMouseMotion && isPressed) || event is InputEventScreenDrag:
		position -= event.relative / zoom

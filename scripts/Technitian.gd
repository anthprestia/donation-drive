class_name Technitian
extends CharacterBody2D

@onready var _animated_sprite = $NecroAnimation

const SPEED = 300.0

var clinic: ClinicController
var walkable_floor: TileMapLayer

var trained_stations = []
var current_station: Station = null

var current_walk_path = []
var speed = 100

func _ready() -> void:
	_animated_sprite.play("idle")
	
func introduce(clinic: ClinicController) -> void:
	self.clinic = clinic
	self.walkable_floor = clinic.get_floor()

func _physics_process(delta: float) -> void:
	# TODO update the tech's position on the navgrid to middle of next tile
	# in walk queue
	
	if not current_walk_path.is_empty():
		var target_pos = walkable_floor.map_to_local(current_walk_path.front())
	
		global_position = global_position.move_toward(target_pos, self.speed*delta)
		
		if global_position.distance_to(target_pos) < 1:
			self.current_walk_path.pop_front()
	
	"""
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
	velocity.x = direction_x * SPEED
	velocity.y = direction_y * SPEED
	move_and_slide()
	"""

func finish_work() -> void:
	self.current_station.progress_complete.disconnect(finish_work)
	self.current_station = null
	self.clinic.request_work(self)
	
	
func is_working() -> bool:
	return current_station != null
	
func assign_work(station: Station, id_path: Array[Vector2i]) -> void:
	self.current_station = station
	self.current_station.progress_complete.connect(finish_work)
	
	# get walking path to station
	self._walk_along(id_path)
	
func _walk_along(walk_path: Array[Vector2i]) -> void:
	self.current_walk_path = walk_path
	pass

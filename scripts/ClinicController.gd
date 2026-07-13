class_name ClinicController
extends Node

# ClinicController

# this class will be used to keep track of each Clinic
# tracks things like:
# waiting room chairs available, total donors in the shop
# available staff
# player upgrades
# donor spawner
# donor stations
# 'check-out'

# the class is in charge of defining and handling processes on the
# 'game board'. Gameplay logic may or may not be placed in here

# Will be able to load in a LevelController to play the game

#idk make all the shit this is likely a tilemaplayer in whatever level it is

@export var donor_scene: PackedScene
@export var spawn_timer: Timer

@onready var num_chairs = $WaitingRoom.get_child_count()
@onready var floor: TileMapLayer = $Floor

var station_queue: Queue

var waiting_donors = 0
var spawn_ready = false
var nav_grid : AStarGrid2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 1.0
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_spawn_timeout)
	
	add_child(spawn_timer)
	
	nav_grid = AStarGrid2D.new()
	nav_grid.region = floor.get_used_rect()
	nav_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	nav_grid.update()
	
	self.station_queue = Queue.new()
	
	# ClinicController needs to introduce itself to all its station Nodes
	var stations = get_node("Stations")
	for station_type in stations.get_children():
		for station in station_type.get_children():
			#introduce ourself
			station.introduce(self)
	
	# check the WaitingChair in WaitingRoom and manually attach
	# each of their "waiting_room_decrement" signals
	var waiting_room = get_node("WaitingRoom")
	
	for chair in waiting_room.get_children():
		chair.waiting_room_decrement.connect(self._waiting_room_decrement)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.spawn_ready:
		_spawn_mob()
		self.spawn_ready = false

func _spawn_timeout() -> void:
	if not self.spawn_ready and (num_chairs > waiting_donors):
		self.spawn_ready = true

func _spawn_mob() -> void:
	# instantiate the mob_scene
	var donor = donor_scene.instantiate()
	var path = $EntryPath
	var walker = PathFollow2D.new()
	
	self.waiting_donors += 1
	
	donor.set_walker(walker)
	
	walker.add_child(donor)
	path.add_child(walker)

func _waiting_room_decrement() -> void:
	self.waiting_donors -= 1
	
# takes in a station and queues it up
func queue_station(station: Station) -> void:
	self.station_queue.enqueue(station)
	self.station_queue.show_queue()
	
# takes in a station and dequeues it from action list
func dequeue_station(station: Station) -> void:
	self.station_queue.leave_queue(station)
	self.station_queue.show_queue()

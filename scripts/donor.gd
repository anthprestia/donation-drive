class_name Donor
extends CharacterBody2D

const Queue := preload("res://scripts/DataTypes/Queue.gd")

var walker: PathFollow2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var body: CollisionShape2D = $CollisionShape2D

var mouse_offset = Vector2.ZERO
var draggable: bool = false
var selected: bool = false

var hovered_station: Node2D = null
var current_station: Node2D = null

static var blood_donor_agenda: Array[GDScript] = [WaitingChair, QuestionTable, PreCheckinChair, BloodChair]
var personal_agenda: Queue

# Called when the node enters the scene tree for the first time.
# load an animated sprite
func _ready() -> void:
	# currently 4 donors so rng
	var donors = ['adam', 'alex', 'amelia', 'bob']
	var chosen = randi() % 4
	var fname = "res://assets/animatedsprites/" + donors[chosen] + '_spriteframes.tres'
	# load donors[chosen]
	sprite.sprite_frames = load(fname)
	sprite.play('idleFront')
	
	self.personal_agenda = Queue.new(blood_donor_agenda)
	
func _init() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.walker != null:
		var prog = delta * 1
		var new = self.walker.progress_ratio + prog
		# if existing + prog >= 1 then release
		if new >= 1.0:
			queue_free()
		else:
			self.walker.progress_ratio = new
			
	if self.selected and self.draggable:
		self.drag_donor()

func set_walker(walker: PathFollow2D) -> void:
	self.walker = walker
	
func get_walker() -> PathFollow2D:
	return self.walker
	
func get_next_station() -> GDScript:
	return self.personal_agenda.get_front()
	
func _clear_walker() -> void:
	self.walker.queue_free()
	self.walker = null
	
func swap_stations(station: Station) -> void:
		# get up from previous station and then sit() at new one
		self.current_station.get_up(self)
		self.sit(station)
		station.sit(self)
	
func sit(station: Node2D) -> void:
	# this will be used every time a donor is moved to a new station.
	# ex: waiting_chair, question_table, donor_chair, etc
	if self.walker:
		self._clear_walker()
		self.draggable = true
	
	# we want to reparent the donor to this station. 
	reparent(station)
	
	self.current_station = station
	self.personal_agenda.dequeue()

	# reset local position to origin of parent
	self.position = Vector2.ZERO
	self.hovered_station = null
	
func drag_donor() -> void:
	self.position =  get_global_mouse_position() + mouse_offset

func station_preview(station: Station) -> void:
	# check if this is my next station. if it is then we're eligible
	if station.get_script() == self.personal_agenda.get_front():
		self.hovered_station = station
	
func station_withdraw(station: Station) -> void:
	# dont withdraw if its your current station
	if station == self.hovered_station:
		self.hovered_station = null

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#click event for drag, should also allow touchscreen input eventually
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# if holding down and draggable then drag
			if self.draggable:
				self.mouse_offset = position - get_global_mouse_position()
				self.selected = true
				#self.top_level = true
		else:
			# if button isnt pressed
			# and hovering over our next station (checked elsewhere)
			if self.hovered_station:
				self.swap_stations(self.hovered_station)
			self.position = Vector2.ZERO
			self.selected = false
			

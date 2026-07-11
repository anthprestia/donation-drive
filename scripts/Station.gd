class_name Station
extends Area2D

# states a station can be in:
# unoccuped
# donor sat, not started, not queued | needs_assist = T; in_line = F
# donor sat, not stated, queued | needs_assist = T; in_line = T
# donor sat, started, --- | needs_assist = F; in_line = F
# donor sat, finished, --- | F ; F

# can use the collision shape we defined in the scene tree
@onready var checker: CollisionShape2D = $CollisionShape2D

# need a var with the ClinicController we're currently a part of
# C.C. should 'introduce' itself to us shortly after _ready()
var clinic: ClinicController

# use this as a boolean too ig, if donor else null
var donor_sat: Donor

#flags for keeping state/understanding comms with ClinicController
var needs_assistance: bool
var in_line: bool

# progress bar logic
var disable_prog: bool
var progress: int
var goal: int
var increment: int

# notified will tell if we have already emitted this completed station cycle 
# so we dont send multiple signals every tick
var notified: bool = false
signal progress_complete

func _ready(disable_prog: bool = false) -> void:
	self.disable_prog = disable_prog
	needs_assistance = false
	progress = 0
	goal = 100
	increment = 5
	
func _process(delta: float) -> void:
	# if a donor is sat 
		#and the station doesnt need assistance 
			#and the progress bar isnt full 
				#then we increment the progress bar
				
	# if donor_sat
	if not is_available():
		# if station has been stated/assisted:
		if not needs_assistance:
			# if theres a progress bar for this station
			if not disable_prog:
				# increment 
				if progress < goal:
					self.increment_progress()
				else:
					if progress > goal:
						progress = goal
					if not notified:
						print("GOAL REACHED!")
						progress_complete.emit()
						notified = true
		# if needs_assistance
		else:
			if Input.is_action_just_pressed("click"):
				# send a message to the clinic that we need to be queued up
				if self.in_line:
					self.in_line = false
					clinic.dequeue_station(self)
				else:
					self.in_line = true
					clinic.queue_station(self)

func _on_body_entered(body: Node2D) -> void:
	# check if its a donor walking past the chair
	if body is Donor:
		if is_available():
			body.station_preview(self)

func _on_body_exited(body: Node2D) -> void:
	if body is Donor:
		if is_available():
			body.station_withdraw(self)
			
# function called by the parent ClinicController on all of its stations
# during parent clinic's _ready() function
func introduce(clinic: ClinicController) -> void:
	self.clinic = clinic

func is_available() -> bool:
	return donor_sat == null

func sit(donor: Donor) -> void:
	self.donor_sat = donor
	self.needs_assistance = true
	#donor.sit(self)
	
func increment_progress() -> void:
	print("Progress: " + str(self.progress) + " / " + str(self.goal))
	self.progress = self.progress + self.increment

func get_up(donor: Donor) -> void:
	if self.donor_sat == donor:
		self.donor_sat = null
		self.needs_assistance = false
		self.notified = false

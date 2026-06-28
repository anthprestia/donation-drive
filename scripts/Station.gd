class_name Station

extends Area2D

# can use the collision shape we defined in the scene tree
@onready var checker: CollisionShape2D = $CollisionShape2D

var donor_sat: Donor
var available: bool = true
var progress: int = 0
var increment: int = 5

signal progress_complete


func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	# check if its a donor walking past the chair
	if body is Donor:
		if is_available:
			body.station_preview(self)

func is_available() -> bool:
	return available

func sit(donor: Donor) -> void:
	self.donor_sat = donor
	self.available = false
	donor.sit(self)
	
func increment_progress() -> void:
	self.progress = self.progress + self.increment

func get_up(donor: Donor) -> void:
	if self.donor_sat == donor:
		self.donor_sat = null
		self.available = true

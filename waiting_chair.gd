extends Node2D

# can use the collision shape we defined in the scene tree
@onready var checker: CollisionShape2D = $CollisionShape2D

signal waiting_available

var donor_sat: Donor
var available: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	# check if its a donor walking past the chair
	if body is Donor:
		# check if the chair is available
		if available:
			# make the donor sit
			sit(body)
			print('ding')
			
func is_available() -> bool:
	return available

func sit(donor: Donor) -> void:
	self.donor_sat = donor
	self.available = false
	donor.sit(self)

func get_up(donor: Donor) -> void:
	if self.donor_sat == donor:
		self.donor_sat = null
		self.available = true
		# notify the ClinicController that we're available
		waiting_available.emit()

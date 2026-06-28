class_name WaitingChair

extends Station

signal waiting_room_decrement

func _on_body_entered(body: Node2D) -> void:
	# check if its a donor walking past the chair
	if body is Donor:
		# check if the chair is available
		if available:
			# make the donor sit
			sit(body)
			
func get_up(donor: Donor) -> void:
	waiting_room_decrement.emit()
	super(donor)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

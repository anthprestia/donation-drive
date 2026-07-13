class_name WaitingChair

extends Station

signal waiting_room_decrement


func _on_body_entered(body: Node2D) -> void:
	# check if its a donor walking past the chair
	if body is Donor:
		# check if the chair is available
		if is_available():
			if body.get_next_station() == self.get_script():
				# make the donor sit
				self.sit(body)
				body.sit(self)

			
func get_up(donor: Donor) -> void:
	waiting_room_decrement.emit()
	super(donor)

# Called when the node enters the scene tree for the first time.
func _ready(disable_prog: bool = true) -> void:
	super(disable_prog)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

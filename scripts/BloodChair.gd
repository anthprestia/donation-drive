class_name BloodChair

extends Station

@onready var blood_iv: AnimatedSprite2D = $BloodIV

# Called when the node enters the scene tree for the first time.
func _ready(disable_prog: bool = false) -> void:
	super(disable_prog) # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

"""
func _on_body_entered(body: Node2D) -> void:
	blood_iv.play('suck')

func _on_body_exited(body: Node2D) -> void:
	blood_iv.stop()
"""

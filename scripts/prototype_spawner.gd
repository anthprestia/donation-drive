extends Node

@export var donor_scene: PackedScene

# I want my mobs to spawn at the start/beginning of the path2D
var spawn_location = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		spawnMob()

func spawnMob() -> void:
	# instantiate the donor_scene
	var alex = donor_scene.instantiate()
	var path = $Path2D
	var walker = PathFollow2D.new()
	
	alex.set_walker(walker)
	
	walker.add_child(alex)
	path.add_child(walker)
	

extends Area2D

func _ready():
	randomize_position()
	add_to_group("Berry")

func randomize_position():
	var viewport_size = get_viewport().size
	var rng = RandomNumberGenerator.new()
	rng.seed = OS.get_unix_time()
	#position = Vector2(rng.randf_range(0, 500), rng.randf_range(0, 500))
	position = Vector2(rng.randf_range(0, int(viewport_size.x-100)), rng.randf_range(0, int(viewport_size.y-100)))


func _on_Berry_area_entered(area):
	print("_on_Berry_area_entered")
	#randomize_position()
	#emit_signal("area_entered")
	
func reset_collision():
	$CollisionShape2D.set_deferred("disabled", false)

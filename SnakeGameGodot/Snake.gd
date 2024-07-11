extends Node2D

signal hit
signal endGame

export var speed = 200
var screen_size
var segment_scene = preload("res://SnakeSegment.tscn")

var body_segments = []
onready var head = $Head
onready var body_container = $BodyContainer

var start_Position = Vector2(0,0)

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO 
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	var new_position = velocity * delta
	
	if velocity.length() > 0:
		update_segments()
	if head != null:
		head.position += new_position
	
func start(pos):
	reset_game()
	start_Position = pos

func reset_game():
	for segment in body_segments:
		segment.queue_free()
		body_segments.clear()
	for child in body_container.get_children():
		body_container.remove_child(child)

	head.position = start_Position
	
	for i in range(3):
		grow()
	update_initial_segment_positions()

func update_initial_segment_positions():
	for i in range(body_segments.size()): 
		body_segments[i].position = head.position

func update_segments():
	var positionToSet
	var positionOld
	if body_segments.size() > 0:
		positionOld = body_segments[0].position
		if position != positionOld:
			body_segments[0].position = position
			positionToSet = positionOld
			for i in range(1, body_segments.size()):
				positionOld = body_segments[i].position
				body_segments[i].position = positionToSet
				positionToSet = positionOld
	if body_segments.size() > 0:
		body_segments[0].position = head.position

func grow():
	var new_segment = segment_scene.instance()
	if body_segments.size() == 0:
		new_segment.position = position
	else:
		new_segment.position = body_segments[body_segments.size() - 1].position
	body_container.add_child(new_segment)
	body_segments.append(new_segment)
	new_segment.position = head.position if body_segments.size() == 1 else body_segments[body_segments.size() - 2].position

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("endGame")

func _on_Head_area_entered(area):
	if "Berry" in area.name:
		emit_signal("hit")
	else:
		own_Body(head.position)
		
		
func own_Body(position):
	for i in range(1, body_segments.size()):
		if body_segments[i].position.distance_to(position) < 2 && position != start_Position: 
					emit_signal("endGame")



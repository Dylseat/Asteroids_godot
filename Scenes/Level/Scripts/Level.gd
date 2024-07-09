extends Node2D
class_name Level

@onready var border_rect = %BorderRect
@onready var asteroids_container: Node2D = $Asteroids

@export var asteroid_scene : PackedScene
@export var spawn_circle_radius : float = 350.0
@export var asteroid_direction_variance = 45.0

var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
var screen_size = Vector2(screen_width, screen_height)


func spawn_asteroid() -> void:
	var screen_center = screen_size / 2.0
	var angle = deg_to_rad(randf_range(0.0, 360.0))
	
	var dir_to_point = Vector2.RIGHT.rotated(angle)
	var point = screen_center + dir_to_point * spawn_circle_radius
	
	var top_left = border_rect.global_position
	var down_right = border_rect.global_position + border_rect.size
	
	point = point.clamp(top_left, down_right)
	
	var asteroid = asteroid_scene.instantiate()
	asteroids_container.add_child(asteroid)
	
	var dir_to_center = point.direction_to(screen_center)
	
	var dir_rotation = randfn(0.0, deg_to_rad(asteroid_direction_variance))
	asteroid.direction = dir_to_center.rotated(dir_rotation)
	asteroid.position = point
	
	asteroid.size = randi_range(0, Asteroid.SIZE.size() - 1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		spawn_asteroid()


class_name JumpingPlayerState extends PlayerMovementState
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25
@export var JUMP_VELOCITY: float = 4.5
var entering_speed: float
var next_state: String
var double_jump: bool = false

func enter(previous_state: State) -> void:
	player.velocity.y += JUMP_VELOCITY
	entering_speed = player.velocity.length()
	
	if previous_state.name == "SlidingPlayerState":
		next_state = default_state
		animation_player.play("RESET")
		await animation_player.animation_finished
	else:
		next_state = previous_state.name
	
	animation_player.play("jump_start")
		
func exit() -> void:
	double_jump = false

func update(delta: float) -> void:
	player.update_gravity(delta)
	player.update_velocity(entering_speed, ACCELERATION, DECELERATION)
	
	if player.is_on_floor():
		animation_player.play("jump_end")
		transition.emit(next_state) 
	
	if not double_jump and Input.is_action_just_pressed("jump"):
		player.velocity.y += JUMP_VELOCITY
		double_jump = true
		
	if Input.is_action_just_released("jump"):
		if player.velocity.y > 0:
			player.velocity.y = player.velocity.y / 2

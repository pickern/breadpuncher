/// @description Insert description here
// You can write your code in this editor
// constants (copied from player)
grv = 0.5; //gravity
hsp = 0; // current horizontal speed
vsp = 0; //current vertical speed
hsp_jump = 5; //jump x speed
air_accel = 1;
vsp_jump = -8.5; //jump y speed
wall_jump_speed = 6.5;

ground_friction = .3;
ground_friction_attack = .3; //higher friction while attacking?
air_friction = .1;

// flags
is_grounded = false;
was_hit = false;
is_hit_stun = false;

// states
state_ground_idle = 0;
state_jump = 1;
state_hit_stun = 2;

// state management vars
current_state = state_ground_idle;
timer_stun = 0;
duration_stun = 0;
prev_state = state_ground_idle;
dir = 1;

// decision weights
p_jump = .01;

// utility functions
// check horizontal collision
function check_horizontal()
{
	return place_meeting(x+hsp, y, Ground)
}

// check vertical collision
function check_vertical()
{
	return place_meeting(x, y+1+vsp, Ground)
}



// Ref to input manager
input = input_manager;

// constants
grv = 0.5; //gravity
hsp = 0; // current horizontal speed
vsp = 0; //current vertical speed
hsp_run = 5; //run speed
air_accel = 1;
vsp_jump = -8.5; //jump speed
vsp_ff = 8; //fast fall speed
wall_jump_speed = 6.5;

ground_friction = .3;
ground_friction_attack = .3; //higher friction while attacking?
air_friction = .1;

// constructors

//attack constructor
function make_attack(_dur, _sprite, _hitbox_sprite, _move = 0, _int_frame = -1) constructor
{
	dur = _dur; // duration in frames of attack animation
	sprite = _sprite; // sprite index
	hitbox = _hitbox_sprite;
	int_frame = _int_frame; // interruptible frame - defaults to -1 (not interruptible)
	move = _move; // used if attack moves character - defaults to 0
};

// flags
can_dbl_jump = 1;
is_grounded = true;
will_create_dust = false;
can_int = true; // can interrupt
attack_cancelled = false; // TODO - maybe use this for cleanup

//states
state_ground_idle = 1;
state_ground_run = 2;
state_ground_crouch = 3;
state_air = 4;
state_wall_slide = 5;
state_attack_ground = 6;
state_attack_air = 7;

//attack ids
attack_jab = new make_attack(10,0, 0);
attack_slide = new make_attack(30,sprite_attack_slide, hitbox_attack_slide, 1);
attack_tilt_up = new make_attack(24,sprite_attack_tilt_up1, hitbox_attack_air_up1, 0);
attack_air_up = new make_attack(24,sprite_attack_air_up1, hitbox_attack_air_up1, 0);
attack_air_down = new make_attack(24,sprite_attack_air_down1, hitbox_attack_air_down1, 0);
attack_air_forward = new make_attack(24,sprite_attack_air_forward1, hitbox_attack_air_forward1, 0);
attack_air_back = new make_attack(24,sprite_attack_air_back1, hitbox_attack_air_back1, 0);
attack_air_neutral = new make_attack(24,sprite_attack_air_neutral, hitbox_attack_air_neutral, 0);

//attack structs

//effect position
effect_feet = 0;
effect_wall = 1;
effect_id = 0; //TODO

// state management vars
current_attack = attack_jab; // id var
timer_anim = 0; // times var for animations
current_state = state_ground_idle; // state_var
effect_pos = effect_feet; // effect position

//Get inputs
//key_right = keyboard_check(vk_right);
key_right = input.input_check("d_right");
key_left = input.input_check("d_left");
key_down = input.input_check("d_down");
key_up = input.input_check("d_up");
key_jump = input.input_down("key_jump");
key_down_pressed = input.input_down("d_down");
key_attack_pressed = input.input_check("c_neutral");


switch current_state
{
	case state_ground_idle:
		// set state and flags
		can_dbl_jump = true;
		is_grounded = true;
		sprite_index = idle;
		// check if jump
		if (key_jump)
		{
			vsp = vsp_jump;
			current_state = state_air;
		}
		// check if run
		else if (key_left or key_right)
		{
			temp_dir = key_right - key_left;
			if not(place_meeting(x+temp_dir, y, Ground))
			{
				current_state = state_ground_run;
			}
		}
		// Check if attack
		else if key_attack_pressed
		{
			// TODO other attacks
			current_state = state_attack_ground;
			current_attack = attack_tilt_up;
		}
		// Check if crouch
		else if key_down
		{
			current_state = state_ground_crouch;	
		}
		// do physics
		if hsp != 0
		{
			if abs(hsp) <= ground_friction
			{
				hsp = 0;
			}
			else
			{
				hsp = hsp - sign(hsp)*ground_friction;
			}
			var onepixel = sign(hsp); // check direction
			if (place_meeting(x+hsp, y, Ground))
			{
				while (!place_meeting(x+onepixel,y,Ground))
				{
					x = x+onepixel;
				}
				hsp = 0;
			}
			x = x+hsp;
		}
		// Check if falling
		if !place_meeting(x,y+1,Ground)
		{
			current_state = state_air;	
		}
	break;
	case state_ground_run:
		// set sprite and flags
		can_dbl_jump = true;
		is_grounded = true;
		sprite_index = run1;
		if hsp < 0 and image_xscale == 1
		{
			image_xscale = -1;
		}
		else if hsp > 0 and image_xscale == -1
		{
			image_xscale = 1;
		}
		// Check if jump
		if (key_jump)
		{
			vsp = vsp_jump;
			current_state = state_air;
		}
		// Check if attack (only dash attack from run)
		else if key_attack_pressed
		{
			current_state = state_attack_ground;
			current_attack = attack_slide;
		}
		// do run if keys still held
		else if (key_left or key_right)
		{
			dir_temp = key_right - key_left;
			if dir_temp != 0
			{
				// Make dust if starting the run or changing direction
				if hsp == 0 or sign(hsp) != dir_temp
				{
					will_create_dust=true;
					effect_pos = effect_feet;
				}
				if abs(hsp) < abs(hsp_run)
				{
					hsp = dir_temp * hsp_run;
				}
				// slow down if moving faster than max run speed
				else
				{
					hsp = hsp - sign(hsp)*ground_friction
				}
			}
		}
		// check if run stopped or against wall
		else if (not (key_left or key_right)) 
		{
			current_state = state_ground_idle;	
		}
		// do physics/collision and move
		var onepixel = sign(hsp); // check direction
		if (place_meeting(x+hsp, y, Ground))
		{
			while (!place_meeting(x+onepixel,y,Ground))
			{
				x = x+onepixel;
			}
			hsp=0;
			current_state = state_ground_idle;
		}
		x = x+hsp;
		// TODO check if falling
		if !place_meeting(x,y+1,Ground)
		{
			current_state = state_air;	
		}
	
	break;
	case state_ground_crouch:
		// set state and flags
		can_dbl_jump = true;
		is_grounded = true;
		sprite_index = crouch;
		// check if jump
		if (key_jump)
		{
			vsp = vsp_jump;
			current_state = state_air;
		}
		// check if run
		else if (key_left or key_right)
		{
			temp_dir = key_right - key_left;
			if not(place_meeting(x+temp_dir, y, Ground))
			{
				current_state = state_ground_run;
			}
		}
		// Check if attack
		else if key_attack_pressed
		{
			// TODO other attacks
			current_state = state_attack_ground;
			current_attack = attack_tilt_up;
		}
		// Check if crouch
		else if not key_down
		{
			current_state = state_ground_idle;	
		}
		// do physics
		if hsp != 0
		{
			if abs(hsp) <= ground_friction
			{
				hsp = 0;
			}
			else
			{
				hsp = hsp - sign(hsp)*ground_friction;
			}
			var onepixel = sign(hsp); // check direction
			if (place_meeting(x+hsp, y, Ground))
			{
				while (!place_meeting(x+onepixel,y,Ground))
				{
					x = x+onepixel;
				}
				hsp = 0;
			}
			x = x+hsp;
		}
		// Check if falling
		if !place_meeting(x,y+1,Ground)
		{
			current_state = state_air;	
		}
	
	break;
	case state_wall_slide:
		sprite_index = wall_slide;
		is_grounded = false;
		// always dust on wall
		will_create_dust = true;
		effect_pos = effect_wall;
		// check if wall_jump
		if key_jump
		{
			temp_dir = 0;
			if place_meeting(x-1, y, Ground)
			{
				 temp_dir = 1;
			}
			else
			{
				temp_dir = -1;	
			}
			current_state = state_air;
			vsp = vsp_jump;
			hsp = wall_jump_speed*temp_dir;
		}
		// stop wall slide if key released
		else if not ((place_meeting(x+1, y, Ground) and key_right) or (place_meeting(x-1, y, Ground) and key_left))
		{
			current_state = state_air;	
		}
		// do physics
		vsp = vsp + grv;
		var onepixel = sign(vsp); //Check vertical direction
		if (place_meeting(x,y+vsp+1,Ground)) 
		{
			while (!place_meeting(x,y+onepixel,Ground))
			{
				y = y + onepixel;
			}
			vsp = 0;
			// check floor or ceiling collision
			if place_meeting(x,y+1,Ground)	
			{
				current_state = state_ground_idle;
			}
	
		}
		y += vsp;
	
	break;
	case state_air:
		// do sprites and flags
		sprite_index = jump;
		is_grounded = false;
		// check if double jump
		if can_dbl_jump and key_jump
		{
			can_dbl_jump = false;
			vsp = vsp_jump;
		}
		// check if wall slide
		else if ((place_meeting(x-1, y, Ground) and key_left) or (place_meeting(x+1, y, Ground) and key_right)) 
		{
			if place_meeting(x-1, y, Ground)
			{
				 image_xscale = -1;
			}
			else
			{
				image_xscale = 1;	
			}
			current_state = state_wall_slide;
			is_grounded = false;
		}
		// check if attack
		else if key_attack_pressed
		{
			current_state = state_attack_air;
			current_attack = attack_air_up;
		}
		// do physics
		// horizontal movement
		dir_temp = key_right - key_left;
		if dir_temp != 0 and abs(hsp) <= hsp_run
		{
			hsp = hsp + dir_temp * air_accel;
		}
		else if hsp != 0
		{
			if abs(hsp) <= air_friction
			{
				hsp = 0;
			}
			else
			{
				hsp = hsp - sign(hsp)*air_friction;
			}
		}
		// check collision
		var onepixel = sign(hsp); // check direction
		if (place_meeting(x+hsp, y, Ground))
		{
			while (!place_meeting(x+onepixel,y,Ground))
			{
				x = x+onepixel;
			}
			hsp=0;
		}
		x += hsp;
		// vertical
		vsp = vsp + grv;
		var onepixel = sign(vsp); //Check vertical direction
		if (place_meeting(x,y+vsp+1,Ground)) 
		{
			while (!place_meeting(x,y+onepixel,Ground))
			{
				y = y + onepixel;
			}
			vsp = 0;
			// check floor or ceiling collision
			if place_meeting(x,y+1,Ground)	
			{
				// update double jump flag and fix state
				if hsp == 0 
				{
					// dust on landing
					will_create_dust=true;
					effect_pos = effect_feet;
					current_state = state_ground_idle;
				}
				else 
				{
					// dust on landing
					will_create_dust=true;
					effect_pos = effect_feet;
					current_state = state_ground_run;
				}
			}
	
		}
		y += vsp;
	
	break;
	case state_attack_air:
		// create hitbox at start of move
		if timer_anim == 0
		{
			temp_hb = create_hitbox(x, y, current_attack.hitbox, 10, 0, 0, image_xscale);
		}
		// continue attack if timer hasn't reached end
		if timer_anim < current_attack.dur
		{
			temp_hb.x = x; // update hitbox location
			temp_hb.y = y;
			timer_anim += 1;	
			sprite_index = current_attack.sprite;
		}
		// else end attack and revert to air
		else
		{
			instance_destroy(temp_hb);
			timer_anim = 0;
			current_state = state_air;
		}
		// horizontal movement
		dir_temp = key_right - key_left;
		if dir_temp != 0 and abs(hsp) <= hsp_run
		{
			hsp = hsp + dir_temp * air_accel;
		}
		else if hsp != 0
		{
			if abs(hsp) <= air_friction
			{
				hsp = 0;
			}
			else
			{
				hsp = hsp - sign(hsp)*air_friction;
			}
		}
		// check collision
		var onepixel = sign(hsp); // check direction
		if (place_meeting(x+hsp, y, Ground))
		{
			while (!place_meeting(x+onepixel,y,Ground))
			{
				x = x+onepixel;
			}
			hsp=0;
		}
		x += hsp;
		// vertical movement
		vsp = vsp + grv;
		var onepixel = sign(vsp); //Check vertical direction
		if (place_meeting(x,y+vsp+1,Ground)) 
		{
			while (!place_meeting(x,y+onepixel,Ground))
			{
				y = y + onepixel;
			}
			vsp = 0;
			// check floor or ceiling collision
			if place_meeting(x,y+1,Ground)	
			{
				// update double jump flag and fix state
				if hsp == 0 
				{
					// dust on landing
					will_create_dust=true;
					effect_pos = effect_feet;
					instance_destroy(temp_hb);
					timer_anim = 0;
					current_state = state_ground_idle;
				}
				else 
				{
					// dust on landing
					will_create_dust=true;
					effect_pos = effect_feet;
					instance_destroy(temp_hb);
					timer_anim = 0;
					current_state = state_ground_run;
				}
			}
	
		}
		y += vsp;
	
	break;
	case state_attack_ground:
		// create hitbox at start of move
		if timer_anim == 0
		{
			temp_hb = create_hitbox(x, y, current_attack.hitbox, 10, 0, 0, image_xscale);
		}
		// continue attack if timer hasn't reached end
		if timer_anim < current_attack.dur
		{
			temp_hb.x = x; // update hitbox location
			temp_hb.y = y;
			timer_anim += 1;	
			sprite_index = current_attack.sprite;
			// hold last frame of attack if needed
		}
		// else end attack and revert to idle
		else
		{
			instance_destroy(temp_hb);
			image_speed = 1;
			timer_anim = 0;
			current_state = state_ground_idle;
			can_int = true;
		}
		// do physics
		if hsp != 0
		{
			if abs(hsp) <= ground_friction
			{
				hsp = 0;
			}
			else
			{
				// slow down only if move doesn't preserve momentum
				if current_attack.move == 0
				{
					hsp = hsp - sign(hsp)*ground_friction;
				}
			}
			var onepixel = sign(hsp); // check direction
			if (place_meeting(x+hsp, y, Ground))
			{
				while (!place_meeting(x+onepixel,y,Ground))
				{
					x = x+onepixel;
				}
				hsp=0;
			}
			x = x+hsp;
		}
		// check for falling
		if !place_meeting(x,y+1,Ground)
		{
			instance_destroy(temp_hb);
			timer_anim = 0;
			current_state = state_air;
		}
	break;
}
/*
// Check for ground attack
if is_grounded and can_int and key_attack_pressed
{
	// up tilt
	if key_up
	{
		current_state = state_attack_ground;
		current_attack = attack_tilt_up;
		can_int = false;
	}
	// dash attack/slide
	else if current_state == state_ground_run
	{
		current_state = state_attack_ground;	
		current_attack = attack_slide;
		can_int = false;
	}
	// jab
	else
	{
		current_state = state_attack_ground;
		current_attack = attack_jab;
		can_int = false;
	}
}
// Check air attack
else if (not is_grounded) and can_int and key_attack_pressed
{
	// up air
	if key_up
	{
		current_state = state_attack_air;
		current_attack = attack_air_up;
		can_int = false;
	}	
}


// Move horizontally
// TODO - probably move state logic here
// ground movement - only move if interruptible
if is_grounded and can_int
{
	dir_temp = key_right - key_left;
	if dir_temp != 0
	{
		// Make dust if starting the run or changing direction
		// TODO: no dust when against wall
		if hsp == 0 or sign(hsp) != dir_temp
		{
			will_create_dust=true;
			effect_pos = effect_feet;
		}
		if abs(hsp) < abs(hsp_run)
		{
			hsp = dir_temp * hsp_run;
		}
		// slow down if moving faster than max run speed
		else
		{
			hsp = hsp - sign(hsp)*ground_friction
		}
	}
	else if hsp != 0
	{
		if abs(hsp) <= ground_friction
		{
			hsp = 0;
		}
		else
		{
			hsp = hsp - sign(hsp)*ground_friction
		}
	}
}
// air movement - can always drift
else if not is_grounded
{
	dir_temp = key_right - key_left;
	if dir_temp != 0 and abs(hsp) <= hsp_run
	{
		hsp = hsp + dir_temp * air_accel;
	}
	else if hsp != 0
	{
		if abs(hsp) <= air_friction
		{
			hsp = 0;
		}
		else
		{
			hsp = hsp - sign(hsp)*air_friction;
		}
	}
}
// Apply attack friction unless attack carries momentum
else if current_attack.move == 0
{
	if hsp != 0
	{
		hsp = hsp - sign(hsp)*ground_friction_attack;
		if abs(hsp) < ground_friction_attack
		{
			hsp = 0;	
		}
	}
}

// Move vertically
vsp = vsp + grv;

// Check if can jump
if (place_meeting(x,y+1,Ground)) and (key_jump) and can_int
{
	
	current_state = state_air;
	vsp = vsp_jump;
	is_grounded = false;
}

// Check if can double jump
if ((!place_meeting(x,y+1,Ground)) and (key_jump)) and can_dbl_jump==1 and current_state == state_air
{
	can_dbl_jump = 0;
	vsp = vsp_jump;
}

// Check if can fast fall
if (!place_meeting(x,y+1,Ground)) and (vsp>0) and (key_down_pressed)
{
	vsp = vsp + 4;
}

// Check if can wall jump
if current_state == state_wall_slide and key_jump
{
	vsp = vsp_jump;
	hsp = (key_left - key_right)*wall_jump_speed;
	current_state = state_air;
}

// Check for horizontal collision
var onepixel = sign(hsp); // check direction
if (place_meeting(x+hsp, y, Ground))
{
	while (!place_meeting(x+onepixel,y,Ground))
	{
		x = x+onepixel;
	}
	hsp=0;
}
x = x+hsp;

// Check vertical collision
var onepixel = sign(vsp); //Check vertical direction
if (place_meeting(x,y+vsp+1,Ground)) 
{
	while (!place_meeting(x,y+onepixel,Ground))
	{
		y = y + onepixel;
	}
	vsp = 0;
	// check floor or ceiling collision
	if place_meeting(x,y+1,Ground)	
	{
		// make dust if landing
		if not is_grounded
		{
			will_create_dust = true;
			effect_pos = effect_feet;
			is_grounded = true;
			can_dbl_jump = 1;
		}
		// cancel air attack when landing
		if current_state == state_attack_air
		{
			instance_destroy(temp_hb);
			current_state = state_air;
			can_int = true;
			timer_anim = 0;
			image_speed = 1;
		}
		// update double jump flag and fix state
		if hsp == 0 and can_int
		{
			current_state = state_ground_idle;
		}
		else if can_int
		{
			current_state = state_ground_run;
		}
	}
	
}
// check to see if we should be falling
else if current_state != state_wall_slide and current_state != state_attack_air
{

	// set to falling and cancel attack
	if current_state == state_attack_ground
	{
	 instance_destroy(temp_hb);	
	}
	current_state = state_air;
	is_grounded = false;
	can_int = true;
	timer_anim = 0;
	image_speed = 1;
}

else if (current_state == state_wall_slide) and ((not (place_meeting(x+1, y, Ground) or place_meeting(x-1, y, Ground))) or not (key_left or key_right))
{

	current_state = state_air;
	is_grounded = false;
}

// Check if can wall slide
// TODO - wall sliding to the left when on ground
if current_state==state_air and can_int and ((place_meeting(x+1, y, Ground) and key_right) or (place_meeting(x-1, y, Ground) and key_left))
{
	current_state = state_wall_slide;
	is_grounded = false;
}

y = y + vsp;

// update sprites

// wall slide
if current_state == state_wall_slide
{
	// Always create dust when sliding
	will_create_dust = true;
	effect_pos = effect_wall;
	sprite_index=wall_slide;	
	
	// check & fix direction
	if key_left and image_xscale == 1
	{
		image_xscale = -1;
		//x = x + 64;
	}
	else if key_right and image_xscale == -1
	{
		image_xscale = 1;
		//x = x - 64;
	}
}
// jump
else if current_state == state_air
{
	sprite_index=jump;	
}

// run
else if current_state == state_ground_run
{
	sprite_index=run1;
	
	// update sprite direction & fix location
	if hsp < 0 and image_xscale == 1
	{
		image_xscale = -1;
		//x = x + 64;
	}
	else if hsp > 0 and image_xscale == -1
	{
		image_xscale = 1;
		//x = x - 64;
	}
}

// idle
else if current_state == state_ground_idle
{
	//sprite_index=idle;	
}

// ground attack sprite handling and logic
else if current_state == state_attack_ground
{
	// create hitbox at start of move
	if timer_anim == 0
	{
		temp_hb = create_hitbox(x, y, current_attack.hitbox, 10, 0, 0, image_xscale);
	}
	// continue attack if timer hasn't reached end
	if timer_anim < current_attack.dur
	{
		temp_hb.x = x; // update hitbox location
		temp_hb.y = y;
		timer_anim += 1;	
		sprite_index = current_attack.sprite;
		// hold last frame of attack if needed
	}
	// else end attack and revert to idle
	else
	{
		instance_destroy(temp_hb);
		image_speed = 1;
		timer_anim = 0;
		current_state = state_ground_idle;
		can_int = true;
	}
}
else if current_state == state_attack_air
{
	// create hitbox at start of move
	if timer_anim == 0
	{
		temp_hb = create_hitbox(x, y, current_attack.hitbox, 10, 0, 0, image_xscale);
	}
	// continue attack if timer hasn't reached end
	if timer_anim < current_attack.dur
	{
		temp_hb.x = x; // update hitbox location
		temp_hb.y = y;
		timer_anim += 1;	
		sprite_index = current_attack.sprite;
		// hold last frame of attack if needed
	}
	// else end attack and revert to idle
	else
	{
		instance_destroy(temp_hb);
		image_speed = 1;
		timer_anim = 0;
		current_state = state_air;
		can_int = true;
	}
}
*/
// Create dust if needed
if will_create_dust
{
	
	temp_x = x;
	temp_y = y;
	if effect_pos == effect_feet
	{
		temp_y += 32;	
	}
	else if effect_pos == effect_wall
	{
		temp_x += 32*(key_right - key_left);	
		temp_y -= 32;
	}
	for (var i = 0; i < 3; i += 1)
	{
		var p = instance_create_depth(temp_x,temp_y,0,obj_Dust);	
		p.dir = sign(hsp)*-1;
		p.v_x = random(.5) + .5;
		p.v_y = random(.5) + .5;
		p.size = random(1);
	}
	will_create_dust = false;
}


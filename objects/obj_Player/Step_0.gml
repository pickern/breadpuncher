
//Get inputs
//key_right = keyboard_check(vk_right);
key_right = input.input_check("d_right");
key_left = input.input_check("d_left");
key_down = input.input_check("d_down");
key_up = input.input_check("d_up");
key_jump = input.input_down("key_jump");
key_down_pressed = input.input_down("d_down");
key_attack_pressed = input.input_check("c_neutral");
key_attack_up_pressed = input.input_check("c_up");
key_attack_down_pressed = input.input_check("c_down");
key_attack_right_pressed = input.input_check("c_right");
key_attack_left_pressed = input.input_check("c_left");


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
		//check if fast fall
		else if key_down and vsp >= 0
		{
			vsp = vsp_ff;
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
		else if input.input_check_c_stick() != "none"
		{
			temp_in = input.input_check_c_stick();
			switch (temp_in)
			{
				case "up":
					current_attack = attack_air_up;
				break;
				case "down":
					current_attack = attack_air_down;
				break;
				case "left":
					if image_xscale == -1
					{
						current_attack = attack_air_forward;	
					}
					else
					{
						current_attack = attack_air_back;	
					}
				break;
				case "right":
					if image_xscale == 1
					{
						current_attack = attack_air_forward;	
					}
					else
					{
						current_attack = attack_air_back;	
					}
				break;
				case "neutral":
					current_attack = attack_air_neutral;
				break;
			}
			current_state = state_attack_air;
			
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
		//check if fast fall
		if key_down and vsp >= 0
		{
			vsp = vsp_ff;
		}
		// TODO - fix hitbox drift
		// create hitbox at start of move
		if timer_anim == 0
		{
			temp_hb = create_hitbox(x, y, current_attack.hitbox, 10, 10, 0, 0, image_xscale);
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
			temp_hb = create_hitbox(x, y, current_attack.hitbox, 10, 10, 0, 0, image_xscale);
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


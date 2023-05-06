/// @description Insert description here
// You can write your code in this editor

// switch based on state
switch current_state
{
	// GROUND IDLE
	case state_ground_idle:
		// check for hit
		if place_meeting(x,y,obj_hitbox)
		{
			prev_state = current_state;
			duration_stun = instance_place(x, y, obj_hitbox).hitstun;
			vsp = -1*instance_place(x, y, obj_hitbox).kb_y;
			hsp = instance_place(x, y, obj_hitbox).kb_x; // todo - horizontal based on relative location of hitbox
			timer_stun = 0;
			current_state = state_hit_stun;
			break;
		}
		// otherwise proceed with ground stuff
		is_grounded = true;
		sprite_index = sprite_blob_idle;
		// decide to jump or not
		if random(1) <= p_jump
		{
			// decide direction
			if random(1) < .5
			{
				temp_dir = 1;	
			}
			else
			{
				temp_dir = -1;	
			}
			// set state to jump
			hsp = hsp_jump*temp_dir;
			vsp = vsp_jump;
			current_state = state_jump;
		}
	break;
	// JUMP
	case state_jump:
		// check for hit
		if place_meeting(x,y,obj_hitbox)
			{
				prev_state = current_state;
				duration_stun = instance_place(x, y, obj_hitbox).hitstun;
				vsp = -1*instance_place(x, y, obj_hitbox).kb_y;
				hsp = instance_place(x, y, obj_hitbox).kb_x; // todo - horizontal based on relative location of hitbox
				timer_stun = 0;
				current_state = state_hit_stun;
				break;
			}
		// otherwise proceed with air stuff
		is_grounded = false;
		sprite_index = sprite_blob_jump;
		// check horizontal collision
		var onepixel = sign(hsp);
		if place_meeting(x + hsp, y, Ground) 
		{
			while (!place_meeting(x + onepixel,y,Ground))
			{
				x = x + onepixel;
			}
			hsp = 0;
		}
		x += hsp;
		// check vertical collision
		vsp = vsp + grv;
		var onepixel = sign(vsp); 
		if place_meeting(x, y+vsp, Ground)
		{
			while (!place_meeting(x,y+onepixel,Ground))
			{
				y = y + onepixel;
			}
			if vsp > 0
			{
				current_state=state_ground_idle;	
			}
			vsp = 0;
			
		}
		else // still airborne 
		{
			y += vsp;
		}
	break;
	// HIT STUN
	case state_hit_stun:
		// do physics
		// check horizontal collision
		var onepixel = sign(hsp);
		if place_meeting(x + hsp, y, Ground) 
		{
			while (!place_meeting(x + onepixel,y,Ground))
			{
				x = x + onepixel;
			}
			hsp = hsp * -1; // bounce on collision
		}
		x += hsp;
		// check vertical collision
		vsp = vsp + grv;
		var onepixel = sign(vsp); 
		if place_meeting(x, y+vsp, Ground)
		{
			while (!place_meeting(x,y+onepixel,Ground))
			{
				y = y + onepixel;
			}
			is_grounded = true;
			vsp = vsp * -1; // bounce on collision
			
		}
		else // still airborne 
		{
			is_grounded = false;
			y += vsp;
		}
		// check for stun duration
		if timer_stun < duration_stun
		{
			sprite_index = sprite_blob_damage1;
			timer_stun += 1;
		}
		else
		{
			timer_stun = 0;
			if is_grounded
			{
				current_state = state_ground_idle;
			}
			else
			{
				current_state = state_jump;	
			}
		}
	
	break;
}

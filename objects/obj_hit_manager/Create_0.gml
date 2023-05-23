/// TODO - manage hit effects and combo counter
combo_timer = -1; //countdown combo refresh. set to -1 for no combo, 0 for active combo.
current_combo = 0; // counts hits in current combo
combo_timer_limit = 40; // combo counter refreshes after 40 frames of no hit

// increment combo and reset timer on hit
// pass hitter and hittee here for better hitstop
// TODO - fix hitstop for hitboxes
// TODO - draw deactivated instances during hitstop
// TODO - adjust combo counter to accommodate for hitstop frames
function add_hit(hitter, hittee){
	current_combo += 1;
	combo_timer = 0;
	//is_hitstop = true;
	//hitstop_timer = 0;
	create_freezer(hitter, 10); // hitstop for hitbox owner
	create_freezer(hittee, 10); // hitstop for object getting hit
}

function reset_combo()
{
	current_combo = 0;
	combo_timer = -1;
}


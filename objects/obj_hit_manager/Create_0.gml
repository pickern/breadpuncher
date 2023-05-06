/// TODO - manage hit effects and combo counter
combo_timer = -1; //countdown combo refresh. set to -1 for no combo, 0 for active combo.
current_combo = 0; // counts hits in current combo
combo_timer_limit = 40; // combo counter refreshes after 40 frames of no hit

// increment combo and reset timer on hit
// TODO- hitstop here?
function add_hit(){
	current_combo += 1;
	combo_timer = 0;
}

function reset_combo()
{
	current_combo = 0;
	combo_timer = -1;
}


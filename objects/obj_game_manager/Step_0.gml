/// @description Insert description here
// You can write your code in this editor
if room==Room1
{
	if input.input_down("key_esc")
	{
		paused = !paused;
		if paused == false
		{
			instance_activate_all();
			surface_free(paused_surf);
			paused_surf = -1;
		}
	}
	if paused == true
	{
		alarm[0]++;
		alarm[1]++;
	}
}


/// @description Insert description here
// You can write your code in this editor
if freeze_timer == 0 // freeze instance on first frame of existence
{
	instance_deactivate_object(frozen_instance);
	freeze_timer += 1;
}
else if freeze_timer < freeze_duration // keep freezing
{
	freeze_timer += 1;	
}
else // end freeze
{
	instance_activate_object(frozen_instance);
	instance_destroy(self);
}


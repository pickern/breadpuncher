/// @description Insert description here
// You can write your code in this editor

if timer < 30
{
 timer = timer + 1;	
 x += .4*dir*v_x;
 y -= .4*v_y;
 image_xscale = image_xscale * .9;
 image_yscale = image_yscale * .9;
 image_angle += v_x*10;
}
else
{
	instance_destroy();
}

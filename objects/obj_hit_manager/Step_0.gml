/// count down combo timer 
if combo_timer != -1
{
	combo_timer += 1;
	if combo_timer > combo_timer_limit
	{
		reset_combo();
	}
}



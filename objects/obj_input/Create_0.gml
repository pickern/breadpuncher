/// @description Insert description here
// You can write your code in this editor
profile_keyboard_colemak = 
{
		d_up: ord("W"),
		d_left: ord("A"),
		d_down: ord("R"),
		d_right: ord("S"),
		c_up: ord("U"),
		c_left: ord("N"),
		c_down: ord("E"),
		c_right: ord("I"),
		c_neutral: ord("K"),
		key_jump: vk_space,
		key_esc: vk_escape,
		key_enter: vk_enter
};
profile_b0xx60_colemak = 
{
		d_up: vk_enter,
		d_left: ord("Q"),
		d_down: ord("W"),
		d_right: ord("S"),
		c_up: 110, // .
		c_left: 188, // ,
		c_down: vk_space,
		c_right: 191, // /
		c_neutral: vk_alt,
		//key_jump: 186, // ;
		key_jump: vk_enter,

		key_esc: vk_escape,
		key_enter: ord("t")
};


current_input_profile = profile_b0xx60_colemak;

// check held
function input_check(in_key){
	// arg - in_key - string for key to check
	return keyboard_check(current_input_profile[$ in_key]);
}

// check key down
function input_down(in_key){
	// arg - in_key - string for key to check
	return keyboard_check_pressed(current_input_profile[$ in_key]);
}
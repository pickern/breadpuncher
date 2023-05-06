// creates a hitbox
// @arg x
// @arg y
// @arg sprite
// @arg kb - knockback
// @arg dam - damage
// @arg owner - object creating the hitbox
function create_hitbox(x_pos, y_pos, _sprite, _kb_x, _kb_y, _dam, _owner, _xscale)
{
	var _hitbox = instance_create_layer(x_pos, y_pos, "Instances", obj_hitbox);
	_hitbox.sprite_index = _sprite;
	_hitbox.owner = _owner;
	_hitbox.dam = _dam;
	_hitbox.kb_x = _kb_x;
	_hitbox.kb_y = _kb_y;
	_hitbox.image_xscale = _xscale;
	return _hitbox;
}
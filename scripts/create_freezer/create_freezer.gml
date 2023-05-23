// creates a "freezer" which managing stopping and restarting instances ie during hitstop
// @arg _instance - instance to be frozen
// @arg _duration - duration in frames of freeze
function create_freezer(_instance, _duration){
	var _freezer = instance_create_layer(0, 0, "Instances", obj_instance_freezer);
	_freezer.frozen_instance = _instance;
	_freezer.freeze_duration = _duration;
}
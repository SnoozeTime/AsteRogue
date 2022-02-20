extends Node



func exec(state: PlayerState):
	state.has_turret = true
	state.turret_bullet += 1

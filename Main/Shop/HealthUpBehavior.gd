extends Node

func exec(state: PlayerState):
	state.health = min(state.max_health, state.health+3)

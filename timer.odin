package main

import rl "vendor:raylib"

Timer :: struct {
	start:    f32,
	duration: f32,
	ready:    bool,
}

create_timer :: proc(duration: f32) -> Timer {
	timer: Timer = {
		start    = f32(rl.GetTime()),
		duration = duration,
		ready    = false,
	}
	return timer
}

update_timer :: proc(timer: ^Timer) {
	if (!timer.ready) {
		now := f32(rl.GetTime())
		if (now - timer.start > timer.duration) {
			timer.ready = true
		}
	}
}

reset_timer :: proc(timer: ^Timer) {
	timer.ready = false
	timer.start = f32(rl.GetTime())
}

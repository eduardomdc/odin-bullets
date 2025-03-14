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

elapsed_timer :: proc(timer: Timer) -> f32 {
	return f32(rl.GetTime())-timer.start
}

StopWatch :: struct {
	start:	f32,
	elapsed:f32,
	running:bool,
}

sw_create :: proc() -> StopWatch{
	return {start = f32(rl.GetTime()), running = true}
}

sw_check_time :: proc(sw: ^StopWatch) -> f32 {
	if sw.running {
		sw.elapsed = f32(rl.GetTime())-sw.start
	}
	return sw.elapsed
}

sw_stop :: proc(sw: ^StopWatch) {
	if sw.running {
		sw.elapsed = f32(rl.GetTime())-sw.start
		sw.running = false
	}
}
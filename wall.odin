package main

import rl "vendor:raylib"

Wall :: struct {
	start:       rl.Vector2,
	end:         rl.Vector2,
	invunerable: bool,
}

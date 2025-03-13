package main

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

draw_game :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
	draw_bullets()
	draw_walls()
	draw_ui()
	rl.EndDrawing()
}

last_selected: i32
drop_down_selected: i32
drop_down_edit: bool
drop_down_rect: rl.Rectangle = {0, 0, 200, 30}
load_button_rect: rl.Rectangle = {200, 0, 120, 30}

draw_ui :: proc() {
	mouse_pos := rl.GetMousePosition()
	if !drop_down_edit &&
	   rl.IsMouseButtonPressed(rl.MouseButton.LEFT) &&
	   rl.CheckCollisionPointRec(mouse_pos, drop_down_rect) {
		drop_down_edit = true
	}

	if rl.GuiDropdownBox(
		drop_down_rect,
		strings.clone_to_cstring(map_options_str, context.temp_allocator),
		&drop_down_selected,
		drop_down_edit,
	) {
		if (drop_down_selected != last_selected) {
			drop_down_edit = false
			last_selected = drop_down_selected
		}
	}

	if drop_down_edit &&
	   drop_down_selected != last_selected &&
	   rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
		drop_down_edit = false
	}

	if rl.GuiButton(load_button_rect, "#01#Load map") {
		fmt.println("Load ", drop_down_selected)
	}
}

update_game :: proc() {
	update_spawners()
	update_bullets()
}

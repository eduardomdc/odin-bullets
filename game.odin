package main

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"
import gl "vendor:raylib/rlgl"

draw_game :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
	draw_bullets()
	draw_walls()
	draw_player()
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
		load_map(drop_down_selected)
	}
	rl.GuiLabel({600,0,200,30}, fmt.caprint("Bullets :", len(game_state.bullets), allocator = context.temp_allocator))
	rl.GuiLabel({600,30,200,30}, fmt.caprint("Walls :", len(game_state.walls), allocator = context.temp_allocator))
	rl.GuiLabel({600,60,200,30}, fmt.caprint("FPS :", rl.GetFPS(), allocator = context.temp_allocator))
	rl.GuiLabel({600,90,200,30}, fmt.caprint("Frame Time :", rl.GetFrameTime(), allocator = context.temp_allocator))
	rl.GuiLabel({600,120,200,30}, fmt.caprint("Time Survived :", sw_check_time(&game_state.player_time), allocator = context.temp_allocator))
}

load_map :: proc(selected: i32) {
	free_all(state_allocator)
	game_state = new(State, state_allocator)
	success := load_map_file(map_files[selected], game_state)
	game_state.player_position = {f32(game_state.map_width/2), f32(game_state.map_height/2)}
	game_state.player_time = sw_create()
	gl.SetLineWidth(game_state.wall_thickness)
}

update_game :: proc() {
	update_spawners()
	update_bullets()
	update_player()
}

draw_player :: proc() {
	rl.DrawTexture(
		assets.player_texture,
		i32(game_state.player_position.x - player_radius),
		i32(game_state.player_position.y - player_radius),
		rl.WHITE,
	)
}

update_player :: proc(){
	input_dir : rl.Vector2
	if rl.IsKeyDown(rl.KeyboardKey.UP) {input_dir.y -= 1}
	if rl.IsKeyDown(rl.KeyboardKey.DOWN) {input_dir.y += 1}
	if rl.IsKeyDown(rl.KeyboardKey.LEFT) {input_dir.x -= 1}
	if rl.IsKeyDown(rl.KeyboardKey.RIGHT) {input_dir.x += 1}
	input_dir = rl.Vector2Normalize(input_dir)

	game_state.player_position += game_state.player_speed * input_dir * rl.GetFrameTime()
}
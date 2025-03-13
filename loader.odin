package main

import "core:encoding/json"
import "core:fmt"
import "core:os"

load_map_file :: proc(file_name: string, state: ^State) -> bool {
	file, success := os.read_entire_file_from_filename(file_name, context.temp_allocator)
	if !success {
		fmt.println("Couldn't read map file ", file_name)
		return false
	}
	parsed, good := json.parse(file)
	data_object : json.Object = parsed.(json.Object)
	state.map_width = i32(data_object["map_width"].(f64))
	state.map_height = i32(data_object["map_height"].(f64))
	state.wall_thickness = f32(data_object["wall_thickness"].(f64))
	state.player_speed = f32(data_object["player_speed"].(f64))
	parse_walls(data_object["walls"], state)
	return true
}

parse_walls :: proc(walls_value : json.Value, state: ^State){
    walls_array := walls_value.(json.Array)
    for wall_v in walls_array{
        wall_obj := wall_v.(json.Object)
        wall : Wall = {
            start={f32(wall_obj["x1"].(f64)),f32(wall_obj["y1"].(f64))},
            end={f32(wall_obj["x2"].(f64)),f32(wall_obj["y2"].(f64))}
        }
        if "invulnerable" in wall_obj{
            wall.invulnerable = wall_obj["invulnerable"].(bool)
        }
        append(&state.walls, wall)
    }
}

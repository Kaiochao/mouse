#ifndef TILE_WIDTH
#define TILE_WIDTH 32
#endif

#ifndef TILE_HEIGHT
#define TILE_HEIGHT 32
#endif

#define MOUSE_LEFT 1
#define MOUSE_RIGHT 2
#define MOUSE_MIDDLE 4

client
	var tmp
		mouse_x
		mouse_y
		mouse_screen_loc
		mouse_on_map = FALSE
		mouse_down = 0

	New()
		. = ..()
		screen += new /atom/movable {
			name = ""
			layer = -1#INF
			mouse_opacity = 2
			screen_loc = "SOUTHWEST to NORTHEAST"
		}

	proc
		SetMouseScreenLoc(S) if(S && mouse_screen_loc != S)
			if(!isnum(text2num(S))) S = copytext(S, findtext(S, ":")+1)
			mouse_screen_loc = S
			var x = text2num(S); S = copytext(S, length("[x]")+2)
			var px = text2num(S); S = copytext(S, length("[px]")+2)
			var y = text2num(S); S = copytext(S, length("[y]")+2)
			var py = text2num(S)
			mouse_x = px + (x-1)*TILE_WIDTH
			mouse_y = py + (y-1)*TILE_HEIGHT

	MouseEntered(object, location, control, params)
		mouse_on_map = TRUE
		SetMouseScreenLoc(params2list(params)["screen-loc"])
		..()

	MouseExited(object, location, control, params)
		..()
		mouse_on_map = FALSE

	MouseMove(object, location, control, params)
		SetMouseScreenLoc(params2list(params)["screen-loc"])
		..()

	MouseDrag(
	src_object, over_object, 
	src_location, over_location, 
	src_control, over_control, params)
		SetMouseScreenLoc(params2list(params)["screen-loc"])
		..()

	MouseDrop(
	src_object, over_object, 
	src_location, over_location, 
	src_control, over_control, params)
		SetMouseScreenLoc(params2list(params)["screen-loc"])
		..()

	MouseUp(object, location, control, params)	
		var p[] = params2list(params)
		if(p["left"]) mouse_down &= ~MOUSE_LEFT
		else if(p["right"]) mouse_down &= ~MOUSE_RIGHT
		else if(p["middle"]) mouse_down &= ~MOUSE_MIDDLE
		SetMouseScreenLoc(p["screen-loc"])
		..()

	MouseDown(object, location, control, params)
		var p[] = params2list(params)
		if(p["left"]) mouse_down |= MOUSE_LEFT
		else if(p["right"]) mouse_down |= MOUSE_RIGHT
		else if(p["middle"]) mouse_down |= MOUSE_MIDDLE
		SetMouseScreenLoc(p["screen-loc"])
		..()

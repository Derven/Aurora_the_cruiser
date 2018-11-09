/turf/unsimulated/wall
	name = "wall"
	icon = 'walls.dmi'
	icon_state = "wall"
	Height = 2
	density = 1
	opacity = 1
	var/walltype = "wall"
		//Properties for airtight tiles (/wall)
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m steel wall
	temperature = T20C
	robustness = 65
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

	CanPass()
		return 0

	ex_act()
		for(var/mob/M in range(2, src))
			M << 'Explosion2.ogg'
			if(rand(1, 100) < 100 - robustness)
				src = new /turf/simulated/floor/plating(src)

	New()
		..()
		hide_wall = image('walls.dmi', icon_state = "[src.icon_state]_hide", layer = 10, loc = src)
		hide_wall.override = 1
		merge()
		//relativewall_neighbours()
		if(!istype(src, /turf/unsimulated/wall/window))
			if(prob(30))
				var/rand_num = rand(1,2)
				overlays += image(icon = 'walls.dmi', icon_state = "overlay_[rand_num]")

		for(var/turf/T in locate(x,y,z))
			if(istype(T, /turf/space))
				del(T)

	Del()
		..()
		//relativewall_neighbours()

	verb/light_capacity()
		set src in range(1, usr)
		world << lightcapacity

/turf/unsimulated/wall
	var/image/wall_overlay
	var/image/hide_wall

	attack_hand()
		merge()

	//MouseEntered()
	//	hide_me()

	verb/hide()
		set name = "Hide"
		set category = null
		set src in view(usr)
		usr << hide_wall
		sleep(25)
		usr.client.images -= hide_wall
		//del(hide_wall) 10 ����������� �� 10
		merge()

	proc/hide_me()
		for(var/mob/M in view(5, usr))
			if(M.client && !istype(src, /turf/unsimulated/wall/window))
				M << hide_wall
				merge()
			..()

	proc/clear_images()
		usr.client.images -= hide_wall

	proc/clear_for_all()
		for(var/mob/M in view(5, usr))
			if(M.client && !istype(src, /turf/unsimulated/wall/window))
				M.client.images -= hide_wall

	proc/merge()
		if(!istype(src, /turf/unsimulated/wall/asteroid))
			if(!istype(src, /turf/unsimulated/wall/window))
				overlays.Cut()
				var/turf/N = get_step(src, NORTH)
				var/turf/S = get_step(src, SOUTH)
				var/turf/W = get_step(src, WEST)
				var/turf/E = get_step(src, EAST)

				if(N && istype(N, /turf/unsimulated/wall))
					wall_overlay = image('walls.dmi', icon_state = "overlay_n", layer = 10)
					overlays.Add(wall_overlay)
				if(S && istype(S, /turf/unsimulated/wall))
					wall_overlay = image('walls.dmi', icon_state = "overlay_s", layer = 10)
					overlays.Add(wall_overlay)
				if(W && istype(W, /turf/unsimulated/wall))
					wall_overlay = image('walls.dmi', icon_state = "overlay_w", layer = 10)
					overlays.Add(wall_overlay)
				if(E && istype(E, /turf/unsimulated/wall))
					wall_overlay = image('walls.dmi', icon_state = "overlay_e", layer = 10)
					overlays.Add(wall_overlay)

/turf/unsimulated/wall/out
	icon_state = "out"

	merge()
		return
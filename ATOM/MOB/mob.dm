/mob/var/usrcolor

client
	var/STFU_ghosts		//80+ people rounds are fun to admin when text flies faster than airport security
	var/STFU_radio		//80+ people rounds are fun to admin when text flies faster than airport security

/mob
	proc/myclick(var/atom/A)
		var/mob/simulated/living/humanoid/H = usr
		if(istype(H, /mob/simulated/living/humanoid))
			if(usr.handcuffed == 0)
				var/obj/item/I = H.get_active_hand()

				if(H.throwing_mode == 1)
					if(H.hand && usr.l_hand)
						var/obj/item/I2 = H.l_hand
						H.drop_item()
						I2.throw_hyuow_at(A, rand(4,9), 1)
						H.throwing_mode = 0
						H.TH.icon_state = "throw1"
					if(!H.hand && H.r_hand)
						var/obj/item/I2 = H.r_hand
						H.drop_item()
						I2.throw_hyuow_at(A, rand(4,9), 1)
						H.throwing_mode = 0
						H.TH.icon_state = "throw1"

				if(istype(I, /obj/item/weapon/gun))
					I.afterattack(A)
				if(src in range(1, usr))
					if(!H.get_active_hand())
						A.attack_hand(usr)
					else
						if(A == H.get_active_hand())
							A.attack_self()
						else
							A.attackby(H.get_active_hand())
							if(I)
								I.afterattack(A, usr)
				else if(A.loc in range(1, usr))
					A.attack_hand(usr)

mob
	var/job = "assistant"
	step_size = 64
	layer = 18
	density = 1
	layer = 18.0
	animate_movement = 2
	flags = NOREACT
	//var/list/obj/last_contents = list()
	//MOB overhaul
	//Not in use yet
	//var/obj/organstructure/organStructure = null

	//Vars that have been relocated to organStructure
	//Vars that have been relocated to organStructure ++END
	var/obj/machinery/machine = null
	var
		//language = ENG
		image/select_overlay
		damage_bonus = 0
		defense = 5
		revenge = 0
		image/hair
		turf/SLOC = null
	var/next_move = null
	var/nutrition = 400.0//Carbon
	var/lying
	var/nodamage = 0
	var/handcuffed = 0
	//Vars that should only be accessed via procs
	var/obj/item/l_hand = null//Living
	var/obj/item/r_hand = null//Living
	var/obj/item/weapon/storage/box/backpack/back = null//Human/Monkey
	var/obj/item/weapon/tank/internal = null//Human/Monkey
	var/obj/item/weapon/storage/s_active = null//Carbon
	var/obj/item/clothing/mask/wear_mask = null//Carbon
	var/obj/item/clothing/suit/cloth= null//Carbon
	var/obj/item/clothing/id/id= null//Carbon
	var/stat = 0
	var/atom/movable/pulling = null
	var/in_throw_hyuow_mode = 0

//Generic list for proc holders. Only way I can see to enable certain verbs/procs. Should be modified if needed.
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	var/list/organs = list()


/mob/Stat()
   statpanel("Internal")
   stat("pulse", (heart.pumppower / 100) * 60)

/client/verb/windowclose(var/atomref as text)
	set hidden = 1						// hide this verb from the user's panel
	set name = ".windowclose"			// no autocomplete on cmd line

	//world << "windowclose: [atomref]"
	if(atomref!="null")				// if passed a real atomref
		var/hsrc = locate(atomref)	// find the reffed atom
		var/href = "close=1"
		if(hsrc)
			//world << "[src] Topic [href] [hsrc]"
			usr = src.mob
			src.Topic(href, params2list(href), hsrc)	// this will direct to the atom's
			return										// Topic() proc via client.Topic()

	// no atomref specified (or not found)
	// so just reset the user mob's machine var
	if(src && src.mob)
		//world << "[src] was [src.mob.machine], setting to null"
		src.mob.machine = null
	return

/mob
	var
		obj/hud/l_hand/LH
		obj/hud/r_hand/RH
		obj/hud/drop/DP
		obj/hud/pulling/PULL
		obj/hud/zone_sel/ZN_SEL
		obj/hud/health/H
		obj/hud/zone_sel_def/DF_ZONE
		obj/hud/cloth/CL
		//obj/hud/rose_of_winds/ROW
		obj/hud/hide_walls/HW
		obj/hud/act_intent/AC
		obj/hud/run_intent/RI
		obj/hud/id/ID
		obj/hud/switcher/SW
		obj/hud/rest/R
		obj/hud/movement/M
		obj/hud/back/B
		obj/hud/swap/S
		obj/hud/black/BL
		obj/hud/sleepbut/SB
		obj/hud/backpack/BP
		obj/hud/throwbutton/TH

	proc
		create_hud(var/client/C)
			if(C)
				BP = new(src)
				TH = new(src)
				LH = new(src)
				RH = new(src)
				DP = new(src)
				PULL = new(src)
				ZN_SEL = new(src)
				H = new(src)
				CL = new(src)
				AC = new(src)
				BL = new(src)
				SB = new(src)
				//ROW = new(src)
				HW = new(src)
				DF_ZONE = new(src)
				RI = new(src)
				ID = new(src)
				SW = new(src)
				R = new(src)
				M = new(src)
				B = new(src)
				S = new(src)

				C.screen.Add(BP)
				C.screen.Add(TH)
				C.screen.Add(LH)
				C.screen.Add(BL)
				C.screen.Add(SB)
				C.screen.Add(ID)
				C.screen.Add(RH)
				C.screen.Add(DP)
				C.screen.Add(PULL)
				C.screen.Add(ZN_SEL)
				C.screen.Add(CL)
				C.screen.Add(HW)
				C.screen.Add(AC)
				C.screen.Add(DF_ZONE)
				C.screen.Add(RI)
				C.screen.Add(H)
				C.screen.Add(SW) //good hud in mood
				C.screen.Add(R)
				C.screen.Add(M)
				C.screen.Add(B)
				C.screen.Add(S)

/mob
	icon = 'mob.dmi'
	icon_state = "mob"
	layer = 15
	var/death = 0
	var/intent = 1 //1 - help, 0 - harm
	var/image/overlay_cur

	gender = MALE
	var/list/stomach_contents = list()

	var/brain_op_stage = 0.0
	var/eye_op_stage = 0.0
	var/appendix_op_stage = 0.0
	var/datum/organ/external/chest/chest
	var/datum/organ/external/head/head
	var/datum/organ/external/arm/l_arm/l_arm
	var/datum/organ/external/arm/r_arm/r_arm
	var/datum/organ/external/leg/r_leg/r_leg
	var/datum/organ/external/leg/l_leg/l_leg
	var/datum/organ/external/groin/groin
	var/datum/organ/internal/lungs/lungs
	var/datum/organ/internal/heart/heart
	//var/datum/disease2/disease/virus2 = null
	//var/list/datum/disease2/disease/resistances2 = list()
	var/antibodies = 0

	proc/handle_chemicals_in_body()
		if(reagents) reagents.metabolize(src)

	New()
		START_PROCESSING(SSmobs, src)
		select_overlay = image(usr)
		overlay_cur = image('sign.dmi', icon_state = "say", layer = 10)
		overlay_cur.layer = 16
		overlay_cur.pixel_z = 5
		overlay_cur.pixel_x = -14

		usr.select_overlay.override = 1
		var/datum/reagents/R = new/datum/reagents(1000)
		reagents = R
		R.my_atom = src

		chest = new /datum/organ/external/chest(src)
		head = new /datum/organ/external/head(src)
		l_arm = new /datum/organ/external/arm/l_arm(src)
		r_arm = new /datum/organ/external/arm/r_arm(src)
		r_leg = new /datum/organ/external/leg/r_leg(src)
		l_leg = new /datum/organ/external/leg/l_leg(src)
		groin = new /datum/organ/external/groin(src)
		lungs = new /datum/organ/internal/lungs(src)
		heart = new /datum/organ/internal/heart(src)

		chest.owner = src
		head.owner = src
		r_arm.owner = src
		l_arm.owner = src
		r_leg.owner = src
		l_leg.owner = src
		groin.owner = src

		organs += chest
		organs += head
		organs += r_arm
		organs += l_arm
		organs += r_leg
		organs += l_leg
		organs += groin

		reagents.add_reagent("blood",300)

		..()



	proc/handle_stomach()
		spawn(0)
			for(var/mob/M in stomach_contents)
				if(M.loc != src)
					stomach_contents.Remove(M)
					continue
				if(istype(M, /mob) && stat != 2)
					if(M.stat == 2)
						M.death(1)
						stomach_contents.Remove(M)
						del(M)
						continue
					if(air_master.current_cycle%3==1)
						if(!M.nodamage)
							M.adjustBruteLoss(5)
						nutrition += 10

	//pain

/atom/proc/relaymove()
	return

/proc/dd_range(var/low, var/high, var/num)
	return max(low,min(high,num))

/mob/New()
	..()
	if(length(landmarks) > 0)
		Move(pick(landmarks))
/*
/mob/proc/show_lobby()
	lobby_text = " \
	<html> \
		<head> \
			<title> lobby </title> \
		</head> \
		<body> \
			<div class=lobby> \
				<span class=miniheader style=\"{color: #FFDE40; background-color: #1CBED5; width: 100%; border: 4px double #CE24CB;}\">\
				<a href='?src=\ref[src];enter=yes'>JOIN</a> / <a href='?src=\ref[src];enter=observe'>OBSERVE</a> / <a href='?src=\ref[src];enter=nahoy'> EXIT </span></a> \
				<br> \
				<center><h1>Lili station</h1></center> \
				<h3><a href='?src=\ref[src];name=newname'>NAME</a><br> \
				SELECTING <a href='?src=\ref[src];color=select'>COLOR</a><br> \
				GENDER <a href='?src=\ref[src];gender=male'> MALE </a> / <a href='?src=\ref[src];gender=female'> FEMALE </a><br> \
				<a href='?src=\ref[src];hair=new'> HAIR </a><br> \
				<a href='?src=\ref[src];display=show'>SCREEN RESOLUTION</a></h3></div> \
				<h3>JOBS:</h3><hr> \
				<span class='gray' style=\"{color: darkgray};\">Assistant</span> <a href='?src=\ref[src];assist=1'>select</a> <br> \
				<span class='green' style=\"{color: darkgreen};\">Botanist</span> <a href='?src=\ref[src];botanist=0'>select</a><br> \
				Bartender <a href='?src=\ref[src];bart=0'>select</a><br>  \
				<span class='sec' style=\"{color: darkred};\">Security</span> <a href='?src=\ref[src];sec=0'>select</a><br>\
				<span class='eng' style=\"{color: orange};\">Engineer</span> <a href='?src=\ref[src];eng=0'>select</a><br> \
				<span class='doc' style=\"{color: darkblue};\">Doctor</span> <a href='?src=\ref[src];doc=0'>select</a><br> \
				<span class='cap' style=\"{color: blue};\">Captain</span> <a href='?src=\ref[src];cap=0'>select</a><br> \
			</div> \
		</body> \
	</html>"
	usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")

/mob/proc/lobby_refresh()
	lobby_text = " \
	<html> \
		<head> \
			<title> lobby </title> \
		</head> \
		<body> \
			<div class=lobby> \
				<span class=miniheader style=\"{color: #FFDE40; background-color: #1CBED5; width: 100%; border: 4px double #CE24CB;}\">\
				<a href='?src=\ref[src];enter=yes'>JOIN</a> / <a href='?src=\ref[src];enter=observe'>OBSERVE</a> / <a href='?src=\ref[src];enter=nahoy'> EXIT </span></a> \
				<br> \
				<center><h1>Lili station</h1></center> \
				<h3><a href='?src=\ref[src];name=newname'>NAME</a><br> \
				SELECTING <a href='?src=\ref[src];color=select'>COLOR</a><br> \
				GENDER <a href='?src=\ref[src];gender=male'> MALE </a> / <a href='?src=\ref[src];gender=female'> FEMALE </a><br> \
				<a href='?src=\ref[src];hair=new'> HAIR </a><br> \
				<a href='?src=\ref[src];display=show'>SCREEN RESOLUTION</a></h3></div> \
				<h3>JOBS:</h3><hr> \
				<span class='gray' style=\"{color: darkgray};\">Assistant</span> <a href='?src=\ref[src];assist=1'>select</a> <br> \
				<span class='green' style=\"{color: darkgreen};\">Botanist</span> <a href='?src=\ref[src];botanist=0'>select</a><br> \
				Bartender <a href='?src=\ref[src];bart=0'>select</a><br>  \
				<span class='sec' style=\"{color: darkred};\">Security</span> <a href='?src=\ref[src];sec=0'>select</a><br>\
				<span class='eng' style=\"{color: orange};\">Engineer</span> <a href='?src=\ref[src];eng=0'>select</a><br> \
				<span class='doc' style=\"{color: darkblue};\">Doctor</span> <a href='?src=\ref[src];doc=0'>select</a><br> \
				<span class='cap' style=\"{color: blue};\">Captain</span> <a href='?src=\ref[src];cap=0'>select</a><br> \
			</div> \
		</body> \
	</html>"
	usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")
*/
client
	var/played = 0

//mob/var/atom/cur_object_i_give
mob/var/atom/cur_object_i_see
mob/var/inlobby = 1
	//if(!istype(cur_object_i_give, /mob) && cur_object_i_give && cur_object_i_give.contents.len > 0) statpanel("container", cur_object_i_give.contents)

/mob/verb/Change_Volume(newv as num)
	set name = "Change Volume(0-75)"
	set category = "OOC"
	if(newv > 75  || newv < 0) src << "\red Your number is out of 0-75 range."
	client.sound_volume = newv

/client
	var/sound_volume = 45 //From 0 to 30

/mob/proc/playsoundforme(sound/S as sound)
	if(client)
		usr << sound(S,0,0,0,client.sound_volume)
/*
/mob/Topic(href,href_list[])
	if(href_list["enter"] == "yes")
		if(job == "assistant")
			wear_on_spawn(/obj/item/clothing/suit/assistant)
		if(job == "bartender")
			wear_on_spawn(/obj/item/clothing/suit/bartender)
		if(job == "doctor")
			wear_on_spawn(/obj/item/clothing/suit/med)
		if(job == "engineer")
			wear_on_spawn(/obj/item/clothing/suit/eng_suit)
		if(job == "security")
			wear_on_spawn(/obj/item/clothing/suit/security_suit)
		if(job == "botanist")
			wear_on_spawn(/obj/item/clothing/suit/hydro_suit)
		if(job == "captain")
			wear_on_spawn(/obj/item/clothing/suit/captain)
		usr << sound(null)
		usr << browse(null, "window=setup")
		for(var/obj/jobmark/J in world)
			if(J.job == job)
				Move(J.loc)
		client.screen -= lobby
		density = 1
		if(name == key || name == "mob")
			name = rand_name(src)
		radio_arrival()
		sleep(2)
		usr << "<H2>[about_job(job)]</H2>"
		inlobby = 0

	if(href_list["name"] == "newname")
		usr.name = input("Choose a name for your character.",
			"Your Name",usr.name)
	if(href_list["enter"] == "nahoy")
		Logout()
	if(href_list["enter"] == "observe")
		usr << sound(null)
		usr << browse(null, "window=setup")
		for(var/obj/jobmark/J in world)
			if(J.job == "assistant")
				Move(J.loc)
		lobby.invisibility = 101
		client.run_intent = 1
		death()
		del(src)

	if(href_list["display"] == "show")
		usr.screen_res = input("Select the resolution.","���� ����������", usr.screen_res) in screen_resolution
		view_to_res()
	if(href_list["hair"] == "new")
		var/hair_state = input("Select the hairs.","Your hairs", hair) in hairs
		if(hair)
			overlays.Remove(hair)
		hair = image('mob.dmi', hair_state)
		hair.layer = initial(layer) + 5
		overlays.Add(hair)
	if(href_list["gender"] == "male")
		icon_state = "mob"
	if(href_list["gender"] == "female")
		icon_state = "mob_f"
	if(href_list["lang"] == "rus")
		language = RUS
	if(href_list["lang"] == "eng")
		language = ENG
	if(href_list["color"] == "select")
		usr.usrcolor = input(usr, "Please select color.", "color") as color
	//jobs SHIT rewrite pls
	if(href_list["assist"] == "0")
		if(job != "assistant")
			job = "assistant"
			lobby_refresh()
			usr << browse(null, "window=setup")
			usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")
		else
			usr << "\red Your job is assistant now or no vacancies!"

	if(href_list["botanist"] == "0")
		if(job != "botanist")
			job = "botanist"
			var/i = 0
			for(var/mob/M in world)
				if(M.client && M.job == "botanist")
					i+= 1
			if(i > 1)
				usr << "\red No vacancies!"
				return
			lobby_refresh()
			usr << browse(null, "window=setup")
			usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")
		else
			usr << "\red Your job is botanist now!"

	if(href_list["sec"] == "0")
		if(job != "security")
			job = "security"
			var/i = 0
			for(var/mob/M in world)
				if(M.client && M.job == "security")
					i+= 1
			if(i > 4)
				usr << "\red No vacancies!"
				return
			lobby_refresh()
			usr << browse(null, "window=setup")
			usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")
		else
			usr << "\red Your job is security now!"

	if(href_list["eng"] == "0")
		if(job != "engineer")
			job = "engineer"
			var/i = 0
			for(var/mob/M in world)
				if(M.client && M.job == "engineer")
					i+= 1
			if(i > 1)
				usr << "\red No vacancies!"
				return
			lobby_refresh()
			usr << browse(null, "window=setup")
			usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")
		else
			usr << "\red Your job is engineer now!"

	if(href_list["doc"] == "0")
		if(job != "doctor")
			job = "doctor"
			var/i = 0
			for(var/mob/M in world)
				if(M.client && M.job == "doctor")
					i+= 1
			if(i > 3)
				usr << "\red No vacancies!"
				return
			lobby_refresh()
			usr << browse(null, "window=setup")
			usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")
		else
			usr << "\red Your job is doctor now!"

	if(href_list["cap"] == "0")
		if(job != "captain")
			job = "captain"
			var/i = 0
			for(var/mob/M in world)
				if(M.client && M.job == "doctor")
					i+= 1
			if(i > 0)
				usr << "\red No vacancies!"
				return
			lobby_refresh()
			usr << browse(null, "window=setup")
			usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")
		else
			usr << "\red Your job is captain now!"

	if(href_list["bart"] == "0")
		if(job != "bartender")
			job = "bartender"
			var/i = 0
			for(var/mob/M in world)
				if(M.client && M.job == "bartender")
					i+= 1
			if(i > 0)
				usr << "\red No vacancies!"
			lobby_refresh()
			usr << browse(null, "window=setup")
			usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")
		else
			usr << "\red Your job is bartender now!"

	return
*/

/*
	if(href_list["assist"] == "0")
		assist = 1
	if(href_list["botanist"] == "0")
		botanist = 1
	if(href_list["sec"] == "0")
		sec = 1
	if(href_list["eng"] == "0")
		engi = 1
	if(href_list["doc"] == "0")
		doc = 1
	if(href_list["bart"] == "0")
		bart =1
*/
	//jobs
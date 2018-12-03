/atom/proc/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/device/detective_scanner))
		for(var/mob/O in viewers(src, null))
			if (O.client)
				O << usr.select_lang(text("\red [src] ������������� [user] � ������� [W]"), text("\red [src] has been scanned by [user] with the [W]"))
	else
		if (!( istype(W, /obj/item/weapon/grab) ) && !(istype(W, /obj/item/weapon/plastique)) &&!(istype(W, /obj/item/weapon/cleaner)) &&!(istype(W, /obj/item/weapon/chemsprayer)) &&!(istype(W, /obj/item/weapon/pepperspray)) && !(istype(W, /obj/item/weapon/plantbgone)) )
			for(var/mob/O in viewers(src, null))
				if (O.client)
					if(O.intent == 0)
						//O << text("\red <B>[] �� ����� [] � ������� []</B>", src, user, W)
						O << usr.select_lang(text("\red <B>[] �� ����� [] � ������� []</B>", src, user, W), text("\red <B>[] has been attacked by [] with the []</B>", src, user, W))
	return

/atom/Click()
	if(!istype(usr, /mob/ghost))
		var/obj/item/I = usr.get_active_hand()
		if(istype(I, /obj/item/weapon/gun))
			I.afterattack(src)
		if(src in range(1, usr))
			if(!usr.get_active_hand())
				attack_hand(usr)
			else
				if(src == usr.get_active_hand())
					attack_self()
				else
					attackby(usr.get_active_hand())
					if(I)
						I.afterattack(src, usr)
		else if(src.loc in range(1, usr))
			if(!usr.get_active_hand())
				attack_hand(usr)
				for(var/obj/structure/closet/closet_3/CL in range(1, usr))
					CL.upd_closet()

/mob
	Bump(var/atom/A)
		if(istype(src, /mob/ghost) || !client)
			return
		var/MY_PAIN
		var/turf/OTBROSOK = get_step(src, turn(dir, 180))
		if(usr.client.run_intent == 2)
			if(prob(60))
				MY_PAIN = get_organ("head")
			if(prob(40))
				MY_PAIN = get_organ(pick("chest", "r_leg", "l_leg","r_arm", "l_arm"))
		if(istype(A, /obj/machinery/airlock))
			var/obj/machinery/airlock/A_LOCK = A
			if(MY_PAIN && A_LOCK.charge == 0 && A_LOCK.close == 1)
				if(MY_PAIN == get_organ("head"))
					apply_damage(rand(5, 25) - defense, "brute" , MY_PAIN, 0)
					for(var/mob/mober in range(5, A))
						mober << mober.select_lang("\red [name] �������&#255; � ������", "\red [name] smash to the airlock")
						mober << 'smash.ogg'
					Move(OTBROSOK)
					rest()
					run_intent()
					RI.icon_state = "walk"
				else
					apply_damage(rand(1, 15) - defense, "brute" , MY_PAIN, 0)
					Move(OTBROSOK)

			var/turf/simulated/floor/T = src.loc
			if(A_LOCK.charge == 0)
				return
			else
				if(istype(A_LOCK, /obj/machinery/airlock/brig/briglock)) return
				for(var/mob/M in range(5, src))
					M << 'airlock.ogg'
				if(A_LOCK.close == 1)
					flick("open_state",A_LOCK)
					A_LOCK.icon_state = "open"
					A_LOCK.close = 0
					A_LOCK.density = 0
					A_LOCK.opacity = 0
					T.blocks_air = 0
				else
					A_LOCK.close = 1
					T.blocks_air = 1
					A_LOCK.density = 1
					A_LOCK.opacity = 1
					flick("close_state",A_LOCK)
					A_LOCK.icon_state = "close"
				T.update_air_properties()
		if(istype(A, /turf/unsimulated/wall))
			if(usr.client.run_intent == 2 && !istype(usr, /mob/ghost))
				for(var/mob/mober in range(5, A))
					mober << mober.select_lang("\red [name] �������&#255; � [A]", "\red [name] smash to [A]")
					mober << 'smash.ogg'
				if(istype(A, /turf/unsimulated/wall/window))
					var/turf/unsimulated/wall/window/WIN = A
					WIN.health -= rand(5,25)
					WIN.update_icon()
				if(MY_PAIN == get_organ("head"))
					apply_damage(rand(5, 35) - defense, "brute" , MY_PAIN, 0)
					Move(OTBROSOK)
					rest()
					run_intent()
					RI.icon_state = "walk"
				else
					apply_damage(rand(1, 15) - defense, "brute" , MY_PAIN, 0)
					Move(OTBROSOK)

	attack_hand()
		if(death == 0 && !istype(src, /mob/ghost))
			if(usr.intent == 0) //harm

				var/datum/organ/external/defen_zone
				if(client)
					defen_zone = get_organ(ran_zone(src.DF_ZONE.selecting))

				var/datum/organ/external/affecting = get_organ(ran_zone(usr.ZN_SEL.selecting))
				if(defen_zone)
					if(defen_zone == affecting )
						src << select_lang("\red �� ���������� ����� �����", "\red You block damage partially")
						usr << usr.select_lang("\red [src] ��������� ����� �����!", "\red [src] block damage partially")
						apply_damage(rand(6, 12) - defense, "brute" , affecting, 0)
				else
					apply_damage(rand(6, 12), "brute" , affecting, 0)
				for(var/mob/M in range(5, src))
					//M << "\red [usr] ���� [src] � ������� [affecting]"
					M << M.select_lang("\red [usr] ���� [src] � ������� [affecting]", "\red [usr] punch [src] to [affecting]")
			else
				if(src.ZLevel < usr.ZLevel)
					for(var/mob/M in range(5, src))
						M << M.select_lang("\red [usr] ����&#255;������ ���� [src] � ��������� �� ������ ����", "\red [usr] lift [src] to [usr.ZLevel] level")
					src.Move(usr.loc)
					src.ZLevel = usr.ZLevel
					layer = 17
					pixel_z = 32 * (ZLevel - 1)
				return


/atom/proc/attack_self()
	return

/atom/proc/Bumped(AM as mob|obj)
	return

/atom/proc/bullet_act(var/obj/item/projectile/Proj)
	return 0

/atom/movable/Bump(var/atom/A as mob|obj|turf)
	spawn( 0 )
		if ((A))
			A.Bumped(src)
		return
	..()
	return

/atom/verb/examine()
	set name = "Examine"
	set category = "IC"
	set src in oview(12)	//make it work from farther away

	if (!( usr ))
		return

	usr << usr.select_lang("��� [name].", "This is \an [name].") //here
	usr << desc
	// *****RM
	//usr << "[name]: Dn:[density] dir:[dir] cont:[contents] icon:[icon] is:[icon_state] loc:[loc]"
	return

atom/proc/attack_hand()

/atom/MouseEntered()
	if(usr.mycraft == null)
		usr.cur_object_i_see = src
		usr.select_overlay.icon = icon
		usr.select_overlay.icon_state = icon_state
		usr.select_overlay.layer = layer
		usr.select_overlay.loc = src
		if(!istype(src, /obj/hud) && !istype(src, /obj/lobby) && !istype(src, /turf/simulated/floor/roof) && !(ZLevel > usr.ZLevel))
			usr.select_overlay.color = usr.usrcolor//"#c0e0ff"
			usr << usr.select_overlay
	else
		if(get_dist(usr, src) < 2)
			usr.mycraft.loc = src
			usr.mycraft.color = "green"
			usr << usr.mycraft

/atom/MouseExited()
	usr.client.images -= usr.select_overlay
	if(usr.mycraft)
		usr.client.images -= usr.mycraft

/atom/proc/MouseDrop_T()
	return

/atom/MouseDrop(atom/over_object as mob|obj|turf|area)
	spawn( 0 )
		if (istype(over_object, /atom))
			over_object.MouseDrop_T(src, usr)
		return
	..()
	return
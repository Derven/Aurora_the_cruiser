// /mob/simulated/living vars
//---------------------
/mob/simulated/living/var/list/organs = list()
/mob/simulated/living/var/brain_op_stage = 0.0 //ORGANS
/mob/simulated/living/var/eye_op_stage = 0.0 //ORGANS
/mob/simulated/living/var/dizziness = 0
/mob/simulated/living/var/appendix_op_stage = 0.0 //ORGANS
/mob/simulated/living/var/datum/organ/external/chest/chest //ORGANS
/mob/simulated/living/var/datum/organ/external/head/head //ORGANS
/mob/simulated/living/var/datum/organ/external/arm/l_arm/l_arm //ORGANS
/mob/simulated/living/var/datum/organ/external/arm/r_arm/r_arm //ORGANS
/mob/simulated/living/var/datum/organ/external/leg/r_leg/r_leg //ORGANS
/mob/simulated/living/var/datum/organ/external/leg/l_leg/l_leg //ORGANS
/mob/simulated/living/var/datum/organ/external/groin/groin //ORGANS
/mob/simulated/living/var/datum/organ/internal/lungs/lungs //ORGANS
/mob/simulated/living/var/datum/organ/internal/heart/heart //ORGANS
/mob/simulated/living/var/antibodies = 0
/mob/simulated/living/var/list/pain_stored = list() //PAIN
/mob/simulated/living/var/last_pain_message = "" //PAIN
/mob/simulated/living/var/next_pain_time = 0 //PAIN
/mob/simulated/living/var/stamina = 100
/mob/simulated/living/var/icon/slimeoverlay
// /mob/simulated/living procs
//---------------------
/mob/simulated/living/proc/handle_chemicals_in_body()
	if(reagents) reagents.metabolize(src)

/mob/simulated/living/New()
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
	START_PROCESSING(SSmobs, src)

/mob/simulated/living/apply_damage(var/damage = 0, var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0)
	if((damagetype != BRUTE) && (damagetype != BURN))
		..(damage, damagetype, def_zone, blocked)
		return 1

	if(blocked >= 2)	return 0


	var/datum/organ/external/organ = null
	if(isorgan(def_zone))
		organ = def_zone
	else
		if(!def_zone)	def_zone = ran_zone(def_zone)
		organ = get_organ(check_zone(def_zone))
	if(!organ)	return 0
	if(blocked)
		damage = (damage/(blocked+1))

	switch(damagetype)
		if(BRUTE)
			organ.take_damage(damage, 0)
			if(damage > 3)
				new /obj/effect/bloodyblood(src.loc)

		if(BURN)
			organ.take_damage(damage, 0)
	UpdateDamageIcon()

	if(istype(def_zone, /datum/organ/external/chest))
		if(damage - blocked > 8)
			lungs.brute_dam += damage / 2
			heart.brute_dam += damage / 3

	return 1

/mob/simulated/living/attack_hand()
	sleep(1)
	var/staminamodify = 0
	if(istype(usr, /mob/simulated/living/humanoid))
		var/mob/simulated/living/humanoid/H = usr
		if(H.stamina > 1)
			H.stamina -= 1
		if(H.stamina < 30)
			staminamodify = rand(3,6)
	if(death == 0 && !istype(src, /mob/ghost))
		var/mob/simulated/living/humanoid/H = usr
		if(usr.intent == 0) //harm

			var/datum/organ/external/defen_zone
			if(client)
				defen_zone = get_organ(ran_zone(src.DF_ZONE.selecting))

			var/datum/organ/external/affecting = get_organ(ran_zone(H.ZN_SEL.selecting))
			if(defen_zone)
				if(defen_zone == affecting )
					src << "\red You block damage partially"
					usr << "\red [src] block damage partially"
					var/damage = rand(6, 12) - defense - staminamodify
					showandhide("[damage]", 1, 5)
					apply_damage(damage, "brute" , affecting, 0)
			else
				var/damage = rand(6, 12) - staminamodify
				apply_damage(damage, "brute" , affecting, 0)
				showandhide("[damage]", 1, 5)
			for(var/mob/M in range(5, src))
				//M << "\red [usr] ���� [src] � ������� [affecting]"
				M << "\red [usr] punch [src] to [affecting]"
				M << pick('punch1.ogg', 'punch2.ogg', 'punch3.ogg')
		else
			if(src.ZLevel < usr.ZLevel)
				for(var/mob/M in range(5, src))
					M << "\red [usr] lift [src] to [usr.ZLevel] level"
				src.Move(usr.loc)
				src.ZLevel = usr.ZLevel
				layer = 17
				pixel_z = 32 * (ZLevel - 1)
			else
				if(istype(src, /mob/simulated/living/humanoid))
					var/mob/simulated/living/humanoid/H2 = src
					if(H2.lying == 1)
						if(H2.death == 0)
							H2.resting()
							src << "\blue [usr] helped get you up"
					else
						var/image/LOVE = image(icon = 'sign.dmi', icon_state = "love_hug")
						usr.overlays.Add(LOVE)
						src << "\blue [usr] hugged you"
						usr << "\blue You hugged [src]"
						sleep(4)
						usr.overlays.Remove(LOVE)
			return

/mob/simulated/living/Stat()
	if(heart)
		statpanel("Internal")
		stat("pulse", (heart.pumppower / 100) * 60)
		stat("hungry", nutrition / (400 / 100))
		stat("drinking", drinking / (400 / 100))

/mob/simulated/living/bullet_act(var/obj/item/projectile/Proj)
	world << "debug210"
	if(Proj.firer != src)
		if(Proj.damage > 0)
			rand_damage(Proj.damage - rand(1,4), Proj.damage)
		else
			stunned += Proj.stun
		del(Proj)
	return 0

/mob/simulated/living/create_hud(var/client/C)
	if(C)
		PULL = new (src)
		ZN_SEL = new (src)
		AC = new(src)
		RI = new(src)
		DF_ZONE = new(src)

		C.screen.Add(PULL)
		C.screen.Add(ZN_SEL)
		C.screen.Add(AC)
		C.screen.Add(DF_ZONE)
		C.screen.Add(RI)
		for(var/datum/organ/external/EX in organs)
			EX.create_hud(C)

/mob/simulated/living/proc/gib()
	death()
	for(var/turf/F in range(3, src))
		if(istype(F, /turf/simulated)) // Make it so the blood that flies out only appears on the freezer floor
			new /obj/blood(F)
			if(prob(15))
				var/obj/item/weapon/reagent_containers/food/snacks/meat/newmeat1 = new /obj/item/weapon/reagent_containers/food/snacks/meat
				newmeat1.loc = get_turf(F)
	for(var/mob/M in range(5, src))
		M << "\red <h1>[src] GIBBED!!!</h1>"
	del(src)

/mob/simulated/living/proc/blood_flow()
	//world << "[src] the wordu"
	if(nutrition > 0)
		if(prob(rand(35, 55)))
			nutrition -= rand(1,2) //hungry
			drinking -= rand(1,2)
	if(prob(37))
		if(dizziness > 0)
			dizziness -= rand(3,7)
			if(dizziness < 0)
				dizziness = 0
	var/mob/simulated/living/humanoid/HUM = src
	if(heart)
		heart.my_func()
		switch(heart.pumppower)
			if (80 to 90)
				if(prob(rand(2,5)))
					src << heart.pain_internal()
			if (50 to 80)
				if(prob(rand(5,15)))
					src << heart.pain_internal()
			if (30 to 50)
				if(prob(rand(10,15)))
					src << heart.pain_internal()
				if(sleeping == 0)
					if(istype(HUM, /mob/simulated/living/humanoid))
						HUM.sleeping()
			if (5 to 30)
				if(prob(rand(10,25)))
					src << heart.pain_internal()
					chest.brute_dam += rand(2,4)
					head.brute_dam += rand(2,4)
			if(0 to 5)
				death()
	else
		death()

	if(istype(HUM, /mob/simulated/living/humanoid))
		if(HUM.H)
			HUM.H.clear_overlay()
			HUM.H.temppixels(round(HUM.H.cur_tnum))
			HUM.H.oxypixels(round(100 - oxyloss))
			HUM.H.healthpixels(round(health))

	if(prob(25))
		if(!reagents.has_reagent("blood", 280))
			reagents.add_reagent("blood", 20)
			if(nutrition > 250)
				reagents.add_reagent("blood", 20)

	if(istype(HUM, /mob/simulated/living/humanoid))
		if(prob(25))
			var/sum_damage = 0
			for(var/datum/organ/external/EX in organs)
				EX.blood_flow(src)
				sum_damage += EX.brute_dam + EX.burn_dam
			if(sum_damage > 350)
				gib()
			if(istype(src, /mob/simulated/living/humanoid/human))
				var/mob/simulated/living/humanoid/human/H = src
				H.update_mydamage(sum_damage)

	if(!reagents.has_reagent("blood", 50))
		death()
		return

/mob/simulated/living/proc/rand_damage(var/mind, var/maxd)
	var/MY_PAIN
	MY_PAIN = get_organ(pick("chest", "r_leg", "l_leg","r_arm", "l_arm"))
	var/damage = rand(mind, maxd) - defense
	apply_damage(damage, "brute" , MY_PAIN, 0)
	showandhide("[damage]", 1, 5)

/mob/simulated/living/proc/attacked_by(var/obj/item/I, var/mob/simulated/living/humanoid/user, var/def_zone)
	user = usr
	var/mob/simulated/living/humanoid/H = src

	var/staminamodify = 0
	if(istype(usr, /mob/simulated/living/humanoid))
		var/mob/simulated/living/humanoid/USRH = usr
		if(USRH.stamina > 1)
			USRH.stamina -= 1
		if(USRH.stamina < 30)
			staminamodify = rand(2,3)


	if((!I || !user) && istype(I, /obj/item/weapon/reagent_containers))	return 0

	if(istype(I, /obj/item/weapon/handcuffs))
		var/turf/cur_loc = loc
		if(usr.do_after(25))
			if(cur_loc == loc)
				user.drop_item_v()
				I.Move(src)
				if(istype(H, /mob/simulated/living/humanoid))
					H.handcuffed = 1
				for(var/mob/M in range(5, src))
					M.playsoundforme('handcuffs.ogg')
				return

	var/datum/organ/external/defen_zone
	if(client)
		defen_zone = get_organ(ran_zone(DF_ZONE.selecting))


	var/datum/organ/external/affecting = get_organ(ran_zone(user.ZN_SEL.selecting))
	var/hit_area
	var/def_area
	if(affecting)
		hit_area = parse_zone(affecting.name)
		if(def_zone && client)
			def_area = parse_zone(defen_zone.name)
	else
		hit_area = pick("chest", "head")
		def_area = pick("chest", "head")


	usr << "\red <B>[src] attacked [user] to [hit_area] by [I.name] !</B>"

	if(istype(I, /obj/item/weapon/flasher))
		for(var/mob/M in range(3, src))
			M.playsoundforme('flash.ogg')
			M << "\red [user] blinds [src] with the flash!"
		if(istype(H, /mob/simulated/living/humanoid))
			H.rest()
		if(client)
			client.show_map = 0
			sleep(rand(3,9))
			client.show_map = 1
			sleep(rand(2,5))
			if(istype(H, /mob/simulated/living/humanoid))
				H.rest()
		run_intent()
	if(istype(I, /obj/item/weapon/fire_ext))
		for(var/mob/M in range(3, src))
			M.playsoundforme('smash2.ogg')
	if(!I.force)	return 0
	if(def_area)
		if(def_area == hit_area)
			I.force -= defense
			user << "\blue You block damage partially"
			usr << "\red [src] block damage partially!"
	apply_damage(I.force - staminamodify, I.damtype, affecting, 0)
	showandhide("[I.force]", 1, 5)
	I.force = initial(I.force)

	stunned += I.stun

	src.UpdateDamageIcon()

/mob/simulated/living/proc/rand_burn_damage(var/mind, var/maxd)
	var/MY_PAIN
	MY_PAIN = get_organ(pick("chest", "r_leg", "l_leg","r_arm", "l_arm"))
	apply_damage(rand(mind, maxd), "fire" , MY_PAIN, 0)


/mob/simulated/living/proc/upd_status(var/datum/organ/external/O)
	var/return_color

	if(O.brute_dam + O.burn_dam < 20)
		return_color = "#00FF21" //good

	if(O.brute_dam + O.burn_dam > 20)
		return_color = "#FFD800" //bad

	if(O.brute_dam + O.burn_dam > 70)
		return_color = "#FF0000" //very bad

	if(O.brute_dam + O.burn_dam > 100)
		return_color = "#FF006E" //pizdec

	return return_color

/mob/simulated/living/proc/select_attack(var/datum/organ/external/O)
	return "red"

/mob/simulated/living/proc/UpdateDamageIcon()
	return

/mob/simulated/living/proc/HealDamage(zone, brute, burn)
	var/datum/organ/external/E = get_organ(zone)
	if(istype(E, /datum/organ/external))
		if (E.heal_damage(brute, burn))
			UpdateDamageIcon()
	else
		return 0
	return

// new damage icon system
// now constructs damage icon for each organ from mask * damage field

/mob/simulated/living/proc/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0)
	if(!damage || (blocked >= 2))	return 0
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage/(blocked+1))
		if(BURN)
			adjustFireLoss(damage/(blocked+1))
	UpdateDamageIcon()
	return 1

/mob/simulated/living/proc/get_organ(var/zone)
	if(!zone)	zone = "chest"
	for(var/datum/organ/external/O in organs)
		if(O.name == zone)
			return O
	return null

// partname is the name of a body part
// amount is a num from 1 to 100
/mob/simulated/living/proc/pain(var/partname, var/amount, var/force)
	if(death != 0) return
	if(world.time < next_pain_time && !force)
		return
	if(amount > 50 && prob(amount / 5))
		src:drop_item()
	var/msg
	switch(amount)
		if(1 to 10)
			msg = "<b>Your [partname] hurts a bit."
		if(11 to 90)
			if(src:PAAAAIN)
				src:PAAAAIN.ouch()
			msg = "<b><font size=1>Ouch! Your [partname] hurts."
		if(91 to 10000)
			if(src:PAAAAIN)
				src:PAAAAIN.ouch()
			msg = "<b><font size=3>OH GOD! Your [partname] is hurting terribly!"
	if(msg && (msg != last_pain_message || prob(10)))
		last_pain_message = msg
		src << msg
	next_pain_time = world.time + (100 - amount)

/mob/simulated/living/proc/handle_pain()
	// not when sleeping
	if(death != 0) return
	if(istype(src,/mob))
		var/maxdam = 0
		var/datum/organ/external/damaged_organ = null
		for(var/datum/organ/external/E in organs)
			var/dam = E.get_damage()
			// make the choice of the organ depend on damage,
			// but also sometimes use one of the less damaged ones
			if(dam > maxdam && (maxdam == 0 || prob(70)) )
				damaged_organ = E
				maxdam = dam
		if(damaged_organ)
			pain(damaged_organ.name, maxdam, 0)

/mob/simulated/living/proc/heal_burn(var/vol)
	if(chest.brute_dam >= vol)
		chest.burn_dam -= vol

	if(head.brute_dam >= vol)
		head.burn_dam -= vol

	if(r_arm.brute_dam >= vol)
		r_arm.burn_dam -= vol

	if(l_arm.brute_dam >= vol)
		l_arm.burn_dam -= vol

	if(r_leg.brute_dam >= vol)
		r_leg.burn_dam -= vol

	if(l_leg.brute_dam >= vol)
		l_leg.burn_dam -= vol

	if(chest.brute_dam < vol)
		chest.burn_dam = vol

	if(head.brute_dam < vol)
		head.burn_dam = 0

	if(r_arm.brute_dam < vol)
		r_arm.burn_dam = 0

	if(l_arm.brute_dam < vol)
		l_arm.burn_dam = 0

	if(r_leg.brute_dam  < vol)
		r_leg.burn_dam = 0

	if(l_leg.brute_dam < vol)
		l_leg.burn_dam = 0

/mob/simulated/living/proc/heal_brute(var/vol)
	if(chest.brute_dam >= vol)
		chest.brute_dam -= vol

	if(head.brute_dam >= vol)
		head.brute_dam -= vol

	if(r_arm.brute_dam >= vol)
		r_arm.brute_dam -= vol

	if(l_arm.brute_dam >= vol)
		l_arm.brute_dam -= vol

	if(r_leg.brute_dam >= vol)
		r_leg.brute_dam -= vol

	if(l_leg.brute_dam >= vol)
		l_leg.brute_dam -= vol

	if(chest.brute_dam < vol)
		chest.brute_dam = vol

	if(head.brute_dam < vol)
		head.brute_dam = 0

	if(r_arm.brute_dam < vol)
		r_arm.brute_dam = 0

	if(l_arm.brute_dam < vol)
		l_arm.brute_dam = 0

	if(r_leg.brute_dam  < vol)
		r_leg.brute_dam = 0

	if(l_leg.brute_dam < vol)
		l_leg.brute_dam = 0

/mob/simulated/living/proc/updatehealth()
	if(src.nodamage)
		src.health = 100
		src.stat = 0
		return
	var/mob/simulated/living/humanoid/H = src
	if((istype(H, /mob/simulated/living/humanoid) && (H.cloth == null || H.cloth.space_suit == 0)) || !istype(H, /mob/simulated/living/humanoid))
		if(istype(src.loc, /turf/simulated/floor))
			var/turf/simulated/floor/F = src.loc
			var/datum/gas_mixture/G = F.return_air()
			if(lungs && heart)
				if(G.oxygen - (lungs.my_func()/5 + rand(1,10)) < HUMAN_NEEDED_OXYGEN + heart.pumppower/1000)
					Emote(pick("gasps", "cough"))
					for(var/mob/M in range(5, src))
						if(prob(35))
							M << 'gasp.ogg'
					oxyloss += 1
				else
					if(oxyloss > 1)
						oxyloss -= 1
			else
				oxyloss += 2


		else if(istype(src.loc, /obj) && !istype(src.loc, /obj/structure/disposalholder))
			var/obj/O = src.loc
			var/turf/simulated/floor/F = O.loc
			var/datum/gas_mixture/G = F.return_air()
			if(lungs)
				if(G.oxygen - (lungs.my_func()/5 + rand(1,10)) < HUMAN_NEEDED_OXYGEN + heart.pumppower/1000)
					if(!istype(src.loc, /turf/unsimulated/floor))
						Emote(pick("gasps", "cough"))
						for(var/mob/M in range(5, src))
							if(prob(35))
								M << 'gasp.ogg'
						oxyloss += 1
				else
					if(oxyloss > 1)
						oxyloss -= 1
			else
				if(!istype(src.loc, /turf/unsimulated/floor))
					oxyloss += 2

		else
			if(!istype(H.loc, /turf/unsimulated/floor))
				Emote(pick("gasps", "cough"))
				for(var/mob/M in range(5, src))
					if(prob(35))
						M << 'gasp.ogg'
				oxyloss += 1
	if(oxyloss > 75)
		if(istype(H, /mob/simulated/living/humanoid))
			H.sleeping()

	src.health = 100 - src.getOxyLoss() - src.getToxLoss() - src.getFireLoss() - src.getBruteLoss()
	if(health > 100)
		health = 100
	if(src.health < 0)
		src.health = 0
		death()

/mob/simulated/living/proc/getBruteLoss()
	bruteloss = 0
	for(var/datum/organ/external/E in organs)
		if(istype(E, /datum/organ/external/chest) || istype(E, /datum/organ/external/head) || istype(E, /datum/organ/external/groin))
			var/dam = E.get_brute()
			bruteloss += dam
		else
			var/dam = E.get_brute()
			bruteloss += round(dam / 4)
	return bruteloss

/mob/simulated/living/proc/adjustBruteLoss(var/amount)
	bruteloss = max(bruteloss + amount, 0)

/mob/simulated/living/proc/getFireLoss()
	fireloss = 0
	for(var/datum/organ/external/E in organs)
		if(istype(E, /datum/organ/external/chest) || istype(E, /datum/organ/external/head) || istype(E, /datum/organ/external/groin))
			var/dam = E.get_burn()
			fireloss += dam
		else
			var/dam = E.get_burn()
			fireloss += round(dam / 4)
	return fireloss

/mob/simulated/living/proc/adjustFireLoss(var/amount)
	fireloss = max(fireloss + amount, 0)

//proc(mob/simulated/living)
/proc/parse_zone(zone)
	if(zone == "r_hand") return "right hand"
	else if (zone == "l_hand") return "left hand"
	else if (zone == "l_arm") return "left arm"
	else if (zone == "r_arm") return "right arm"
	else if (zone == "l_leg") return "left leg"
	else if (zone == "r_leg") return "right leg"
	else if (zone == "l_foot") return "left foot"
	else if (zone == "r_foot") return "right foot"
	else return zone
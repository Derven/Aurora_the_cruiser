/datum/AI
	var/mysay = "squeal"
	var/mob/simulated/brain
	var/aggressive

	proc/mobmovement()
	proc/seek_target()
	proc/life()
	proc/talking()

	friends_animal
		mobmovement()
			var/moveto = locate(brain.x + rand(-1,1),brain.y + rand(-1, 1),brain.z)
			if (istype(moveto, /turf/simulated/floor) || istype(moveto, /turf/unsimulated/floor)) step_towards(brain, moveto)
			if(aggressive) seek_target()

		talking()
			for(var/mob/M in range(5, brain))
				M << "[brain] * [mysay] *"

		life()
			var/deathfactor = 0
			while(deathfactor == 0)
				if(istype(brain, /mob/simulated/living))
					deathfactor = brain.death
				sleep(rand(7,25))
				if(prob(75))
					mobmovement()
				if(prob(3))
					talking()

		New(var/mob/simulated/SM)
			if(!brain)
				brain = SM
			life()
			..()

		monkey
			mysay = "whimpers"

	patrol_bots

		kate_bot

			mobmovement()
				if(brain)
					var/mindist = min(distances)
					dist_calculate()
					for(var/obj/botsignaler/BS in signalers)
						if(get_dist(BS,brain) == mindist && !myway.Find(BS))
							if(prob(10))
								talking()
							walk_to(brain, BS, 0, 3, 64)
							myway.Add(BS)
							dist_calculate()
							if(length(myway) == length(signalers) - 1 || length(myway) == length(signalers))
								for(var/mob/M in range(5, brain))
									M << 'buzz-two.ogg'
								myway.Cut()
								dist_calculate()
							for(var/mob/simulated/living/humanoid/H in oview(5, src))
								if(H.health < 70)
									if(prob(5))
										helptalk(pick("Hey [H], seek help from a doctor", "[H] health status is very bad"))

						if(prob(5))
							for(var/atom/movable/M in orange(3, brain))
								if(!istype(M, /obj/machinery/lamp))
									if(prob(3))
										walk_to(brain, M, 0, 3, 64)
										if(M != brain)
											M:attack_hand(brain)
										brain:drop_item_v()
						if(istype(brain.loc, /obj/structure))
							brain.loc:attack_hand(brain)

			talking()
				for(var/mob/M in range(5, brain))
					M << pick('buzz-sigh.ogg', 'chime.ogg')
					M << pick("Kate states, \"Hello dear, how are you? Oh, cool!\"", "Kate states, \"I launch the destruction protocol... It was a joke!\"", \
					"Kate states, \"Azimov was not a fool!\"", "Kate states, \"Maybe you are a clone with already loaded memories?!\"", "Kate states, \"My drives have long been rusted...\"", \
					"Kate states, \"This place is wonderful!\"")

			proc/helptalk(var/msg)
				for(var/mob/M in range(5, brain))
					M << pick("Kate states, \"[msg]!\"")

		clean_bot
			mobmovement()
				var/mindist = min(distances)
				dist_calculate()
				for(var/obj/botsignaler/BS in signalers)
					for(var/obj/blood/BL in view(5,src))
						walk_to(brain, BL, 0, 3, 64)
						if(prob(45))
							talking()
					if(get_dist(BS,brain) == mindist && !myway.Find(BS))
						if(prob(10))
							talking()
						walk_to(brain, BS, 0, 3, 64)
						myway.Add(BS)
						dist_calculate()
						if(length(myway) == length(signalers) - 1 || length(myway) == length(signalers))
							for(var/mob/M in range(5, brain))
								M << 'buzz-two.ogg'
							myway.Cut()
							dist_calculate()


		var/list/distances = list()
		var/list/obj/botsignaler/myway = list()

		proc/dist_calculate()
			..()
			distances.Cut()
			for(var/obj/botsignaler/BS in signalers)
				if(!myway.Find(BS))
					distances.Add(get_dist(BS,brain))

		mobmovement()
			var/mindist = min(distances)
			dist_calculate()
			for(var/obj/botsignaler/BS in signalers)
				if(get_dist(BS,brain) == mindist && !myway.Find(BS))
					if(prob(10))
						talking()
					walk_to(brain, BS, 0, 3, 64)
					myway.Add(BS)
					dist_calculate()
					if(length(myway) == length(signalers) - 1 || length(myway) == length(signalers))
						for(var/mob/M in range(5, brain))
							M << 'buzz-two.ogg'
						myway.Cut()
						dist_calculate()

		talking()
			for(var/mob/M in range(5, brain))
				M << pick('buzz-sigh.ogg', 'chime.ogg')

		life()
			var/deathfactor = 0
			while(deathfactor == 0)
				if(istype(brain, /mob/simulated/living))
					deathfactor = brain.death
				sleep(rand(7,25))
				if(prob(75))
					mobmovement()

		New(var/mob/simulated/SM)
			if(!brain)
				brain = SM
			dist_calculate()
			life()
			..()
	hunter
		var/list/distances = list()
		zombie
			talking()
				for(var/mob/M in range(5, brain))
					M << "[brain] <b>roars</b>"

			life()
				var/deathfactor = 0
				while(deathfactor == 0)
					brain.process()
					if(brain.death == 1)
						deathfactor = 1
					sleep(rand(7,25))
					if(prob(75))
						mobmovement()
						for(var/mob/simulated/living/humanoid/human/MOB in range(1,brain))
							if(brain.type != MOB.type)
								for(var/mob/O in viewers(brain, null))
									O.show_message("\red <B>[brain]</B> bites [MOB]!", 1)
								MOB.rand_damage(7, 15)

			mobmovement()
				for(var/mob/simulated/living/humanoid/human/M in range(9, brain))
					if(brain.type != M.type)
						if(prob(10))
							talking()
						walk_to(brain, M, 0, 3, 64)

		mobmovement()
			for(var/mob/M in range(5, brain))
				if(prob(10))
					talking()
				walk_to(brain, M, 0, 3, 64)
			var/moveto = locate(brain.x + rand(-1,1),brain.y + rand(-1, 1),brain.z)
			if (istype(moveto, /turf/simulated/floor) || istype(moveto, /turf/unsimulated/floor)) step_towards(brain, moveto)

		talking()
			for(var/mob/M in range(5, brain))
				M << pick('buzz-sigh.ogg', 'chime.ogg')

		slime
			talking()
				if(prob(15))
					for(var/mob/M in range(5, brain))
						M << pick("[brain] gurgles")

			proc/attack(var/mob/simulated/living/L)
				if(istype(brain, /mob/simulated/living/slime))
					if(L.type != brain.type)
						if(prob(35))
							for(var/mob/simulated/living/slime/SL in L)
								return
							brain:eat(L)
			life()
				var/deathfactor = 0
				while(deathfactor == 0)
					if(istype(brain.loc, /turf))
						for(var/mob/simulated/living/L in range(1, brain))
							attack(L)
					if(istype(brain, /mob/simulated/living))
						deathfactor = brain.death
					sleep(rand(7,25))
					if(prob(75))
						if(istype(brain.loc, /turf))
							mobmovement()
		life()
			var/deathfactor = 0
			while(deathfactor == 0)
				if(istype(brain, /mob/simulated/living))
					deathfactor = brain.death
				sleep(rand(7,25))
				if(prob(75))
					mobmovement()

		New(var/mob/simulated/SM)
			if(!brain)
				brain = SM
			life()
			..()

proc/addai(var/mob/simulated/M, var/datum/AI/ai)
	new ai(M)

proc/delai(var/mob/M)
	var/datum/AI/ai
	for(ai in M)
		del(ai)

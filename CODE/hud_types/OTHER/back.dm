obj/hud
	back
		layer = 16
		icon = 'screen1.dmi'
		icon_state = "back2"
		screen_loc = "SOUTH-1, WEST to SOUTH-1, EAST"

		verb/craft()
			set src in usr
			//usr << browse(null,"window=[name]")
			var/list/descr = list()
			var/list/myhrefs = list()
			for(var/datum/crecipe/DD in init_craft())
				descr.Add("[DD.desc]")
				myhrefs.Add("production=[DD.type]")

			special_browse(usr, nterface(descr, myhrefs))

		Topic(href,href_list[])
			if(href_list["production"])
				var/recipe = text2path(href_list["production"])
				for(var/datum/crecipe/R in init_craft())
					if(R.type == recipe)
						R.check_recipe(iam)
						attack_hand(usr)

		New(var/mob/M)
			..()
			iam = M
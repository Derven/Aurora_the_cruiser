#define ui_acti "SOUTH-1,12"
#define ui_movi "SOUTH-1,14"

#define ui_iarrowleft "SOUTH-1,11"
#define ui_iarrowright "SOUTH-1,13"

// /obj/hud vars
//---------------------
/obj/hud/layer = 18
/obj/hud/plane = 71
/obj/hud/icon = 'screen1.dmi'
/obj/hud/mouse_over_pointer = MOUSE_HAND_POINTER
/obj/hud/var/mob/iam = null

// /obj/hud procs
//---------------------
/obj/hud/proc/update_slot(var/obj/item/I)
	if(I)
		I.screen_loc = screen_loc
		if(istype(iam, /mob/simulated/living))
			iam.client.screen.Add(I)
		else
			var/datum/organ/external/EX = iam
			EX.CLIENT.screen.Add(I)

/obj/hud/New(var/mob/M)
	..()
	iam = M
/obj/hud
	swap
		icon_state = "swap"
		screen_loc = "SOUTH-1, WEST"

		Click()
			iam << 'button.ogg'
			var/mob/simulated/living/humanoid/H = iam
			H.swap_hand()
			H.doing_this = 0
var/ids = 0

/obj/item/clothing/id
	var/datum/id/ID
	var/idtype
	icon = 'suit.dmi'
	icon_state = "id"
	var/list/myids = list()
	var/credits = 0
	var/cubits = 0
	var/password = 0

	New()
		..()
		ids += 1
		password = rand(1000,9990)
		credits = rand(500, 700)
		desc = "[name];[password]"

	captain
		New()
			..()
			ids += 1
			password = rand(1000,9990)
			myids.Add(/datum/id/captain)
			credits = rand(1500, 2500)
			desc = "[name];[password]"

	assistant
		New()
			..()
			ids += 1
			password = rand(1000,9990)
			myids.Add(/datum/id/assistant)
			credits = rand(300, 500)
			desc = "[name];[password]"

	doctor
		New()
			..()
			ids += 1
			password = rand(1000,9990)
			myids.Add(/datum/id/doctor)
			credits = rand(500, 850)
			desc = "[name];[password]"

	security
		New()
			..()
			ids += 1
			password = rand(1000,9990)
			myids.Add(/datum/id/security)
			credits = rand(700, 1200)
			desc = "[name];[password]"

/obj/item/clothing/suit
	icon = 'suit.dmi'
	var/space_suit = 0

/obj/item/clothing/suit/soviet
	icon_state = "soviet_spacesuit"
	space_suit = 1

/obj/item/clothing/suit/assistant
	icon_state = "assistant_suit"

/obj/item/clothing/suit/NTspace
	icon_state = "NT_spacesuit"
	space_suit = 1

/obj/item/clothing/suit/syndispace
	icon_state = "syndi_spacesuit"
	space_suit = 1

/obj/item/clothing/suit/clown
	icon_state = "clown_suit"
	space_suit = 0

/obj/item/clothing/suit/detective
	icon_state = "detective_suit"
	space_suit = 0

/obj/item/clothing/suit/bartender
	icon_state = "bartender_suit"

/obj/item/clothing/suit/security_suit
	icon_state = "security_suit"

/obj/item/clothing/suit/detective_suit
	icon_state = "detective_suit"

/obj/item/clothing/suit/eng_suit
	icon_state = "eng_suit"

/obj/item/clothing/suit/med
	icon_state = "med_suit"

/obj/item/clothing/suit/hydro_suit
	icon_state = "hydro_suit"

/obj/item/clothing/suit
	icon = 'suit.dmi'

/obj/item/clothing/suit/soviet
	icon_state = "soviet_spacesuit"

/obj/item/clothing/suit/captain
	icon_state = "captain_suit"
	space_suit = 0
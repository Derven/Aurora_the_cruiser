//ok_hand

var/list/jobs = list("assitant", "engineer", "chief engineer", "captain", "head of personnel",
"head of security", "warden", "security", "detective", "lawyer", "quartermaster", "shaft miner",
"assistant", "janitor", "botanist", "research director", "chief of medical", "doctor", "chemist",
 "genetist", "scientist", "bartender", "chief", "priest", "clown")

/mob/simulated/living/humanoid
	proc/wear_on_spawn(var/mytype, var/myid)
		var/obj/item/clothing/CLT = new mytype(src)
		var/obj/item/clothing/id/USID = new myid(src)
		USID.layer = 22
		USID.name = "[name] ([job])"
		id = USID
		CLT.layer = 22
		cloth = CLT
		var/obj/item/weapon/storage/box/backpack/BPI = new /obj/item/weapon/storage/box/backpack(src)
		BPI.layer = 22
		back = BPI
		BP.update_slot(BPI)
		if(gender == "male")
			BP.backoverlay = image('suit.dmi',icon_state = BPI.icon_state)
		else
			BP.backoverlay = image('suit.dmi',icon_state = "[BPI.icon_state]_fem")
		BP.backoverlay.layer = 23
		CL.update_slot(CLT)
		CLT.wear_clothing(src)
		ID.update_slot(USID)
		var/obj/item/clothing/PDA/MPDA = new /obj/item/clothing/PDA(src)
		MPDA.layer = 22
		PDA = MPDA
		PPDDAA.update_slot(MPDA)
		overlays += BP.backoverlay

	proc/about_job(var/job)
		switch(job)
			if("assistant")
				return "Don't tell them you're a free assistant.</b>"
			if("bartender")
				return "Let them get drunk"
			if("security")
				return "You ignore space law."
			if("engineer")
				return "We build!"
			if("botanist")
				return "He steal my potatoes!"
			if("doctor")
				return "Casus incurabilis"
			if("captain")
				return "Tonight� you pukes will sleep with your rifles! You will give your rifle a girl�s name!\
			    Because this is the only pussy you people are going to get! Your days of finger-banging old Mary Jane Rottencrotch\
			    through her pretty pink panties are over! You�re married to this piece, this weapon of iron and wood! And you will be faithful!!"

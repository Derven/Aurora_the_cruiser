/obj/machinery/control
	anchored = 1

/obj/machinery/control/move_button
	icon = 'panel.dmi'
	icon_state = "button"

	attack_hand()
		var/counter = 0
		for(var/obj/machinery/motor/SHIP in world)
			counter += 1
			SHIP.on()
		if(counter > 7)
			brat << "<b>������ �������� ���� � �������� �� ������� \"������ ���� ������ ������&#255;\". ���-�� �������� �������, ����� ���� ��������&#255; �������� ��� ����������</b>"
			for(var/turf/space/SPICE in world)
				SPICE.icon_state = "in_move"
			for(var/obj/glass/G in world)
				G.update_turf()
		else
			sleep(3)
			brat << "<b>������ �������� ���� � �������� �� ������� \"������ ���������� �� ������&#255;, ����� ���������� ����������� ��� ����������</b>"
			for(var/obj/machinery/motor/SHIP in world)
				SHIP.off()

/obj/machinery/control/stop_kran
	icon = 'panel.dmi'
	icon_state = "button"

	attack_hand()
		brat << "<b>����� ������&#255; �������� ������ \"��������\" ������� ����� ��������������&#255;</b>"
		for(var/turf/space/SPICE in world)
			SPICE.icon_state = ""
		for(var/obj/glass/G in world)
			G.update_turf()
		for(var/obj/machinery/motor/SHIP in world)
			SHIP.off()
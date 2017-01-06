/obj/machinery/consol
	anchored = 1
	icon_state = "consol"
	power_channel = ENVIRON
	idle_power_usage = 200

/obj/machinery/consol/panic
	name = "panic console"

	var
		panic = 0

	attack_hand()
		if(panic == 0)
			brat << "�� ������������ ����� \"�������\"!"
			for(var/obj/machinery/lamp/LAMP in machines)
				LAMP.icon_state = "danger"
			world << "\red <b>������� ���������&#255; ������� ������&#255;, ���� �������. �������, �������!</b>"
			panic = 1
			for(var/turf/simulated/floor/F in world)
				F.icon_state = "danger"
			for(var/obj/glass/G in world)
				G.update_turf()
			return
		else
			brat << "�� �������������� ����� \"�������\"!"
			for(var/obj/machinery/lamp/LAMP in machines)
				LAMP.icon_state = "lamp"
			world << "\blue <b>������� ���������&#255; ������� ������&#255;, ���� �������. ������� ��������� � ����������� �����!</b>"
			panic = 0
			for(var/turf/simulated/floor/F in world)
				F.icon_state = "floor"
			for(var/obj/glass/G in world)
				G.update_turf()
			return
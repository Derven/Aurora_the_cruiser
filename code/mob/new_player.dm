/mob/New()
	..()
	Move(pick(landmarks))

/mob/Login()
	..()
	brat << "<h1>���������te, ������sch! ������ ������������ ������&#255; \"������\" ������ ��� �������� ������</h1>"
	create_hud(usr.client)
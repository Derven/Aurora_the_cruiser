/mob/New()
	..()
	Move(pick(landmarks))

/mob/Login()
	..()
	brat << "<h1>���������te, ������sch! ������ ������������ �������� \"������\" ������ ��� �������� ������</h1>"
	create_hud(usr.client)
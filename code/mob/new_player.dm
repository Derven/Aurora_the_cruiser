/mob
	var/obj/lobby/lobby
	var/lobby_text
	var/sound/lobbysound = sound('sound/soviet_hymn.it')


	proc/create_lobby(var/client/C)
		C.screen += lobby

/mob/New()
	..()
	Move(pick(landmarks))

/mob/proc/show_lobby()
	lobby_text = " \
	<html> \
	<head><title>�������� �����</title></head> \
	<body style=\"font-family: Georgia, sans-serif;\"> \
	<a href='?src=\ref[src];display=show'>����������</a>\
	<br> \
	<br> \
	<a href='?src=\ref[src];enter=yes'>����</a>\
	<br> \
	<a href='?src=\ref[src];enter=nahoy'>�����</a> \
	</body></html>"
	usr << browse(lobby_text,"window=setup")

/mob/Login()
	..()
	brat << "<h1>����������� ��� �� �������� ������� �������������� �������. ����� �� ������ �����������&#255; � �������� ����������&#255;�� � ����������&#255;�� ������� �������</h1>"
	brat << "<h1><b>����&#255; ���&#255;�� �������. � ������� �� ��������.</b></h2>"
	brat << "<h2><a href=\"https://discord.gg/2VyzxfE\">���������� ����� ����. ����� ����� �������������&#255; � ����������.</h2>"
	brat << "<h2><a href=\"https://sites.google.com/view/space-station-13-isometric\">������ ���� �������</h2>"
	brat << "<h2><a href=\"https://plinhost.github.io/Aurora_the_cruiser\">������ ���� �������</h2>"
	brat << "<h2><a href=\"https://github.com/Derven/Aurora_the_cruiser\">�����������</h2>"
	lobby = new(usr)
	create_hud(usr.client)
	create_lobby(usr.client)
	usr << lobbysound
	show_lobby()
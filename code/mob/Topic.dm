/mob/Topic(href,href_list[])
	if(href_list["enter"] == "yes")
		Move(pick(jobmarks))
		lobby.invisibility = 101
		usr << sound(null)
		usr << browse(null, "window=setup")
	if(href_list["enter"] == "nahoy")
		Logout()
	if(href_list["display"] == "show")
		usr.screen_res = input("�������� ���������� ������ ������ ��� ������� � ���� (��� ����� ��&#1103; ����������� ����������&#1103; ����������).","���� ����������", usr.screen_res) in screen_resolution
		view_to_res()
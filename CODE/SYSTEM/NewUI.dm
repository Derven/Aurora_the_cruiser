/datum/UI
	var/itype = "computer"
	var/info = ""
	var/style = ""
	var/obj/DEVICE
	var/list/buttons_names = list()
	var/list/buttons_hrefs = list()

	proc/initUI(var/BN, var/BH, var/obj/IDEVICE, var/mytype)
		itype = mytype
		DEVICE = IDEVICE
		buttons_names = BN
		buttons_hrefs = BH

	proc/updateUI(var/myinfo)
		info = myinfo
		switch(itype)
			if("computer")
				style = {"
					<!DOCTYPE html>
					<html>
					<head>
					<title>[DEVICE.name]</title>
					<style>
					 body {
					    height: 320px;
					    width: 480px;
					    padding-left: 15px;
					    overflow: hidden;
					    background: url(interface.png) no-repeat;
					    font-family: "Consolas";
					}
					p{
						position: relative;
						color: green;
						height: 210px;
						width: 290px;
						overflow: auto;
						padding-left: 50px;
						top: 40px;
						padding-right: 150px;
					}

					a{
						color: darkgreen;
					}

					.widget {
						position: relative;
						height: 110px;
						width: 20px;
						bottom: 200px;
						padding-right: 30px;
						padding-left: 395px;
					}
					.widget h3 {
						margin-bottom: 20px;
						text-align: center;
						font-weight: normal;
						color:  #424949;
					}
					.widget ul {
						position: relative;
						bottom: 10px;
						margin: 0;
						padding: 0;
						list-style: none;
						right: 6px;
					}
					.widget li {
						font-size: 14px;
						bottom: 10px;
						text-decoration: none;
						color: gray;
						right: 7px;
					}
					.widget li:last-child {
						font-size: 12px;
						right: 3px;
					}

					.widget a img{
						position: relative;
						color: gray;
						text-decoration: none;
						text-shadow: #EAA 1px 0 10px;
						border: 0;
						left: 3px;
					}
					.widget li:before {
						font-size: 32px;
						vertical-align:bottom;
						right: 6px;
						padding-top: 0px;
					}
					.widget li:nth-child(1):before {content:url(https://cdn.discordapp.com/attachments/206390709371142144/588106893730381844/button.png);}
					</style>
					</head>
					<body scroll=no>
						<p>[fix1103(info)]</p>
					"}
			if("PDA")
				style = {"
					<!DOCTYPE html>
					<html>
					<head>
					<title>[DEVICE.name]</title>
					<style>
					 body {
					    height: 320px;
					    width: 480px;
					    padding-left: 15px;
					    overflow: hidden;
					    background: url(interface2.png) no-repeat;
					    font-family: "Consolas";
					}
					p{
						position: relative;
						color: green;
						height: 210px;
						width: 290px;
						overflow: auto;
						padding-left: 50px;
						top: 40px;
						padding-right: 150px;
					}

					.widget {
						position: relative;
						height: 110px;
						width: 20px;
						bottom: 200px;
						padding-right: 30px;
						padding-left: 395px;
					}
					.widget h3 {
						margin-bottom: 20px;
						text-align: center;
						font-weight: normal;
						color:  #424949;
					}
					.widget ul {
						position: relative;
						bottom: 10px;
						margin: 0;
						padding: 0;
						list-style: none;
						right: 3px;
					}
					.widget li {
						font-size: 14px;
						bottom: 10px;
						text-decoration: none;
						color: gray;
						right: 7px;
					}
					.widget li:last-child {
						font-size: 12px;
						right: 3px;
					}

					.widget a img{
						position: relative;
						color: gray;
						text-decoration: none;
						text-shadow: #EAA 1px 0 10px;
						border: 0;
						left: 5px;
					}
					.widget li:before {
						font-size: 32px;
						vertical-align:bottom;
						right: 6px;
						padding-top: 0px;
					}
					.widget li:nth-child(1):before {content:url(https://cdn.discordapp.com/attachments/206390709371142144/588106893730381844/button.png);}
					</style>
					</head>
					<body scroll=no>
						<p>[fix1103(info)]</p>
					"}
			if("device")
				style = {"
					<!DOCTYPE html>
					<html>
					<head>
					<title>[DEVICE.name]</title>
					<style>
					 body {
					    height: 320px;
					    width: 480px;
					    padding-left: 15px;
					    overflow: hidden;
					    background: url(interface3.png) no-repeat;
					    font-family: "Consolas";
					}
					p{
						position: relative;
						color: green;
						height: 210px;
						width: 290px;
						overflow: auto;
						padding-left: 50px;
						top: 40px;
						padding-right: 150px;
					}

					.widget {
						position: relative;
						height: 110px;
						width: 20px;
						bottom: 200px;
						padding-right: 30px;
						padding-left: 395px;
					}
					.widget h3 {
						margin-bottom: 20px;
						text-align: center;
						font-weight: normal;
						color:  #424949;
					}
					.widget ul {
						position: relative;
						bottom: 10px;
						margin: 0;
						padding: 0;
						list-style: none;
						right: 3px;
					}
					.widget li {
						font-size: 14px;
						bottom: 10px;
						text-decoration: none;
						color: gray;
						right: 7px;
					}
					.widget li:last-child {
						font-size: 12px;
						right: 3px;
					}

					.widget a img{
						position: relative;
						color: gray;
						text-decoration: none;
						text-shadow: #EAA 1px 0 10px;
						border: 0;
						left: 5px;
					}
					.widget li:before {
						font-size: 32px;
						vertical-align:bottom;
						right: 6px;
						padding-top: 0px;
					}
					.widget li:nth-child(1):before {content:url(https://cdn.discordapp.com/attachments/206390709371142144/588106893730381844/button.png);}
					</style>
					</head>
					<body scroll=no>
						<p>[fix1103(info)]</p>
					"}
		style += {"<div class="widget">
		<ul>
		"}
		for(var/i = 1, i <= length(buttons_names), i++)
			style += "<a href=\"?src=\ref[DEVICE];[buttons_hrefs[i]];\"><img src=\"button.png\"><li>[buttons_names[i]]</li></a>"
		style += {"
		</ul>
		</div>
		</body>
		</html>"}

	proc/browseme(var/mob/M, var/myinfo)
		updateUI(myinfo)
		if(M.client)
			M << browse_rsc('interface.png',"interface.png")
			M << browse_rsc('interface2.png',"interface2.png")
			M << browse_rsc('interface3.png',"interface3.png")
			M << browse_rsc('button.png',"button.png")
			M << browse(style, "window=[DEVICE.name];size=515x350")
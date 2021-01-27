@ECHO OFF
SET _mountletterdatabase=
SET /p _localip= Enter the server ip: 

if %_localip%==d GOTO _debugmode


GOTO _connect

:_connect
	SET /p _drivename= Enter the name of the drive: 
	wmic logicaldisk get caption,volumename

	SET /p _mountletter= Enter the perfered mount letter (that is not allready used): 
	SET /p _guestornot= log in as guest / account: 

	if %_guestornot%==guest GOTO _guestLogin
	if %_guestornot%==account GOTO _accountLogin


:_guestLogin
	echo mounting \\%_localip%\%_drivename% to %_mountletter%
	net use %_mountletter%: \\%_localip%\%_drivename%
	GOTO _passthru

  
:_accountLogin
	SET /p _username= username: 
	SET /p _password= password: 
	net use %_mountletter%: \\%_localip%\%_drivename% /u:%_username% %_password%
	GOTO _passthru

:_passthru
	SET /p _moreorquit= connect more drives or quit (more / quit): 
	if %_moreorquit%==more (
		SET _mountletterdatabase= %_mountletter% and %_mountletterdatabase%
		ECHO Added %_mountletter% to %_mountletterdatabase% for later disconnecting purposes
		GOTO _connect
	)
	if %_moreorquit%==quit GOTO _disconnect
	
:_disconnect
	ECHO disconnect all the connected network drives to this machine or a specific one or the last one? 
	SET /p _disconnectcommand=(all / specific / last / exit): 
	if %_disconnectcommand%==all (
		net use * /delete
		exit
	)
	if %_disconnectcommand%==specific (
		SET /p _mountletter= Enter the mount letter of the drive that has to be disconnected: 
		net use %_mountletter%: /delete
		GOTO _disconnect
	)
	if %_disconnectcommand%==last (
		net use %_mountletter%: /delete
		GOTO _disconnect
	)
	if %_disconnectcommand%==exit exit

:_debugmode
	SET _localip=[CHANGE ME]
	ECHO %_localip%
	SET _drivename=[CHANGE ME]
	ECHO %_drivename%
	GOTO _connect
	pause
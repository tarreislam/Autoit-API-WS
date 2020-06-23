; Include the UDF
#include "../API.au3"

; Set basic app info
_API_MGR_SetName("My APP adapter")
_API_MGR_SetVer("1.0 BETA")
_API_MGR_SetDescription("This adapter wraps some stuff from my app")

; Init the _API manager
_API_MGR_Init(4545)
If @error Then
	MsgBox(64,"", "Failed to init API. Error " & @error)
	Exit
EndIf

; Success
ConsoleWrite("Please visit http://localhost:4545" & @LF)

; Handle requests
While _API_MGR_ROUTER_HANDLE()
WEnd
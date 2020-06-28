#include "../API.AU3"


; Init the _API manager
_API_MGR_Init(4545)
If @error Then
	MsgBox(64,"", "Failed to init API. Error " & @error)
	Exit
EndIf



; Handle requests
While _API_MGR_ROUTER_HANDLE()
WEnd

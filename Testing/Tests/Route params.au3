#include "../../API.AU3"


; Init the _API manager
_API_MGR_Init(4545)
If @error Then Exit(1)

_API_MGR_ROUTER_GET('/test/{mypath}', CB_Test)


; Handle requests
While _API_MGR_ROUTER_HANDLE()
WEnd

Func CB_Test(Const $oRequest)



	; Pass the object back to our router, which will convert it into escaped json
	Return $oRequest
EndFunc
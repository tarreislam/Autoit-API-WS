#include "../../API.AU3"


; Init the _API manager
_API_MGR_Init(4545)
If @error Then Exit(1)

_API_MGR_ROUTER_GET('/test', CB_Test)


; Handle requests
While _API_MGR_ROUTER_HANDLE()
WEnd

Func CB_Test(Const $oRequest)

	;
	; Create an empty object
	Local $object = ObjCreate("Scripting.Dictionary")

	; List all headers
	Local $aHeaderKeys = $oRequest.keys()
	For $i = 0 To $oRequest.count() -1
		; Fetch the header KEY
		Local $key = $aHeaderKeys[$i]
		Local $value = $oRequest.item($key)

		; Place in new SD
		$object.add($key, $value)
	Next

	; Pass the object back to our router, which will convert it into escaped json
	Return $object
EndFunc
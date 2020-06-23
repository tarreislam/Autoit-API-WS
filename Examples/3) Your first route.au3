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

; Register routes (Must be done after MGR_INIT)
_API_MGR_ROUTER_GET('/my-first-route', _CB_MyFirstRoute)

; Success
ConsoleWrite("Please visit http://localhost:4545" & @LF)

; Handle requests
While _API_MGR_ROUTER_HANDLE()
WEnd

; Define your routes here

Func _CB_MyFirstRoute()
	; This UDF relies on the Dictionary object to create JSON (See more here: https://docs.microsoft.com/en-us/office/vba/language/reference/user-interface-help/dictionary-object)

	; Create an empty object
	Local $object = ObjCreate("Scripting.Dictionary")

	; Assign some values

	$object.add('username', @UserName)
	$object.add('computerName', @ComputerName)

	; Pass the object back to our router, which will convert it into escaped json
	Return $object
EndFunc
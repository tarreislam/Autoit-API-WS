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
_API_MGR_ROUTER_GET('/my-second-route', _CB_MySecondRoute)
_API_MGR_ROUTER_GET('/my-third-route', _CB_MyThirdRoute)
_API_MGR_ROUTER_GET('/my-fourth-route', _CB_MyFourthRoute)
_API_MGR_ROUTER_GET('/my-fifth-route', _CB_MyFifthRoute)

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

Func _CB_MySecondRoute(Const $oRequest)
	; the $oRequest passed to this function is an "Scripting.Dictionary", the same type of object we used to return data

	; Create an empty object
	Local $object = ObjCreate("Scripting.Dictionary")

	; Assign some values
	Local Const $queryParam1 = $oRequest.exists('param1') ? $oRequest.item('param1') : 'param1 not set. append ?param1= to the url see this value change'

	$object.add('param1', $queryParam1)

	; Pass the object back to our router, which will convert it into escaped json
	Return $object
EndFunc

Func _CB_MyThirdRoute(Const $oRequest, Const $oHeaders)
	;
	; Create an empty object
	Local $object = ObjCreate("Scripting.Dictionary")

	; List all headers
	Local $aHeaderKeys = $oHeaders.keys()
	For $i = 0 To $oHeaders.count() -1
		; Fetch the header KEY
		Local $key = $aHeaderKeys[$i]
		Local $value = $oHeaders.item($key)

		; Place in new SD
		$object.add($key, $value)
	Next

	; Pass the object back to our router, which will convert it into escaped json
	Return $object
EndFunc

Func _CB_MyFourthRoute()
	; The router can handle infinte nested objects and arrays. Here is an small example that will generate an array of objects

	; define some random names
	Local $names = ['Terry a Davis', 'TarreTarreTarre', 'Olivia', 'Bên', 'Güstafó', 'Åsa', 'inridjé']

	; Create array
	Local $array[UBound($names)]

	; Fill with random crap
	For $i = 0 To UBound($names) -1
		Local $person = ObjCreate("Scripting.Dictionary")
		Local $assets[2] = [Random(1, 10, 1), Random(11, 15, 1)]
		$person.add('name', $names[$i])
		$person.add('age', Random(15,45, 1))
		$person.add('assets', $assets)
		$array[$i] = $person
	Next

	; Pass the object back to our router, which will convert it into escaped json
	Return $array
EndFunc

Func _CB_MyFifthRoute()
	; By default the API will return text/json. You can easily change that with the function _API_RES_SET_CONTENT_TYPE

	; Change content type for this route
	_API_RES_SET_CONTENT_TYPE($API_CONTENT_TYPE_TEXTHTML)

	;Return html
	Return '<h1>Here is some HTML!</h1>'
EndFunc


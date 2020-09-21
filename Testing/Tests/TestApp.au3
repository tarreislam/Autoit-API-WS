#include "../../API.AU3"


; Init the _API manager
_API_MGR_Init(4545)
If @error Then Exit(1)
_API_MGR_ROUTER_GET('/empty-string-response', CB_EmptyStringResponse)
_API_MGR_ROUTER_GET('/empty-array-response', CB_EmptyArrayResponse)
_API_MGR_ROUTER_GET('/empty-object-response', CB_EmptyObjectResponse)
_API_MGR_ROUTER_GET('/array-of-objects-response', CB_ArrayOfObjectsResponse)
_API_MGR_ROUTER_GET('/object-of-arrays-response', CB_ObjectOfArrayResponse)
_API_MGR_ROUTER_GET('/object-of-types-response', CB_ObjectOfTypesResponse)


; Handle requests
While _API_MGR_ROUTER_HANDLE()
WEnd


Func CB_EmptyStringResponse()
	Return ''
EndFunc

Func CB_EmptyArrayResponse()
	Local const $arr[0] = []
	Return $arr
EndFunc

Func CB_EmptyObjectResponse()
	return ObjCreate("Scripting.Dictionary")
EndFunc

Func CB_ArrayOfObjectsResponse()
	Local Const $obj1 = ObjCreate("Scripting.Dictionary")
	$obj1.add('name', 'test')
	$obj1.add('number',1337)
	Local Const $obj2 = ObjCreate("Scripting.Dictionary")
	$obj2.add('name', 'test')
	$obj2.add('number', 22)

	Local Const $arr = [$obj1, $obj2]

	Return $arr
EndFunc

Func CB_ObjectOfArrayResponse()
	Local Const $arr = [1, 2, 3, 4, 5]
	Local Const $arr2 = [ObjCreate("Scripting.Dictionary")]
	Local Const $oObj = ObjCreate("Scripting.Dictionary")
	$oObj.add('arr', $arr)
	$oObj.add('arr2', $arr2)
	Return $oObj
EndFunc

Func CB_ObjectOfTypesResponse()
	Local Const $oObj = ObjCreate("Scripting.Dictionary")
	Local Const $arr[0] = []
	$oObj.add('string', '')
	$oObj.add('ip', '192.168.1.0')
	$oObj.add('number_a', 1337)
	$oObj.add('number_b', 13.37)
	$oObj.add('number_c', "13.37")
	$oObj.add('object', ObjCreate("Scripting.Dictionary"))
	$oObj.add('array', $arr)
	$oObj.add('null', Null)
	$oObj.add('bool_a', True)
	$oObj.add('bool_b', False)
	Return $oObj
EndFunc

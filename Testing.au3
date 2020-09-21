#include "Testing\TestSuite.au3"

Global Const $tests = [testMostBasic, testRequest_GET, testRequest_POST, testRequest_PUT, testRequest_PATCH, testRequest_DELETE, testRequest_OPTIONS, testRequest_HEAD, testCB_EmptyStringResponse, testCB_CB_EmptyArrayResponse, testCB_EmptyObjectResponse, testCB_ArrayOfObjectsResponse, testCB_ObjectOfArrayResponse, testCB_ObjectOfTypesResponse]

Runner($tests)

Func testMostBasic()
	Local Const $pid = RunIsolatedInstanceOf("Most basic.au3")
	Local Const $oHTTP = SyncRequest("GET", "")
	ProcessClose($pid)
	Return $oHTTP.Status = 200
EndFunc   ;==>testMostBasic

Func testRequest_GET()
	Local Const $pid = RunIsolatedInstanceOf("Basic response types.au3")
	Local Const $oHTTP = SyncRequest("GET", "/test")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 And $oHTTP.ResponseText == 'OK'
EndFunc   ;==>testRequest_GET

Func testRequest_POST()
	Local Const $pid = RunIsolatedInstanceOf("Basic response types.au3")
	Local Const $oHTTP = SyncRequest("POST", "/test")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 And $oHTTP.ResponseText == 'OK'
EndFunc   ;==>testRequest_POST

Func testRequest_PUT()
	Local Const $pid = RunIsolatedInstanceOf("Basic response types.au3")
	Local Const $oHTTP = SyncRequest("PUT", "/test")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 And $oHTTP.ResponseText == 'OK'
EndFunc   ;==>testRequest_PUT

Func testRequest_PATCH()
	Local Const $pid = RunIsolatedInstanceOf("Basic response types.au3")
	Local Const $oHTTP = SyncRequest("PATCH", "/test")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 And $oHTTP.ResponseText == 'OK'
EndFunc   ;==>testRequest_PATCH

Func testRequest_DELETE()
	Local Const $pid = RunIsolatedInstanceOf("Basic response types.au3")
	Local Const $oHTTP = SyncRequest("DELETE", "/test")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 And $oHTTP.ResponseText == 'OK'
EndFunc   ;==>testRequest_DELETE

Func testRequest_OPTIONS()
	Local Const $pid = RunIsolatedInstanceOf("Basic response types.au3")
	Local Const $oHTTP = SyncRequest("OPTIONS", "/test")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 And $oHTTP.ResponseText == 'OK'
EndFunc   ;==>testRequest_OPTIONS

Func testRequest_HEAD()
	Local Const $pid = RunIsolatedInstanceOf("Basic response types.au3")
	Local Const $oHTTP = SyncRequest("HEAD", "/test")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 And $oHTTP.ResponseText == 'OK'
EndFunc   ;==>testRequest_HEAD

Func testCB_EmptyStringResponse()
	Local Const $pid = RunIsolatedInstanceOf("TestApp.au3")
	Local Const $oHTTP = SyncRequest("GET", "/empty-string-response")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 And $oHTTP.ResponseText == ''
EndFunc   ;==>testCB_EmptyStringResponse

Func testCB_CB_EmptyArrayResponse()
	Local Const $pid = RunIsolatedInstanceOf("TestApp.au3")
	Local Const $oHTTP = SyncRequest("GET", "/empty-array-response")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 And $oHTTP.ResponseText == '[]'
EndFunc   ;==>testCB_CB_EmptyArrayResponse

Func testCB_EmptyObjectResponse()
	Local Const $pid = RunIsolatedInstanceOf("TestApp.au3")
	Local Const $oHTTP = SyncRequest("GET", "/empty-object-response")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 And $oHTTP.ResponseText == '{}'
EndFunc   ;==>testCB_EmptyObjectResponse

Func testCB_ArrayOfObjectsResponse()
	Local Const $pid = RunIsolatedInstanceOf("TestApp.au3")
	Local Const $oHTTP = SyncRequest("GET", "/array-of-objects-response")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 And $oHTTP.ResponseText == '[{"name": "test","number": 1337},{"name": "test","number": 22}]'
EndFunc   ;==>testCB_ArrayOfObjectsResponse

Func testCB_ObjectOfArrayResponse()
	Local Const $pid = RunIsolatedInstanceOf("TestApp.au3")
	Local Const $oHTTP = SyncRequest("GET", "/object-of-arrays-response")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 And $oHTTP.ResponseText == '{"arr": [1,2,3,4,5],"arr2": [{}]}'
EndFunc   ;==>testCB_ObjectOfArrayResponse

Func testCB_ObjectOfTypesResponse()
	Local Const $pid = RunIsolatedInstanceOf("TestApp.au3")
	Local Const $oHTTP = SyncRequest("GET", "/object-of-types-response")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 And $oHTTP.ResponseText == '{"string": "","ip": "192.168.1.0","number_a": 1337,"number_b": 13.37,"number_c": "13.37","object": {},"array": [],"null": null,"bool_a": true,"bool_b": false}'
EndFunc   ;==>testCB_ObjectOfTypesResponse

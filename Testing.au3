#include "Testing\TestSuite.au3"

Global Const $tests = [testMostBasic, testRequest_GET, testRequest_POST, testRequest_PUT, testRequest_PATCH, testRequest_DELETE, testRequest_OPTIONS, testRequest_HEAD, testRequest_GetQueryParams]

Runner($tests)

Func testMostBasic()
	Local Const $pid = RunIsolatedInstanceOf("Most basic.au3")
	Local Const $oHTTP = SyncRequest("GET", "")
	ProcessClose($pid)
	Return $oHTTP.Status = 200
EndFunc   ;==>Test_1

Func testRequest_GET()
	Local Const $pid = RunIsolatedInstanceOf("Basic response types.au3")
	Local Const $oHTTP = SyncRequest("GET", "/test")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 AND $oHTTP.ResponseText == 'OK'
EndFunc   ;==>Test_1

Func testRequest_POST()
	Local Const $pid = RunIsolatedInstanceOf("Basic response types.au3")
	Local Const $oHTTP = SyncRequest("POST", "/test")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 AND $oHTTP.ResponseText == 'OK'
EndFunc   ;==>Test_1

Func testRequest_PUT()
	Local Const $pid = RunIsolatedInstanceOf("Basic response types.au3")
	Local Const $oHTTP = SyncRequest("PUT", "/test")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 AND $oHTTP.ResponseText == 'OK'
EndFunc   ;==>Test_1


Func testRequest_PATCH()
	Local Const $pid = RunIsolatedInstanceOf("Basic response types.au3")
	Local Const $oHTTP = SyncRequest("PATCH", "/test")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 AND $oHTTP.ResponseText == 'OK'
EndFunc   ;==>Test_1


Func testRequest_DELETE()
	Local Const $pid = RunIsolatedInstanceOf("Basic response types.au3")
	Local Const $oHTTP = SyncRequest("DELETE", "/test")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 AND $oHTTP.ResponseText == 'OK'
EndFunc   ;==>Test_1


Func testRequest_OPTIONS()
	Local Const $pid = RunIsolatedInstanceOf("Basic response types.au3")
	Local Const $oHTTP = SyncRequest("OPTIONS", "/test")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 AND $oHTTP.ResponseText == 'OK'
EndFunc   ;==>Test_1


Func testRequest_HEAD()
	Local Const $pid = RunIsolatedInstanceOf("Basic response types.au3")
	Local Const $oHTTP = SyncRequest("HEAD", "/test")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 AND $oHTTP.ResponseText == 'OK'
EndFunc   ;==>Test_1


Func testRequest_GetQueryParams()
	Local Const $pid = RunIsolatedInstanceOf("Request data.au3")
	Local Const $oHTTP = SyncRequest("HEAD", "/test?test=123")
	ProcessClose($pid)
	Return $oHTTP.Status = 200 AND $oHTTP.ResponseText == '{"test": 123}'
EndFunc   ;==>Test_1


; Request data.au3
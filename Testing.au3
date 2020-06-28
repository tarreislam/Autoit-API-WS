#include "Testing\TestSuite.au3"

Global Const $tests = [testMostBasic, testRequest_GET, testRequest_POST]

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


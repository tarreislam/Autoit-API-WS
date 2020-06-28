#include-once

; #FUNCTION# ====================================================================================================================
; Name ..........: Runner
; Description ...:
; Syntax ........: Runner()
; Parameters ....:
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Runner(Const ByRef $tests)
	Local Const $nMax = UBound($tests)
	Local $nSuccess = 0
	Local $nFailure = 0

	ConsoleWrite(@LF & @LF & "> # # # # Test start # # # # <" & @LF)
	For $i = 0 To $nMax - 1
		Local $curTest = $tests[$i]
		Local $funcName = FuncName($curTest)

		;cw('-', StringFormat('Running test "%s"', $funcName))
		If Not $curTest() Then
			cw('!', StringFormat('[%d/%d]: %s (Failure!)', $i + 1, $nMax, $funcName))
			$nFailure += 1
		Else
			cw('+', StringFormat('[%d/%d]: %s (Success!)', $i + 1, $nMax, $funcName))
			$nSuccess += 1
		EndIf
	Next

	Local $iPercent = Round($nSuccess / $nMax * 100, 2)

	ConsoleWrite(@LF & "> # # # # Test results # # # # <" & @LF)

	If $iPercent < 100 Then
		cw('!', StringFormat("%s%% of tests succeded", $iPercent))
	Else
		cw('+', StringFormat("%s%% of tests succeded", $iPercent))
	EndIf

	ConsoleWrite("> # # # # Test results # # # # <" & @LF & @LF)


EndFunc   ;==>Runner

; #FUNCTION# ====================================================================================================================
; Name ..........: RunIsolatedInstanceOf
; Description ...: Run a script in an isolated instance
; Syntax ........: RunIsolatedInstanceOf($path)
; Parameters ....: $path                - a pointer value.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func RunIsolatedInstanceOf($path)
	Return Run(StringFormat('"%s" "%s"', @AutoItExe, $path), @ScriptDir & "\Testing\Tests")
EndFunc   ;==>RunIsolatedInstanceOf

; #FUNCTION# ====================================================================================================================
; Name ..........: SyncRequest
; Description ...: Make a SYNc request
; Syntax ........: SyncRequest($method[, $uri = ""[, $payload = Null]])
; Parameters ....: $method              - a map.
;                  $uri                 - [optional] an unknown value. Default is "".
;                  $payload             - [optional] a pointer value. Default is Null.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func SyncRequest($method, $uri = "", $payload = Null)
	Local Const $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")
	$oHTTP.OPEN("GET", "http://localhost:4545" & $uri, False)
	$oHTTP.send()
	Return $oHTTP
EndFunc   ;==>SyncRequest

; #FUNCTION# ====================================================================================================================
; Name ..........: cw
; Description ...: consolewrite with some tabs and linefeeds
; Syntax ........: cw($color, $text)
; Parameters ....: $color               - an unknown value.
;                  $text                - a dll struct value.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func cw($color, $text)
	ConsoleWrite($color & @TAB & $text & @LF)
EndFunc   ;==>cw

#cs
	Copyright (c) 2020 TarreTarreTarre <tarre.islam@gmail.com>

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
#ce
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w 7
#include-once

#Region Respons statuses
Global Const $API_STATUS_OK = "200 OK"
Global Const $API_STATUS_CREATED = "201 CREATED"
Global Const $API_STATUS_NO_CONTENT = "204 NO CONTENT"
Global Const $API_STATUS_BAD_REQUEST = "400 BAD REQUEST"
Global Const $API_STATUS_UNAUTHORIZED = "401 UNAUTHORIZED"
Global Const $API_STATUS_FORBIDDEN = "403 FORBIDDEN"
Global Const $API_STATUS_NOT_FOUND = "404 NOT FOUND"
Global Const $API_STATUS_CONFLICT = "409 CONFLICT"
Global Const $API_STATUS_INTERNAL_SERVER_ERROR = "500 INTERNAL SERVER ERROR"
Global Const $API_STATUS_GATEWAY_TIMEOUT = "504 GATEWAY TIMEOUT"
#EndRegion Respons statuses

#Region Mimes (Content types)
Global Const $API_CONTENT_TYPE_TEXTJSON = "text/json"
Global Const $API_CONTENT_TYPE_TEXTHTML = "text/html"
#EndRegion Mimes (Content types)

#Region Internals
Global $g__API_MainSocket = Null
Global $g__API_Prefix = ''
Global $g__API_StatusTextToUse = $API_STATUS_OK
Global $g__API_CONTENT_TYPEToUse = $API_STATUS_OK
Global $g__API_RegistredRoutes[1] = [0]
Global $g__API_ApiName = "Untitled API"
Global $g__API_ApiVer = "1.0.0"
Global $g__API_ApiDescription = ""
Global Const $g__API_sUDFVer = "1.0.0-beta"
Global Const $g__API_DocTemplate = '<!doctype html><html lang="en"><head><meta charset="utf-8"><title>{title} (V {ver})</title><link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"></head><body><div class="container"><div class="row mt-2"><div class="col"><div class="jumbotron"><h1 class="display-4">{title}</h1><p class="lead">V {ver}</p><hr class="my-4"><p>{description}</p><p>All requests must be <code>x-www-form-urlencoded</code></p><div class="mt-2"><div class="list-group">{listGroupItems}</div></div></div></div></div></div></body></html>'
#EndRegion Internals

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_GetUDFVer
; Description ...: Get the semantic version of the UDF
; Syntax ........: _API_GetUDFVer()
; Parameters ....: None
; Return values .: SEMVER string (X.Y.Z-)
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......: See more on semver @ http://semver.org/
; Related .......:
; Link ..........: http://semver.org/
; Example .......: No
; ===============================================================================================================================
Func _API_GetUDFVer()
	Return $g__API_sUDFVer
EndFunc   ;==>_API_GetUDFVer

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_MGR_SetName
; Description ...: Set the name of your API (Not parsed, just for docs)
; Syntax ........: _API_MGR_SetName($sName)
; Parameters ....: $sName               - a string value.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......:
; Related .......: _API_MGR_SetVer, _API_MGR_SetDescription
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_MGR_SetName($sName)
	$g__API_ApiName = $sName
EndFunc   ;==>_API_MGR_SetName

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_MGR_SetVer
; Description ...: Set the version of your API (Not parsed, just for docs)
; Syntax ........: _API_MGR_SetVer($sVer)
; Parameters ....: $sVer                - a string value.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......:
; Related .......: _API_MGR_SetName, _API_MGR_SetDescription
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_MGR_SetVer($sVer)
	$g__API_ApiVer = $sVer
EndFunc   ;==>_API_MGR_SetVer

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_MGR_SetDescription
; Description ...: Set the description of your API (Not parsed, just for docs)
; Syntax ........: _API_MGR_SetDescription($sDesc)
; Parameters ....: $sDesc               - a string value.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......:
; Related .......: _API_MGR_SetVer, _API_MGR_SetName
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_MGR_SetDescription($sDesc)
	$g__API_ApiDescription = $sDesc
EndFunc   ;==>_API_MGR_SetDescription

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_MGR_Init
; Description ...: Initializes the API and starts listening on the given port. Default is 8080
; Syntax ........: _API_MGR_Init([$port = 3333[, $ipAdress = "127.0.0.1"]])
; Parameters ....: $port                - [optional] a pointer value. Default is 8080
;                  $ipAdress            - [optional] an integer value. Default is "127.0.0.1".
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......:
; Related .......: _API_MGR_ROUTER_HANDLE
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_MGR_Init($port = 8080, $ipAdress = "127.0.0.1")

	; Start TCP udf
	TCPStartup()

	; Create main socket
	Local $mainSocket = TCPListen($ipAdress, $port)

	If @error Then
		Return SetError(1, 0, Null)
		Exit
	EndIf

	; Set default socket (Only once)
	If Not $g__API_MainSocket Then
		$g__API_MainSocket = $mainSocket
	EndIf

	; Register default routes
	_API_MGR_ROUTER_GET("/", __API_ListRegistredRoutes, "", "Documentation (This page)", $mainSocket)

	Return $mainSocket

EndFunc   ;==>_API_MGR_Init

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_MGR_ROUTER_Prefix
; Description ...: Sets a given prefix to the following router registrations.
; Syntax ........: _API_MGR_ROUTER_Prefix($sPrefix)
; Parameters ....: $sPrefix             - a string value.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......:
; Related .......: _API_MGR_ROUTER_EndPrefix, _API_MGR_ROUTER_HANDLE, _API_MGR_ROUTER_Register, _API_MGR_ROUTER_GET, _API_MGR_ROUTER_POST, _API_MGR_ROUTER_PUT, _API_MGR_ROUTER_PATCH, _API_MGR_ROUTER_DELETE
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_MGR_ROUTER_Prefix($sPrefix)
	$g__API_Prefix = $sPrefix
EndFunc   ;==>_API_MGR_ROUTER_Prefix

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_MGR_ROUTER_EndPrefix
; Description ...: Removes the prefix for the following router registrations
; Syntax ........: _API_MGR_ROUTER_EndPrefix([$sDummy = ""])
; Parameters ....: $sDummy              - [optional] a string value. Default is "".
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......: $sDummy can be used to give a visual representation, it will not be parsed
; Related .......: _API_MGR_ROUTER_Prefix
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_MGR_ROUTER_EndPrefix($sDummy = "")
	#forceref $sDummy
	_API_MGR_ROUTER_Prefix("")
EndFunc   ;==>_API_MGR_ROUTER_EndPrefix

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_MGR_ROUTER_Register
; Description ...: Register a HTTP route with a callback.
; Syntax ........: _API_MGR_ROUTER_Register($method, $route, $callBack[, $requiredParams = ""[, $description = "No description"[,
;                  $mainSocket = $g__API_MainSocket]]])
; Parameters ....: $method              - a map.
;                  $route               - an unknown value.
;                  $callBack            - an unknown value.
;                  $requiredParams      - [optional] an unknown value. Default is "".
;                  $description         - [optional] a binary variant value. Default is "No description".
;                  $mainSocket          - [optional] a map. Default is $g__API_MainSocket.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......: The $callback param CAN have 2, 1 or 0 (ZERO) params. Func MyCallback(Const $oRequest, Const, $oHeaders),  Func MyCallback(Const $oRequest),  Func MyCallback(). The $requiredParams has the following format "type Name<*required>" and is separated by pipelines, for example. "string name*" = "String $name (Required)", if <*> is not used, the result will be "String $name (Optional)"
; Related .......: _API_MGR_ROUTER_Prefix, _API_MGR_ROUTER_HANDLE, _API_MGR_ROUTER_GET, _API_MGR_ROUTER_POST, _API_MGR_ROUTER_PUT, _API_MGR_ROUTER_PATCH, _API_MGR_ROUTER_DELETE
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_MGR_ROUTER_Register($method, $route, $callBack, $requiredParams = "", $description = "No description", Const $mainSocket = $g__API_MainSocket)
	$route = $g__API_Prefix & $route

	; Prepend slash if needed
	If StringLeft($route, 1) <> "/" Then
		$route = "/" & $route
	EndIf

	If Not StringRegExp($route, '^[a-z0-9_\/-\{\}]+') Then
		If Not @Compiled Then ConsoleWriteError(StringFormat('Failed to register: "%s" => "%s" (Regex mismatch)', $method, $route) & @LF)
		Return SetError(1, 0, Null)
	EndIf

	Local Const $fqrn = StringFormat("%s %s", $method, $route)
	Local Const $pairs[5] = [$fqrn, $callBack, StringSplit($requiredParams, "|"), $description, $mainSocket]

	; Add to stack
	ReDim $g__API_RegistredRoutes[$g__API_RegistredRoutes[0] + 2]
	$g__API_RegistredRoutes[$g__API_RegistredRoutes[0] + 1] = $pairs
	$g__API_RegistredRoutes[0] += 1

	; For debug only
	If Not @Compiled Then ConsoleWrite(StringFormat('Route registred: "%s" => "%s"', $fqrn, FuncName($callBack)) & @LF)
EndFunc   ;==>_API_MGR_ROUTER_Register

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_MGR_ROUTER_ANY
; Description ...: Shorthand for _API_MGR_ROUTER_Register
; Syntax ........: _API_MGR_ROUTER_ANY($route, $callBack[, $requiredParams = ""[, $description = "No description"[,
;                  $mainSocket = $g__API_MainSocket]]])
; Parameters ....: $route               - an unknown value.
;                  $callBack            - an unknown value.
;                  $requiredParams      - [optional] an unknown value. Default is "".
;                  $description         - [optional] a binary variant value. Default is "No description".
;                  $mainSocket          - [optional] a map. Default is $g__API_MainSocket.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......: This will register the most common route methods. Read more at _API_MGR_ROUTER_Register
; Related .......: _API_MGR_ROUTER_Register
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_MGR_ROUTER_ANY($route, $callBack, $requiredParams = "", $description = "No description", Const $mainSocket = $g__API_MainSocket)
	Local Const $CommonPaths = ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS', 'HEAD']
	For $i = 0 To UBound($CommonPaths) -1
		Local $method = $CommonPaths[$i]
		_API_MGR_ROUTER_Register($method, $route, $callBack, $requiredParams, $description, $mainSocket)
	Next
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_MGR_ROUTER_GET
; Description ...: Shorthand for _API_MGR_ROUTER_Register
; Syntax ........: _API_MGR_ROUTER_GET($route, $callBack[, $requiredParams = ""[, $description = "No description"[,
;                  $mainSocket = $g__API_MainSocket]]])
; Parameters ....: $route               - an unknown value.
;                  $callBack            - an unknown value.
;                  $requiredParams      - [optional] an unknown value. Default is "".
;                  $description         - [optional] a binary variant value. Default is "No description".
;                  $mainSocket          - [optional] a map. Default is $g__API_MainSocket.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......: Read more at _API_MGR_ROUTER_Register
; Related .......: _API_MGR_ROUTER_Register
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_MGR_ROUTER_GET($route, $callBack, $requiredParams = "", $description = "No description", Const $mainSocket = $g__API_MainSocket)
	Return _API_MGR_ROUTER_Register("GET", $route, $callBack, $requiredParams, $description, $mainSocket)
EndFunc   ;==>_API_MGR_ROUTER_GET

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_MGR_ROUTER_POST
; Description ...: Shorthand for _API_MGR_ROUTER_Register
; Syntax ........: _API_MGR_ROUTER_POST($route, $callBack[, $requiredParams = ""[, $description = "No description"[,
;                  $mainSocket = $g__API_MainSocket]]])
; Parameters ....: $route               - an unknown value.
;                  $callBack            - an unknown value.
;                  $requiredParams      - [optional] an unknown value. Default is "".
;                  $description         - [optional] a binary variant value. Default is "No description".
;                  $mainSocket          - [optional] a map. Default is $g__API_MainSocket.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......: Read more at _API_MGR_ROUTER_Register
; Related .......: _API_MGR_ROUTER_Register
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_MGR_ROUTER_POST($route, $callBack, $requiredParams = "", $description = "No description", Const $mainSocket = $g__API_MainSocket)
	Return _API_MGR_ROUTER_Register("POST", $route, $callBack, $requiredParams, $description, $mainSocket)
EndFunc   ;==>_API_MGR_ROUTER_POST

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_MGR_ROUTER_PUT
; Description ...: Shorthand for _API_MGR_ROUTER_Register
; Syntax ........: _API_MGR_ROUTER_PUT($route, $callBack[, $requiredParams = ""[, $description = "No description"[,
;                  $mainSocket = $g__API_MainSocket]]])
; Parameters ....: $route               - an unknown value.
;                  $callBack            - an unknown value.
;                  $requiredParams      - [optional] an unknown value. Default is "".
;                  $description         - [optional] a binary variant value. Default is "No description".
;                  $mainSocket          - [optional] a map. Default is $g__API_MainSocket.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......: Read more at _API_MGR_ROUTER_Register
; Related .......: _API_MGR_ROUTER_Register
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_MGR_ROUTER_PUT($route, $callBack, $requiredParams = "", $description = "No description", Const $mainSocket = $g__API_MainSocket)
	Return _API_MGR_ROUTER_Register("PUT", $route, $callBack, $requiredParams, $description, $mainSocket)
EndFunc   ;==>_API_MGR_ROUTER_PUT

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_MGR_ROUTER_PATCH
; Description ...: Shorthand for _API_MGR_ROUTER_Register
; Syntax ........: _API_MGR_ROUTER_PATCH($route, $callBack[, $requiredParams = ""[, $description = "No description"[,
;                  $mainSocket = $g__API_MainSocket]]])
; Parameters ....: $route               - an unknown value.
;                  $callBack            - an unknown value.
;                  $requiredParams      - [optional] an unknown value. Default is "".
;                  $description         - [optional] a binary variant value. Default is "No description".
;                  $mainSocket          - [optional] a map. Default is $g__API_MainSocket.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......: Read more at _API_MGR_ROUTER_Register
; Related .......: _API_MGR_ROUTER_Register
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_MGR_ROUTER_PATCH($route, $callBack, $requiredParams = "", $description = "No description", Const $mainSocket = $g__API_MainSocket)
	Return _API_MGR_ROUTER_Register("PATCH", $route, $callBack, $requiredParams, $description, $mainSocket)
EndFunc   ;==>_API_MGR_ROUTER_PATCH

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_MGR_ROUTER_DELETE
; Description ...: Shorthand for _API_MGR_ROUTER_Register
; Syntax ........: _API_MGR_ROUTER_DELETE($route, $callBack[, $requiredParams = ""[, $description = "No description"[,
;                  $mainSocket = $g__API_MainSocket]]])
; Parameters ....: $route               - an unknown value.
;                  $callBack            - an unknown value.
;                  $requiredParams      - [optional] an unknown value. Default is "".
;                  $description         - [optional] a binary variant value. Default is "No description".
;                  $mainSocket          - [optional] a map. Default is $g__API_MainSocket.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......: Read more at _API_MGR_ROUTER_Register
; Related .......: _API_MGR_ROUTER_Register
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_MGR_ROUTER_DELETE($route, $callBack, $requiredParams = "", $description = "No description", Const $mainSocket = $g__API_MainSocket)
	Return _API_MGR_ROUTER_Register("DELETE", $route, $callBack, $requiredParams, $description, $mainSocket)
EndFunc   ;==>_API_MGR_ROUTER_DELETE

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_MGR_ROUTER_HANDLE
; Description ...: This function handles all incoming requests. This Should be used in your applications mainloop
; Syntax ........: _API_MGR_ROUTER_HANDLE([$mainSocket = $g__API_MainSocket])
; Parameters ....: $mainSocket          - [optional] a map. Default is $g__API_MainSocket.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......: This should be called at least every 100 ms
; Related .......: _API_MGR_INIT
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_MGR_ROUTER_HANDLE(Const $mainSocket = $g__API_MainSocket)

	; Wait for connection
	;ConsoleWrite("Waiting for incomming connection" & @LF)
	Do
		Local $connectedSocket = TCPAccept($mainSocket)
	Until $connectedSocket <> -1

	If $connectedSocket < 0 Then Return ; // invalid

	; Fetch request
	Local $response

	;ConsoleWrite("Connection established. Waiting for request data" & @LF)
	Do
		Local $curResp = TCPRecv($connectedSocket, 1024)
		$response &= $curResp
	Until @error Or StringLen($response) > 0 Or $curResp == ""

	$response = $curResp
	; ConsoleWrite( $response & @LF)

	Local $responseContent = Null
	Local $routeFound = False
	Local $callbackFound = True


	For $i = 1 To $g__API_RegistredRoutes[0]
		Local $registredRoute = $g__API_RegistredRoutes[$i]

		; Match TCP socket
		If $registredRoute[4] <> $mainSocket Then
			ContinueLoop
		EndIf

		Local $routeName = $registredRoute[0] ; GET /path/to/stuff
		Local $routeNameAsRe = "^" & StringRegExpReplace($routeName, "(?i)(\{[a-z_]+[a-z_0-9]*\})", "([^/]+)") & "\/*$"; the route name but as an regex
		Local $callBack = $registredRoute[1]; Can be String or FuncName

		; Get the requested path with option éx "GET /path/to/stuff/1" without query params ?etc
		Local $requestedRouteName = StringRegExp($response, '^((?:GET|POST|PUT|DELETE|PATCH|OPTIONS|HEAD) [^? ]+)[? ]', 1)
		If Not @error Then
			; URI decode the url
			$requestedRouteName = __API_URIDecode($requestedRouteName[0])
			; convert to pattern
		EndIf

		; Preflight requests will cause $requestedRouteName to return 0, so for the time beign, we just throw these requests away.
		If $requestedRouteName == 0 Then ContinueLoop

		; If we matched the route

		Local $aRouteParams = StringRegExp($requestedRouteName, $routeNameAsRe, 2); Will always match if the route exists
		If Not @error Then
			Local $key, $value

			; ###################
			; #  Build oReuqest
			; ###
			Local $oRequest = ObjCreate("Scripting.Dictionary")

			; Attempt to get route params (prepended with _route_)
			If UBound($aRouteParams) > 1 Then
				Local $aHeaderReNames = StringRegExp($routeName, "(?i)\{([a-z_]+[a-z_0-9]*)\}", 3)

				For $j = 0 To UBound($aHeaderReNames) -1
					$key = $aHeaderReNames[$j]
					$value = $aRouteParams[$j +1]
					$oRequest.add('#' & $key,  $value)

				Next
			EndIf

			; First we look at the query string to get our initial data
			__API_ParseQueryByRE($oRequest, $response, "\?([^ ]*) HTTP")

			; Then we replace / fill the rest with x-www-form-urlencoded keys
			__API_ParseQueryByRE($oRequest, $response, "\n{2}([^\n]+)", True)

			; ###################
			; #  Build oHeaders
			; ###

			Local $oHeaders = ObjCreate("Scripting.Dictionary")

			; fetch Key:value
			Local $aHeadersRe = StringRegExp($response, "(?mi)^([a-z0-9_-]+): ([^\n]+)", 3)

			;ConsoleWrite($response)

			If Not @error Then
				For $j = 0 To UBound($aHeadersRe) - 1 Step +2
					$key = $aHeadersRe[$j]
					$value = $aHeadersRe[$j + 1]

					$oHeaders.add($key,StringTrimRight($value, 1))
				Next
			EndIf

			;Invoke user defined callback, try three combinations
			$responseContent = Call($callBack, $oRequest, $oHeaders)
			If @error == 0xDEAD And @extended = 0xBEEF Then
				$responseContent = Call($callBack, $oRequest)
				If @error == 0xDEAD And @extended = 0xBEEF Then
					$responseContent = Call($callBack)
					; Flag that no method exists
					$callbackFound = False
				EndIf
			EndIf

			; Flag that we found the route
			$routeFound = True

			; stop looking
			ExitLoop
		EndIf
	Next
	;ConsoleWrite("Handling completed. Closing connection" & @LF)

	If Not $routeFound Then
		$responseContent = _API_RES_NotFound(StringFormat("The route '%s' was not found.", $requestedRouteName))
	ElseIf Not $callbackFound Then
		$responseContent = _API_RES_InternalServerError(StringFormat("The callback '%s' was not found.", $callBack))
	EndIf

	; Create request
	Local Const $httpResponse = __API_RES($responseContent, $g__API_StatusTextToUse, $g__API_CONTENT_TYPEToUse)

	; Reset status
	_API_RES_SET_STATUS($API_STATUS_OK)
	_API_RES_SET_CONTENT_TYPE($API_CONTENT_TYPE_TEXTJSON)

	TCPSend($connectedSocket, $httpResponse)
	TCPCloseSocket($connectedSocket)

	Return True

EndFunc   ;==>_API_MGR_ROUTER_HANDLE

#Region Response functions

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_RES_SET_STATUS
; Description ...: Set the response status code and text for your response. The default value after each request is $API_STATUS_OK
; Syntax ........: _API_RES_SET_STATUS($statusCodeText)
; Parameters ....: $statusCodeText      - a string value.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......: The most common statuses are defined as constants, see more at #Region Respons statuses
; Related .......: _API_RES_SET_CONTENT_TYPE
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_RES_SET_STATUS($statusCodeText)
	$g__API_StatusTextToUse = $statusCodeText
EndFunc   ;==>_API_RES_SET_STATUS

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_RES_SET_CONTENT_TYPE
; Description ...: Set the content type of your request. The default value after each request is $API_CONTENT_TYPE_TEXTJSON
; Syntax ........: _API_RES_SET_CONTENT_TYPE($mime)
; Parameters ....: $mime                - a map.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......: The most common statuses are defined as constants, see more at #Region Mimes (Content types)
; Related .......: _API_RES_SET_STATUS
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_RES_SET_CONTENT_TYPE($mime)
	$g__API_CONTENT_TYPEToUse = $mime
EndFunc   ;==>_API_RES_SET_CONTENT_TYPE

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_RES_BadRequest
; Description ...: Shorthend function for a "bad request" response
; Syntax ........: _API_RES_BadRequest([$message = "Bad request"[, $ResponseStatus = $API_STATUS_BAD_REQUEST]])
; Parameters ....: $message             - [optional] a map. Default is "Bad request".
;                  $ResponseStatus      - [optional] an unknown value. Default is $API_STATUS_BAD_REQUEST.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......: The json will always return with this structure: {"description": "Custom message descrpition"} with the given status code
; Related .......: _API_RES_NotFound, _API_RES_InternalServerError
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_RES_BadRequest($message = "Bad request", $ResponseStatus = $API_STATUS_BAD_REQUEST)

	Local Const $oRes = ObjCreate("Scripting.Dictionary")
	$oRes.add('description', $message)
	_API_RES_SET_STATUS($ResponseStatus)
	Return $oRes
EndFunc   ;==>_API_RES_BadRequest

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_RES_NotFound
; Description ...: Shorthend for "API_RES_BadRequest" that only takes 1 params instead of two
; Syntax ........: _API_RES_NotFound([$message = "Not found"])
; Parameters ....: $message             - [optional] a map. Default is "Not found".
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......:
; Related .......: _API_RES_BadRequest, _API_RES_InternalServerError
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_RES_NotFound($message = "Not found")
	Return _API_RES_BadRequest($message, $API_STATUS_NOT_FOUND)
EndFunc   ;==>_API_RES_NotFound

; #FUNCTION# ====================================================================================================================
; Name ..........: _API_RES_InternalServerError
; Description ...: Shorthend for "API_RES_BadRequest" that only takes 1 params instead of two
; Syntax ........: _API_RES_InternalServerError([$message = "Something went wrong in the server"])
; Parameters ....: $message             - [optional] a map. Default is "Something went wrong in the server".
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......:
; Related .......: _API_RES_BadRequest, _API_RES_NotFound
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _API_RES_InternalServerError($message = "Something went wrong in the server")
	Return _API_RES_BadRequest($message, $API_STATUS_INTERNAL_SERVER_ERROR)
EndFunc   ;==>_API_RES_InternalServerError

#EndRegion Response functions

#Region Internals
Func __API_RES($content, $statusCodeText, $ContentType)

	; Cast objects and arrays to json
	If IsObj($content) Or IsArray($content) Then
		$content = __API_RES_toJson($content)
	EndIf

	; Return response data
	Return "HTTP/1.1 " & $statusCodeText & @LF & _
			"Access-Control-Allow-Origin: *" & @LF & _
			"Server: " & $g__API_ApiName & " V " & $g__API_ApiVer & " (AutoIt V" & @AutoItVersion & ")" & @LF & _
			"Content-Length: " & StringLen($content) & @LF & _
			"Content-Type: " & $ContentType & "; charset=utf-8" & @LF & @LF & _
			$content & @LF
EndFunc   ;==>__API_RES

Func __API_RES_toJson(Const $content)
	Local $sRet = '', $key, $value

	; Handle scripting dictionaries
	If IsObj($content) Then

		Local Const $aKeys = $content.keys()
		$sRet = "{"

		For $i = 0 To UBound($aKeys) - 1
			$key = $aKeys[$i]
			$value = $content.item($key)
			Local $passValueAsRawCusArray = False

			If IsArray($value) Or IsObj($value) Then
				$value = __API_RES_toJson($value)
				$passValueAsRawCusArray = True
			EndIf

			$sRet &= __API_RES_toJson_CreatePair($key, $value, $passValueAsRawCusArray) & ","

		Next

		$sRet = StringRight($sRet, 1) == ',' ? StringTrimRight($sRet, 1) & "}" : $sRet & "}"

	ElseIf IsArray($content) Then
		$sRet = '['

		For $key = 0 To UBound($content) - 1
			$value = $content[$key]

			; see if we should nest
			If IsArray($value) Or IsObj($value) Then
				$value = __API_RES_toJson($value)
			Else
				$value = __API_RES_toJson_parseValue($value)
			EndIf

			$sRet &= $value & ","

		Next

		$sRet = StringRight($sRet, 1) == ',' ? StringTrimRight($sRet, 1) & "]" : $sRet & "]"

	EndIf

	Return $sRet

EndFunc   ;==>__API_RES_toJson

Func __API_RES_toJson_CreatePair($key, $value, $passValueAsRawCusArray = False)
	Return StringFormat('"%s": %s', $key, __API_RES_toJson_parseValue($value, $passValueAsRawCusArray))
EndFunc   ;==>__API_RES_toJson_CreatePair

Func __API_RES_toJson_parseValue($value, $bRaw = False)

	; Return specials "as is"
	If $value == Null Then
		Return 'null'
	EndIf

	; bools
	If IsBool($value) Then
		Return $value ? 'true' : 'false'
	EndIf

	; binaries
	If IsBinary($value) Then
		Return String($value)
	EndIf

	; Escape stringerals
	If IsString($value) And Not $bRaw Then
		; Escape unicode
		$value = __API_URIEscapeUnicode($value)
		; Escape slashes (This will ignore the unicode esapce)
		$value = StringRegExpReplace($value, "[\\](?!u\d{1})", "\\\\")
		; Escape quotes
		$value = '"' & StringReplace($value, '"', '\"') & '"'
	EndIf

	; consider empty strings as nulls
	If StringLen($value) == 0 Then
		$value = '""'
	EndIf


	Return $value
EndFunc   ;==>__API_RES_toJson_parseValue

Func __API_ListRegistredRoutes()
	Local $response

	Local Const $template = $g__API_DocTemplate

	Local Const $routes = $g__API_RegistredRoutes

	Local $listGroupItems = ""

	For $i = 1 To $routes[0]
		Local $registredRoute = $routes[$i]
		Local $uri = $registredRoute[0]
		;Local $callBack = $registredRoute[1]
		Local $aRequiredParams = $registredRoute[2]
		Local $description = $registredRoute[3]

		Local $sParams = ""

		If $aRequiredParams[0] > 0 And $aRequiredParams[1] <> '' Then
			For $j = 1 To $aRequiredParams[0]
				Local $param = $aRequiredParams[$j]
				Local $paramRequired = StringRight($param, 1) == "*"
				Local $displayName

				If $paramRequired Then
					$displayName = StringTrimRight($param, 1) & " (Required)"
				Else
					$displayName = $param & " (Optional)"
				EndIf
				$sParams &= StringFormat('<code class="d-block">%s</code>', $displayName)
			Next
		EndIf

		Local $listGroupItem = '<div class="list-group-item">' & @LF & _
				'<div class="d-flex">' & @LF & _
				'  <h5 class="mb-1">' & $uri & ' </h5>' & @LF & _
				'</div>' & @LF & _
				'<p class="mb-2 mt-2">' & @LF & _
				$description & @LF & _
				'</p>' & @LF & _
				'<small class="text-muted">' & @LF & _
				'	<strong class="d-block">Params</strong>' & @LF & _
				$sParams & @LF & _
				'</small>' & @LF & _
				'</div>'

		$listGroupItems &= $listGroupItem
	Next

	; Use template
	$response = StringReplace($template, "{listGroupItems}", $listGroupItems)
	$response = StringReplace($response, "{title}", $g__API_ApiName)
	$response = StringReplace($response, "{description}", $g__API_ApiDescription)
	$response = StringReplace($response, "{ver}", $g__API_ApiVer)

	; Set mime and status
	_API_RES_SET_CONTENT_TYPE($API_CONTENT_TYPE_TEXTHTML)
	_API_RES_SET_STATUS($API_STATUS_OK)
	; Return response
	Return $response
EndFunc   ;==>__API_ListRegistredRoutes

Func __API_ParseQueryByRE(Const ByRef $oRequest, Const ByRef $response, Const $RE, Const $bReplace = False)
	Local $aQueryParamstr = StringRegExp($response, $RE, 1)

	If Not @error Then
		$aQueryParamstr = StringSplit(__API_URIDecode($aQueryParamstr[0]), "&")

		; add to request
		For $j = 1 To $aQueryParamstr[0]
			Local $pair = StringSplit($aQueryParamstr[$j], "=")
			If $pair[0] < 2 Then ContinueLoop; The queryString is broken and can be ignored
			Local $key = $pair[1]
			Local $value = $pair[2]

			If $bReplace And $oRequest.exists($key) Then $oRequest.remove($key)

			$oRequest.add($key, $value)
		Next
	EndIf
EndFunc   ;==>__API_ParseQueryByRE

Func __API_URIDecode($sData)
	; Prog@ndy
	Local $aData = StringSplit(StringReplace($sData, "+", " ", 0, 1), "%")
	$sData = ""
	For $i = 2 To $aData[0]
		$aData[1] &= Chr(Dec(StringLeft($aData[$i], 2))) & StringTrimLeft($aData[$i], 2)
	Next

	Return BinaryToString(StringToBinary($aData[1], 1), 4)
EndFunc   ;==>__API_URIDecode

Func __API_URIEscapeUnicode($sInput)
	; Malkey
	Local Const $sRet = Execute(StringRegExpReplace($sInput, '(.)', '(AscW("$1")>127?"\\u"&StringLower(Hex(AscW("$1"),4)):"$1")&') & "''")
	If Not $sRet Then Return $sInput
	Return $sRet
EndFunc   ;==>__API_URIEscapeUnicode

#EndRegion Internals

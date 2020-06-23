## About AutoIt-API-WS
**AutoIt-API-WS** is a light weight web server with expressive syntax, with the sole purpose of wrapping your existing AutoIt app with little to no effort.

With **AutoIt-API-WS** you can send and receive data between any application or framework, as long they can handle HTTP requests, which is an industry standard today.

Like my other communcations UDF [AutoIt-Socket-IO](https://www.autoitscript.com/forum/topic/188991-autoit-socket-io-networking-in-autoit-made-simple) **AutoIt-API-WS** is heavily inspired from the big boys, but this time its  [Laravel](https://laravel.com/) and [Ruby on Rails](https://rubyonrails.org/).

## ~~Features~~ Highlights
* No external or internal dependencies required
* RESTful mindset when designed
* Expressive syntax
* Small codebase
* Heavy use of Michelsofts [Dictionary object](https://docs.microsoft.com/en-us/office/vba/language/reference/user-interface-help/dictionary-object)

## Limitations
* Not complient with any RFC, so something important could be missing. Time will tell!
* One persons slow loris attack will kill the process forever.

## Example of implemetnation (With screenshots)
This is a basic cRud operation with the RESTful mindset in use.
```AutoIt
#include "API.au3"
#include <Array.au3>

_API_MGR_SetName("My APP DB adapter")
_API_MGR_SetVer("1.0 BETA")
_API_MGR_SetDescription("This adapter allows you to get this n that")

_API_MGR_Init(3000)
_API_MGR_ROUTER_GET('/users', CB_GetUsers, 'string sortBy', 'Get all users, sortBy can be either asc or desc. asc is default')
_API_MGR_ROUTER_GET('/users/{id}', CB_GetUsersById, 'int id*', 'Get user by id')

While _API_MGR_ROUTER_HANDLE()
WEnd

Func DB_GetUsers()
	Local $userA = ObjCreate("Scripting.Dictionary")
	Local $userB = ObjCreate("Scripting.Dictionary")

	$userA.add('id', 1)
	$userA.add('name', 'TarreTarreTarre')
	$userA.add('age', 27)

	$userB.add('id', 2)
	$userB.add('name', @UserName)
	$userB.add('age', 22)

	Local $aRet = [$userA, $userB]

	Return $aRet
EndFunc

Func CB_GetUsers(Const $oRequest)
	Local $aUsers = DB_GetUsers()

	If $oRequest.exists('sortBy') Then

		Switch $oRequest.item('sortBy')
			Case Default
			Case 'asc'

			Case 'desc'
				_ArrayReverse($aUsers)
		EndSwitch

	EndIf

	Return $aUsers

EndFunc

Func CB_GetUsersById(Const $oRequest)

	Local Const $aUsers = DB_GetUsers()
	Local $foundUser = Null

	For $i = 0 To UBound($aUsers) -1

		Local $curUser = $aUsers[$i]

		If $curUser.item('id') == $oRequest.item('#id') Then
			$foundUser = $curUser
			ExitLoop
		EndIf

	Next

	If Not IsObj($foundUser) Then
		Return _API_RES_NotFound(StringFormat("Could not find user with ID %d", $oRequest.item('#id')))
	EndIf

	return $foundUser

EndFunc
```

When you visit [http://localhost:3000](http://localhost:3000) you are greeted with this pleasent view that will show you all your registred routes and some extra info you have provided.

![Doc preview](https://i.imgur.com/UiNKTxy.png "Doc preview")

When you visit [http://localhost:3000/users](http://localhost:3000/users) the UDF will return the array of objects as Json

![User preview](https://i.imgur.com/msNIGMa.png "User preview")
And here is an example of [http://localhost:3000/users/1](http://localhost:3000/users/1)

![User specified](https://i.imgur.com/Q3C4J6N.png "User specified")

If you want more examples, look in the **examples/**
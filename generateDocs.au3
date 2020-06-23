#include <Array.au3>

Global Const $source = InputBox("Source AU3 file", "", "API.au3")
Global Const $targetHtml = InputBox("Source AU3 file", "", "Docs\index.html")


Global Const $content = FileRead($source)
Global Const $AutoItDoctemplate = '<!DOCTYPE html><html><head><title>Function %name%</title><meta charset=utf-8><link href=style.css rel=stylesheet></head><body><h1>%name%</h1><p class=funcdesc>%description%<br /></p><p class=codeheader>%calling%<br /></p><h2>Return Value</h2><table class=noborder><tr><td>%return%</td></table><h2>Remarks</h2><p>%remarks%</p><h2>Related</h2><p>%related%</p></body></html>'
Global Const $RefIndex = '<!doctype html><html lang=en><head><meta charset=utf-8><title>AutoIt-WS-API refdocs</title></head><body style=margin:0px;padding:0px><div style=display:block;float:left;width:20%><ul>%list%</ul></div><iframe name=iframe src=about:blank style=width:80%;border:0;float:right;display:block;height:100vh></iframe></body></html>'

Global $aFuncDefs = getFncs()
Global $aNames = getHeaderByName("Name")
Global $aDescriptions = getHeaderByName("Description")
Global $aRemarks = getHeaderByName("Remarks")
Global $aRelateds = getHeaderByName("Related")
Global $aReturns = getHeaderByName("Return values")


For $i = 0 To UBound($aNames) - 1
	Global $calling = $aFuncDefs[$i]
	Global $name = StringStripWS($aNames[$i], 7)
	Global $description = $aDescriptions[$i]
	Global $remark = $aRemarks[$i]
	Global $related = $aRelateds[$i]
	Global $returns = $aReturns[$i]

	buildDoc($name, $calling, $description, $remark, $related, $returns)
Next
buildIndex()


Func getHeaderByName($name)
	Return StringRegExp($content, "(?m)^;\h" & $name & "\h[.]{0,15}:\h*(.*)", 3)
EndFunc

Func getFncs()
	Return StringRegExp($content, '(?mi)^Func\h([_]{1}[a-z]+.*\)+)', 3)
EndFunc

Func buildIndex()
	_ArraySort($aNames)
	Local $sList = ""
	For $i = 1 To UBound($aNames) -1
		Local $name = $aNames[$i]
		$sList &= '<li><a href="refs\' & $name & '.html" target="iframe">' & $name & '</a></li>'
	Next

	Local $finalIndex = StringReplace($RefIndex, '%list%', $sList)
	Local $fh = FileOpen($targetHtml, 2)
	FileWrite($fh, $finalIndex)
	FileClose($fh)

EndFunc

Func buildDoc($name, $calling, $description, $remark, $related, $returns)
	Local $fHandle = FileOpen("Docs\refs\" & $name & ".html", 2)
	Local $template = $AutoItDoctemplate
	$template = StringReplace($template, '%name%', $name)
	$template = StringReplace($template, '%description%', $description)
	$template = StringReplace($template, '%remarks%', $remark)
	$template = StringReplace($template, '%calling%', $calling)
	$template = StringReplace($template, '%return%', $returns)
	$template = StringReplace($template, '%related%', getDocRelated($related))
	FileWrite($fHandle, $template)
	FileClose($fHandle)
EndFunc

Func getDocRelated($related)
	$related = StringStripWS($related, 8)
	Local $aRelated = StringSplit($related, ',')
	Local $sRelatedHrefs = ""

	For $i = 1 To $aRelated[0]
		$sRelatedHrefs &= StringFormat('<a href="%s.html">%s</a>, ', $aRelated[$i], $aRelated[$i])
	Next

	$sRelatedHrefs = StringTrimRight($sRelatedHrefs, 2)

	Return $sRelatedHrefs

EndFunc

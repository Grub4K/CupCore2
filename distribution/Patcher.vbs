Option Explicit
'On Error Resume Next

Dim strRegValue, strFolder, objFolder, strCupheadDir, strCupheadDataDir, arrPatches, CurrentPatch, blnUnpatched
Dim objWshShl : Set objWshShl = CreateObject("WScript.Shell")
Dim objShl : Set objShl = CreateObject("Shell.Application")
Dim objFso : Set objFso = CreateObject("Scripting.FileSystemObject")

strRegValue = objShell.RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 268910\InstallLocation")
If len(strRegValue) = 0 Then
    objFolder = objShl.BrowseForFolder(0,"Cuphead not found, please select location manually",0,17)
    
    If objFolder Is Nothing Then
        Wscript.Quit()
    Else
        strCupheadDir = objFolder.Self.Path
    End If
End If

intOKCancel = MsgBox("Click OK to patch Cuphead to: " & vbCrLf & vbCrLf & strTemp, vbOKCancel, "CupCore Patcher")

if intOKCancel = 2 Then
    WScript.Quit()
End If

strCupheadDataDir = strTemp & "\Cuphead_Data\"

' Patching array
arrPatches = Array(Array("Managed\", "Assembly-CSharp.dll"))

'
' Patching gets done here
'
for each file in arrPatches
    CurrentPatch = strCupheadDataDir & file(0) & file(1)
    
    If (objFso.FileExists(CurrentPatch & ".temp")) Then
        blnUnpatched = True
        objFso.DeleteFile CurrentPatch
        objFso.MoveFile CurrentPatch & ".temp", CurrentPatch
    Else
        objFso.MoveFile CurrentPatch, CurrentPatch & ".temp"
        objWshShl.Run "xdelta3 -d -s """ & CurrentPatch & ".temp"" " & file(1) & ".xdelta """ & CurrentPatch & """", 0, True
    	blnUnpatched = False
    End If
Next
' Done patching

if blnUnpatched = True Then
    MsgBox "Safely unpached", 32, "CupCore Patcher"
Else
    MsgBox "Files patched successfully", 32, "CupCore Patcher"
End If
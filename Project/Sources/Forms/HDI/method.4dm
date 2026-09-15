C_TEXT:C284($vers; $minVers)
C_BOOLEAN:C305($license)


Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		$minVers:="1600"
		$vers:=Application version:C493
		$license:=Is license available:C714(4D Write license:K44:2)
		
		If (($vers<$minVers) | ($license=False:C215))  //1630 means 16R3   1601 means 16.1
			
			// The demo cannot be run: wrong version or missing license
			<>Quit:=True:C214
			OBJECT SET TITLE:C194(*; "BtnDemo"; "Quit 4D")
			
			If ($vers<$minVers)
				OBJECT SET VISIBLE:C603(*; "TxtSorry@"; True:C214)
				OBJECT SET VISIBLE:C603(*; "TxtInfo@"; False:C215)
			End if 
			
			If ($license=False:C215)
				OBJECT SET VISIBLE:C603(*; "TxtLicense"; True:C214)
			End if 
			
			
		Else 
			<>Quit:=False:C215
			
		End if 
		
End case 

//%attributes = {}
C_OBJECT:C1216(vInfos; vDoc)
C_TEXT:C284($path)



$path:=Get 4D folder:C485(Current resources folder:K5:16)+"HDI_Infos.4wp"

// Load 4D Write Pro document populating the "info" tab
vInfos:=WP Import document:C1318($path)

// Load 4D Write Pro document to be used for "demo" tab
$path:=Get 4D folder:C485(Current resources folder:K5:16)+"Argentina.4wp"
vDoc:=WP Import document:C1318($path)



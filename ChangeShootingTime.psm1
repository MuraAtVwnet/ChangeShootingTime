#######################################################
# Jpeg の撮影時間を変更する
#######################################################
function ChangeShootingTime( $JpegFile, [double]$Offset ){

	if( $Offset -eq 0 ){
		return
	}

	# 拡張子チェック
	$FileName = Split-Path $JpegFile -Leaf
	if( (($FileName -split "\.")[1] -ne "jpg" ) -and (($FileName -split "\.")[1] -ne "jpeg" )){
		return
	}

	# フルパスにする
	$JpegFileFullName = Convert-Path $JpegFile -ErrorAction SilentlyContinue
	if( $JpegFileFullName -eq $null ){
		echo "$JpegFile not convert full path."
		return
	}

	# 存在確認
	if( -not ( Test-Path $JpegFileFullName )){
		echo "$JpegFile not found"
		return
	}

	# テンポラリファイル名
	$TempFile = $JpegFileFullName + ".tmp"

	# アセンブリロード
	Add-Type -AssemblyName System.Drawing

	# Jpeg 読み込み
	$bmp = New-Object System.Drawing.Bitmap($JpegFileFullName)

	# 撮影日時のタグ
	$DateTimeOriginalIndex = 0x9003

	# 撮影日時を取得
	Try{
		$DateTimeOriginal = $bmp.GetPropertyItem($DateTimeOriginalIndex)
	}
	Catch{
		$bmp.Dispose()
		return
	}

	# 撮影日時のデータ
	[array]$DateTimeOriginalBytes = $DateTimeOriginal.Value

	# 文字列へ
	$DateString = [System.Text.Encoding]::ASCII.GetString($DateTimeOriginalBytes)

	# 日付を YYYY/MM/DD 形式にし、時間計算する
	[array]$YYYYMMDDandHHMMSS = $DateString.Split(" ")
	[datetime]$OriginalDateTime = $YYYYMMDDandHHMMSS[0].Replace(":","/") + " " + $YYYYMMDDandHHMMSS[1]
	[datetime]$NewDateTime = $OriginalDateTime.AddHours($Offset)

	# Exif の日付形式にする
	$NewDateTimeString = $NewDateTime.ToString("yyyy:MM:dd HH:mm:ss")
	[array] $NewDateBytes = [System.Text.Encoding]::ASCII.GetBytes($NewDateTimeString)
	$NewDateBytes += 0x00

	# データセット
	$DateTimeOriginal.Value = $NewDateBytes
	$bmp.SetPropertyItem($DateTimeOriginal)

	# ファイル出力
	$bmp.Save($TempFile, [System.Drawing.Imaging.ImageFormat]::Jpeg )
	$bmp.Dispose()

	# オリジナルとテンポラリファイルを入れ替える
	$Org_Path = Split-Path -Path $JpegFileFullName
	$Org_FileName = Split-Path -Leaf $JpegFileFullName
	$New_FileName = $Org_FileName.Split(".")[0] + "-ORG." + $Org_FileName.Split(".")[1]
	ren $JpegFileFullName $New_FileName
	ren $TempFile $JpegFileFullName

	# 変更した日時の表示
	$OriginalDateTimeString = $OriginalDateTime.ToString("yyyy/MM/dd HH:mm:ss")
	$NewDateTimeString = $NewDateTime.ToString("yyyy/MM/dd HH:mm:ss")
	Write-Output "$OriginalDateTimeString -> $NewDateTimeString"
}

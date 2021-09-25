Jpeg 画像方向を撮影時間を変更する

■ これは何?
Jpeg 画像の撮影時間をオフセットで変更します
写真の撮影日時が UTC になっているのを JST に変更するとか、撮影時間を変更します

■ 使い方
PowerShell プロンプトで以下コマンド入力すると、Jpeg の撮影時間がオフセット時間分変更されます
オリジナルファイルは -ORG.jpg として残ります

ChangeShootingTime ファイルPath オフセット時間

(例)
ChangeShootingTime "C:\temp\20210919_224409029_iOS.jpg" -9

■ セットの仕方
PowerShell プロンプトで install.ps1 を実行してください

■ Uninstall 方法
uninstall.ps1 を実行して下さい

■ 動作確認環境
On Windows
	5.1
	7.1.4

■ Web サイト
Jpeg ファイルの GPS Exif を PowerShell で削除する
https://www.vwnet.jp/Windows/PowerShell/2016051501/RemoveGPSExif.htm

■ リポジトリ
https://github.com/MuraAtVwnet/ChangeShootingTime
git@github.com:MuraAtVwnet/ChangeShootingTime.git



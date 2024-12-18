PowerShell でパスワードを生成する

■ これは何
パスワード生成スクリプトです
指定文字種のパスワード(ランダム文字列)を生成し、クリップボードに格納します

少々手抜きなので、指定文字種が全て含まれているかのチェックはしていません
(指定文字種が足りないようなら再生成してください)

■ 使い方
15文字のパスワードを生成する場合は、PowerShell プロンプトで以下のよう入力します

MakePassword 15

(makep[TAB] で MakePassword と補完されます)


■ オプション

-PasswordSize
	生成するパスワードの文字数(default 8)

-Basic
	パスワードを基本文字列にする(default)
	(Numeric + Alphabet + BaseMark)

-Numeric
	パスワードに数字を含める

-Alphabet
	パスワードにアルファベットを含める

-BaseMark
	パスワードに基本記号(!.?+$%#&*=@)を含める

-ExtendMark
	パスワードに拡張記号('`"``()-^~\|[]{};:<>,/_)を含める

-OnlyAlphabetNumeric
	パスワードを数字とアルファベットのみにする
	(Numeric + Alphabet)

-AllCharacter
	パスワードに全文字種を使用する
	(Numeric + Alphabet + BaseMark + ExtendMark)

-VertionCheck
	最新スクリプトがあるか確認する


■ インストール方法

# 以下コマンドを PowerShell プロンプトにコピペしてください

$ModuleName = "MakePassword"
$GitHubName = "MuraAtVwnet"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/$GitHubName/$ModuleName/master/OnlineInstall.ps1 -OutFile ~/OnlineInstall.ps1
& ~/OnlineInstall.ps1


■ アンインストール
以下コマンドを PowerShell プロンプトにコピペしてください

~/UnInstallMakePassword.ps1

■ 動作確認環境
Windows PowerShell 5.1
PowerShell 7.4.6 (Windows)


■ リポジトリ
以下でスクリプトを公開しています

https://github.com/MuraAtVwnet/MakePassword
git@github.com:MuraAtVwnet/MakePassword.git


■ Web サイト
PowerShell でパスワードを生成する
https://www.vwnet.jp/windows/PowerShell/2024121801/MakePassword.htm

■ 参考情報
PowerShell で指定サイズのランダムな文字列/バイナリ列を生成する
https://www.vwnet.jp/windows/PowerShell/CreateRandomData.htm

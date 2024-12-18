##################################################
# パスワード生成
##################################################
function MakePassword(
			[int]$PasswordSize, 			# 生成する文字数
			[switch]$Basic,					# アルファベット+数字+基本記号
			[switch]$OnlyAlphabetNumeric,	# 数字とアルファベットのみ
			[switch]$AllCharacter,			# 全文字種
			[switch]$Numeric,				# 数字
			[switch]$AlphabetLarge,			# アルファベット大文字
			[switch]$AlphabetSmall,			# アルファベット小文字
			[switch]$BaseMark,				# 基本記号
			[switch]$ExtendMark,			# 拡張記号
			[switch]$VertionCheck			# バージョンチェック
		){

	# バージョンチェックとオンライン更新
	if( $VertionCheck ){
		$ModuleName = "TestModule"
		$GitHubName = "MuraAtVwnet"

		$Module = $ModuleName + ".psm1"
		$Vertion = "Vertion" + $ModuleName + ".txt"
		$VertionTemp = "VertionTemp" + $ModuleName + ".tmp"

		$Update = $False

		if( -not (Test-Path ~/$Vertion)){
			$Update = $True
		}
		else{
			# 現在のバージョン
			$LocalVertion = Get-Content -Path ~/$Vertion

			# ローカルにリポジトリに置いてあるバージョン管理ファイルをダウンロードし読み込む
			Invoke-WebRequest -Uri https://raw.githubusercontent.com/$GitHubName/$ModuleName/master/Vertion.txt -OutFile ~/$VertionTemp
			$NowVertion = Get-Content -Path ~/$VertionTemp
			Remove-Item ~/$VertionTemp

			# バージョン チェック
			if( $LocalVertion -ne $NowVertion ){
				$Update = $True
			}
		}

		if( $Update ){
			Write-Output "最新版に更新します"
			Write-Output "更新完了後、PowerShell プロンプトを開きなおしてください"
			Invoke-WebRequest -Uri https://raw.githubusercontent.com/$GitHubName/$ModuleName/master/OnlineInstall.ps1 -OutFile ~/OnlineInstall.ps1
			& ~/OnlineInstall.ps1
			Write-Output "更新完了"
			Write-Output "PowerShell プロンプトを開きなおしてください"
		}
		else{
			Write-Output "更新の必要はありません"
		}
		return
	}

	# アセンブリロード
	Add-Type -AssemblyName System.Security

	# ランダム文字列にセットする値
	$NumericString 		= '1234567890'
	$AlphabetLargeString 	= 'ABCDEFGHIJKLNMOPQRSTUVWXYZ'
	$AlphabetSmallString 	= 'abcdefghijklnmopqrstuvwxyz'
	$BaseMarkString 	= '!.?+$%#&*=@'
	$ExtendMarkString	= "'`"``()-^~\|[]{};:<>,/_"

	if( $PasswordSize -eq 0 ){
		$PasswordSize = 8
	}

	if( ($Numeric -eq $false) -and
		($AlphabetLarge -eq $false) -and
		($AlphabetSmall -eq $false) -and
		($BaseMark -eq $false) -and
		($ExtendMark -eq $false) -and
		($OnlyAlphabetNumeric -eq $false) -and
		($AllCharacter -eq $false)){
			$Basic = $true
	}

	if($Basic){
		$Numeric = $True
		$AlphabetLarge = $True
		$AlphabetSmall = $True
		$BaseMark = $True
	}

	if($OnlyAlphabetNumeric){
		$Numeric = $True
		$AlphabetLarge = $True
		$AlphabetSmall = $True
	}

	if($AllCharacter){
		$Numeric = $True
		$AlphabetLarge = $True
		$AlphabetSmall = $True
		$BaseMark = $True
		$ExtendMark = $True
	}

	[String] $BaseString = ""

	# 数字
	if($Numeric){
		$BaseString += $NumericString
	}

	# アルファベット大文字
	if($AlphabetLarge){
		$BaseString += $AlphabetLargeString
	}

	# アルファベット小文字
	if($AlphabetSmall){
		$BaseString += $AlphabetSmallString
	}

	# 基本記号
	if($BaseMark){
		$BaseString += $BaseMarkString
	}

	# 拡張記号
	if( $ExtendMark){
		$BaseString += $ExtendMarkString
	}

	$LoopFlag = $true
	$LoopIndex = 0
	while($LoopFlag){
		# 乱数格納配列
		[array]$RandomValue = New-Object byte[] $PasswordSize

		# オブジェクト 作成
		$RNG = New-Object System.Security.Cryptography.RNGCryptoServiceProvider

		# 乱数の生成
		$RNG.GetBytes($RandomValue)

		# 乱数を文字列に変換
		[String] $PasswordString = ""
		$Max = $BaseString.Length
		for($i = 0; $i -lt $PasswordSize; $i++){
			$PasswordString += $BaseString[($RandomValue[$i] % $Max)]
		}

		# オブジェクト削除
		$RNG.Dispose()

		$LoopFlag = $false

		# 数字
		if($Numeric -and ($LoopFlag -eq $false) ){
			if($PasswordString -notmatch "[$NumericString]") {
				$LoopFlag = $true
			}
		}

		# アルファベット大文字
		if($AlphabetLarge -and ($LoopFlag -eq $false) ){
			if($PasswordString -cnotmatch "[$AlphabetLargeString]") {
				$LoopFlag = $true
			}
		}

		# アルファベット小文字
		if($AlphabetSmall -and ($LoopFlag -eq $false) ){
			if($PasswordString -cnotmatch "[$AlphabetSmallString]") {
				$LoopFlag = $true
			}
		}

		# 基本記号
		if($BaseMark -and ($LoopFlag -eq $false) ){
			if($PasswordString -notmatch "[$BaseMarkString]") {
				$LoopFlag = $true
			}
		}

		# 拡張記号
		if($ExtendMark -and ($LoopFlag -eq $false) ){
			if($PasswordString -notmatch "[$ExtendMarkString]") {
				$LoopFlag = $true
			}
		}

		$LoopIndex++
		if( $LoopIndex -ge 10){
			Write-Output "FAIL"
			$LoopFlag = $false
		}
	}

	Set-Clipboard -Value $PasswordString

	 Write-Output $PasswordString
}


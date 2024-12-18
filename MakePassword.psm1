##################################################
# パスワード生成
##################################################
function MakePassword(
			[int]$ByteSize, 				# 生成する文字数
			[switch]$Numeric,				# 数字
			[switch]$Alphabet,				# アルファベット
			[switch]$BaseMark,				# 基本記号
			[switch]$ExtendMark,			# 拡張記号
			[switch]$OnlyAlphabetNumeric,	# 数字とアルファベットのみ
			[switch]$AllCharacter,			# 全文字種
			[switch]$Basic					# アルファベット+数字+基本記号
		){
	# アセンブリロード
	Add-Type -AssemblyName System.Security

	# ランダム文字列にセットする値
	$NumericString 		= '1234567890'
	$AlphabetString 	= 'ABCDEFGHIJKLNMOPQRSTUVWXYZabcdefghijklnmopqrstuvwxyz'
	$BaseMarkString 	= '!.?+$%#&*=@'
	$ExtendMarkString	= "'`"``()-^~\|[]{};:<>,/_"

	if( $ByteSize -eq 0 ){
		$ByteSize = 8
	}

	if( ($Numeric -eq $false) -and
		($Alphabet -eq $false) -and
		($BaseMark -eq $false) -and
		($ExtendMark -eq $false) -and
		($OnlyAlphabetNumeric -eq $false) -and
		($AllCharacter -eq $false)){
			$Basic = $true
	}

	if($Basic){
		$Numeric = $True
		$Alphabet = $True
		$BaseMark = $True
	}

	if($OnlyAlphabetNumeric){
		$Numeric = $True
		$Alphabet = $True
	}

	if($AllCharacter){
		$Numeric = $True
		$Alphabet = $True
		$BaseMark = $True
		$ExtendMark = $True
	}

	[String] $BaseString = ""

	# 数字
	if($Numeric){
		$BaseString += $NumericString
	}

	# アルファベット
	if($Alphabet){
		$BaseString += $AlphabetString
	}

	# 基本記号
	if($BaseMark){
		$BaseString += $BaseMarkString
	}

	# 拡張記号
	if( $ExtendMark){
		$BaseString += $ExtendMarkString
	}

	# 乱数格納配列
	[array]$RandomValue = New-Object byte[] $ByteSize

	# オブジェクト 作成
	$RNG = New-Object System.Security.Cryptography.RNGCryptoServiceProvider

	# 乱数の生成
	$RNG.GetBytes($RandomValue)

	# 乱数を文字列に変換
	[String] $PasswordString = ""
	$Max = $BaseString.Length
	for($i = 0; $i -lt $ByteSize; $i++){
		$PasswordString += $BaseString[($RandomValue[$i] % $Max)]
	}

	# オブジェクト削除
	$RNG.Dispose()

	Set-Clipboard -Value $PasswordString

	 Write-Output $PasswordString
}


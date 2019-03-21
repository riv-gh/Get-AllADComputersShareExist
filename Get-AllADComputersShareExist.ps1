function Get-AllADComputersShareExist
{
	param($ShareFolder, $FileName)
	function Get-PCShareExists 
	{
		param($SharePath)
		if(Test-Path -Path $SharePath)
		{
			Write-Host "PathFind: " $SharePath
			if ($FileName.Length -gt 0)
			{
				Add-Content shared.txt $SharePath
			}
		}
	}
	Try
	{
		$adpc = Get-ADComputer -Filter *
		$len = $adpc.Length
		$pcName = @()
		for ($i=0; $i -lt $adpc.Length; $i++)
		{
			$pcName+=$adpc[$i].Name
		}
		$pcShare = @()
		for ($i=0; $i -lt $len; $i++)
		{
			$pcShare+=[string]::Format("\\{0}\{1}",$pcName[$i],$ShareFolder)
		}
		for ($i=0; $i -lt $len; $i++)
		{
			$percent = ( '{0:P}' -f ($i/$len) )
			$host.ui.RawUI.WindowTitle = "Path:${i}/${len} Complete:${percent}"
			Get-PCShareExists($pcShare[$i])
		}
	}
	Catch
	{
		Write-Host "Other type of error was found:"
		Write-Host "Exception type is $($_.Exception.GetType().Name)"
	}
	Finally
	{
		Write-Host "Finish!"
		$host.ui.RawUI.WindowTitle = "Finish!"
	}
}

#Get-AllADComputersShareExist("SHARE", "test.txt")

#echo "`nVenue configuration, preparing the system for cloud integration."
#echo "Please follow the instruction.`n"
#
#echo "------------------------------Cloud Login------------------------------------"
#echo "Cloud Login (User name and Password - documented in ReleaseNote. )"
#cmd.exe /c "C:\FreedCode\Base\Apps\Danone\DanoneSender.exe" nav start "C:\FreedCode\Base\Flow\Jobs\CloudCredentials\CloudCredentials_job.xml" "D:\Intel\FreeD\WorkDir\Configuration\System\Danone.ini"
#echo "Please enter user name and password`n`n"
#Remove-Item D:\Intel\FreeD\WorkDir\Configuration\Cloud\CloudCredentials.xml
#while (!(Test-Path "D:\Intel\FreeD\WorkDir\Configuration\Cloud\CloudCredentials.xml")) { Start-Sleep 10 }
#
#echo "----------------------TimeStamp and Choosing set-----------------------------"
#echo "Please Choose Original or Current timestamp and after that choose your set`n`n"
#powershell.exe -file "D:\Intel\FreeD\WorkDir\Configuration\System\SimulatorModeSelectorWrapper.ps1"
#while (!(Test-Path "D:\Intel\FreeD\WorkDir\Configuration\System\SimulatorEventSelector.ini")) { Start-Sleep 10 }
##need to check it the wait thing
#
#echo "-----------------WrapAround | First frame | Last frame-----------------------"
#$wraparound = Read-Host "WrapAround: (1/0)"
#$firstFrame = Read-Host "First frame: (-1 for start with the first frame in set)"
#$endframe = Read-Host "End frame: (-1 for end with the last frame in set )"
#
#$WrapAroundValue = Get-content -path "C:\FreedCode\Base\Configuration\Templates\FGC\FrameGrabber.DYN" | Where-Object { $_.Contains("SimModeDowrapAround=") }
#$WrapAroundValueToReplace = $WrapAroundValue.Split("=")[1]
#$NewWrapAround = $WrapAroundValue -replace $WrapAroundValueToReplace, $wraparound
#(Get-content "C:\FreedCode\Base\Configuration\Templates\FGC\FrameGrabber.DYN").replace($WrapAroundValue, $NewWrapAround) | Set-Content "C:\FreedCode\Base\Configuration\Templates\FGC\FrameGrabber.DYN"
#
#
#$FirstFrameValue = Get-content -path "C:\FreedCode\Base\Configuration\Templates\FGC\FrameGrabber.DYN" | Where-Object { $_.Contains("FrameFirstIndex=") }
#$FirstFrameValueToReplace = $FirstFrameValue.Split("=")[1]
#$NewFirstFrame = $FirstFrameValue -replace $FirstFrameValueToReplace, $firstFrame
#$NewFirstFrame = $NewFirstFrame + ';'
#(Get-content "C:\FreedCode\Base\Configuration\Templates\FGC\FrameGrabber.DYN").replace($FirstFrameValue, $NewFirstFrame) | Set-Content "C:\FreedCode\Base\Configuration\Templates\FGC\FrameGrabber.DYN"
#
#
#$EndFrameValue = Get-content -path "C:\FreedCode\Base\Configuration\Templates\FGC\FrameGrabber.DYN" | Where-Object { $_.Contains("FrameLastIndex=") }
#$EndFrameValueToReplace = $EndFrameValue.Split("=")[1]
#$NewEndFrame = $EndFrameValue -replace $EndFrameValueToReplace, $endFrame
#$NewEndFrame = $NewEndFrame + ';'
#(Get-content "C:\FreedCode\Base\Configuration\Templates\FGC\FrameGrabber.DYN").replace($EndFrameValue, $NewEndFrame) | Set-Content "C:\FreedCode\Base\Configuration\Templates\FGC\FrameGrabber.DYN"

echo "`n`n------------------------Upload Static Metadata------------------------------"
$UploadMetadata = Read-Host "Please choose one of those options:`n1. yes`n2. no`n3. no - only at the handshake, not during the run`n"

$MetadataTasksValue = Get-content -path "C:\FreedCode\Base\Flow\Backend\VenueUploader\VenueUploader_job.xml" | Where-Object { $_.Contains("<javaExecutable class") }
echo $MetadataTasksValue
if (($UploadMetadata -eq "1") -or ($UploadMetadata -eq "yes")) { 
    
    $MetadataTasksValueToReplace = $MetadataTasksValue.Split("=")[1] -replace '"', "" -replace ">", ""
    echo $MetadataTasksValueToReplace
    $NewUploadMetadata = $MetadataTasksValue -replace "empty", "exe"
    echo $NewUploadMetadata
    (Get-content "C:\FreedCode\Base\Flow\Backend\VenueUploader\VenueUploader_job.xml").replace($MetadataTasksValue, $NewUploadMetadata) | Set-Content "C:\FreedCode\Base\Flow\Backend\VenueUploader\VenueUploader_job.xml"
}
elseif (($UploadMetadata -eq "2") -or ($UploadMetadata -eq "no")) { 
    $MetadataTasksValueToReplace = $MetadataTasksValue.Split("=")[1] -replace '"', "" -replace ">", ""
    echo $MetadataTasksValueToReplace
    $NewUploadMetadata = $MetadataTasksValue -replace "exe", "empty"
    echo $NewUploadMetadata
    (Get-content "C:\FreedCode\Base\Flow\Backend\VenueUploader\VenueUploader_job.xml").replace($MetadataTasksValue, $NewUploadMetadata) | Set-Content "C:\FreedCode\Base\Flow\Backend\VenueUploader\VenueUploader_job.xml"

}elseif (($UploadMetadata -eq "3") -or ($UploadMetadata -eq "no - only at the handshake, not during the run")) { 
    
    $MetadataTasksValueToReplace = $MetadataTasksValue.Split("=")[1] -replace '"', "" -replace ">", ""
    $NewUploadMetadata = $MetadataTasksValue -replace "exe", "empty"
    (Get-content "C:\FreedCode\Base\Flow\Backend\VenueUploader\VenueUploader_job.xml").replace($MetadataTasksValue, $NewUploadMetadata) | Set-Content "C:\FreedCode\Base\Flow\Backend\VenueUploader\VenueUploader_job.xml"
    
    $MetadataTasksValue_option3 = (Get-content -path "C:\FreedCode\Base\Flow\Backend\VenueUploader\VenueUploader_job.xml" | Where-Object { $_.Contains("<javaExecutable class") })[4]
    echo $MetadataTasksValue_option3
    $MetadataTasksValueToReplace = $MetadataTasksValue_option3.Split("=")[1] -replace '"', "" -replace ">", ""
    $NewUploadMetadata_option3 = $MetadataTasksValue_option3 -replace "empty", "exe"
    echo $NewUploadMetadata_option3
    (Get-content "C:\FreedCode\Base\Flow\Backend\VenueUploader\VenueUploader_job.xml" -Encoding UTF8).replace($MetadataTasksValue_option3, $NewUploadMetadata_option3) | Set-Content -encoding UTF8 "C:\FreedCode\Base\Flow\Backend\VenueUploader\VenueUploader_job.xml"
}

#echo "`n`n------------------------Update Configuration-----------------------------"
#& "D:\Intel\FreeD\WorkDir\Configuration\System\UpdateConfiguration.cmd"
#
#echo "`n`n-----------------------Start Game Utilities-----------------------------"
#echo "Cloud Handshake"
#cmd.exe /c "C:\FreedCode\Base\Apps\Danone\DanoneSender.exe" nav start "C:\FreedCode\Base\Flow\Jobs\GameUtils\GameUtils_job.xml" "D:\Intel\FreeD\WorkDir\Configuration\System\Danone.ini"
#echo "Please enter GameID`n`n"
#Remove-Item D:\Intel\FreeD\WorkDir\Signals\Maintenance\OreganoCardExist.signal
#while (!(Test-Path "D:\Intel\FreeD\WorkDir\Signals\Maintenance\OreganoCardExist.signal")) { Start-Sleep 10 }
#
#echo "`n`n----------------------------------------------------"
#echo "`n`n--------------System ready stream-------------------"
#echo "`n`n----------------------------------------------------"

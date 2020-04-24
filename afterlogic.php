<?php 
include_once '/var/www/html/system/autoload.php';
\Aurora\System\Api::Init(true);

$oSettings = \Aurora\System\Api::GetSettings();
if ($oSettings)
{
	$fgc = get_data("https://afterlogic.com/get-trial-key?productId=afterlogic-webmail-pro-8&format=json");
	$oResponse = json_decode($fgc);
	if (isset($oResponse->success) && $oResponse->success && isset($oResponse->key) && $oResponse->key !== '')
	{
		$oSettings->LicenseKey = $oResponse->key;
	}

	$oSettings->SetConf('DBHost', 'localhost');
	$oSettings->SetConf('DBName', 'afterlogic');
	$oSettings->SetConf('DBLogin', 'rootuser');
	$oSettings->SetConf('DBPassword', 'dockerbundle');
	$result = $oSettings->Save();
	
	\Aurora\System\Api::GetModuleDecorator('Core')->CreateTables();
	\Aurora\System\Api::GetModuleManager()->SyncModulesConfigs();
}

function get_data($url)
{
	$ch = curl_init();
	$timeout = 20;
	curl_setopt($ch,CURLOPT_URL,$url);
	curl_setopt($ch,CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch,CURLOPT_CONNECTTIMEOUT,$timeout);
	$data = curl_exec($ch);
	curl_close($ch);
	return $data;
} 

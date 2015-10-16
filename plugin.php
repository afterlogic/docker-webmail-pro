<?php

class_exists('CApi') or die();

class CTrialLicenseKeyPlugin extends AApiPlugin
{
	/**
	 * @param CApiPluginManager $oPluginManager
	 */
	public function __construct(CApiPluginManager $oPluginManager)
	{
		parent::__construct('1.0', $oPluginManager);

		$this->AddHook('before-get-license-key', 'BeforeGetLicenseKey');
	}

	public function Init()
	{
		parent::Init();
	}

	/**
	 * @param CAccount $oAccount
	 */
	public function BeforeGetLicenseKey()
	{
		$oSettings =& CApi::GetSettings();
		$sLicenseKey = $oSettings->GetConf('Common/LicenseKey');
		if (empty($sLicenseKey))
		{
			$oLicensingApi = CApi::Manager('licensing');
			if ($oLicensingApi)
			{
				$oSettings->SetConf('Common/LicenseKey', $oLicensingApi->GetT()) ;
				$oSettings->SaveToXml();
			}
		}
	}
}

return new CTrialLicenseKeyPlugin($this);

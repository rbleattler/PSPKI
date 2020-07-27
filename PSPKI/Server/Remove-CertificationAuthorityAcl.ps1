function Remove-CertificationAuthorityAcl {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Security.AccessControl.CertSrvSecurityDescriptor')]
[CmdletBinding(DefaultParameterSetName = '__identity')]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('AclObject','Acl')]
		[SysadminsLV.PKI.Security.AccessControl.CertSrvSecurityDescriptor[]]$InputObject,
		[Parameter(Mandatory = $true, ParameterSetName = '__identity')]
		[Security.Principal.NTAccount[]]$User,
		[Parameter(Mandatory = $true, ParameterSetName = '__identity')]
		[Security.AccessControl.AccessControlType]$AccessType = "Allow",
		[Parameter(Mandatory = $true, ParameterSetName = '__purge')]
		[switch]$Force
	)
	process {
		foreach($ACL in $InputObject) {
			switch ($PSCmdlet.ParameterSetName) {
				'__purge' {
					if ($Force) {
						$aceArray = $ACL.Access | ForEach-Object {$_}
						$aceArray | ForEach-Object {
							$ACL.PurgeAccessRules($_.IdentityReference)
						}
					}
				}
				'__identity' {
					$User | ForEach-Object {
						[void]$ACL.RemoveAccessRule($_, $AccessType)
					}
				}
			}
			$ACL
		}
	}
}
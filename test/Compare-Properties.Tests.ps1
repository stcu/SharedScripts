﻿<#
.SYNOPSIS
Tests comparing the properties of two objects.
#>

Describe 'Compare-Properties' -Tag Compare-Properties {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir Compare-Properties.ps1
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Compares the properties of two objects' -Tag CompareProperties,Compare,Properties {
		It 'Should find the difference between PSProviders' {
			$diff = Compare-Properties.ps1 (Get-PSProvider variable) (Get-PSProvider alias) |Sort-Object PropertyName
			$diff.Reference |Should -BeTrue
			$diff.Difference |Should -BeTrue
			$imptype = $diff |Where-Object PropertyName -eq ImplementingType
			$imptype.Value |Should -BeExactly Microsoft.PowerShell.Commands.VariableProvider
			$imptype.DifferentValue |Should -BeExactly Microsoft.PowerShell.Commands.AliasProvider
			$name = $diff |Where-Object PropertyName -eq Name
			$name.Value |Should -BeExactly Variable
			$name.DifferentValue |Should -BeExactly Alias
		}
	}
}

$loadEnvPath = Join-Path $PSScriptRoot 'loadEnv.ps1'
if (-Not (Test-Path -Path $loadEnvPath)) {
    $loadEnvPath = Join-Path $PSScriptRoot '..\loadEnv.ps1'
}
. ($loadEnvPath)

$TestRecordingFile = Join-Path $PSScriptRoot 'Update-AzMariaDbServer.Recording.json'
$currentPath = $PSScriptRoot
while(-not $mockingPath) {
    $mockingPath = Get-ChildItem -Path $currentPath -Recurse -Include 'HttpPipelineMocking.ps1' -File
    $currentPath = Split-Path -Path $currentPath -Parent
}
. ($mockingPath | Select-Object -First 1).FullName

Describe 'Update-AzMariaDbServer' {
    It 'UpdateExpanded' {
        $mariadb = Get-AzMariaDbServer -Name $env.rstrbc02 -ResourceGroupName $env.ResourceGroup
        $newStorageProfileStorageMb = $mariadb.StorageProfileStorageMb + 1024
        $updatedMariadb = Update-AzMariaDbServer -Name $env.rstrbc02 -ResourceGroupName $env.ResourceGroup -StorageProfileStorageInMb $newStorageProfileStorageMb 
        $updatedMariadb.StorageProfileStorageMb | Should -Be $newStorageProfileStorageMb
    }
    It 'UpdateViaIdentity' {
        $mariadb = Get-AzMariaDbServer -Name $env.rstrbc02 -ResourceGroupName $env.ResourceGroup
        $newStorageProfileStorageMb = $mariadb.StorageProfileStorageMb + 1024
        $updatedMariadb = Update-AzMariaDbServer -InputObject $mariadb -StorageProfileStorageInMb $newStorageProfileStorageMb 
        $updatedMariadb.StorageProfileStorageMb | Should -Be $newStorageProfileStorageMb
    }
}

$nomClient = Read-Host "Entrez le nom du client (sans espaces ni caractères spéciaux):"

$cheminClient = "C:\Travail\mon_projet_vagrant\NewTech\$nomClient"

New-Item -Path $cheminClient -ItemType Directory -Force

$vagrantPath = "C:\Travail\mon_projet_vagrant\commun"
$nextIPFile = "C:\Travail\mon_projet_vagrant\commun\next.txt"
$numberOfVMs = 3
$baseIP = "192.168.33.10"

$configDirectoryVM = Join-Path -Path $vagrantPath -ChildPath "NewTech\$nomClient\config" -Replace '\\','/'

for ($i = 1; $i -le $numberOfVMs; $i++) {
    $lastIP = Get-Content $nextIPFile
    $nextIPBytes = $lastIP.Split('.') | ForEach-Object { [byte]::Parse($_) }
    $nextIPBytes[3]++
    $nextIP = [string]::Join('.', $nextIPBytes)
    $nextIP | Out-File $nextIPFile

    $vmDirectory = Join-Path -Path $vagrantPath -ChildPath "vm$i"
    New-Item -Path $vmDirectory -ItemType Directory -Force

    New-Item -Path $configDirectoryVM -ItemType Directory -Force

    $vagrantfileContent = @"
Vagrant.configure("2") do |config|
  config.vm.define "vm$i" do |vm|
    vm.vm.box = "jaca1805/debian12"
    vm.vm.network "private_network", type: "static", ip: "$nextIP"
    vm.vm.synced_folder "$configDirectoryVM", "/home/vagrant/config"
  end
end
"@
    Set-Content -Path (Join-Path -Path $vmDirectory -ChildPath "Vagrantfile") -Value $vagrantfileContent

    cd $vmDirectory
    vagrant up
    cd $vagrantPath

    Write-Host "VM $i créée avec l'adresse IP $nextIP pour le client '$nomClient'."
}

$ansibleHostsFile = "C:\Travail\mon_projet_vagrant\ansible\hosts"
$ansibleHostsContent = @"
[$nomClient]
"@

for ($i = 0; $i -lt $numberOfVMs; $i++) {
    $lastIP = Get-Content $nextIPFile
    $nextIPBytes = $lastIP.Split('.') | ForEach-Object { [byte]::Parse($_) }
    $nextIPBytes[3]++
    $nextIP = [string]::Join('.', $nextIPBytes)
    $ansibleHostsContent += "$nextIP`n"
}

$ansibleHostsContent | Out-File -FilePath $ansibleHostsFile -Append

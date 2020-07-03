################
# Variables    #
################
$DNSRecordsCSV = import-csv "INSERT_PATH"

################
# Script       #
################
Foreach ($record in $DNSRecordsCSV) {
if ($record.NodeName -like "etcd*"){
$DNSName = $record.NodeName+'.'+$record.ClusterName
Add-DnsServerResourceRecordA -Name $DNSName -ZoneName $record.BaseDomain -AllowUpdateAny -IPv4Address $record.IP -TimeToLive 01:00:00 
}
else {
$DNSName = $record.NodeName+'.'+$record.ClusterName
Add-DnsServerResourceRecordA -Name $DNSName -ZoneName $record.BaseDomain -AllowUpdateAny -IPv4Address $record.IP -TimeToLive 01:00:00 -createptr} 
}
$sslname = "_etcd-server-ssl._tcp."+$DNSRecordsCSV.ClusterName[0]
$FullDomain = $DNSRecordsCSV.ClusterName[0]+'.'+$DNSRecordsCSV.BaseDomain[0]
$etcd0 = "etcd-0."+$FullDomain
$etcd1 = "etcd-1."+$FullDomain
$etcd2 = "etcd-2."+$FullDomain
Add-DnsServerResourceRecord -zonename $DNSRecordsCSV.BaseDomain[0] -name $sslname -TimeToLive 3600 -srv -DomainName $etcd0 -Priority 0 -Weight 0 -port 2380
Add-DnsServerResourceRecord -zonename $DNSRecordsCSV.BaseDomain[0] -name $sslname -TimeToLive 3600 -srv -DomainName $etcd1 -Priority 0 -Weight 0 -port 2380
Add-DnsServerResourceRecord -zonename $DNSRecordsCSV.BaseDomain[0] -name $sslname -TimeToLive 3600 -srv -DomainName $etcd2 -Priority 0 -Weight 0 -port 2380

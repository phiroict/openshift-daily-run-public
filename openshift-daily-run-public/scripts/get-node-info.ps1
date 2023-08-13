$nodes = (oc get nodes -A)
foreach($node in $nodes){
    Write-Output "Node $($node)"
}
Start-Sleep -Seconds 3600

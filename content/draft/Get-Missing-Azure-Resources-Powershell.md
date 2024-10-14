---
comments: true
date: "2024-10-14T00:00:00Z"
title: Get resources missing in Resource Group using PowerShell
tags:
- Azure
- DevOps
- Powershell
GHissueID: 16
---

I've recently stumbled across a situation where some resource groups were missing a given type of resource. 
The "normal" scenario is that each resource group has a bunch of resources, and this happens for multiple resource groups owned by my team.
There were some issues with some implementations, and there was no logic on why some resource groups had the resource and others didn't. Since we are talking about hundreds of resource groups, checking one by one is out of question.

Instead, I quickly fired up my vscode and wrote a quick script to check which resource groups were missing the resource.

The reason why I'm sharing this, is because I think it's a good example of how PowerShell can be really powerful and save a lot of time on some simple tasks that would be very time consuming otherwise.

# The logic
Before showing you the final solution, let's break down the thought process:
- I need to get all resource groups based on some logic
    - In this case, we have a tag dedicated to the team that owns the resource group
- For each resource group, I need to check if it has a resource of a given type
    - In this case, we will be looking for a KeyVault as an example
- If it doesn't have the resource, I'll print a message stating that
    - You can also write to a file, or do whatever fits your needs

## 1st approach

```powershell
$rgs = Get-AzResourceGroup | Where-Object { $_.Tags["Team"] -eq "MyTeam" }
$typeToCheck = "Microsoft.KeyVault/vaults"
$rgs | Select-Object -ExpandProperty ResourceGroupName | ForEach-Object {
    $resources = Get-AzResource -ResourceGroupName $_ | Select-Object -ExpandProperty ResourceType
    if(-not $resources.Contains($typeToCheck)) {
        Write-Host "Resource group $_ is missing a resource of type $typeToCheck"
    }
}
```
This first approach works, but it's not the most efficient. I'm loading _all_ the resource groups that I have access to, and only then filtering by the ones that match my team. 
But the `Get-AzResourceGroup` has a `-Tag` parameter that allows me to filter directly on the query. This way, I only get the resource groups that match my criteria.

## 2nd approach

```powershell
$rgs = Get-AzResourceGroup -tag @{"Team"="MyTeam"} 
$typeToCheck = "Microsoft.KeyVault/vaults"
$rgs | Select-Object -ExpandProperty ResourceGroupName | ForEach-Object {
    $resources = Get-AzResource -ResourceGroupName $_ | Select-Object -ExpandProperty ResourceType
    if(-not $resources.Contains($typeToCheck)) {
        Write-Host "Resource group $_ is missing a resource of type $typeToCheck"
    }
}
```

This small change, although it seems insignificant, can make a huge difference in performance in cases where you have to hundreds of resource groups, because you are now filtering directly on the query, instead of filtering it locally.
But there's still room for improvement in this case, similar to what we've just did. Can you spot it?
The `Get-AzResource` cmdlet is returning all resources for a given resource group and adding them to a list. Not only that, but we are afterwards doing a `Contains`, which will have to iterate the list just to find if a value exists.
But we are only interested in a specific type. I could change the `Select-Object -ExpandProperty ResourceType` to only get the `ResourceType` property, but that would still return all resources, and we would have to iterate them to find the one we are looking for.

Like in the previous example, we can filter it directly on the query by using the `-ResourceType` of the `Get-AzResource` command.

## 3rd approach

```powershell
$rgs = Get-AzResourceGroup -tag @{"Team"="MyTeam"} 
$typeToCheck = "Microsoft.KeyVault/vaults"
$rgs | Select-Object -ExpandProperty ResourceGroupName | ForEach-Object {
    $resourceType = Get-AzResource -ResourceGroupName $_ -ResourceType $typeToCheck
    if($null -eq $resourceType) {
        Write-Host "Resource group $_ is missing a resource of type $typeToCheck"
    }
}
```

I find this solution not only more eficient, but also cleaner. We are now directly filtering the resources by type, and if it doesn't exist, we print the message.
I still think that there's room for improvement, but I'm already pretty happy with the improvements and the outcome.

# The goal
Again, the goal of this post is not only to share with you one of the scenarios where I leverage the ease of use and power of PowerShell (pun intended), but also to share with you the thought process behind it.
Hopefuly you found it useful. Thanks for reading!

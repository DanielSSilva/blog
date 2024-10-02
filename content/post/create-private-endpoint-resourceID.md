---
title: "Create private endpoints using ResourceID"
date: "2024-10-02T00:00:00Z"
tags:
- devops
- azure
- storage accounts
- networking
comments: true
GHissueID: 16
---

# What is a private endpoint?
As described by [Microsoft](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview)
> A private endpoint is a network interface that uses a private IP address from your virtual network. This network interface connects you privately and securely to a service that's powered by Azure Private Link. By enabling a private endpoint, you're bringing the service into your virtual network. 

This is a good way to allow all traffic between the host and Azure to go through a private connection, or, in other words, through Azure Backbone.

# Pre-requirements
- A vNET in which the private endpoint will live
- A DNS solution that can translate the hostname into the private IP of the private endpoint, such as an [Azure DNS Private Resolver](https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-overview)

***NOTE***: Because DNS is always the root of all problems and DNS is a somewhat complex topic, this post won't cover the DNS resolution part. This assumes that you already have a way to resolve the hostname into the private IP of the private endpoint. I will have a dedicated blog post on (one of) the way to achieve this.

# Creating a private endpoint
## The ClickOps way

Many (if not all) resources that support private endpoints allow you to create the private endpoint directly within the resource. 
For example, if you want to create a private endpoint for a storage account, you can head over to `Networking > Private endpoint connections > + Private endpoint`. This is pretty straightforward for scenarios where you own both the host resource (the resource you want to connect to) and the vNET where the private endpoint will be.

But what if you want to create a private endpoint for a resource that's not yours, and you don't even have access to it?

## ResourceID to the rescue!

Search for private endpoints and open the correspondent service

<a href="/images/create-private-endpoint-resoruceID/search_pe.png" target="_blank">
  <img src="/images/create-private-endpoint-resoruceID/search_pe.png"/>
</a>

Go to `create`, and follow the wizard

<a href="/images/create-private-endpoint-resoruceID/create_pe_basics.png" target="_blank">
  <img src="/images/create-private-endpoint-resoruceID/create_pe_basics.png"/>
</a>

The key part here is the `Resource` section:
<a href="/images/create-private-endpoint-resoruceID/create_pe_resource.png" target="_blank">
  <img src="/images/create-private-endpoint-resoruceID/create_pe_resource.png"/>
</a>

- **Connection Method**: Select the “_Connect to an Azure resource by resource ID or alias._”.
- **ResourceID or alias:** You need to have the _resourceID_ of the resource you want to link to the private endpoint. In this case, it is the ResourceID of the storage account. It looks like this: `/subscriptions/<subscriptionID>/resourceGroups/<target resource group>/providers/Microsoft.Storage/storageAccounts/<target storage>`
- **Target sub-resource:** This will depend on what you want to connect to. In this case, it is the blob service.
- **Request message**: This will be visible in the Storage Account connections. Consider including information that helps the owner know that you are the owner of this private endpoint.

# Approve the connection on the Storage Account
<a href="/images/create-private-endpoint-resoruceID/storage_networking_pe.png" target="_blank">
  <img width="800" src="/images/create-private-endpoint-resoruceID/storage_networking_pe.png"/>
</a>
</p>
The final step is to approve the private endpoint connection in the Storage account. As you can see, there is no specific information about who created the private endpoint. That's why I suggest that you write down in the subscription any relevant information that helps the Storage Account owner know who owns the private endpoint.

</p>
<a href="/images/create-private-endpoint-resoruceID/storage_pe_approve.png" target="_blank">
  <img width="800" src="/images/create-private-endpoint-resoruceID/storage_pe_approve.png"/>
</a>

If you are the storage account owner and the user didn't provide a useful description or want to add any details, you can do so before approving.

# The IaC way
Creating it through IaC is pretty straightforward since we are always required to provide the resourceID. The following Terraform snippet translates to the same as the previous example.
``` hcl 
resource "azurerm_private_endpoint" "blob_storage_pe" {
  name                = "pe-storageaccount"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  private_service_connection {
    name                           = var.storage_account_name
    private_connection_resource_id = var.storage_account_resourceID
    is_manual_connection           = true
	request_message                = "This private endpoint is owned & managed by Daniel"
    subresource_names              = ["blob"]
  }
```

Depending on what tool you use to manage your infrastructure (Terraform, Azcli, PowerShell, etc.), some names and parameters might differ, but they shouldn't be that different.

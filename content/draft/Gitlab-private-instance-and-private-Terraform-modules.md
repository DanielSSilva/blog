---
title: "Gitlab private instance and private Terraform modules"
date: "2022-07-26T00:00:00Z"
draft: true
tags:
- DevOps
- Terraform
comments: true
GHissueID: 13
---

At my current job, we use a private instance of Gitlab to host the code, CI/CD, and such, and we also have private runners.
I recently began working on a terraform script that became a module since multiple teams/projects can leverage such implementation. For this reason, it makes sense to have a repository dedicated to this module (or even more modules, but that can be another topic).

## The objective

The idea is pretty simple: Have a git repository that hosts the module(s), and every other project that wants to use the them, reference the repository through the `source = "git:: (...)` terraform syntax.

## Using terraform modules
I love Terraform documentation, since it's really well written, has examples and is very detailed. On [this](https://www.terraform.io/language/modules/sources#module-sources) page, they have examples on how to use modules with different sources. Without going into much details [here](https://www.terraform.io/language/modules/sources#generic-git-repository) is what we are looking for:
```
module "vpc" {
  source = "git::https://example.com/vpc.git"
}

module "storage" {
  source = "git::ssh://username@example.com/storage.git"
}
```

## The issue
Because the module is hosted on a private instance of Gitlab, we need some sort of authentication in order to be able to fetch the code. For a local setup, I've generated SSH keys and it works perfectly, but for the CI/CD pipeline I haven't figured how to achieve that.

## The CI_JOB_TOKEN predefined variable
[CI_JOB_TOKEN](https://docs.gitlab.com/ee/ci/jobs/ci_job_token.html) is a predefined variable that gets populated whenever a pipeline job is about to run and serves as an access token. 
As they mention on the documentation
> You can also use the job token to authenticate and clone a repository from a private project in a CI/CD job:

```
git clone https://gitlab-ci-token:${CI_JOB_TOKEN}@gitlab.example.com/<namespace>/<project>
```
This gives us an hint that we could use the syntax `https://gitlab-ci-token:${CI_JOB_TOKEN}@gitlab.example.com/<namespace>/<project>` for our case!
Not so fast! We need to keep in mind that in this case we are not running a command on the pipeline itself. Instead, we are referencing the repository on our `main.tf` file, which means that the pipeline won't see this, hence it will not replace the variable.

## Storing credentials and replacing the repository endpoint
We can configure the pipeline to store the git credentials, as well as taking care of replacing the URL to something we want.

Here's a snippet of the configuration that we're currently using:
``` bash
git config --global credential.helper store
echo "https://gitlab-ci-token:${CI_JOB_TOKEN}@gitlab.ourinstancename.com" > ~/.git-credentials
git config --global url."https://gitlab.ourinstancename.com/".insteadOf "git@gitlab.ourinstancename.com:"
```

Here's what it's doing:
	1. Configure a credential helper to store our credentials - I've tried with `cache` instead of `store` but it didn't work
	2. store the username (`gitlab-ci-token` ) and access token (`${CI_JOB_TOKEN}`)
	3. Replace the `git@` syntax with HTTPS, in order to use the user:accessToken

## Adding these configs to the pipeline
Because between stages the runner might change, we need to run `terraform init` on every stage to ensure we have everything set up, including the modules.
We can use the `default` YAML element to specify what should run before every job, and include these configurations there. Here's an example:

```YAML
default:
	before_script:
	# setup git to download module from another repo
		git config --global credential.helper store
		echo "https://gitlab-ci-token:${CI_JOB_TOKEN}@gitlab.ourinstancename.com" > ~/.git-credentials
		git config --global url."https://gitlab.ourinstancename.com/".insteadOf "git@gitlab.ourinstancename.com:"
		# setup terraform variables and init
		- export ARM_CLIENT_ID=${ARM_CLIENT_ID}
		- export ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET}
		- export ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID}
		- export ARM_TENANT_ID=${ARM_TENANT_ID}
		- export TF_IN_AUTOMATION=1
		- terraform init -input=false
			-upgrade
			-backend-config="storage_account_name=stgotham${CI_ENVIRONMENT_NAME}"
			-backend-config="container_name=terraform"
			-backend-config="key=terraform.tfstate"
			-backend-config="subscription_id=${ARM_SUBSCRIPTION_ID}"
			-backend-config="tenant_id=${ARM_TENANT_ID}"
		- terraform workspace select ${CI_ENVIRONMENT_NAME} || terraform workspace new ${CI_ENVIRONMENT_NAME}
```


# Wrapping up
If you are using terraform and hosting the modules on a private instance of Gitlab, you need to configure the CI/CD pipelines to know how to fetch the code from a private repository.
One approach is using the 3 lines I've previously mentioned:
``` bash
git config --global credential.helper store
echo "https://gitlab-ci-token:${CI_JOB_TOKEN}@gitlab.ourinstancename.com" > ~/.git-credentials
git config --global url."https://gitlab.ourinstancename.com/".insteadOf "git@gitlab.ourinstancename.com:"
```

Thanks for reading this, and I hope that this was useful!

If you want to comment this post, you can leave a comment on [this issue](https://github.com/DanielSSilva/blog/issues/13)
---
title: "How I've revamped my domain - From Jekyll to Hugo"
#title: Taking full advantage of my domain - Personal Page + Blog
date: "2022-08-04T00:00:00Z"
tags:
- Personal
- Blog
comments: true
GHissueID: 14
---

# A small introduction

When I first started blogging [back in 2017](https://danielsknowledgebase.wordpress.com/2017/05/30/what-am-i-doing/) (damn it has already been 5 years...), I created a free blog on WordPress - [https://danielsknowledgebase.wordpress.com](https://danielsknowledgebase.wordpress.com).
It was a really simple and nice way to get started with blogging.
As time passed and I kept on writing posts, I noticed that I enjoyed it.
For that reason, it seemed reasonable to invest in a custom domain, and in that way also enrich my online presence.

### Custom domain choice
When I decided to "upgrade" to a custom domain, the `.dev` domains had just become available, and since this is a technical blog and I'm a dev... perfect opportunity.
I've ended with [Namecheap](https://www.namecheap.com/) because as far as I remember, at the time there were a lot of complaints about GoDaddy (not that NameCheap is perfect...) and Namecheap had the domain that I wanted at a small price.

### WordPress vs GitHub Pages
As I've mentioned, WordPress worked just fine for the needs that I had, but since I wanted to upgrade to a custom domain, it involved upgrading the WordPress account or hosting WordPress on the domain itself.
Namecheap offers WordPress hosting, but it increases costs.
This is where GitHub Pages comes in, and it's the main reason I've moved to it.
But there's another big advantage that I haven't even thought about at the time - subdomains! (we'll see this later)

When I moved to GitHub Pages, I read some blog posts and seemed that Jekyll was widely used, plus I knew people that used it.
Additionally, as mentioned on [their site](https://jekyllrb.com/)
>  GitHub Pages is powered by Jekyll, so you can easily deploy your site using GitHub for free—custom domain name and all.

# Let's go to the changes

### What's wrong with Jekyll?

Nothing! I have no complaints regarding Jekyll as a product.
But there's something that always annoyed me when using it to view my blog locally: the setup.
Jekyll is built on Ruby, which means I need to install it, solve any issues that it might cause during the installation, create environments, install dependencies, etc, etc.
But there's an alternative

### Docker to the rescue
Jekyll provides an [official docker image](https://hub.docker.com/r/jekyll/jekyll/), which means that everything mentioned before is no longer an issue since in my case I already used docker.

But... even with the docker image, whenever I wanted to run the blog locally, I had to run the following command:
```docker
sudo docker run --name blogContainer
-v $PWD:/srv/jekyll
-e JEKYLL_UID=$(id -u)
-p 4000:4000
-d jekyll/jekyll jekyll serve --force_polling --drafts
```

So docker brings the advantage of not having to install Ruby and all but creates this train that I had to put on a gist just so that I could look it up and run it when needed.

## Why Hugo
Well to be honest, at first I didn't have any particular reason.
I haven't updated anything "engine-wise" on the blog ever since I've initially set up the blog in 2019.
Since I had an idea I wanted to try that implied changing things, I thought I might as well just test another site generator.
A bonus is that Hugo is built with Go, which is easier for me to understand and it helps when troubleshooting.
Another bonus is that, to run Hugo locally I only had to install it with by running `brew install hugo` and to run it is as simple as `hugo server -D`
## From Jekyll to Hugo

When making such change, one can't just simply create a new Hugo site and copy/paste the posts from Jekyll.
There are some changes that need to be done.
Fortunately, Hugo even has their on documentation on how to [migrate to Hugo](https://gohugo.io/tools/migrations/).

I have successfully used their [`import` command](https://gohugo.io/commands/hugo_import_jekyll/).
Although the command does a really good job, there were at least two things that I needed manually change:
* Themes: 
    * I don't know how it's currently done, but when I built my blog with Jekyll, I had to clone a repository that had the theme as a template and then apply the changes. This is not friendly if you want to test different themes - most likely there's other ways to achieve this
    * With Hugo you add a submodule or clone the theme into the  themes folder, and specify which theme you want to use on the config file
* References:
    * In case you want to reference another post on your blog:
        * In Jekyll - `[On my last post]({{ site.baseurl }}{% post_url postName %})`
        * In Hugo - `[On my last post]({{</* ref "/post/postName"*/>}})`

### Showing/Hiding drafts

## Moving from Disqus to GitHub Issues
This has nothing to do with moving from Jekyll to Hugo. 
This is another "Since I had an idea I wanted to try that implied changing things" component.
Disqus is widely used and works just fine, but since I'm already on GitHub ecosystem, might as well leverage it and move the comments to GitHub Issues.
For my use case it makes sense, since it's a tech/dev blog and I would assume that most of the readers have a GitHub account (I would risk saying that more have GH accounts than Disqus).

I've followed [this post](https://retifrav.github.io/blog/2019/04/19/github-comments-hugo/), which includes everything needed, from the scripts, to the instructions on where should you place those.

Then, because my blog has only a few posts, I took the time to got to the GitHub repo and create an issue for each.
But Cláudio Silva ([b](https://claudioessilva.eu/)|[t](https://twitter.com/claudioessilva)) recently also revamped his blog and told me about [utterances](https://utteranc.es/), which automatically searchs for GitHub issues for a given blog post and creates a new issue if it doesn't exist.

## Final step: Deploy!

When I was using Jekyll, the action to deploy the website ran automatically whenever I commited to the main branch.
With Hugo, all I had to do was to add a GitHub Action [as described here](https://gohugo.io/hosting-and-deployment/hosting-on-github/#build-hugo-with-github-action).
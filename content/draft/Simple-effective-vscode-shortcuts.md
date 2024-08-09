---
title: "Simple yet effecient VSCode shortcuts for everyday use"
date: "2024-08-09T00:00:00Z"
tags:
- vscode
- devops
comments: true
GHissueID: 14
---
There's not a (working) day when I don't open vscode. I would even say I spend 80% of my day on that app. I've been using it for the last 7 years, so naturally, I've developed a workflow/muscle memory while using the app.

Today, I want to share with you some of the shortcuts I use daily to be more efficient.

# Before we start
I'm using MacOS and the US keyboard layout. Although, in most cases, the only difference is using the command key (⌘) instead of alt, some shortcuts will be completely different. I will mark those so that you can compare and adjust.
You can see all shortcuts using ⌘K ⌘S or by going to Settings -> Keyboard Shortcuts.

## Do it along

Open your vscode and try it along! You can find examples in my [blog's repo](https://github.com/DanielSSilva/blog/tree/main/examples/vscode). Even better, if you have a GitHub account, head to the previous link and press `.`. It will open a new vscode dev environment 🤯. You can still do it along even if you don't have a vscode on your machine or a GitHub account! Go to https://vscode.dev/, and you will find an empty vscode dev environment. You can then copy the example and work on it.

But there's something to keep in mind: some of the shortcuts in these cases (like the terminal toggle) can be different.


# Window management

## Toggle (primary) side bar
shortcut: ⌘ + B

Let's start simple. This shortcut toggles the display of the primary side panel. If you have the default settings, that's the panel located on the left. This is useful if you need more window space for your code or are focused on your code/text and don't need any external features.
## Toggle the terminal panel
(This may vary depending on your keyboard layout & environment)
shortcut: ⌘ + ;

This one is also straightforward. Whenever I'm focused on writing code, I collapse all panels. I toggle the terminal using this shortcut whenever I need to access it. This is nice because I don't need to use the external terminal, so I don't need to leave the current context.

# Searching

## Current file
⌘ + F

This one is quite universal. However, I use this extensively, especially when I need to do some find/replace/replace all

## Whole workspace
⌘ + ⇧ + F

I usually work with multiple configuration files or even multiple different folders simultaneously. This one brings the search to the next level since it allows you to search the current project/workspace. Again, it's super useful if you need to rename a parameter that you know is being used across multiple files
# Edit the current file

## Select all
⌘ + A
This might seem obvious since it's the same used across multiple apps, but I'm adding it here because it's needed for some of the upcoming commands. There's not much to say to it.

## Change language mode
⌘ + K + M

Having the correct language selected brings (at least) two big advantages: intelliSense, and ability to format

VSCode can easily determine the correct language you are using by looking at the file extension. So, if you open a .json file, it should be automatically formatted to display the correct syntax and highlights for JSON. 
What if you don't have a file yet? When you copy/paste content, it will (most of the time) correctly infer what's the language it's written on. 
So when will this be useful?
Mostly in two scenarios: 
- I open a new tab and start working on it right away 
	- Because I want to have IntelliSense or whatever visual helper it provides
	- When I copy/paste content on a new tab that is either not recognized, or VSCode assumes the wrong language

## Format
Select section + ⌘ + K + ⌘ + F

For this to work, you must select the correct language mode. This is _amazing_ when you are working on long, unformatted files like JSON.
I combine this with *select all* (⌘+A) to format the whole document. So, the final combination is ⌘+A + ⌘ + K + ⌘ + F.
There's a dedicated shortcut to format the whole document (⌥ + ⇧ + F). However, it implies knowing (yet) another combination. Due to my muscle memory, I find it easier to use format selection after selecting everything.

( GIF formatting a JSON file )

## Comment/Uncomment selected section
⌘ + K + C / ⌘ + K + U

Oh the amount of time I spend commenting/uncommenting code because I'm testing something. If your workflow is something like: write code -> test -> comment piece of code -> test -> uncomment and comment other section -> repeat, then these two shortcuts are a must!

( GIF of comment/uncomment )

## toggle word wrap
⌥+Z
If you are working on a smaller screen, or if your text/code is super long, you'll need to scroll sideways to be able to see the rest of the content. That is unless you toggle wrap mode. Instead of creating a really long line of text, it moves the rest of the content to the following line. This is purely visual and doesn't affect the number of lines on a file

( GIF of toggling word wrap)

## Multi line cursor select
⌘ + ⌥ + ⇧ + direction

I don't use this one as much as the rest, but when I need to add the same content to multiple lines at the same column position, it does wonders and saves so much time!

To give you a practical example with terraform (don't worry, you don't need to know terraform!): let's say that I have some resources I want to remove from the state. Running `terraform state list` outputs the following list
```
random_integer.priority[0]
random_integer.priority[1]
random_integer.priority[2]
random_integer.priority[3]
random_integer.priority[4]
random_integer.priority[5]
random_integer.priority[6]
random_integer.priority[7]
random_integer.priority[8]
random_integer.priority[9]
```

The syntax to remove a resource from the state is by doing `terraform state rm <name of the resource>
With this, I can go to the beginning of the list, use the `⌘ + ⌥ + ⇧ + arrow down` and add `terraform state rm`.


You can test this with the [terraform_state_sample.txt]() file

(GIF of an example for terraform state rm command)

This is also achievable using the mouse if you prefer by hitting ⌥ + ⇧ + mouse click to place the cursor where desired. But who takes their hands out of the keyboard anyway?!

# Other

## Open command palette
⌘ + ⇧ + P

This can be seen as a "default" go-to whenever I want to run/do something but don't know the shortcut or don't want to click around. My most used case is whenever I want to merge content from a branch into my current working branch. I simply hit ⌘ + ⇧ + P and type merge. Then select the branch, and voilá!

But it's also the place for many other commands, such as the themes, open settings, and whatever commands your extensions support.


# Wrap up

Whether you are a new VSCode user or you have been using this for years, I hope that you find any of these commands useful. I know that some of them might be hard to memorize, but the more you start using them, the more natural it becomes. I rely so much on them and muscle memory that there are many times that I want to share some shortcuts with someone, and I completely forget what the correct keys are.
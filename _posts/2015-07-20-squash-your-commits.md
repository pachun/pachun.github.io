---
layout: post
title: "Squash Your Commits"
tags: ["Git", "Diligent Maintenance"]
---

When I was introduced to the concept of squashing commits, I had a difficult
time accepting it. I had been using git as a commit history
time machine and I didn't like the squash workflow because it reduced my time machine's
granularity.

I wasn't committing enough. My commits were a collection of changes with vague
messages, rather than concise changes with descriptive messages. If I had known
how to make better commits, the idea of squashing might have seemed less crazy.

As you're working on a feature or bug, you should be committing pretty
frequently. For example, if you're changing the name of a class's instance
variable, make that its own commit.

Every task you set out to complete should be a composition of similarly small
commits. I like to leave those commits un-squashed when I submit pull requests,
because I feel it helps reviewers follow the coder's train of thought.

Once everyone agrees the pull request is up to par, I squash the commits I made,
rebase them on top of master, and then merge them to master.

Looking back at the git log, you'll be glad you squashed. As you're working
through a task, it's good
to have some commit granularity in case you break something and need to hop
around. However, once a task is complete, you probably don't want to look at the
log and see a variable name change commit, a file name change commit, and ten
others like that.

You'll probably want to see just one commit, encapsulating the overarching task.
With a good commit message, and well-written tests, you shouldn't need the
individual commits anymore. If it turns out that code isn't needed anymore, you
only need to revert one commit.

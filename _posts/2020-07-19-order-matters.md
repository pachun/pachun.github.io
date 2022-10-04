---
layout: post
title: Order Matters
author: Nick Pachulski
tags: ["Agile", "Diligent Maintenance"]
---

Many of us split development work into segments called user stories. User stories deliver value. There should be no point at which a story is completed and no new value is delivered.

Let's build a Twitter clone...

- sign up
- sign in
- post thoughts
- like other's thoughts

The order of these (alleged) stories is in concert with our ultimate vision for the end user's experience.

This isn't the order in which we should build our app.

Let's say that we decide to build our app in this order. Let's also stipulate that we convinced some rich strangers to fund our app with some "market research indicates the world needs another twitter" pitch.

We build the sign up and sign in flows.

> Shit! We're of cash. Computer people are expensive...

> Mr. Funder, look at this progress! May we have some more money, please?

Mr. Funder was silly enough to fund another Twitter clone, but there's a good chance he's wiser than to throw more resources at an effort that's created no value.

## Order Matters

- Show Thoughts
- Post Thoughts
- Like Other's Thoughts
- Sign Up

This is a better order in which to build our app.

Aside from reordering things, you'll notice we've split the _post thoughts_ story out into two new stories: _show thoughts_ and _post thoughts_. We also got rid of the _sign in_ story.

## Show Thoughts

We don't need to build a form for collecting people's thoughts to show a list of thoughts someone's already had.

> Whose thoughts?

Pick someone. It doesn't matter who.

We will show a list of our friend Tina's thoughts to complete this story. Write a couple down and stick them in the app.

People can see Tina's thoughts. Value added.

## Post Thoughts

Add a text field and a button. Clicking the button adds any entered text to the list of thoughts.

People can see Tina's _new_ thoughts. Value added.

## Like Other's Thoughts

Let's assume there's a product requirement stating you cannot "like" anything in our own list of thoughts. For exmaple, Tina cannot click the like button beside a thought she's posted.

We need a new user account to complete this story. Signing in is not a story; It alone doesn't add any new value. The _like other's thoughts_ story creates value and requires separate users, so the complexity of having separate users is driven out here.

We'll create a sign in screen, seed two unchangeable user accounts (one for Tina and one for someone else), and add a like button by each thought to complete this story.

The two users can like each other's thoughts. Value added.

## Sign Up

Until this point, we've created an app which creates value for a couple specific people. This story will allow _anyone_ to share and like thoughts.

Value added.

## This is a Tough Mental Shift

Moving people away from an order-stories-by-user-experience disposition to an order-by-value mentality is hard. There's a trick to it; When does your iPhone, Android, browser, or whatever _tell you_ something? Start there.

Most people unlock their phones and open their browsers to learn things. Nobody has their iPhone programmed to have Siri _ask them_ questions.

Some people perceive value in asking users questions, so that they can then ask them more finely tuned questions, based on the previous answer.

> What's your zip code?

> Thanks! Now which of these service providers would you like to use?

This isn't value.

We should choose someone whose zip code and favorite available service provider we already know. This gets us to the value creating bit immediately.

Always create value.

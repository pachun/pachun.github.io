---
layout: post
title: "Create New Expo Projects with Some Pep"
author: Nick Pachulski
tags: ["React Native", "Expo", "Typescript", "Prettier", "Eslint"]
excerpt_separator: <!--end-of-excerpt-->
---

[Expo](https://expo.dev) sets you up with a new [React Native](https://reactnative.dev) project that will run natively on Android, iOS, and in the browser with a single codebase.
You can also put that same code in an [Electron app](https://www.electronjs.org) to get it running as Mac and Windows desktop applications. <!--end-of-excerpt-->

Beginning work on a new idea is an exciting time and every so often I find myself creating a new Expo project, enthusiasm abound.
Although it's usually been a while since I last kicked off a new Expo project, so I'll cruise on over to the "Beginning Expo" docs to remind myself how to get started. Found it!

```bash
npx create-expo-app my-app
```

Works perfectly! Moving on! Let's get into the code.

... Wait a second ...

This is an `App.js` file.
I wanted to use typescript.
While I'm sure there's a way to add typescript to an existing Expo project, I'm almost certain there's a way to generate a new project and have Expo set that up for me.
I haven't made any changes to this project yet and letting Expo do stuff for me is ~~almost~~ _always_ easier.

Lemme try again...

```bash
rm -rf my-app
npx create-expo-app my-app --template blank-typescript
```

Ah, much better. Now let's get back into the code.
Though, I'm noticing something really annoying...
I'm expecting Vim to update this sloppy edit I made when I save the file.

<!-- {% raw %} -->
```
const App = () =>
  (
    <View style={styles.container}>
      <Text style={{fontWeight: 'bold', fontSize: 22, textAlign: 'right', }} numberOfLines={1}>Open up App.tsx to start working on your app!</Text>
      <StatusBar style="auto" />
    </View>
  )
```
<!-- {% endraw %} -->

... should just become ...

<!-- {% raw %} -->
```
const App = () => (
  <View style={styles.container}>
    <Text
      style={{ fontWeight: "bold", fontSize: 22, textAlign: "right" }}
      numberOfLines={1}
    >
      Open up App.tsx to start working on your app!
    </Text>
    <StatusBar style="auto" />
  </View>
)
```
<!-- {% endraw %} -->

... When I save the file.

We need to install [Prettier](https://prettier.io).

```bash
yarn add -D prettier
```

Installing prettier reveals I have an npm lockfile - but I like yarn.
I wanted to use yarn.
Should I switch to yarn - or again, just start over and let Expo do it?
I think either option is just as easy at this point but we'll start again and let Expo handle it.

```bash
rm -rf my-app
yarn create expo-app my-app --template blank-typescript
```

Super! Now we'll write our `.prettierrc`

```
{
  "semi": false,
  "singleQuote": false,
  "trailingComma": "all",
  "arrowParens": "avoid",
  "quoteProps": "consistent"
}
```

Back to it!

... Wait ...

I've been hacking around and it turns out I have been typing variables with typescript's `any`/`unknown` types and it's just humming along, not caring. I also have several defined but unused variables and imports. I prefer to have my editor shout at me for those things so I don't commit cruft. I need to configure typescript and setup eslint. Woof.

I remember typescript being easier to setup (from the last time I did it), so we'll do that first.
I already have a `tsconfig.json` file that was generated by Expo, but I prefer a unique set of rules.
Let's go check out a project I worked on recently to see which options I've discovered that I like.

```
{
  "extends": "expo/tsconfig.base",
  "compilerOptions": {
    "strict": true,
    "allowJs": true,
    "esModuleInterop": true,
    "jsx": "react-native",
    "lib": [
      "DOM",
      "ESNext"
    ],
    "moduleResolution": "node",
    "noEmit": true,
    "resolveJsonModule": true,
    "skipLibCheck": true,
    "target": "ESNext",
    "baseUrl": "src"
  }
}
```

Ok, all good. Wait a second. That line: `"baseUrl": "src"` ... It allows for absolute imports like this:

```
import MyComponent from "components/MyComponent"
```

... instead of doing ...

```
import MyComponent from "../../components/MyComponent"
```

But I also remember the setup for that isn't only done in the `tsconfig.json` file - I also have to tell my `babel` config how that will work and eventually `eslint` will also need to know too... Ok so let's omit that line for now and dig into the git history of a recent project to see how I added typescript, eslint and absolute imports with discrete commit messages for each change.

I think you get it.
The struggle continues.

# Enter pep

[Pep](https://github.com/pachun/pep) sets up prettier, typescript, eslint, react navigation, and absolute imports in discrete commits with small diffs and reasonable messages on top of the original commit supplied by Expo, when you create a new typescript project with yarn instead of npm.
Ya know, the way you'd do it if you were doing it.

Other prepackaged starter-kits out there claim to build "on top" of the official package they "enhance", but they're done in a way that makes me uncomfortable; They deviate too far from the actual official starting point that's popular and has community support.

Pep also deviates from it's baseline "thing" (the original Expo project's commit) but the things it touches are clear; If there's an issue with your `pep` project, it'll be easy to discern if the problem is coming from something `pep` changed or something that's sincerely an issue with the baseline Expo project.

It's nice to have the popularly used, well-known thing I'm working with (like Expo) instantiated directly as the first commit in the git history with any changes atop that commit.
It's also nice not having to put your creativity and enthusiasm on hold while you dig around the internet trying to remember how to set up your tools.

<img src="https://i.imgur.com/XlEyADo.png" width="650"/>

That's why I made pep.
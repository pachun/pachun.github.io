---
layout: post
title: "Composing React Providers with Differing Value Prop Types in a Type-Safe way with Typescript"
author: Nick Pachulski
tags: ["React", "Functional Programming"]
excerpt_separator: <!--end-of-excerpt-->
---

There's a common complaint - not a problem, per se - that people run into when building applications which use React Contexts to share state.

<!--end-of-excerpt-->

<blockquote class="twitter-tweet" data-conversation="none" data-theme="dark"><p lang="en" dir="ltr">every React doom tree must have obligatory hadouken <a href="https://t.co/VHej94qn2w">pic.twitter.com/VHej94qn2w</a></p>&mdash; swyx (@swyx) <a href="https://twitter.com/swyx/status/1644124125148110849?ref_src=twsrc%5Etfw">April 6, 2023</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Most people who use contexts in React create a bunch of them for performance reasons. It's a good idea to make your contexts specific because all the consumers of a given context will rerender (causing their children to rerender) whenever that context's value changes.

If you're creating specific contexts you'll eventually end up with this sideways-mountain-looking view hierarchy. (All the examples posted here are written in React Native, but the concept we're interested in explaining in this post can be applied to react-only projects as well).

```react
import React from "react";
import { Text, View } from "react-native";

const NameContext = React.createContext("");
const AgeContext = React.createContext(undefined);
const HeightInInchesContext = React.createContext(0);

const App = () => {
  return (
    <NameContext.Provider value={"Nick"}>
      <AgeContext.Provider value={32}>
        <HeightInInchesContext.Provider value={72}>
          <PersonalDetails />
        </HeightInInchesContext.Provider>
      </AgeContext.Provider>
    </NameContext.Provider>
  );
};

const PersonalDetails = () => {
  const name = React.useContext(NameContext);
  const age = React.useContext(AgeContext);
  const heightInInches = React.useContext(HeightInInchesContext);
  return (
    <View style={ { flex: 1, justifyContent: "center", alignItems: "center" }}>
      <Text>Name: {name}</Text>
      <Text>Age: {age}</Text>
      <Text>
        Height: {heightInInches}
        {'"'}
      </Text>
    </View>
  );
};

export default App;
```

It's not a problem. It's just annoying. Especially if you're using prettier with a maximum line length set. Fortunately, we can compose the providers to work around the issue.

```react
const ComposedProviders = ({ providersAndValues, children }) =>
  providersAndValues.reduceRight(
    (acc, providerAndValue) => (
      <providerAndValue.provider value={providerAndValue.value}>
        {acc}
      </providerAndValue.provider>
    ),
    children
  );

const App = () => {
  const providersAndValues = [
    {
      provider: NameContext.Provider,
      value: "Nick",
    },
    {
      provider: AgeContext.Provider,
      value: 32,
    },
    {
      provider: HeightInInchesContext.Provider,
      value: 72,
    },
  ];

  return (
    <ComposedProviders providersAndValues={providersAndValues}>
      <PersonalDetails />
    </ComposedProviders>
  );
};
```

Everything looks great to this point - but so far we've been writing javascript and we like Typescript. Just getting that tiny bit of demo code together for the purpose of writing this blog post was a PITA without typescript. [However, getting the provider-composing code to work well with Typescript (in an actual type-safe way, e.g. avoiding the use of the `any` type) was an ordeal](https://stackoverflow.com/questions/78176284/composing-react-providers-with-value-props-in-typescript). Some providers don't accept `value` props. Some do. The ones that do, accept different types of data.

Now, for my aha moment 🙇: To get this composition working well with Typescript, we can provide a common interface for all of the providers, so that Typescript can `reduceRight` over the list of providers without [needing to use the `any` type or other overly-complex and contrived type definitions to define the data type of each provider's value prop, which may or may not be present, and if it is, could be the shape of any of the context's types](https://stackoverflow.com/a/77152168/1137752).

```react
export type Provider = ({
  children,
}: {
  children: React.ReactElement | React.ReactElement[]
}) => React.ReactElement
```

Obviously, the providers provided (🤦) to us when we do `AgeContext.Provider` return a provider that expects a value prop, so how do we get the provider to fit the `Provider` type we've created? More composition.

Wrap each `Context.Provider` in a new component, defined by us, which initializes its state internally and conforms to our `Provider` type from above. Altogether, our finished app with safely-typed and composed providers becomes:

```react
import React from "react"
import { Text, View } from "react-native"

type Children = React.ReactElement | React.ReactElement[]
type Provider = ({ children }: { children: Children }) => React.ReactElement

const NameContext = React.createContext<string>("")
const AgeContext = React.createContext<number>(0)
const HeightInInchesContext = React.createContext<number>(0)

const NameProvider: Provider = ({ children }) => (
  <NameContext.Provider value={"Nick"}>{children}</NameContext.Provider>
)

const AgeProvider: Provider = ({ children }) => (
  <AgeContext.Provider value={32}>{children}</AgeContext.Provider>
)

const HeightInInchesProvider: Provider = ({ children }) => (
  <HeightInInchesContext.Provider value={72}>
    {children}
  </HeightInInchesContext.Provider>
)

const ComposedProviders = ({
  providers,
  children,
}: {
  providers: Provider[]
  children: React.ReactElement
}): React.ReactElement =>
  providers.reduceRight((acc, Provider) => <Provider>{acc}</Provider>, children)

const App = (): React.ReactElement => {
  return (
    <ComposedProviders
      providers={[NameProvider, AgeProvider, HeightInInchesProvider]}
    >
      <PersonalDetails />
    </ComposedProviders>
  )
}

const PersonalDetails = (): React.ReactElement => {
  const name = React.useContext(NameContext)
  const age = React.useContext(AgeContext)
  const heightInInches = React.useContext(HeightInInchesContext)
  return (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      <Text>Name: {name}</Text>
      <Text>Age: {age}</Text>
      <Text>
        Height: {heightInInches}
        {'"'}
      </Text>
    </View>
  )
}

export default App
```

The key part here is:

```react
type Children = React.ReactElement | React.ReactElement[]
type Provider = ({ children }: { children: Children }) => React.ReactElement

// ...

const NameProvider: Provider = ({ children }) => (
  <NameContext.Provider value={"Nick"}>{children}</NameContext.Provider>
)

const AgeProvider: Provider = ({ children }) => (
  <AgeContext.Provider value={32}>{children}</AgeContext.Provider>
)

const HeightInInchesProvider: Provider = ({ children }) => (
  <HeightInInchesContext.Provider value={72}>
    {children}
  </HeightInInchesContext.Provider>
)
```

It's nice that each Provider we define initializes its own state, rather than initializing all the different provider's states in the `App` component, as we'd done earlier in the plain javascript example. Every provider conforms to our self-defined `Provider` type, allowing us to more easily `reduceRight` over the providers and compose them.

```react
const ComposedProviders = ({
  providers,
  children,
}: {
  providers: Provider[]
  children: React.ReactElement
}): React.ReactElement =>
  providers.reduceRight((acc, Provider) => <Provider>{acc}</Provider>, children)
```

This permits us to go from this:

```react
<NameContext.Provider value={"Nick"}>
  <AgeContext.Provider value={32}>
    <HeightInInchesContext.Provider value={72}>
      <PersonalDetails />
    </HeightInInchesContext.Provider>
  </AgeContext.Provider>
</NameContext.Provider>
```

To this (in a type-safe way):

```react
<ComposedProviders
  providers={[NameProvider, AgeProvider, HeightInInchesProvider]}
>
  <PersonalDetails />
</ComposedProviders>
```

🥳🍾

Well, I like it.

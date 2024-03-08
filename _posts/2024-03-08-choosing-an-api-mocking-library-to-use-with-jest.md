---
layout: post
title: "Choosing an API Mocking Dependency to use with Jest"
author: Nick Pachulski
tags: ["React Native", "Expo", "Testing", "Jest"]
excerpt_separator: <!--end-of-excerpt-->
---

Recently I've been working on a universal Expo app (iOS, Android & web) intended to help my hockey team keep track of our player and game stats, track who's RSVP'd to our weekly games, and so on.

To keep track of all those things, the Expo app communicates with a restful Ruby on Rails API. I decided, for typical reasons which aren't the subject of this post, to mock that rails API as I test drove the React Native app.

<!--end-of-excerpt-->

My initial thought when deciding which library to use was that it'd be best to find a dependency which actually spun up a real server and allowed me to define its behavior in the jest tests rather than mocking fetch or axios, so that the tests wouldn't be married to whichever network-request-making dependency I chose.

I love the idea of completely decoupling my tests' pass or fail state with the implementation details of the production code ... including the stack. Test driving an app this way allows you to completely delete your production code, choose a new technology for your production stack (Rails, Phoenix, Django, Spring, Exprss, etc) and re-arrive at a _very_ similar product using the existing tests for the old stack against whichever new stack you choose. We actually did that once at work, in 2016, at Pivotal Labs - and it was pretty awesome how well it worked.

I'll regret being so married to concept later. Not due to an unforseen shortcoming of the benefits described above, but because of sneaky problem that came with choosing a library that offered this sort of behavior.

Enter Mock Service Worker (MSW).

> [Mock Service Worker is an API mocking library that allows you to write client-agnostic mocks and reuse them across any frameworks, tools, and environments.](https://mswjs.io).

I'm not sure how it works (whether it's actually spinning up a server to intercept requests), but it's network-request-library agnostic. That's at least close to what I wanted - and possibly exactly what I was looking for if it is actually spinning up that server in the background for me.

To cut right to the chase, I don't like MSW's API. To be fair to MSW, I'm not doing my homework here. It's possible I was just using it all wrong. I realized I was spending 90% of the time I spent writing code on writing wrappers around MSW's API to get what I felt should be default behavior, by default. When I realized that, I looked for an alternative to MSW with those defaults in mind, [found one (albeit, not "client-agnostic"; More on this dependency later in the post)](https://github.com/nock/nock), and replaced MSW with the new dependency in less than an hour. The change was 90% deletions and I feel that my tests read better now, too.

I also realized that in my previous two side projects, the majority of all the code written (including production code 😬) was MSW-wrapping. I've been spending most of my time fixing-up a dependency for my current needs, all for the benefit of being able to possibly benefit in the future (e.g. change the whole stack). I'm a little embarrassed that [I fell into the same trap that I've ranted about having to clean up after in the past](https://pachulski.me/focus-and-do-as-little-as-is-required). When you realize you're losing an outsized amount of time now, in order to compensate for an imagined problem that may never occur in the future, you're just being wasteful.

Maybe that happened because I didn't take the lesson of doing "as little as is required" as seriously with my test code as I did with my production code. I really try to, even in my tests. I think the more likely reason is that it also happened over time. As I began writing more and more tests with MSW, the complexity of the wrappers I'd been writing to make what I felt should be default behavior default (and I was also trying to improve the readability of my tests through those wrappers) took more and more time, over time. I didn't realize there was a problem until I'd wasted too much time.

Take, for example, testing that when a button is tapped, a user is sent a confirmation code to enter into the app, to confirm who they are:

```react
const sendTextMessageConfirmationCode = async (): Promise<void> => {
  await fetch(
    `${Config.apiUrl}/players/${player.id.toString()}/send_text_message_confirmation_code`,
  )
}

// ...

<ReactNative.Button
  testID="This is Me Button"
  title="👋 This is Me"
  onPress={sendTextMessageConfirmationCode}
/>
```

We want to make sure that when the button is tapped, an API request is made to send users (hockey players, here) their confirmation code, trusting that the API at the given path is also tested to do its part (yeah, the testing "seem" there isn't ideal; but after years of working on products that consume APIs, this is the strategy I've generally come to like the most, for reasons that could occupy a whole nother post).

The test for that, using MSW (and jest, expo-router-testing-library) looks like this:

```react
describe("viewing a player", () => {

  // ...

  describe("when the player is done loading from the api", () => {

    it("shows a This Is Me button", async () => {
      // ...
    }

    describe("tapping the This Is Me button", () => {
      it("sends a text message to the players phone number containing a 6-digit code", async () => {
        const player = playerFactory({ id: 1 })

        const server = MSW_NODE.setupServer()

        let urlsOfApiRequests: string[] = []
        server.events.on("request:match", ({ request }) => {
          urlsOfApiRequests = [...urlsOfApiRequests, request.url]
        })

        server.use(
          MSW.http.get(
            `${Config.apiUrl}/players/1`,
            () => {
              return MSW.HttpResponse.json(player)
            },
            { once: true },
          ),
          MSW.http.get(
            `${Config.apiUrl}/players/1/send_text_message_confirmation_code`,
            { once: true },
          ),
        )

        server.listen({ onUnhandledRequest: "error" })

        try {
          ERTL.renderRouter("src/app", { initialUrl: "/players/1" })

          await ERTL.waitFor(() => {
            expect(ERTL.screen).toShowTestId("This is Me Button")
          })

          await ERTL.waitFor(() =>
            ERTL.fireEvent.press(ERTL.screen.getByTestId("This is Me Button")),
          )
        } finally {
          server.close()
        }q

        expect(urlsOfApiRequests).toContain(
          `${Config.apiUrl}/players/1/send_text_message_confirmation_code`,
        )
      })
    })
  })
})
```

I have a few nitty things to say about this.

1.  There's a lot of setup code. There are 45 lines of code there. If you remove the code that's solely dedicated to setting up MSW, the test becomes 13 lines. I like my tests to read like stories, describing the scenario a user is in and asserting what should happen next. When each test's size is tripled (and they get worse, as you mock more and more requests) it becomes tougher to follow along with the story, and easier to get bogged down in what those pretty imperative msw-configuring lines are doing.

2.  This is a privileged gripe, but I really dislike mutating variables. We literally don't ever mutate variables at work and I have never needed to in any of my personal projects, so this little, really imperative-looking snippet really bothers me:

        let urlsOfApiRequests: string[] = []
        server.events.on("request:match", ({ request }) => {
          urlsOfApiRequests = [...urlsOfApiRequests, request.url]
        })

3.  I feel, anyway, that MSW should implicitly assume that each request I tell it to mock should only be mocked once. Having to do it explicitly seems like a less sensible default. Again, maybe those decisions were made intentionally and for good reasons. I don't know what those reasons are and I didn't look into what those reasons might be, but in my case, I feel the default should be the other way around (MSW should assume a mocked request should only be mocked once, not requiring `{ once: true }` whenever you don't want it mocked forever).

        { once: true }

4.  I don't like that you need to explicitly tell MSW that if a network request is made, which wasn't provisioned for by a mock, it should throw an error. That should also be the default behavior, IMO.

        server.listen({ onUnhandledRequest: "error" })

5.  Nobody likes test pollution. If this test fails, say for example, here:

        expect(ERTL.screen).toShowTestId("This is Me Button")

    Because we haven't added the "This is Me Button" yet, then the server that was setup for this test stays open, blocking MSW servers that are setup in and for other tests from starting, and causing all other tests that use MSW server-thingers to fail. So, we need this `try { ... } finally { ... }` section, in every test... I'd really prefer that that was just taken care of for me. MSW is a library for writing tests that feels like it didn't consider some practical test-writing concerns (and again, maybe I'm totally wrong and misusing or misunderstanding MSW).

        try {
          // ...
        } finally {
          server.close()
        }

I wrote a generic helper wrapper around MSW to address all of the concerns that I listed above.

```react
it("sends a text message to the players phone number containing a 6-digit code", async () => {
  const player = playerFactory({ id: 1 })

  // mockApi() is the wrapper function
  const urlsOfApiRequests = await mockApi({
    mockedRequests: [
      {
        method: "get",
        route: "/players/[id]",
        params: { id: 1 },
        response: player,
      },
      {
        method: "get",
        route: "/players/[id]/send_text_message_confirmation_code",
        params: { id: 1 },
      },
    ],
    test: async () => {
      ERTL.renderRouter("src/app", { initialUrl: "/players/1" })

      await ERTL.waitFor(() => {
        expect(ERTL.screen).toShowTestId("This is Me Button")
      })

      await ERTL.waitFor(() =>
        ERTL.fireEvent.press(
          ERTL.screen.getByTestId("This is Me Button"),
        ),
      )
    },
  })

  expect(urlsOfApiRequests).toContain(
    `${Config.apiUrl}/players/1/send_text_message_confirmation_code`,
  )
})
```

The wrapper removes a good amount of the setup code. You could go even crazier by creating a more specific mocking method to abstract away the api details behind a well-named function, and I toyed with the idea but think I prefer clarity over brevity here. The mutated variable is hidden from us. It's not actually gone - but at least I don't have to look at it or paste it into every test. The wrapper defaults to mocking each request once, without needing to explicitly state that. It also defaults to erroring when an unprovisioned-for API request is made. Finally, it also takes care of preventing test pollution from occuring by ensuring that the server is always closed, regardless of whether the test passes or fails.

I feel this is nicer than the default, but it was a little over 100 lines of code, and because I've got it's arguments strongly typed with Typescript, each no endpoint I want to mock requires a couple new type definitions to be added to the wrapper. Here's an example of one of a couple of them:

```react
export type MockedPlayersRequestResponse = Player[] | "Network Error"
export interface MockedPlayersRequest {
  method: "get"
  route: "/players"
  response: MockedPlayersRequestResponse
}

export type MockedGamesRequestResponse = Game[] | "Network Error"
export interface MockedGamesRequest {
  method: "get"
  route: "/games"
  response: MockedGamesRequestResponse
}

export type MockedRequest =
  | MockedPlayersRequest
  | MockedGamesRequest
```

As I abstracted away what I felt should be defaults, and added more and more endpoint mocks, I realized that I've been spending an outsized amount of my time working around MSW.

Enter [nock](https://github.com/nock/nock). The test becomes:

```react
it("sends a text message to the players phone number containing a 6-digit code", async () => {
  const player = playerFactory({ id: 1 })

  const mockedRequests = nock(Config.apiUrl)
    .get("/players/1")
    .reply(200, player)
    .get("/players/1/send_text_message_confirmation_code")
    .reply(200, {})

  ERTL.renderRouter("src/app", { initialUrl: "/players/1" })

  await ERTL.waitFor(() => {
    expect(ERTL.screen).toShowTestId("This is Me Button")
  })

  await ERTL.waitFor(() =>
    ERTL.fireEvent.press(ERTL.screen.getByTestId("This is Me Button")),
  )

  expect(mockedRequests.isDone()).toBe(true)
})
```

Nock addresses all of the concerns I addressed with my wrapper function, but now I don't have to maintain mine; I can delete it. Nock also makes the test read better, in my opinion. It's also more concise then mine and also doesn't abstract away important details about how we're mocking the network.

---
layout: post
title: "Syncing State with AsyncStorage"
author: Nick Pachulski
tags: ["React Native"]
excerpt_separator: <!--end-of-excerpt-->
---

I have a few [providers](https://react.dev/reference/react/createContext#provider) which initialize state, shove it in a context, and then ensure that the state is synchronized with AsyncStorage so that if the app is quit and restarted, the context's state is rehydrated from AsyncStorage. A few examples of the types of state I tend to treat this way are API tokens and user IDs.

<!--end-of-excerpt-->

When I realized that I'd been doing this a lot in the past, and twice in my current project (for an API token and user ID), I maybe got too clever. I pulled out the functionality to sync the state with AsyncStorage into it's own hook.

```react
const [thing, setThing] = useStateSyncedWithAsyncStorage<T>(asyncStorageKey: string, transformer: (thing: T) => string): [T | null, (thing: T) => Promise<void>]
```

Until someone lets me know why that's terribly wrong, I'm pretty happy with the result.

```react
import React from "react"
import AsyncStorage from "@react-native-async-storage/async-storage"

const useStateSyncedWithAsyncStorage = <T>(
  asyncStorageKey: string,
  transformer: (value: string) => T,
): [T | null, (thing: T) => Promise<void>] => {
  const [thing, setThingInState] = React.useState<T | null>(null)

  const setThingInStateAndAsyncStorage = async (thing: T): Promise<void> => {
    setThingInState(thing)
    await AsyncStorage.setItem(asyncStorageKey, (thing || "").toString())
  }

  React.useEffect(() => {
    const setStateValueFromAsyncStorageValueOnMount =
      async (): Promise<void> => {
        const thingInAsyncStorage = await AsyncStorage.getItem(asyncStorageKey)
        setThingInState(transformer(thingInAsyncStorage || ""))
      }
    setStateValueFromAsyncStorageValueOnMount()
  }, [setThingInState, asyncStorageKey, transformer])

  return [thing, setThingInStateAndAsyncStorage]
}

export default useStateSyncedWithAsyncStorage
```

AsyncStorage can only hold strings, so when we get a value out of AsyncStorage and try to put it in a typed useState value, typescript will complain. That's where the transformer parameter helps. If we're storing a `number` in our `useState`, then we need a way to convert that thing from a string (when we get it out of AsyncStorage) back to it's typed `useState` type. Here's an example of using this hook to store a number on context and keep it synced with AsyncStorage across app launches.

```react
import React from "react"
import type { Provider as ProviderType } from "types/Provider"
import emptyPromiseReturningFunctionForInitializingContexts from "helpers/emptyPromiseReturningFunctionForInitializingContexts"
import useStateSyncedWithAsyncStorage from "hooks/useStateSyncedWithAsyncStorage"

export interface UserIdContextType {
  userId: number | null
  setUserId: (userId: number) => Promise<void>
}

export const UserIdContext = React.createContext<UserIdContextType>({
  userId: null,
  setUserId: emptyPromiseReturningFunctionForInitializingContexts,
})

const UserIdProvider: ProviderType = ({ children }) => {
  const [userId, setUserId] = useStateSyncedWithAsyncStorage<number>(
    "User ID",
    Number,
  )

  return (
    <UserIdContext.Provider value={{ '{{' }} userId, setUserId }}>
      {children}
    </UserIdContext.Provider>
  )
}

export default UserIdProvider
```

Maybe I got too clever. For now, I think I like it.

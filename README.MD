#  PokeDex App

## App connection to the pokeapi.co, search for a pokemon

## Features

### Steps, 
1. connect to API, get pokemon, get sprite or official artwork, get location and area
2. show a continuous list of pokemon using Task and async/await
3. allow users to select a <single> pokemon, to view its details
4. search the results in the pokedex summary filtering the list.


### uses clean swift, and tests, test swiftui with views iewinspector, implemented a skeleton UITest for end-to-end tests. 
    Light swift6 support, not strict swift 6 concurrency, AsyncImages, Generic APIService for extending to different endpoints.
## Running,
Change the development Team, build and run. 3 Targets exists,
- Main App - Pokedex
- Unit and ViewInspect Testing - PokeDexTests
- UITesting - PokeDexUITests 

## Depencies 
2. viewInspector, this is a testing library that allows you to inspect the SwiftUI view hierarchy and perform Unit test against your view.


## Discovery
I wanted too use this take home test to explore clean swift in a fully SwiftUI project. Mainly dynamic state such as the list, in a traditional Clean Swift approach there is a ViewController that will render the new view after a interaction calls the presenter. I was able to use the @Observable SwiftUI marco instead of a ViewController. I update the objectState in the presenter instead. I started to invistigate NavigationStack but as the view is only one level deep a Enviornment dismiss was all that was needed. I would like to explore the Clean swift's Router pattern and the NavigationStack a bit more in a "wider" project.

1. PokeApiGetService, this is a network request service that fetches the types from the PokeApi.co
2. PokemonData, this is a cache of the types previously requested and saved to userDefaults

## Unit Testing
 using View Inspector and XCTesting we can perform traditional unit testing and with viewInspector we can unit test the Views that will be displayed to the user.
 
## Improvements

working with navigationstack and path state
animation between related views
remove magic numbers and strings, centralize both for reusable and localisation strings
additional accessibility Labels/ accessibility audit
 
### basic DI with a singlton was created but using a mature DI library such as factory would be preferred
### Factory, [on github](https://github.com/hmlongco/Factory)



TODO:
keep readme updated

Interactor support DI, and the Container.shared in pokeServices remains private with a FakeServices and the URLSessionProtocol so that I can return fake pokemon data and an appropriate spies to confirm those functions are being called.
This is a limitation, I've had to include the MockAPIGetService in the main app, the test only classes PokeApiGetRequestSpy should have been directly returned in the compute property `var urlSession` This is where a plugin like Factory is useful as the services can exists in it's shared container on start up. This is a larger piece of work well outside the remit of the Pokedex project, but proper DI or a Factory would be advise in a full scale project

<More Thoughts>
MockPokeGetService feels very anti-pattern. I've worked on projects where a underlying core urlserver existed and would handle all network request. The additon of a MockPockapiGetService shows where this underlying urlserver benefits larger apps as the package could be adapted when running tests, right now I have a Condition checking which target is running and toogle which service to use. Something I see as a limitation.

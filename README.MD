#  PokeDex App

## App connection to the pokeapi.co, search for a pokemon

## Features

### Steps, 
1. connect to API, get pokemon, get sprite or official artwork, get location and area
2. show a continuous list of pokemon using Task and async/await
3. allow users to select a <single> pokemon, to view its details
4. search the results in the pokedex summary filtering the list.


### use clean swift, and tests, test swiftui views iewinspector.

## Depencies 
2. viewInspector, this is a testing library that allows you to inspect the SwiftUI view hierarchy and perform Unit test against your view.


## Discovery
I wanted too use this take home test to explore clean swift in a fully SwiftUI project. Mainly dynamic state such as the list, in a traditional Clean Swift approach there is a ViewController that will render the new view after a interaction calls the presenter. I was able to use the @Observable SwiftUI marco instead of a ViewController. I update the objectState in the presenter instead. I started to invistigate NavigationStack but as the view is only one level deep a Enviornment dismiss was all that was needed. I would like to explore the Clean swift's Router pattern and the NavigationStack a bit more in a "wider" project.

1. PokeApiGetService, this is a network request service that fetches the types from the PokeApi.co
2. PokemonData, this is a cache of the types previously requested and saved to userDefaults

## Unit Testing
 TODO: using View Inspector
 
## Improvements

working with navigationstack and path state
animation between related views
remove magic numbers and strings, centralize both for reusable and localisation strings
additional accessibility Labels/ accessibility audit
 
### basic DI with a singlton was created but using a mature DI library such as factory would be preferred
### Factory, [on github](https://github.com/hmlongco/Factory)

on the HRMC App we use the predecessor [Resolver](https://github.com/hmlongco/Resolver), the start of a new project, the chance to learn something new.

TODO:
keep readme updated

Tests: They are a WIP and do not complie.
I need to overwrite the Container.shared pokeServices with a FakeServices and the URLSessionProtocol so that I can return fake pokemon data and a apprpriate spies to confirm those functions are being called.
When you reconnect the currentPage and nextPage start to fail and you can't pass the last scrolled to pokemone. list gets stuck, need to debug

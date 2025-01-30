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
2. viewInspector


## Discovery
I wanted too use this take home test to explore clean swift in a fully SwiftUI project. NavigationStack needs further deep dive when using the clean swift pattern and it is something I will address in the near future on this project.

### Factory, [on github](https://github.com/hmlongco/Factory)

on the HRMC App we use the predecessor [Resolver](https://github.com/hmlongco/Resolver), the start of a new project, the chance to learn something new.

create the first service by extending the `Container` a factory defined object. I create a FactoryContainer to that will be responsible for registering my dependency objects.

1. PokeApiGetService, this is a network request service that fetches the types from the PokeApi.co
2. PokemonDataTypeCache, this is a cache of the types previously requested and saved to userDefaults

## Unit Testing
 View Inspector not launching to the correct view on the simulator
 
## Improvements

working with navigationstack and path state
animation between related views
remove magic numbers and strings, centralize both for reusable and localisation strings

### UI for the Pokemon Modules

Only pokemon were address for the spoc, further user experince could be made by allowing the user to search the pokemon types and find ones that have an advantage or disadvantage against each other. 
 
### basic DI with a singlton was created but using a mature DI library such as factory would be preferred

TODO:
keep readme updated

manage currentPage, prev and next in observableState.
infinite scroll ( kindof, a bug after view details)
update PokemonSceneView based on observerState
Tests

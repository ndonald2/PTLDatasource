# PTLDatasource
[![Build Status](https://travis-ci.org/PearTreeLabs/PTLDatasource.png?branch=master)](https://travis-ci.org/PearTreeLabs/PTLDatasource)

## Description
Helpers to lighten your view controllers.

## Dependencies
- UIKit

### Optional
- CoreData : PTLFetchedDatasource will not be available if CoreData isn't linked.

## Usage

### Basic Array Datasource

```
// Prepare your table view
[self.tableView registerClass:cellClass forCellReuseIdentifier:identifier];

// Setup your datasource
PTLArrayDatasource *ds = [[PTLArrayDatasource alloc] initWithArray:@[@"Alice", @"Bob", @"Charlie"]];
ds.tabelViewCellIdentifier = identifier
ds.tabelViewCellConfigBlock = ^{ ... }

// Attach it to a table view
self.tableView.dataSource = ds;
```

### Basic Enum Datasource

```
typedef NS_ENUM(NSInteger, MyEnum) {
    MyEnumFoo,
    MyEnumBar,
    MyEnumBaz,
    MyEnumCount
};

...

// Prepare your table view
[self.tableView registerClass:cellClass forCellReuseIdentifier:identifier];

// Setup your datasource
NSIndexSet *indecies = [NSIndexSet initWithIndexesInRange:NSMakeRange(0, MyEnumCount)];
PTLIndexDatasource *ds = [[PTLIndexDatasource alloc] initWithIndecies:indecies];
ds.tabelViewCellIdentifier = identifier
ds.tabelViewCellConfigBlock = ^{ ... }

// Attach it to a table view
self.tableView.dataSource = ds;
```

### Advanced Multiple Datasources

```
// Prepare your table view
[self.tableView registerClass:arrayCellClass forCellReuseIdentifier:arrayIdentifier];
[self.tableView registerClass:indexCellClass forCellReuseIdentifier:indexIdentifier];
[self.tableView registerClass:fetchCellClass forCellReuseIdentifier:fetchIdentifier]

// Setup multiple datasources
PTLArrayDatasource *arrayDS = [[PTLArrayDatasource alloc] initWithArray:@[@"Alice", @"Bob", @"Charlie"]];
arrayDS.tabelViewCellIdentifier = arrayIdentifier
arrayDS.tabelViewCellConfigBlock = ^{ ... }

NSIndexSet *indecies = [NSIndexSet initWithIndexesInRange:NSMakeRange(0, MyEnumCount)];
PTLIndexDatasource *indexDS = [[PTLIndexDatasource alloc] initWithIndecies:indecies];
indexDS.tabelViewCellIdentifier = indexIdentifier
indexDS.tabelViewCellConfigBlock = ^{ ... }

NSFetchedResultsController *frc = ...
PTLFetchedDatasource *fetchDS = [[PTLFetchedDatasource alloc] initWithFetchedResults:frc trackChanges:YES];
fetchDS.tabelViewCellIdentifier = fetchIdentifier
fetchDS.tabelViewCellConfigBlock = ^{ ... }

// Concatenate them
PTLCompositeDatasource *ds = [[PTLCompositeDatasource alloc] initWithDatasources:@[arrayDS, indexDS, fetchDS]];

// Attach to a table view
self.tableView.dataSource = ds;

// Handle datasource changes
[ds addChangeObserver:self];
```

## Known Issues

## Roadmap
- Add unit tests for PTLFetchedDatasource, UITableView extensions, UICollectionView extensions
- Add support for OSX

## License
[MIT](LICENSE.txt)

## Contact
[Brian Partridge](http://brianpartridge.name) - @brianpartridge on [Twitter](http://twitter.com/brianpartridge) and [App.Net](http://alpha.app.net/brianpartridge)
//
//  PTLPeopleFilterViewController.m
//  PTLDatasource
//
//  Created by Brian Partridge on 10/31/13.
//
//

#import "PTLPeopleFilterViewController.h"
#import "UIKit+PTLDatasource.h"
#import "PTLFilteredDatasource.h"

static NSString * const kCellId = @"Cell";

@interface PTLPeopleFilterViewController () <PTLDatasourceObserver, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray *compositedDatasources;
@property (nonatomic, strong) PTLDatasource *datasource;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) PTLFilteredDatasource *searchDatasource;

@end

@implementation PTLPeopleFilterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"People";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellId];

    NSMutableArray *datasources = [NSMutableArray array];
    for (NSString *filename in @[@"heroes", @"villians", @"ladies"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSArray *items = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        items = [items sortedArrayUsingSelector:@selector(compare:)];
        PTLArrayDatasource *datasource = [[PTLArrayDatasource alloc] initWithItems:items];
        datasource.tableViewHeaderTitle = filename;
        [datasources addObject:datasource];
    }
    self.compositedDatasources = datasources;
    PTLDatasource *composite = [[PTLCompositeDatasource alloc] initWithWithDatasources:datasources];
    composite.tableViewCellIdentifier = kCellId;
    composite.tableViewCellConfigBlock = ^(UITableView *tableView, UITableViewCell *cell, id item, NSIndexPath *indexPath){
        cell.textLabel.text = item;
    };
    self.datasource = composite;
    [self.datasource addChangeObserver:self];
    self.tableView.dataSource = composite;

    self.searchDatasource = [[PTLFilteredDatasource alloc] initWithDatasource:self.datasource filter:nil];
    self.searchDatasource.tableViewHideHeadersForEmptySections = NO;

    self.searchDisplayController.searchResultsDataSource = self.searchDatasource;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTapped:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTapped:(id)sender {
    // Randomly add a new item to one of the datasources
    PTLArrayDatasource *datasource = [self.compositedDatasources objectAtIndex:(arc4random() % self.compositedDatasources.count)];
    [datasource addItem:@"Random"];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.searchDatasource.filter = nil;
    } else {
        self.searchDatasource.filter = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
    }
}

#pragma mark - UISearchDisplayDelegate 

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellId];
    tableView.dataSource = self.searchDatasource;
}

#pragma mark - PTLDatasourceObserver

- (UITableView *)tableViewForDatasource:(id<PTLDatasource>)datasource {
    if (datasource == self.datasource) {
        return self.tableView;
    } else if (datasource == self.searchDatasource) {
        return self.searchDisplayController.searchResultsTableView;
    }
    return nil;
}

- (void)datasourceWillChange:(id<PTLDatasource>)datasource {
    [[self tableViewForDatasource:datasource] beginUpdates];
}

- (void)datasourceDidChange:(id<PTLDatasource>)datasource {
    [[self tableViewForDatasource:datasource] endUpdates];
}

- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change atIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = [self tableViewForDatasource:datasource];
    switch(change) {
        case PTLChangeTypeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;

        case PTLChangeTypeRemove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;

        case PTLChangeTypeUpdate:
            // As suggested by oleb: http://oleb.net/blog/2013/02/nsfetchedresultscontroller-documentation-bug/
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;

        case PTLChangeTypeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change atSectionIndex:(NSInteger)sectionIndex {
    UITableView *tableView = [self tableViewForDatasource:datasource];
    switch(change) {
        case PTLChangeTypeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;

        case PTLChangeTypeRemove:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}

@end

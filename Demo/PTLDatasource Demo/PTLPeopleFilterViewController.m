//
//  PTLPeopleFilterViewController.m
//  PTLDatasource
//
//  Created by Brian Partridge on 10/31/13.
//
//

#import "PTLPeopleFilterViewController.h"
#import "UIKit+PTLDatasource.h"

typedef NS_ENUM(NSInteger, SortType) {
    SortTypeName,
    SortTypeAlterEgo,
};

static NSString * const kCellId = @"Cell";

@interface PTLPersonCell : UITableViewCell

@end

@implementation PTLPersonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

@end

@interface PTLPeopleFilterViewController () <PTLDatasourceObserver, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray *compositedDatasources;
@property (nonatomic, strong) PTLDatasource *datasource;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) PTLFilteredDatasource *filterDatasource;
@property (nonatomic, strong) PTLSortedDatasource *sortDatasource;
@property (nonatomic, strong) PTLDatasource *searchDatasource;

@end

@implementation PTLPeopleFilterViewController

- (NSAttributedString *)attributedSearchResultString:(NSString *)string {
    NSString *term = self.searchDisplayController.searchBar.text;
    NSRange range = [string rangeOfString:term options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
    if (!self.searchDisplayController.isActive) {
        return [[NSAttributedString alloc] initWithString:string];
    } else {
        NSDictionary *attributes = @{ NSForegroundColorAttributeName : [UIColor lightGrayColor] };
        NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
        [result addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
        [result addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
        return [result copy];
    }
}

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

    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UISegmentedControl *sortControl = [[UISegmentedControl alloc] initWithItems:@[@"Name", @"Alter Ego"]];
    sortControl.selectedSegmentIndex = SortTypeName;
    [sortControl addTarget:self action:@selector(sortChanged:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortControl];
    self.toolbarItems = @[flex, sortItem, flex];

    __weak typeof(self) weak_self = self;

    [self.tableView registerClass:[PTLPersonCell class] forCellReuseIdentifier:kCellId];

    NSMutableArray *datasources = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"characters" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *charactersByCateogry = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    [charactersByCateogry enumerateKeysAndObjectsUsingBlock:^(NSString *category, NSArray *characters, BOOL *stop) {
        PTLArrayDatasource *datasource = [[PTLArrayDatasource alloc] initWithItems:characters];
        datasource.tableViewHeaderTitle = category;
        [datasources addObject:datasource];

    }];
    self.compositedDatasources = datasources;
    PTLDatasource *composite = [[PTLCompositeDatasource alloc] initWithWithDatasources:datasources];
    composite.tableViewCellIdentifier = kCellId;
    composite.tableViewCellConfigBlock = ^(UITableView *tableView, UITableViewCell *cell, NSDictionary *character, NSIndexPath *indexPath){
        cell.textLabel.attributedText = [weak_self attributedSearchResultString:character[@"name"]];
        cell.detailTextLabel.attributedText = [weak_self attributedSearchResultString:character[@"alter-ego"]];
    };
    self.datasource = composite;
    [self.datasource addChangeObserver:self];
    self.tableView.dataSource = composite;

    self.filterDatasource = [[PTLFilteredDatasource alloc] initWithDatasource:self.datasource filter:nil];
    self.filterDatasource.tableViewHideHeadersForEmptySections = NO;

//    self.sortDatasource = [NSSortDescriptor ]
//    self.sortDatasource = [[PTLSortedDatasource alloc] initWithDatasource:filtered sortDescriptor:sort];

    self.searchDatasource = self.filterDatasource;

    self.searchDisplayController.searchResultsDataSource = self.searchDatasource;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTapped:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Interaction

- (void)sortChanged:(UISegmentedControl *)sortControl {
    // TODO: update the sort descriptor
    NSLog(@"selectedScope = %d", sortControl.selectedSegmentIndex);
    NSSortDescriptor *descriptor = nil;
    switch (sortControl.selectedSegmentIndex) {
        case SortTypeName:
        break;
        case SortTypeAlterEgo:
        break;
        default:
        break;
    }
    self.sortDatasource.sortDescriptors = @[descriptor];
}

- (void)addTapped:(id)sender {
    // Randomly add a new item to one of the datasources
    PTLArrayDatasource *datasource = [self.compositedDatasources objectAtIndex:(arc4random() % self.compositedDatasources.count)];
    [datasource addItem:@"Random"];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.filterDatasource.filter = nil;
    } else {
        self.filterDatasource.filter = [NSPredicate predicateWithFormat:@"(SELF.%K contains[cd] %@) OR (SELF.%K contains[cd] %@)", @"name", searchText, @"alter-ego", searchText];
    }
}

#pragma mark - UISearchDisplayDelegate 

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    [tableView registerClass:[PTLPersonCell class] forCellReuseIdentifier:kCellId];
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

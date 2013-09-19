//
//  PTLArrayDatasourceTests.m
//  PTLDatasource
//
//  Created by Brian Partridge on 7/17/13.
//
//

#import "PTLArrayDatasourceTests.h"
#import "PTLArrayDatasource.h"

@implementation PTLArrayDatasourceTests

- (void)testEmptyArray {
    PTLDatasource *ds = [[PTLArrayDatasource alloc] initWithItems:@[]];
    XCTAssertTrue([ds numberOfSections] == 1, @"Number of sections should be 1 for an empty array.");
    XCTAssertTrue([ds numberOfItemsInSection:0] == 0, @"Number of items should be 0 for an empty array.");
    XCTAssertThrows([ds numberOfItemsInSection:1], @"Number of items should be 0 for the wrong section index.");
    XCTAssertThrows([ds itemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]], @"There are no items in the array");
}

- (void)testSampleArray {
    PTLDatasource *ds = [[PTLArrayDatasource alloc] initWithItems:@[@"Alice", @"Bob", @"Charlie"]];
    XCTAssertTrue([ds numberOfSections] == 1, @"Number of sections should always be 1.");
    XCTAssertTrue([ds numberOfItemsInSection:0] == 3, @"Number of items should be 3.");
    XCTAssertNotNil([ds itemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]], @"There should be an object at index 2");
    XCTAssertEqualObjects([ds itemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]], @"Bob", @"Bob should be at index 1");
}

- (void)testInsertion {
    PTLArrayDatasource *ds = [[PTLArrayDatasource alloc] initWithItems:@[@"Alice", @"Bob", @"Charlie"]];

    [ds addItem:@"David"];
    XCTAssertTrue([ds numberOfItemsInSection:0] == 4, @"Should be able to insert an item");
    XCTAssertEqualObjects([ds itemAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]], @"David", @"David should be at index 3");

    [ds addItemsFromArray:@[@"Eve", @"Fred", @"George"]];
    XCTAssertTrue([ds numberOfItemsInSection:0] == 7, @"Should be able to insert items");
    XCTAssertEqualObjects([ds itemAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:0]], @"Fred", @"Fred should be at index 5");

    XCTAssertThrows([ds insertItem:@"Heidi" atIndex:NSIntegerMax], @"Shouldn't be able to insert into this index");

    [ds insertItem:@"Indiana" atIndex:2];
    XCTAssertEqualObjects([ds itemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]], @"Indiana", @"Indiana should be at index 2");
    XCTAssertTrue([ds numberOfItemsInSection:0] == 8, @"Number of items should be 8");
}

- (void)testRemoval {
    PTLArrayDatasource *ds = [[PTLArrayDatasource alloc] initWithItems:@[@"Alice", @"Bob", @"Charlie", @"David", @"Eve", @"Fred"]];

    [ds removeItem:@"Zelda"];
    XCTAssertTrue([ds numberOfItemsInSection:0] == 6, @"Nothing should have changed");

    [ds removeItem:@"Bob"];
    XCTAssertTrue([ds numberOfItemsInSection:0] == 5, @"Nothing should have changed");
    XCTAssertFalse([ds containsItem:@"Bob"], @"Bob should be long gone");

    XCTAssertThrows([ds removeItemAtIndex:20], @"Should throw for removing form an invalid index");
    XCTAssertTrue([ds numberOfItemsInSection:0] == 5, @"Nothing should have changed");

    [ds removeItemAtIndex:1];
    XCTAssertTrue([ds numberOfItemsInSection:0] == 4, @"Count should have been decremented");

    [ds removeAllItems];
    XCTAssertTrue([ds numberOfItemsInSection:0] == 0, @"Should be empty");
}

- (void)testReordering {
    PTLArrayDatasource *ds = [[PTLArrayDatasource alloc] initWithItems:@[@"Alice", @"Bob", @"Charlie", @"David", @"Eve", @"Fred"]];

    [ds moveItemAtIndex:3 toIndex:4];
    XCTAssertTrue([ds numberOfItemsInSection:0] == 6, @"The size shouldn't have changed");
    XCTAssertEqualObjects([ds itemAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]], @"Eve", @"Eve should now be before David");
    XCTAssertEqualObjects([ds itemAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]], @"David", @"David should now be after Eve");

    ds = [[PTLArrayDatasource alloc] initWithItems:@[@"Alice", @"Bob", @"Charlie", @"David", @"Eve", @"Fred"]];
    [ds moveItemAtIndex:1 toIndex:4];
    XCTAssertTrue([ds numberOfItemsInSection:0] == 6, @"The size shouldn't have changed");
    XCTAssertEqualObjects([ds itemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]], @"Charlie", @"Charlie should now be after Alice");
    XCTAssertEqualObjects([ds itemAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]], @"Bob", @"Bob should now be after David");
}

- (void)testReplacement {
    PTLArrayDatasource *ds = [[PTLArrayDatasource alloc] initWithItems:@[@"Alice", @"Bob", @"Charlie", @"David", @"Eve", @"Fred"]];

    [ds replaceItemAtIndex:2 withItem:@"Quentin"];
    XCTAssertTrue([ds numberOfItemsInSection:0] == 6, @"The size shouldn't have changed");
    XCTAssertEqualObjects([ds itemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]], @"Quentin", @"Quentin should now be at index 2");
    XCTAssertEqualObjects([ds indexPathOfItem:@"Quentin"], [NSIndexPath indexPathForItem:2 inSection:0], @"Quentin should now be at index 2");

    XCTAssertFalse([ds containsItem:@"Charlie"], @"Charlie should be long gone");
}

@end

//
//  PTLIndexDatasourceTests.m
//  PTLDatasource
//
//  Created by Brian Partridge on 8/2/13.
//
//

#import "PTLIndexDatasourceTests.h"
#import "PTLIndexDatasource.h"

typedef NS_ENUM(NSInteger, TestIndex) {
    TestIndexFirst,
    TestIndexSecond,
    TestIndexThird,
    TestIndexFourth,
    TestIndexFifth,
    TestIndexSixth,
    TestIndexCount
};

@implementation PTLIndexDatasourceTests

- (void)testEmptyIndecies {
    PTLIndexDatasource *ds = [[PTLIndexDatasource alloc] initWithIndecies:[NSIndexSet indexSet]];
    XCTAssertTrue([ds numberOfSections] == 1, @"Number of sections should be 1 for an empty set.");
    XCTAssertTrue([ds numberOfItemsInSection:0] == 0, @"Number of items should be 0 for an empty set.");
    XCTAssertThrows([ds numberOfItemsInSection:1], @"Number of items should be 0 for the wrong section index.");
    XCTAssertThrows([ds itemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]], @"There are no items in the array");
    XCTAssertThrows([ds indexValueAtIndex:0], @"There are no items in the array.");
}

- (void)testSampleIndecies {
    PTLIndexDatasource *ds = [[PTLIndexDatasource alloc] initWithIndecies:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, TestIndexCount)]];
    XCTAssertTrue([ds numberOfSections] == 1, @"Number of sections should be 1 for an empty array.");
    XCTAssertTrue([ds numberOfItemsInSection:0] == TestIndexCount, @"Number of items should be 6.");
    XCTAssertNotNil([ds itemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]], @"There should be an object at index 2");
    XCTAssertEqualObjects([ds itemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]], @(TestIndexSecond), @"The second value should be at index 1");
    XCTAssertTrue([ds indexValueAtIndex:0] == TestIndexFirst, @"The first item should be at index 0.");
    XCTAssertThrows([ds indexValueAtIndex:1000], @"Invalid index.");
}

- (void)testInsertion {
    PTLIndexDatasource *ds = [[PTLIndexDatasource alloc] initWithIndecies:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];

    [ds addIndexValue:TestIndexFifth];
    XCTAssertTrue([ds numberOfItemsInSection:0] == 4, @"Should be able to insert an item");
    XCTAssertEqualObjects([ds itemAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]], @(TestIndexFifth), @"The fifth value should be at index 3");
    XCTAssertTrue([ds indexValueAtIndex:3] == TestIndexFifth, @"The fifth value should be at index 3");

    [ds addIndexValuesFromIndexSet:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(TestIndexFourth, 3)]];
    XCTAssertTrue([ds numberOfItemsInSection:0] == 6, @"Should be able to insert items");
    XCTAssertEqualObjects([ds itemAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:0]], @(TestIndexSixth), @"The sixth value should be at index 5");
    XCTAssertTrue([ds indexValueAtIndex:5] == TestIndexSixth, @"The sixth value should be at index 5");
}

- (void)testRemoval {
    PTLIndexDatasource *ds = [[PTLIndexDatasource alloc] initWithIndecies:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, TestIndexCount)]];

    [ds removeIndexValue:1024];
    XCTAssertTrue([ds numberOfItemsInSection:0] == TestIndexCount, @"Nothing should have changed");

    XCTAssertThrows([ds removeIndexValueAtIndex:1000], @"Invalid index");

    [ds removeIndexValue:TestIndexSecond];
    XCTAssertTrue([ds numberOfItemsInSection:0] == TestIndexCount - 1, @"Count should decrement");
    XCTAssertFalse([ds containsItem:@(TestIndexSecond)], @"The second value should be long gone");

    [ds removeIndexValueAtIndex:0];
    XCTAssertTrue([ds numberOfItemsInSection:0] == TestIndexCount - 2, @"Count should decrement");
    XCTAssertFalse([ds containsItem:@(TestIndexFirst)], @"The first value should be long gone");

    [ds removeAllItems];
    XCTAssertTrue([ds numberOfItemsInSection:0] == 0, @"Should be empty");
}

@end

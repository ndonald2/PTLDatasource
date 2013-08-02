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
    PTLDatasource *ds = [[PTLIndexDatasource alloc] initWithIndecies:[NSIndexSet indexSet]];
    STAssertTrue([ds numberOfSections] == 1, @"Number of sections should be 1 for an empty set.");
    STAssertTrue([ds numberOfItemsInSection:0] == 0, @"Number of items should be 0 for an empty set.");
    STAssertThrows([ds numberOfItemsInSection:1], @"Number of items should be 0 for the wrong section index.");
    STAssertThrows([ds itemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]], @"There are no items in the array");
}

- (void)testSampleIndecies {
    PTLDatasource *ds = [[PTLIndexDatasource alloc] initWithIndecies:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, TestIndexCount)]];
    STAssertTrue([ds numberOfSections] == 1, @"Number of sections should be 1 for an empty array.");
    STAssertTrue([ds numberOfItemsInSection:0] == TestIndexCount, @"Number of items should be 6.");
    STAssertNotNil([ds itemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]], @"There should be an object at index 2");
    STAssertEqualObjects([ds itemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]], @(TestIndexSecond), @"The second value should be at index 1");
}

- (void)testInsertion {
    PTLIndexDatasource *ds = [[PTLIndexDatasource alloc] initWithIndecies:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];

    [ds addIndexValue:TestIndexFifth];
    STAssertTrue([ds numberOfItemsInSection:0] == 4, @"Should be able to insert an item");
    STAssertEqualObjects([ds itemAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]], @(TestIndexFifth), @"The fifth value should be at index 3");

    [ds addIndexValuesFromIndexSet:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(TestIndexFourth, 3)]];
    STAssertTrue([ds numberOfItemsInSection:0] == 6, @"Should be able to insert items");
    STAssertEqualObjects([ds itemAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:0]], @(TestIndexSixth), @"The sixth value should be at index 5");
}

- (void)testRemoval {
    PTLIndexDatasource *ds = [[PTLIndexDatasource alloc] initWithIndecies:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, TestIndexCount)]];

    [ds removeIndexValue:1024];
    STAssertTrue([ds numberOfItemsInSection:0] == TestIndexCount, @"Nothing should have changed");

    [ds removeIndexValue:TestIndexSecond];
    STAssertTrue([ds numberOfItemsInSection:0] == 5, @"Count should decrement");
    STAssertFalse([ds containsItem:@(TestIndexSecond)], @"The second value should be long gone");

    [ds removeAllItems];
    STAssertTrue([ds numberOfItemsInSection:0] == 0, @"Should be empty");
}

@end

#import <XCTest/XCTest.h>
#import "NSUserActivity+WMFExtensions.h"


@interface NSUserActivity_WMFExtensions_wmf_activityForWikipediaScheme_Test : XCTestCase
@end

@implementation NSUserActivity_WMFExtensions_wmf_activityForWikipediaScheme_Test

- (void)testURLWithoutWikipediaSchemeReturnsNil {
    NSURL *url = [NSURL URLWithString:@"http://www.foo.com"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertNil(activity);
}

- (void)testInvalidArticleURLReturnsNil {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/Foo"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertNil(activity);
}

- (void)testArticleURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/wiki/Foo"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeLink);
    XCTAssertEqualObjects(activity.webpageURL.absoluteString, @"https://en.wikipedia.org/wiki/Foo");
}

- (void)testExploreURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://explore"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeExplore);
}

- (void)testPlaceURLWithCorrectLocation {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places/?latitude=34.0335387&longitude=-118.8366035"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    
    // Test the values in the userInfo dictionary
    NSDictionary *userInfo = activity.userInfo;
    XCTAssertNotNil(userInfo, @"userInfo should not be nil");
    
    NSNumber *latitudeValue = userInfo[@"latitude"];
    XCTAssertNotNil(latitudeValue, @"latitude should not be nil");
    XCTAssertEqual(latitudeValue.doubleValue, 34.0335387, @"latitude value should match");
    
    NSNumber *longitudeValue = userInfo[@"longitude"];
    XCTAssertNotNil(longitudeValue, @"longitude should not be nil");
    XCTAssertEqual(longitudeValue.doubleValue, -118.8366035, @"longitude value should match");
}

- (void)testPlaceURLWithZeroCoordinates {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places/?latitude=0.0&longitude=0.0"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    
    // Test the values in the userInfo dictionary
    NSDictionary *userInfo = activity.userInfo;
    XCTAssertNotNil(userInfo, @"userInfo should not be nil");
    
    NSNumber *latitudeValue = userInfo[@"latitude"];
    XCTAssertNotNil(latitudeValue, @"latitude should not be nil");
    XCTAssertEqual(latitudeValue.doubleValue, 0.0, @"latitude value should match");
    
    NSNumber *longitudeValue = userInfo[@"longitude"];
    XCTAssertNotNil(longitudeValue, @"longitude should not be nil");
    XCTAssertEqual(longitudeValue.doubleValue, 0.0, @"longitude value should match");
}
- (void)testPlaceURLWithoutLocation {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    
    // Test the values in the userInfo dictionary
    NSDictionary *userInfo = activity.userInfo;
    
    NSNumber *latitudeValue = userInfo[@"latitude"];
    XCTAssertNil(latitudeValue, @"latitude should be nil");
    
    NSNumber *longitudeValue = userInfo[@"longitude"];
    XCTAssertNil(longitudeValue, @"longitude should be nil");
}
- (void)testHistoryURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://history"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeHistory);
}

- (void)testSavedURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://saved"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeSavedPages);
}

- (void)testSearchURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/w/index.php?search=dog"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeLink);
    XCTAssertEqualObjects(activity.webpageURL.absoluteString,
                          @"https://en.wikipedia.org/w/index.php?search=dog&title=Special:Search&fulltext=1");
}

@end


//
//  SearchViewControllerNew.h
//  parqV1
//
//  Created by Duncan Riefler on 12/21/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class MapViewFindParkingTab;

@interface SearchViewControllerNew : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSArray *searchResults;
    MapViewFindParkingTab *mapViewController;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) id delegate;
- (id) initWithMapViewController: (MapViewFindParkingTab *) mvc;

@end

@protocol SearchViewControllerDelegate

- (void) searchOptionSelected:(MKMapItem *) mapItem;

@end
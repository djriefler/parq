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
#import "MapViewFindParkingTab.h"

@interface SearchViewControllerNew : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSArray *searchResults;
    MapViewFindParkingTab *mapViewController;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (id) initWithMapViewController: (MapViewFindParkingTab *) mvc;

@end

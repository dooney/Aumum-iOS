//
//  PhotoCell.h
//  iosapp
//
//  Created by Simpson Du on 12/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_PhotoCell_h
#define iosapp_PhotoCell_h

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell

- (void)reloadData:(NSString*)imageUrl;

@end

#endif

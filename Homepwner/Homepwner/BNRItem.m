//
//  BNRItem.m
//  Homepwner
//
//  Created by lovocas on 13-11-18.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "BNRItem.h"


@implementation BNRItem

@dynamic dateCreated;
@dynamic imageKey;
@dynamic itemName;
@dynamic serialNumber;
@dynamic thumbnail;
@dynamic thumbnailData;
@dynamic valueInDollar;
@dynamic orderingValue;
@dynamic assetType;
-(void)setThumbnailDataFromImg:(UIImage *)image
{
    CGSize originSize = [image size];
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    float ratio = MAX(newRect.size.width/originSize.width, newRect.size.height/originSize.height);
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO,0.0);
    UIBezierPath *path =[UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    [path addClip];
    CGRect project ;
    project.origin.y=(newRect.size.height-originSize.height*ratio)/2;
    project.origin.x=(newRect.size.width-originSize.width*ratio)/2;
    project.size.width=originSize.width*ratio;
    project.size.height = originSize.height*ratio;
    [image drawInRect:project];
    UIImage * smallimage  =UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:smallimage];
    NSData * data = UIImagePNGRepresentation(smallimage);
    [self setThumbnailData:data];
    UIGraphicsEndImageContext();
    
}

-(void)awakeFromFetch
{
    [super awakeFromFetch];
    //
    UIImage * img=[UIImage imageWithData:[self thumbnailData]];
    [self setPrimitiveValue:img forKey:@"thumbnail"];
    
}
-(void)awakeFromInsert{
    [super awakeFromInsert];
    NSTimeInterval date =[[NSDate date]timeIntervalSinceReferenceDate];
    self.dateCreated=date;
}
@end

//
//  HelpCells.m
//  MCDM
//
//  Created by Fred on 12-12-31.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "HelpCells.h"

#define kNewsIconWidth 69
#define kNewsIconHeight 50

#define kAppIconWidth 53
#define kAppIconHeight 53

#define kTempPadX 7
#define kTempPadY 8


@implementation NewsItemCell

@synthesize seperatorLine, iconView;

- (id)initWithReuse:(NSString *)reuse
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
    if (self)
    {
        [self setSeperatorLineImage:[UIImage imageNamed:@"CellSepLine.png"]];
        self.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow.png"]] autorelease];
        
        self.textLabel.font = [UIFont systemFontOfSize:16.f];
        self.textLabel.textAlignment = UITextAlignmentLeft;
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
        self.detailTextLabel.numberOfLines = 2;
    }
    
    return self;
}

- (void)setSeperatorLineImage:(UIImage *)line
{
    if (!seperatorLine)
    {
        seperatorLine = [[UIImageView alloc] initWithImage:line];
        [self.contentView addSubview:[seperatorLine autorelease]];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect imageRect = CGRectMake(kTempPadX, 0, kNewsIconWidth, kNewsIconHeight);
    self.iconView.frame = imageRect;
    
    CGPoint iconCenter = self.iconView.center;
    iconCenter.y = self.contentView.center.y;
    self.iconView.center = iconCenter;
    
    CGRect textFrame = self.textLabel.frame;
    textFrame.origin.x = 2*kTempPadX+kNewsIconWidth;
    textFrame.origin.y = kTempPadY;
    textFrame.size.width = self.contentView.bounds.size.width - textFrame.origin.x;
    self.textLabel.frame = textFrame;
    
    CGRect detailTextFrame = self.detailTextLabel.frame;
    detailTextFrame.origin.x = 2*kTempPadX+kNewsIconWidth;
    detailTextFrame.size.width = self.contentView.bounds.size.width - detailTextFrame.origin.x;
    detailTextFrame.origin.y = textFrame.origin.y+textFrame.size.height+2;
    detailTextFrame.size.height = 30;
    self.detailTextLabel.frame = detailTextFrame;
    
    if (seperatorLine)
    {
        CGRect frame = self.contentView.bounds;
        frame.origin.y = frame.size.height-seperatorLine.frame.size.height;
        frame.size.height = seperatorLine.frame.size.height;
        frame.origin.x = 0;//(frame.size.width-seperatorLine.frame.size.width)/2;
        frame.size.width = frame.size.width+20;
        seperatorLine.frame = frame;
    }
}

- (DelayImageView *)iconView
{
    if (!iconView)
    {
        iconView = [[DelayImageView alloc] initWithFrame:CGRectMake(0, 0, kNewsIconWidth, kNewsIconHeight)];
        iconView.clipsToBounds = YES;
        [self.contentView addSubview:[iconView autorelease]];
    }
    
    return iconView;
}

@end

@implementation AppItemCell

@synthesize seperatorLine, iconView;

- (id)initWithReuse:(NSString *)reuse
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
    if (self)
    {
        [self setSeperatorLineImage:[UIImage imageNamed:@"CellSepLine.png"]];
        self.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow.png"]] autorelease];
        
        self.textLabel.font = [UIFont systemFontOfSize:16.f];
        self.textLabel.textAlignment = UITextAlignmentLeft;
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
        self.detailTextLabel.numberOfLines = 2;
    }
    
    return self;
}

- (void)setSeperatorLineImage:(UIImage *)line
{
    if (!seperatorLine)
    {
        seperatorLine = [[UIImageView alloc] initWithImage:line];
        [self.contentView addSubview:[seperatorLine autorelease]];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect imageRect = CGRectMake(kTempPadX, 0, kAppIconWidth, kAppIconHeight);
    self.iconView.frame = imageRect;
    
    CGPoint iconCenter = self.iconView.center;
    iconCenter.y = self.contentView.center.y;
    self.iconView.center = iconCenter;
    
    CGRect textFrame = self.textLabel.frame;
    textFrame.origin.x = 2*kTempPadX+kAppIconWidth;
    textFrame.origin.y = kTempPadY;
    textFrame.size.width = self.contentView.bounds.size.width - textFrame.origin.x;
    self.textLabel.frame = textFrame;
    
    CGRect detailTextFrame = self.detailTextLabel.frame;
    detailTextFrame.origin.x = 2*kTempPadX+kAppIconWidth;
    detailTextFrame.size.width = self.contentView.bounds.size.width - detailTextFrame.origin.x;
    detailTextFrame.origin.y = textFrame.origin.y+textFrame.size.height+2;
    detailTextFrame.size.height = 30;
    self.detailTextLabel.frame = detailTextFrame;
    
    if (seperatorLine)
    {
        CGRect frame = self.contentView.bounds;
        frame.origin.y = frame.size.height-seperatorLine.frame.size.height;
        frame.size.height = seperatorLine.frame.size.height;
        frame.origin.x = 0;//(frame.size.width-seperatorLine.frame.size.width)/2;
        frame.size.width = frame.size.width+20;
        seperatorLine.frame = frame;
    }
}

- (DelayImageView *)iconView
{
    if (!iconView)
    {
        iconView = [[DelayImageView alloc] initWithFrame:CGRectMake(0, 0, kAppIconWidth, kAppIconHeight)];
        [self.contentView addSubview:[iconView autorelease]];
    }
    
    return iconView;
}

@end

@implementation AppCatalogItemCell

@synthesize seperatorLine, iconView;

- (id)initWithReuse:(NSString *)reuse
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
    if (self)
    {
        [self setSeperatorLineImage:[UIImage imageNamed:@"CellSepLine.png"]];
        self.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow.png"]] autorelease];
        
        self.textLabel.font = [UIFont systemFontOfSize:16.f];
        self.textLabel.textAlignment = UITextAlignmentLeft;
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
        self.detailTextLabel.numberOfLines = 2;
    }
    
    return self;
}

- (void)setSeperatorLineImage:(UIImage *)line
{
    if (!seperatorLine)
    {
        seperatorLine = [[UIImageView alloc] initWithImage:line];
        [self.contentView addSubview:[seperatorLine autorelease]];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect imageRect = CGRectMake(kTempPadX, 0, kAppIconWidth, kAppIconHeight);
    self.iconView.frame = imageRect;
    
    CGPoint iconCenter = self.iconView.center;
    iconCenter.y = self.contentView.center.y;
    self.iconView.center = iconCenter;
    
    CGRect textFrame = self.textLabel.frame;
    textFrame.origin.x = 2*kTempPadX+kAppIconWidth;
    textFrame.origin.y = self.contentView.center.y-textFrame.size.height/2;
    textFrame.size.width = self.contentView.bounds.size.width - textFrame.origin.x;
    self.textLabel.frame = textFrame;
    
    /*
    CGRect detailTextFrame = self.detailTextLabel.frame;
    detailTextFrame.origin.x = 2*kTempPadX+kAppIconWidth;
    detailTextFrame.size.width = self.contentView.bounds.size.width - detailTextFrame.origin.x;
    detailTextFrame.origin.y = textFrame.origin.y+textFrame.size.height+2;
    detailTextFrame.size.height = 30;
    self.detailTextLabel.frame = detailTextFrame;*/
    
    if (seperatorLine)
    {
        CGRect frame = self.contentView.bounds;
        frame.origin.y = frame.size.height-seperatorLine.frame.size.height;
        frame.size.height = seperatorLine.frame.size.height;
        frame.origin.x = 0;//(frame.size.width-seperatorLine.frame.size.width)/2;
        frame.size.width = frame.size.width+20;
        seperatorLine.frame = frame;
    }
}

- (DelayImageView *)iconView
{
    if (!iconView)
    {
        iconView = [[DelayImageView alloc] initWithFrame:CGRectMake(0, 0, kAppIconWidth, kAppIconHeight)];
        [self.contentView addSubview:[iconView autorelease]];
    }
    
    return iconView;
}

@end

@implementation NotificationCell

@synthesize seperatorLine;

- (id)initWithReuse:(NSString *)reuse
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
    if (self)
    {
        [self setSeperatorLineImage:[UIImage imageNamed:@"CellSepLine.png"]];
        self.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow.png"]] autorelease];
        
        self.textLabel.font = [UIFont systemFontOfSize:16.f];
        self.textLabel.textAlignment = UITextAlignmentLeft;
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
        self.detailTextLabel.numberOfLines = 1;
    }
    
    return self;
}

- (void)setSeperatorLineImage:(UIImage *)line
{
    if (!seperatorLine)
    {
        seperatorLine = [[UIImageView alloc] initWithImage:line];
        [self.contentView addSubview:[seperatorLine autorelease]];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
        
    if (seperatorLine)
    {
        CGRect frame = self.contentView.bounds;
        frame.origin.y = frame.size.height-seperatorLine.frame.size.height;
        frame.size.height = seperatorLine.frame.size.height;
        frame.origin.x = 0;//(frame.size.width-seperatorLine.frame.size.width)/2;
        frame.size.width = frame.size.width+20;
        seperatorLine.frame = frame;
    }
}

@end

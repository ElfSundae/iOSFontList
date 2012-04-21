//
//  FontListViewController.m
//  iOSFontList
//
//  Created by Elf Sundae on 4/21/12.
//  Copyright (c) 2012 www.0x123.com. All rights reserved.
//

#import "FontListViewController.h"


#define kFontSize                       16.0f
#define kContentLabelTag                1024
#define kContentLabelMargin             10.0f
#define kContentSize_MinHeight          ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 100.0f : 180.0f)




@interface FontListViewController ()
@property (nonatomic, retain) NSMutableDictionary *fontsDict;
@end

@implementation FontListViewController
@synthesize fontsDict = _fontsDict;

- (void)dealloc
{
    [_fontsDict release], _fontsDict = nil;
    [super dealloc];
}

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // get font family names
    NSArray *familyNames = [UIFont familyNames];
    
    _fontsDict = [[NSMutableDictionary alloc] initWithCapacity:
                  [familyNames count]];
    
    for (NSString *family in familyNames)
    {
        // get font names for a family
        NSArray *fonts = [UIFont fontNamesForFamilyName:family];
        [_fontsDict setObject:fonts forKey:family];
    }

}


///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Methods

- (NSString *)getFontNameForTableView:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath
{
    NSArray *fonts = [_fontsDict objectForKey:
                      [[_fontsDict allKeys] objectAtIndex:indexPath.section]];
    return [fonts objectAtIndex:indexPath.row];
}

- (NSString *)getContentForTableView:(UITableView *)tableView
                           indexPath:(NSIndexPath *)indexPath
{
    NSString *font = [self getFontNameForTableView:tableView
                                         indexPath:indexPath];
    if (font)
    {
        font = [@"font name: " stringByAppendingString:font];
        return [font stringByAppendingString:@"\n中文测试 苹果中国"
                @"\nabcdefghijklmnopqrstuvwxyz"
                @"\nABCDEFGHIJKLMNOPQRSTUVWXYZ"
                @"\n😄😍😪😂😡👿👽💗💔🙏👋👷💆👧☀🌙🍀➿📢🎿⚠🇨🇳🇺🇸⬅9⃣5⃣🅰🅱🅾"
                @"\n1234567890"];
    }
    return @"N/A";
}

- (UIFont *)getFontForTableView:(UITableView *)tableView
                      indexPath:(NSIndexPath *)indexPath
{
    NSString *fontName = [self getFontNameForTableView:tableView
                                             indexPath:indexPath];
    if (!fontName)
    {
        return [UIFont systemFontOfSize:kFontSize];
    }
    return [UIFont fontWithName:fontName size:kFontSize];
}
///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_fontsDict allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView 
    titleForHeaderInSection:(NSInteger)section
{
    return [[_fontsDict allKeys] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView 
    numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)[_fontsDict objectForKey:
                        [[_fontsDict allKeys] objectAtIndex:section]] 
            count];
}

- (CGFloat)tableView:(UITableView *)tableView 
        heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:kContentLabelTag];
    return label.frame.size.height + (2 * kContentLabelMargin);
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellID] 
                autorelease];
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        contentLabel.lineBreakMode = UILineBreakModeWordWrap;
        contentLabel.numberOfLines = 0;
        contentLabel.font = [self getFontForTableView:tableView indexPath:indexPath];
        contentLabel.tag = kContentLabelTag;
        contentLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:contentLabel];
        [contentLabel release];
        contentLabel = nil;
    }
    
    NSString *content = [self getContentForTableView:tableView indexPath:indexPath];
    CGSize constraintSize = CGSizeMake(cell.contentView.frame.size.width - (2 * kContentLabelMargin), 
                                       CGFLOAT_MAX);
    CGSize size = [content sizeWithFont:[self getFontForTableView:tableView
                                                        indexPath:indexPath]
                      constrainedToSize:constraintSize
                          lineBreakMode:UILineBreakModeWordWrap];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:kContentLabelTag];
    label.text = content;
    label.frame = CGRectMake(kContentLabelMargin, 
                             kContentLabelMargin, 
                             size.width,
                             MAX(size.height, kContentSize_MinHeight));

    return cell;
  
}

- (void)tableView:(UITableView *)tableView 
        didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    static int i = 0;
    NSString *fontName = [self getFontNameForTableView:tableView 
                                             indexPath:indexPath];
    NSMutableString *str = [[NSMutableString alloc] init];
    if (i++ > 0)
    {
        [str appendString:
         [[UIPasteboard generalPasteboard] string]];
    }
    [str appendFormat:@"\n%@", fontName];
    [UIPasteboard generalPasteboard].persistent = YES;
    [[UIPasteboard generalPasteboard] setString:str];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

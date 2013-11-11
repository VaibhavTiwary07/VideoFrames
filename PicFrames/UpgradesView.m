//
//  UpgradesView.m
//  InstaSplash
//
//  Created by Vijaya kumar reddy Doddavala on 9/27/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "UpgradesView.h"
@interface UpgradesView()
{
    UILabel   *_toolBarTitle;
    UIToolbar *_toolbar;
    OT_OfferWallView *_offerWallView;
    BOOL _isOfferWallClosed;
}
@end
@implementation UpgradesView

@synthesize controller;

#define UPGRADES_VIRCURRENCY_PRDCOUNT 10
typedef struct
{
    int       tag;
    int       currencyRequiredToUnlock;
    NSString *prdId;
    NSString *title;
    UITextAlignment eTitleAlignment;
}tVirCurrencyPrdRecord;

static tVirCurrencyPrdRecord vcp_mapping[UPGRADES_VIRCURRENCY_PRDCOUNT]=
{
    {0, 0, nil, @"Earn FREE Currency", UITextAlignmentCenter}, //First entry is the title for earn currency button, we should never map product id and currency count for this one
    {1, 30, key_boughtAnyProduct, @"  Remove Ads",UITextAlignmentLeft}, //to remove ads
    {2, 50, kInAppPurchaseCartoonPack, @"  Cartoon Effects",UITextAlignmentLeft},
    {3, 50, kInAppPurchaseVintaePack, @"  Vintage Effects",UITextAlignmentLeft},
    {4, 50, kInAppPurchaseSketchPack, @"  Sketch Effects",UITextAlignmentLeft},
    {5, 50, kInAppPurchaseGrungePack, @"  Grunge Effects",UITextAlignmentLeft},
    {6, 50, kInAppPurchaseTexturePack, @"  Texture Effects",UITextAlignmentLeft},
    {7, 50, kInAppPurchaseSpacePack, @"  Space Effects",UITextAlignmentLeft},
    {8, 50, kInAppPurchaseBokehPack, @"  Bokeh Effects",UITextAlignmentLeft},
    {9, 50, kInAppPurchaseShapesPack, @"  Shapes",UITextAlignmentLeft},
};

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style toobar:(UIToolbar*)tbar title:(UILabel*)title
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        // Initialization code
        self.dataSource = self;
        self.delegate = self;
        
        _toolbar = tbar;
        _toolbar.barStyle = UIBarStyleBlack;
        [_toolbar sizeToFit];
        
        _toolBarTitle = title;
        _toolBarTitle.text = @"UPGRADES";
        _toolBarTitle.textAlignment = UITextAlignmentCenter;
        _toolBarTitle.textColor = [UIColor whiteColor];
        _toolBarTitle.center = CGPointMake(frame.size.width/2.0,22.0);
        _toolBarTitle.font = [UIFont boldSystemFontOfSize:16.0];
        _toolBarTitle.backgroundColor = [UIColor clearColor];
        _isOfferWallClosed = YES;
        
        [self addUpgradeButtons];
        
        [Flurry logEvent:@"Upgrades Screen Opens" withParameters:nil];
    }
    return self;
}

-(void)dealloc{
    
    
    [super dealloc];
}

-(void)showCurrentScoreToUser:(id)sender
{
    //int score = [[tapPoints Instance]curScore];
    
    [WCAlertView showAlertWithTitle:@"Instapic Currency" message:[NSString stringWithFormat:@"Your current instapic currency count is %d",[tapPoints Instance].curScore] customizationBlock:^(WCAlertView *alertView)
     {
         
         // You can also set different appearance for this alert using customization block
         
         alertView.style = WCAlertViewStyleBlackHatched;
         alertView.alertViewStyle = UIAlertViewStyleDefault;
     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
         
     } cancelButtonTitle:@"Ok" otherButtonTitles:nil];
}

-(void)offerWallWillExit
{
    if(YES == _isOfferWallClosed)
    {
        return;
    }
    
    /* For some reason tapjoy is calling this method for multiple times */
    _isOfferWallClosed = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showCurrentScoreToUser:) userInfo:self repeats:NO];
}

-(void)openOfferWall
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Upgrades",@"From", nil];
    [Flurry logEvent:@"Offerwall Opens" withParameters:params];

    _isOfferWallClosed = NO;
    goalBasedOfferWallController *vc = [[goalBasedOfferWallController alloc]init];
    vc.delegate = self;
    [self.controller presentModalViewController:vc animated:YES];
    [vc release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 2;
    }
    
    if(section == 1)
    {
        return 10;
    }
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return [NSString stringWithFormat:@"\n\nUpgrade to %@ Pro version. You will get 100's of effects, Ability to change frame shape to circle, heart..., No Ads, and all future upgrades",appname];
    }
    else if(section == 1)
    {
        return [NSString stringWithFormat:@"The following upgrades can be earned for FREE by watching videos and offers.To begin earning FREE currency, Tap on Earn Currency"];
    }
    
    return [NSString stringWithFormat:@"Check out our free apps. If you like %@ then you will definitely like our other apps as well.",appname];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 100.0;
    
    if((section == 1)||(section == 2))
    {
        height = 70.0;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect full = [[UIScreen mainScreen]bounds];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, full.size.width, full.size.height)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont boldSystemFontOfSize:13.0];
    lbl.numberOfLines = 5;
    if(section == 0)
    {
        lbl.text = [NSString stringWithFormat:@"\n\nUpgrade to %@ Pro version. You will get 100's of effects, Ability to change frame shape to circle, heart...etc, No Ads, and all future upgrades",appname];
    }
    else if(section == 1)
    {
        lbl.text = [NSString stringWithFormat:@"The following upgrades can be earned for FREE by watching videos and offers.To begin earning FREE currency, Tap on Earn Currency"];
    }
    else
    {
        lbl.text = [NSString stringWithFormat:@"Check out our free apps. If you like %@ then you will definitely like our other apps as well.",appname];
    }
    
    return lbl;
}

-(FTWButton*)buttonWithTitle:(NSString*)title selectedTitle:(NSString*)seltile
{
    FTWButton *button6 = [[FTWButton alloc] init];
    button6.frame = CGRectMake(0, 0, 40, 30);
    //[button6 setFrame:CGRectMake(0, 0, 80, 30) forControlState:UIControlStateSelected];
    [button6 addBlueStyleForState:UIControlStateNormal];
    [button6 setInnerShadowColor:[UIColor colorWithRed:200.0f/255 green:250.0f/255 blue:253.0f/255 alpha:1.0f] forControlState:UIControlStateNormal];
    [button6 setInnerShadowRadius:2.0f forControlState:UIControlStateNormal];
    [button6 setText:title forControlState:UIControlStateNormal];
    [button6 setText:seltile forControlState:UIControlStateSelected];
    
    button6.textAlignment = NSTextAlignmentCenter;
    
    return button6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CellFullSizeText *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CellFullSizeText alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.font          = [UIFont boldSystemFontOfSize:15.0];
    cell.detailTextLabel.font    = [UIFont systemFontOfSize:10.0];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    //cell.textLabel.frame         = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    //cell.accessoryType           = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    if(indexPath.section == 0)
    {
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.accessoryView = nil;
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"Pro Version";
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"Restore Upgrade";
        }
    }
    else if(indexPath.section == 1)
    {
        cell.textLabel.textAlignment = vcp_mapping[indexPath.row].eTitleAlignment;
        cell.textLabel.text = vcp_mapping[indexPath.row].title;
        
        if(vcp_mapping[indexPath.row].currencyRequiredToUnlock > 0)
        {
            if(NO == [[NSUserDefaults standardUserDefaults]boolForKey:vcp_mapping[indexPath.row].prdId])
            {
                NSString *currency = [NSString stringWithFormat:@" %d ",vcp_mapping[indexPath.row].currencyRequiredToUnlock];
                FTWButton *accessory = [self buttonWithTitle:currency selectedTitle:@"Spend Points"];
                accessory.tag = vcp_mapping[indexPath.row].tag;
                [accessory addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.accessoryView = accessory;
                [accessory release];
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    else
    {
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.text = @"Free Apps";
        cell.accessoryView = nil;
    }
    
    return cell;
}

-(void)buttonTapped:(FTWButton*)sender
{
    if(sender.selected)
    {
        [sender setFrame:CGRectMake(sender.frame.origin.x+70.0, sender.frame.origin.y, 40, 30) forControlState:UIControlStateNormal];
        NSLog(@"Upgrade Button Tag %d",sender.tag);
        
        int score = [[tapPoints Instance]curScore];
        if(score >= vcp_mapping[sender.tag].currencyRequiredToUnlock)
        {
            [[tapPoints Instance]spendPoints:vcp_mapping[sender.tag].currencyRequiredToUnlock completion:^(BOOL success){
                if(success)
                {
                    NSDictionary *filterParams = [NSDictionary dictionaryWithObjectsAndKeys:vcp_mapping[sender.tag].title, @"Product",nil];
                    
                    [Flurry logEvent:@"Successful product upgrades using tapjoy" withParameters:filterParams];
                    /* update user defaults with product id and send the success notification */
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:vcp_mapping[sender.tag].prdId];
                    [[NSNotificationCenter defaultCenter]postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
                    [self reloadData];
                    NSLog(@"Successfully Unlocked the content");
                }
                else
                {
                    [WCAlertView showAlertWithTitle:@"Failed" message:[NSString stringWithFormat:@"Failed to unlock %@",vcp_mapping[sender.tag].title] customizationBlock:^(WCAlertView *alertView)
                     {
                         
                         // You can also set different appearance for this alert using customization block
                         
                         alertView.style = WCAlertViewStyleBlackHatched;
                         alertView.alertViewStyle = UIAlertViewStyleDefault;
                     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                         
                     } cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    //NSLog(@"Failed to Unlocke the content");
                }
            }];
            
            //[[tapPoints Instance]spendPoints:vcp_mapping[sender.tag].currencyRequiredToUnlock];
        }
        else
        {
            [WCAlertView showAlertWithTitle:@"Not Enough Currency" message:[NSString stringWithFormat:@"Your current instapic currency count is %d, you need %d more currency to unlock %@",[tapPoints Instance].curScore,vcp_mapping[sender.tag].currencyRequiredToUnlock - [tapPoints Instance].curScore,vcp_mapping[sender.tag].title] customizationBlock:^(WCAlertView *alertView)
             {
                 
                 // You can also set different appearance for this alert using customization block
                 
                 alertView.style = WCAlertViewStyleBlackHatched;
                 alertView.alertViewStyle = UIAlertViewStyleDefault;
             } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 0)
                 {
                     [self openOfferWall];
                     
                     return;
                 }
             } cancelButtonTitle:@"Earn Free Currency" otherButtonTitles:nil];
        }
    }
    else
    {
        [sender setFrame:CGRectMake(sender.frame.origin.x-70.0, sender.frame.origin.y, 110, 30) forControlState:UIControlStateSelected];
    }
    sender.selected = !sender.selected;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            if([[InAppPurchaseManager Instance] canMakePurchases])
            {
                NSDictionary *filterParams = [NSDictionary dictionaryWithObjectsAndKeys:@"Pro from upgrades",@"Product",nil];
                
                [Flurry logEvent:@"InApp Purchase Request" withParameters:filterParams];
                [[InAppPurchaseManager Instance] puchaseProductWithId:kInAppPurchaseProUpgradeProductId];
            }
        }
        else if(indexPath.row == 1)
        {
            [[InAppPurchaseManager Instance] restoreProUpgrade];
        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            [self openOfferWall];
        }
        else if(indexPath.row == 1)
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if(cell)
            {
                FTWButton *but = (FTWButton*)cell.accessoryView;
                if(nil != but)
                {
                    [self buttonTapped:but];
                }
            }
        }
        else
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if(cell)
            {
                FTWButton *but = (FTWButton*)cell.accessoryView;
                if(nil != but)
                {
                    [self buttonTapped:but];
                }
            }
        }
    }
    else if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            [Flurry logEvent:@"Free Apps Opens" withParameters:nil];
            
            CGRect owrect = CGRectMake(0.0, 44.0, self.frame.size.width, self.frame.size.height-44.0);
            _offerWallView = [[OT_OfferWallView alloc]initWithFrame:owrect style:UITableViewStylePlain];
            [self.controller.view addSubview:_offerWallView];
            
            [_offerWallView release];
            
            /* Update Toolbar Title */
            _toolBarTitle.text = @"FREE APPS";
            
            UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            /* Add back button to toolbar */
            UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"BACK" style:UIBarButtonItemStyleBordered target:self action:@selector(exitFreeApps)];
            _toolbar.items = [NSArray arrayWithObjects:flex,back, nil];
            [back release];
            [flex release];
        }
    }
}

-(void)addUpgradeButtons
{
    UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    /* Add back button to toolbar */
    UIBarButtonItem *balance = [[UIBarButtonItem alloc]initWithTitle:@"Balance" style:UIBarButtonItemStyleBordered target:self action:@selector(showCurrentScoreToUser:)];
    
    UIBarButtonItem *earn = [[UIBarButtonItem alloc]initWithTitle:@"Earn" style:UIBarButtonItemStyleBordered target:self action:@selector(openOfferWall)];

    _toolbar.items = [NSArray arrayWithObjects:balance,flex,earn, nil];
    
    [flex release];
    [balance release];
    [earn release];
}

-(void)exitFreeApps
{
    NSLog(@"exitFreeApps");
    [_offerWallView removeFromSuperview];
    
    _toolBarTitle.text = @"UPGRADES";
    
    _toolbar.items = nil;
    
    [self addUpgradeButtons];
}


@end

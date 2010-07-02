/*
 * AppController.j
 * YPassword
 *
 * Created by You on June 28, 2010.
 * Copyright 2010, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "YModel.j"


@implementation AppController : CPObject
{
    CPArray _column;
    CPArray _line;
    float vspace;
    float hspace;
    CPTextField lengthValue;
    CPSlider slider;
    CPPopUpButton hashType;
    YModel model;
    int uid;
    CPTextField password;
    CPSecureTextField masterPasswordTextField;
}

- (void) init_layout
{
    // init lines and columns
    var _tmp_column=[[CPMutableArray alloc] init];
    var _tmp_line=[[CPMutableArray alloc] init];
    var height=27.0;
    var width=20.0;
    vspace=3.0;
    hspace=3.0;


    for (var i=0.0; i<=960; i+=height) {
        [_tmp_line addObject:i ];
    }
    for (var i=0.0; i<=960; i+=width) {
        [_tmp_column addObject:i ];
    }

    _column=[[CPArray alloc] initWithArray: _tmp_column];
    _line  =[[CPArray alloc] initWithArray: _tmp_line];
}

// return the CGRect associated to the space specified by 
// the layout for example:
// [rectForColumn:3 line:2 width:4 height:1] 
// will return the rect for an object begining at the 
// third column of the second line and of width 4 columns
- (CGRect) rectForColumn:(int)column line:(int)line width:(int)width height:(int)height {
    // console.log( @"rectForColumn: ([%d,%d],[%d,%d])", column, line, width, height);
    // console.log( @"       output: ([%f,%f],[%f,%f])", _column[column], _line[line], _column[column + width] - hspace, _line[line + height] - vspace );
    return CGRectMake( _column[column], 
                        _line[line], 
                        _column[column + width] - _column[column] - hspace, 
                        _line[line + height] - _line[line] - vspace);
}

- (CGRect) rectForTextfieldColumn:(int)column line:(int)line width:(int)width {
    // console.log( @"rectForColumn: ([%d,%d],[%d])", column, line, width);
    return CGRectMake( _column[column], 
                        _line[line] - 1, 
                        _column[column + width] - _column[column] - hspace, 
                        30);
}

// -------------- LOGIC ----------------

- (void)updatePassword
{
    // console.log(@"update password");
    [password setStringValue:[model password]];
}

// -------------- ACTIONS ---------------

// -- Master Password --
- (void)masterPasswordChanged:(id)aSender
{
    // console.log(@"masterPasswordChanged: %s", [aSender objectValue]);
    [model setMasterPassword:[aSender objectValue]];
    [self updatePassword];
}

// -- URL --
- (void)urlChanged:(id)aSender
{
    // console.log(@"urlChanged: %s", [aSender objectValue]);
    [model setUrl:[aSender objectValue]];
    [self updatePassword];
}

// -- slider --
- (void)sliderChangedValue:(id)aSender
{
    [lengthValue setObjectValue:[CPString stringWithFormat:@"%d",[aSender objectValue]]];
    [model setLength:[aSender objectValue]];
    [self updatePassword];
}

// -- length textfield --
- (void)textLengthChanged:(id)aSender
{
    [slider setObjectValue:[aSender objectValue]];
    [model setLength:[aSender objectValue]];
    [self updatePassword];
}

// -- hash type changed --
- (void)typeChanged:(id)aSender
{
    // console.log( [[aSender selectedItem] title] );
    [model setType:[[aSender selectedItem] title]];
    [self updatePassword];
}

// -- change password --
- (void)changePassword:(id)aSender
{
    // console.log(@"change password");
    uid+=1;
    [model setUid:uid];
    [self updatePassword];
}

// -- reset password --
- (void)resetPassword:(id)aSender
{
    // console.log(@"reset password");
    uid=0;
    [model setUid:uid];
    [self updatePassword];
}

// -- textfields --
- (void) controlTextDidEndEditing:(CPNotification)notification
{
    var tf=[notification object];
    if ( tf == masterPasswordTextField ) {
        [self masterPasswordChanged:tf];
    } else if ( tf == urlTextField ) {
        [self urlChanged:tf];
    } else {
        console.log ('ERROR: YPassword: controlTextDidEndEditing: cannot find textfield');
    }
}

// -------------- APPLICATION --------------------

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    var totalWidth=24*20.0 - 3.0;
    var totalHeight=6*27.0 - 3.0;
    var mainView=[[CPView alloc] initWithFrame:CGRectMake(
        0,0,
        // (CGRectGetWidth([contentView bounds]) - totalWidth )/2,
        // (CGRectGetMaxY([contentView bounds]) -totalHeight)/2,
        totalWidth,
        totalHeight
        )];
    [mainView setBackgroundColor:[CPColor colorWithHexString:@"eeeeee"]];
    // [mainView setAutoresizingMask: CPViewMinXMargin |
    //                                CPViewMaxXMargin |
    //                                CPViewMinYMargin |
    //                                CPViewMaxYMargin ];

    [self init_layout];

    model=[[YModel alloc] init];
    uid=0;

    // == Line 0 ==
    // create title
    var title = [[CPTextField alloc] initWithFrame:
                    [self rectForColumn:1 line:0 width:23 height:1]];
    [title setStringValue:@"YPassword"];
    [title setVerticalAlignment:CPCenterTextAlignment];
    [title setFont:[CPFont boldSystemFontOfSize:16.0]];
    [title setAlignment:CPCenterTextAlignment];
    [mainView addSubview:title];

    // == Line 1 ==
    // create title
    var masterPasswordLabel =[[CPTextField alloc] initWithFrame:
                    [self rectForColumn:1 line:1 width:5 height:1]];
    [masterPasswordLabel setStringValue:@"Master Pass"];
    [masterPasswordLabel setVerticalAlignment:CPCenterTextAlignment];
    [mainView addSubview:masterPasswordLabel];

    masterPasswordTextField=[[CPSecureTextField alloc] initWithFrame:
        [self rectForTextfieldColumn:5 line:1 width: 18]];
    [masterPasswordTextField setVerticalAlignment:CPCenterTextAlignment];
    [masterPasswordTextField setEditable:true];
    [masterPasswordTextField setBezeled:true];
    [masterPasswordTextField setDelegate:self];
    [mainView addSubview:masterPasswordTextField];

    // == Line 3 ==
    // add URL
    urlLabel=[[CPTextField alloc] initWithFrame:
        [self rectForColumn:1 line:2 width: 4 height: 1]];
    [urlLabel setStringValue:@"URL"];
    [urlLabel setVerticalAlignment:CPCenterTextAlignment];
    [mainView addSubview:urlLabel];

    urlTextField=[[CPTextField alloc] initWithFrame:
        [self rectForTextfieldColumn:5 line:2 width: 18]];
    [urlTextField setVerticalAlignment:CPCenterTextAlignment];
    [urlTextField setEditable:true];
    [urlTextField setBezeled:true];
    [urlTextField setDelegate:self];
    [mainView addSubview:urlTextField];

    // == Line 3 ==
    // add length of password
    var maxLengthLabel=[[CPTextField alloc] initWithFrame:
                    [self rectForColumn:1 line:3 width:4 height:1]];
    [maxLengthLabel setVerticalAlignment:CPCenterVerticalTextAlignment];
    [maxLengthLabel setStringValue:@"length"];
    [mainView addSubview:maxLengthLabel];

    slider = [[CPSlider alloc] initWithFrame:[self rectForColumn:5 line:3 width:15 height:1]];
    [slider setMinValue:8.0];
    [slider setMaxValue:40.0];
    [slider setAltIncrementValue:1.0];
    [slider setContinuous:true];
    [slider setTarget:self];
    [slider setAction:@selector(sliderChangedValue:)];
    [slider setDoubleValue:20.0];
    [mainView addSubview:slider];

    lengthValue=[[CPTextField alloc] initWithFrame:
                    [self rectForTextfieldColumn:20 line:3 width:3]];
    [lengthValue setVerticalAlignment:CPCenterVerticalTextAlignment];
    [lengthValue setIntValue:[slider objectValue]];
    [lengthValue setEditable:true];
    [lengthValue setBezeled:true];
    [lengthValue setAlignment:CPCenterTextAlignment];
    [lengthValue setVerticalAlignment:CPCenterTextAlignment];
    [lengthValue setTarget: self];
    [lengthValue setAction:@selector(textLengthChanged:)];
    [mainView addSubview:lengthValue];

    // == Line 4 ==
    hashType=[[CPPopUpButton alloc] initWithFrame:
                 [self rectForColumn:1 line:4 width: 10 height: 1]];
    [hashType addItemWithTitle:@"base64"];
    [hashType addItemWithTitle:@"hexa"];
    [hashType setTarget:self];
    [hashType setAction:@selector(typeChanged:)];
    [mainView addSubview:hashType];

    changePasswordButton=[[CPButton alloc] initWithFrame:
                 [self rectForColumn:11 line:4 width: 6 height: 1]];
    [changePasswordButton setTitle:@"Change"];
    [changePasswordButton setTarget: self];
    [changePasswordButton setAction:@selector(changePassword:)];
    [mainView addSubview:changePasswordButton];

    resetPasswordButton=[[CPButton alloc] initWithFrame:
                 [self rectForColumn:17 line:4 width: 6 height: 1]];
    [resetPasswordButton setTitle:@"Reset"];
    [resetPasswordButton setTarget:self];
    [resetPasswordButton setAction:@selector(resetPassword:)];
    [mainView addSubview:resetPasswordButton];

    // == Line 5 ==
    // create password
    password = [[CPTextField alloc] initWithFrame:
                    [self rectForColumn:1 line:5 width:23 height:1]];
    [password setStringValue:@"Password"];
    [password setVerticalAlignment:CPCenterTextAlignment];
    [password setFont:[CPFont boldSystemFontOfSize:16.0]];
    [password setAlignment:CPCenterTextAlignment];
    [password setEditable:YES];
    [password setSelectable:YES];
    [mainView addSubview:password];

    // ======== Show all the content =============
    [contentView addSubview:mainView];
    [theWindow orderFront:self];

    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

@end

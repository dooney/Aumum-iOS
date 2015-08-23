//
//  EditProfileScene.m
//  iosapp
//
//  Created by Simpson Du on 19/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "EditProfileScene.h"
#import "EditProfileSceneModel.h"
#import "UIViewController+MBHud.h"
#import "XLForm.h"
#import "Profile.h"
#import "Country.h"
#import "City.h"

@interface EditProfileScene()<XLFormDescriptorDelegate>
{
    XLFormDescriptor* _formDescriptor;
}

@property (nonatomic, strong)EditProfileSceneModel* sceneModel;

@end

@implementation EditProfileScene

- (id)init {
    Profile* profile = [Profile get];
    NSArray* countryList = [Country findAll];
    
    _formDescriptor = [XLFormDescriptor formDescriptor];
    XLFormSectionDescriptor* section;
    XLFormRowDescriptor* row;
    section = [XLFormSectionDescriptor formSection];
    [_formDescriptor addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ScreenName" rowType:XLFormRowDescriptorTypeText title:NSLocalizedString(@"label.screenName", nil)];
    row.required = YES;
    row.value = profile.screenName;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Country" rowType:XLFormRowDescriptorTypeSelectorPush title:NSLocalizedString(@"label.country", nil)];
    NSMutableArray* countryOptions = [NSMutableArray array];
    for (Country* country in countryList) {
        [countryOptions addObject:[XLFormOptionsObject formOptionsObjectWithValue:country.objectId displayText:[country getLocaleName]]];
    }
    row.selectorOptions = countryOptions;
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:profile.country displayText:[[Country getById:profile.country] getLocaleName]];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"City" rowType:XLFormRowDescriptorTypeSelectorPush title:NSLocalizedString(@"label.city", nil)];
    row.required = YES;
    if (profile.country) {
        row.selectorOptions = [self getCityListByCountry:profile.country];
    }
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:profile.city displayText:[[City getById:profile.city] getLocaleName]];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Email" rowType:XLFormRowDescriptorTypeEmail title:NSLocalizedString(@"label.email", nil)];
    [row addValidator:[XLFormValidator emailValidator]];
    row.value = profile.email;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"About" rowType:XLFormRowDescriptorTypeTextView title:NSLocalizedString(@"label.about", nil)];
    row.value = profile.about;
    [section addFormRow:row];
    
    return [super initWithForm:_formDescriptor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initSceneModel];
}

- (void)initView {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed)];
    [self loadHud:self.view];
}

- (void)initSceneModel {
    self.sceneModel = [EditProfileSceneModel SceneModel];
    self.sceneModel.profile = [Profile get];
    
    [self.sceneModel.request onRequest:^{
        NSDictionary* values = [_formDescriptor formValues];
        self.sceneModel.profile.screenName = [values valueForKey:@"ScreenName"];
        self.sceneModel.profile.country = [[values valueForKey:@"Country"] formValue];
        self.sceneModel.profile.city = [[values valueForKey:@"City"] formValue];
        self.sceneModel.profile.email = [values valueForKey:@"Email"];
        self.sceneModel.profile.about = [values valueForKey:@"About"];
        [self.sceneModel.profile save];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProfile" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSError *error) {
        [self hideHudFailed:error.localizedDescription];
    }];
}

- (void)saveButtonPressed {
    [self showHudIndeterminate:NSLocalizedString(@"info.saving", nil)];
    
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    [self.tableView endEditing:YES];
    
    NSDictionary* values = [_formDescriptor formValues];
    [self.sceneModel.request send:self.sceneModel.profile.objectId
                       screenName:[values valueForKey:@"ScreenName"]
                          country:[[values valueForKey:@"Country"] formValue]
                             city:[[values valueForKey:@"City"] formValue]
                            email:[values valueForKey:@"Email"]
                            about:[values valueForKey:@"About"]];
}

-(void)showFormValidationError:(NSError *)error {
    [self hideHudFailed:error.localizedDescription];
}

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    [super formRowDescriptorValueHasChanged:formRow oldValue:oldValue newValue:newValue];
    if ([formRow.tag isEqualToString:@"Country"] && ![[oldValue valueData] isEqualToString:[newValue valueData]]) {
        NSString* country = [newValue valueData];
        XLFormRowDescriptor* cityRow = [_formDescriptor formRowWithTag:@"City"];
        cityRow.selectorOptions = [self getCityListByCountry:country];
    }
}

-(NSMutableArray*)getCityListByCountry:(NSString*)country {
    NSArray* cityList = [City findByColumn:@"country" value:country];
    NSMutableArray* cityOptions = [NSMutableArray array];
    for (City* city in cityList) {
        [cityOptions addObject:[XLFormOptionsObject formOptionsObjectWithValue:city.objectId displayText:[city getLocaleName]]];
    }
    return cityOptions;
}

@end

//
//  ContactsDetector.m
//  MCDM
//
//  Created by Fred on 12-12-28.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "ContactsDetector.h"
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABPerson.h>
#import "Defines.h"
#import "ASIHTTPRequest.h"
#import "DataLoader.h"

#define kLastPostedContactsFile NSUtil::DocumentsSubPath(@"LastPostedContactsFile.xml")

#define kPersonModifyDateKey [NSString stringWithFormat:@"%d", kABPersonModificationDateProperty]
#define kPersonFirstNameKey [NSString stringWithFormat:@"%d", kABPersonFirstNameProperty]

static ContactsDetector *g_detector = nil;

@implementation ContactsDetector

@synthesize serverContactsCount=_serverContactsCount, localContactsCount=_localContactsCount;

+ (ContactsDetector *)detector
{
    if (!g_detector)
    {
        g_detector = [[ContactsDetector alloc] init];
    }
    
    return g_detector;
}

+ (void)releaseDetector
{
    [g_detector release];
    g_detector = nil;
}

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

/*
+ (void)parseContact
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    NSString *info = @"";
    
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        
        //读取firstname
        NSString *personName = (NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if(personName != nil)
            info = [info stringByAppendingFormat:@"\n姓名：%@\n",personName];
        
        //读取lastname
        NSString *lastname = (NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
        if(lastname != nil)
            info = [info stringByAppendingFormat:@"%@\n",lastname];
        
        //读取middlename
        NSString *middlename = (NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
        if(middlename != nil)
            info = [info stringByAppendingFormat:@"%@\n",middlename];
        
        //读取prefix前缀
        NSString *prefix = (NSString*)ABRecordCopyValue(person, kABPersonPrefixProperty);
        if(prefix != nil)
            info = [info stringByAppendingFormat:@"%@\n",prefix];
        
        //读取suffix后缀
        NSString *suffix = (NSString*)ABRecordCopyValue(person, kABPersonSuffixProperty);
        if(suffix != nil)
            info = [info stringByAppendingFormat:@"%@\n",suffix];
        
        //读取nickname呢称
        NSString *nickname = (NSString*)ABRecordCopyValue(person, kABPersonNicknameProperty);
        if(nickname != nil)
            info = [info stringByAppendingFormat:@"%@\n",nickname];
        
        //读取firstname拼音音标
        NSString *firstnamePhonetic = (NSString*)ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty);
        if(firstnamePhonetic != nil)
            info = [info stringByAppendingFormat:@"%@\n",firstnamePhonetic];
        
        //读取lastname拼音音标
        NSString *lastnamePhonetic = (NSString*)ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
        if(lastnamePhonetic != nil)
            info = [info stringByAppendingFormat:@"%@\n",lastnamePhonetic];
        
        //读取middlename拼音音标
        NSString *middlenamePhonetic = (NSString*)ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty);
        if(middlenamePhonetic != nil)
            info = [info stringByAppendingFormat:@"%@\n",middlenamePhonetic];
        //读取organization公司
        NSString *organization = (NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
        if(organization != nil)
            info = [info stringByAppendingFormat:@"%@\n",organization];
        
        //读取jobtitle工作
        NSString *jobtitle = (NSString*)ABRecordCopyValue(person, kABPersonJobTitleProperty);
        if(jobtitle != nil)
            info = [info stringByAppendingFormat:@"%@\n",jobtitle];
        
        //读取department部门
        NSString *department = (NSString*)ABRecordCopyValue(person, kABPersonDepartmentProperty);
        if(department != nil)
            info = [info stringByAppendingFormat:@"%@\n",department];
        
        //读取birthday生日
        NSDate *birthday = (NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
        if(birthday != nil)
            info = [info stringByAppendingFormat:@"%@\n",birthday];
        
        //读取note备忘录
        NSString *note = (NSString*)ABRecordCopyValue(person, kABPersonNoteProperty);
        if(note != nil)
            info = [info stringByAppendingFormat:@"%@\n",note];
        
        //第一次添加该条记录的时间
        NSString *firstknow = (NSString*)ABRecordCopyValue(person, kABPersonCreationDateProperty);
        NSLog(@"第一次添加该条记录的时间%@\n",firstknow);
        
        //最后一次修改該条记录的时间
        NSString *lastknow = (NSString*)ABRecordCopyValue(person, kABPersonModificationDateProperty);
        NSLog(@"最后一次修改該条记录的时间%@\n",lastknow);
        
        //获取email多值
        ABMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
        int emailcount = ABMultiValueGetCount(email);
        for (int x = 0; x < emailcount; x++)
        {
            //获取email Label
            NSString* emailLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, x));
            //获取email值
            NSString* emailContent = (NSString*)ABMultiValueCopyValueAtIndex(email, x);
            info = [info stringByAppendingFormat:@"%@:%@\n",emailLabel,emailContent];
        }
        
        //读取地址多值
        ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
        int count = ABMultiValueGetCount(address);
        
        for(int j = 0; j < count; j++)
        {
            //获取地址Label
            NSString* addressLabel = (NSString*)ABMultiValueCopyLabelAtIndex(address, j);
            info = [info stringByAppendingFormat:@"%@\n",addressLabel];
            
            //获取該label下的地址6属性
            NSDictionary* personaddress =(NSDictionary*) ABMultiValueCopyValueAtIndex(address, j);
            NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
            if(country != nil)
                info = [info stringByAppendingFormat:@"国家：%@\n",country];
            NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
            if(city != nil)
                info = [info stringByAppendingFormat:@"城市：%@\n",city];
            NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
            if(state != nil)
                info = [info stringByAppendingFormat:@"省：%@\n",state];
            NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
            if(street != nil)
                info = [info stringByAppendingFormat:@"街道：%@\n",street];
            NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
            if(zip != nil)
                info = [info stringByAppendingFormat:@"邮编：%@\n",zip];
            NSString* coutntrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
            if(coutntrycode != nil)
                info = [info stringByAppendingFormat:@"国家编号：%@\n",coutntrycode];
        }
        
        //获取dates多值
        ABMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
        int datescount = ABMultiValueGetCount(dates);
        for (int y = 0; y < datescount; y++)
        {
            //获取dates Label
            NSString* datesLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(dates, y));
            
            //获取dates值
            NSString* datesContent = (NSString*)ABMultiValueCopyValueAtIndex(dates, y);
            info = [info stringByAppendingFormat:@"%@:%@\n",datesLabel,datesContent];
        }
        
        //获取kind值
        CFTypeRef recordType = ABRecordCopyValue(person, kABPersonKindProperty);
        if (recordType == kABPersonKindOrganization) {
            // it's a company
            NSLog(@"it's a company\n");
        } else {
            // it's a person, resource, or room
            NSLog(@"it's a person, resource, or room\n");
        }
        
        //获取IM多值
        ABMultiValueRef instantMessage = ABRecordCopyValue(person, kABPersonInstantMessageProperty);
        for (int l = 1; l < ABMultiValueGetCount(instantMessage); l++)
        {
            //获取IM Label
            NSString* instantMessageLabel = (NSString*)ABMultiValueCopyLabelAtIndex(instantMessage, l);
            info = [info stringByAppendingFormat:@"%@\n",instantMessageLabel];
            //获取該label下的2属性
            NSDictionary* instantMessageContent =(NSDictionary*) ABMultiValueCopyValueAtIndex(instantMessage, l);
            NSString* username = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
            if(username != nil)
                info = [info stringByAppendingFormat:@"username：%@\n",username];
            
            NSString* service = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
            if(service != nil)
                info = [info stringByAppendingFormat:@"service：%@\n",service];
        }
        //读取电话多值
        
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            NSString * personPhoneLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * personPhone = (NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            info = [info stringByAppendingFormat:@"%@:%@\n",personPhoneLabel,personPhone];
        }
        
        //获取URL多值
        ABMultiValueRef url = ABRecordCopyValue(person, kABPersonURLProperty);
        for (int m = 0; m < ABMultiValueGetCount(url); m++)
        {
            //获取电话Label
            NSString * urlLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(url, m));
            //获取該Label下的电话值
            NSString * urlContent = (NSString*)ABMultiValueCopyValueAtIndex(url,m);
            info = [info stringByAppendingFormat:@"%@:%@\n",urlLabel,urlContent];
        }
        
        //读取照片
         NSData *image = (NSData*)ABPersonCopyImageData(person);
         UIImageView *myImage = [[UIImageView alloc] initWithFrame:CGRectMake(200, 0, 50, 50)];
         [myImage setImage:[UIImage imageWithData:image]];
         myImage.opaque = YES;
        
        _Log(@"Contacts:%@", info);
        
        info = @"";
    }
    
    CFRelease(results);
    
    CFRelease(addressBook);
}
*/

//文件中每条通讯录使用一个dict表示，其键使用数字表示，含义如下：
//200：记录ID，当需要删除或修改本地某条记录时，使用此id进行查找。
//100：操作，有三种：NEW：新建这条记录；UPDATE：更新这条记录；DELETE：删除这条记录。
//0：first name；
//6：middle name；
//1：last name；
//3：phone number,多值属性，每条电话号码使用一个dict表示，下同；
//10：ortanization；
//22：url（个人主页），多值属性；
//14：note（备注）。
//18：job title（工作）；
//11：department（部门）；
//17：birthday；
//13：imessage（即时通讯方式），多值属性；
//12：date，多值属性;
//5：address，多值属性;
//4:email，多值属性;
//19:nick name;

+ (int)getLocalContactsCount
{    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    int count = CFArrayGetCount(results);
    
    CFRelease(results);
    
    CFRelease(addressBook);
    
    return count;
}

+ (NSMutableArray *)parseAllLocalContacts:(int)startProgress
{
    NSMutableArray *contactArray = [NSMutableArray array];
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    NSString *info = @"";
    
    [[ContactsDetector detector] publishProgress:startProgress];
    
    static const ABPropertyID c_propertyTypes[] =
    {
        kABPersonFirstNameProperty,
        kABPersonMiddleNameProperty,
        kABPersonLastNameProperty,
        kABPersonOrganizationProperty,
        kABPersonNoteProperty,
        kABPersonJobTitleProperty,
        kABPersonDepartmentProperty,
        kABPersonNicknameProperty,
        
        // 保存修改时间
        kABPersonModificationDateProperty,
    };

    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        
        NSMutableDictionary *personDict = [NSMutableDictionary dictionary];
        
        ABRecordID recordId = ABRecordGetRecordID(person);
        
        _Log(@"parseAllLocalContacts, recordId=%d", recordId);
        
        [personDict setObject:[NSNumber numberWithInt:recordId] forKey:kContactRecordIDKey];
        
        [personDict setObject:kNewKey forKey:kContactOperationKey];
        
        
        for (NSUInteger i = 0; i < (sizeof(c_propertyTypes) / sizeof(c_propertyTypes[0])); i++)
        {
            NSString *value = (NSString*)ABRecordCopyValue(person, c_propertyTypes[i]);
            if(value)
            {
                NSString *key = [NSString stringWithFormat:@"%d", c_propertyTypes[i]];
                [personDict setObject:value forKey:key];
            }
        }
        
        NSDate *birthday = (NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
        if(birthday)
        {
            NSString *key = [NSString stringWithFormat:@"%d", kABPersonBirthdayProperty];
            [personDict setObject:birthday forKey:key];
        }

        //读取电话多值
        {
            ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
            NSMutableArray *phoneArray = [NSMutableArray array];
            for (int k = 0; k < ABMultiValueGetCount(phone); k++)
            {
                //获取电话Label
                NSString * personPhoneLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
                //获取該Label下的电话值
                NSString * personPhone = (NSString*)ABMultiValueCopyValueAtIndex(phone, k);
                
                NSDictionary *itemDict = [NSDictionary dictionaryWithObject:personPhone forKey:personPhoneLabel];
                [phoneArray addObject:itemDict];
            }
            if ([phoneArray count])
            {
                NSString *key = [NSString stringWithFormat:@"%d", kABPersonPhoneProperty];
                [personDict setObject:phoneArray forKey:key];
            }
        }
        
        //获取URL多值
        {
            ABMultiValueRef url = ABRecordCopyValue(person, kABPersonURLProperty);
            NSMutableArray *urlArray = [NSMutableArray array];
            for (int m = 0; m < ABMultiValueGetCount(url); m++)
            {
                //获取url Label
                NSString * urlLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(url, m));
                //获取該Label下的值
                NSString * urlContent = (NSString*)ABMultiValueCopyValueAtIndex(url, m);
                
                NSDictionary *itemDict = [NSDictionary dictionaryWithObject:urlContent forKey:urlLabel];
                [urlArray addObject:itemDict];
            }
            if ([urlArray count])
            {
                NSString *key = [NSString stringWithFormat:@"%d", kABPersonURLProperty];
                [personDict setObject:urlArray forKey:key];
            }
        }
        
        //获取IM多值,
        ABMultiValueRef instantMessage = ABRecordCopyValue(person, kABPersonInstantMessageProperty);
        NSMutableArray *imArray = [NSMutableArray array];
        for (int l = 0; l < ABMultiValueGetCount(instantMessage); l++)
        {
            info = @"";
            
            //获取IM Label
            NSString* instantMessageLabel = (NSString*)ABMultiValueCopyLabelAtIndex(instantMessage, l);
            
            //获取該label下的2属性
            
            NSDictionary *instantMessageContent =(NSDictionary*) ABMultiValueCopyValueAtIndex(instantMessage, l);
            /*
            NSString *username = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
            info = username ? [info stringByAppendingFormat:@"%@|", username] : [info stringByAppendingFormat:@" |"];
            
            NSString *service = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
            info = service ? [info stringByAppendingFormat:@"%@|", service] : [info stringByAppendingFormat:@" |"];*/
            
            NSDictionary *itemDict = [NSDictionary dictionaryWithObject:instantMessageContent forKey:instantMessageLabel];
            [imArray addObject:itemDict];
        }
        if ([imArray count])
        {
            NSString *key = [NSString stringWithFormat:@"%d", kABPersonInstantMessageProperty];
            [personDict setObject:imArray forKey:key];
        }
        
        //获取dates多值
        ABMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
        NSMutableArray *dateArray = [NSMutableArray array];
        for (int y = 0; y < ABMultiValueGetCount(dates); y++)
        {
            //获取dates Label
            NSString* datesLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(dates, y));
            
            //获取dates值
            NSString* datesContent = (NSString*)ABMultiValueCopyValueAtIndex(dates, y);
            
            NSDictionary *itemDict = [NSDictionary dictionaryWithObject:datesContent forKey:datesLabel];
            [dateArray addObject:itemDict];
        }
        if ([dateArray count])
        {
            NSString *key = [NSString stringWithFormat:@"%d", kABPersonDateProperty];
            [personDict setObject:dateArray forKey:key];
        }
        
        //获取email多值
        ABMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
        NSMutableArray *emailArray = [NSMutableArray array];
        for (int x = 0; x < ABMultiValueGetCount(email); x++)
        {
            //获取email Label
            NSString* emailLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, x));
            //获取email值
            NSString* emailContent = (NSString*)ABMultiValueCopyValueAtIndex(email, x);
            
            NSDictionary *itemDict = [NSDictionary dictionaryWithObject:emailContent forKey:emailLabel];
            [emailArray addObject:itemDict];
        }
        if ([emailArray count])
        {
            NSString *key = [NSString stringWithFormat:@"%d", kABPersonEmailProperty];
            [personDict setObject:emailArray forKey:key];
        }
        
        //读取地址多值
        ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
        NSMutableArray *addressArray = [NSMutableArray array];
        for(int j = 0; j < ABMultiValueGetCount(address); j++)
        {
            info = @"";
            
            //获取地址Label
            NSString* addressLabel = (NSString*)ABMultiValueCopyLabelAtIndex(address, j);
            
            //获取該label下的地址6属性
            NSDictionary* personaddress =(NSDictionary*) ABMultiValueCopyValueAtIndex(address, j);
            /*
            NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
            info = country ? [info stringByAppendingFormat:@"%@|", country] : [info stringByAppendingFormat:@" |"];
            
            NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
            info = city ? [info stringByAppendingFormat:@"%@|", city] : [info stringByAppendingFormat:@" |"];
            
            NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
            info = state ? [info stringByAppendingFormat:@"%@|", state] : [info stringByAppendingFormat:@" |"];
            
            NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
            info = street ? [info stringByAppendingFormat:@"%@|", street] : [info stringByAppendingFormat:@" |"];
            
            NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
            info = zip ? [info stringByAppendingFormat:@"%@|", zip] : [info stringByAppendingFormat:@" |"];
            
            NSString* countrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
            info = countrycode ? [info stringByAppendingFormat:@"%@|", countrycode] : [info stringByAppendingFormat:@" |"];*/
            
            NSDictionary *itemDict = [NSDictionary dictionaryWithObject:personaddress forKey:addressLabel];
            [addressArray addObject:itemDict];
        }
        if ([addressArray count])
        {
            NSString *key = [NSString stringWithFormat:@"%d", kABPersonAddressProperty];
            [personDict setObject:addressArray forKey:key];
        }
        
        [contactArray addObject:personDict];
        
        [[ContactsDetector detector] publishProgress:startProgress + (i*40.f/CFArrayGetCount(results))];
    }
    
    CFRelease(results);
    
    CFRelease(addressBook);
    
    return contactArray;
}

- (NSArray *)changedContacts:(NSArray *)localContacts lastPost:(NSArray *)lastPostedContacts andChangesDict:(NSMutableDictionary *)changesDict
{
    NSMutableArray *newItems = [NSMutableArray array];
    NSMutableArray *updatedItems = [NSMutableArray array];
    NSMutableArray *deletedItems = [NSMutableArray array];
    
    int localIndex = 0;
    int oldIndex = 0;
    
    int localRecordId = 0;
    NSDate *localChangeDate = nil;
    for (; localIndex < [localContacts count]; )
    {
        [[ContactsDetector detector] publishProgress:40+(localIndex*20.f/[localContacts count])];
        
        BOOL flag = NO;
        
        NSDictionary *localPerson = [localContacts objectAtIndex:localIndex];
        localRecordId = [[localPerson objectForKey:kContactRecordIDKey] intValue];
        localChangeDate = [localPerson objectForKey:kPersonModifyDateKey];
        
        _Log(@"Local: id %d, change: %@", localRecordId, localChangeDate);
        
        for (; oldIndex < [lastPostedContacts count]; )
        {
            flag = YES;
            
            NSDictionary *oldPerson = [lastPostedContacts objectAtIndex:oldIndex];
            int oldRecordId = [[oldPerson objectForKey:kContactRecordIDKey] intValue];
            NSDate *oldChangeDate = [oldPerson objectForKey:kPersonModifyDateKey];
            
            if (localRecordId == oldRecordId)
            {
                if (![localChangeDate isEqualToDate:oldChangeDate])
                {
                    NSMutableDictionary *updatePerson = [NSMutableDictionary dictionaryWithDictionary:localPerson];
                    [updatePerson setObject:kUpdateKey forKey:kContactOperationKey];
                    [updatedItems addObject:updatePerson];
                    
                    _Log(@"changedContacts, person updated, first name: %@", [updatePerson objectForKey:kPersonFirstNameKey]);
                }
                
                ++oldIndex;
                ++localIndex;
                
                break;
            }
            else if (localRecordId < oldRecordId)
            {
                [newItems addObject:localPerson];
                ++localIndex;
                
                _Log(@"changedContacts, person added, first name: %@", [localPerson objectForKey:kPersonFirstNameKey]);
                
                break;
            }
            else if (localRecordId > oldRecordId)
            {
                NSMutableDictionary *deletePerson = [NSMutableDictionary dictionaryWithDictionary:oldPerson];
                [deletePerson setObject:kDeleteKey forKey:kContactOperationKey];
                [deletedItems addObject:deletePerson];
                ++oldIndex;
                
                _Log(@"changedContacts, person deleted, first name: %@", [deletePerson objectForKey:kPersonFirstNameKey]);
                
                break;
            }
        }
        
        if (!flag)
        {
            break;
        }
    }
    
    if (localIndex < [localContacts count])
    {
        for (; localIndex < [localContacts count]; )
        {
            NSDictionary *localPerson = [localContacts objectAtIndex:localIndex];
            
            [newItems addObject:localPerson];
            
            ++localIndex;
            
            _Log(@"changedContacts, person added, first name: %@", [localPerson objectForKey:kPersonFirstNameKey]);
        }
    }
    
    if (oldIndex < [lastPostedContacts count])
    {
        for (; oldIndex < [lastPostedContacts count]; )
        {
            NSDictionary *oldPerson = [lastPostedContacts objectAtIndex:oldIndex];
            
            NSMutableDictionary *deletePerson = [NSMutableDictionary dictionaryWithDictionary:oldPerson];
            [deletePerson setObject:kDeleteKey forKey:kContactOperationKey];
            [deletedItems addObject:deletePerson];
            
            ++oldIndex;
            
            _Log(@"changedContacts, person deleted, first name: %@", [deletePerson objectForKey:kPersonFirstNameKey]);
        }
    }
    
    NSMutableArray *contactsToPost = [NSMutableArray array];
    
    if ([newItems count])
    {
        [contactsToPost addObjectsFromArray:newItems];
        [changesDict setObject:[NSNumber numberWithInt:[newItems count]] forKey:kNewKey];
    }
    
    if ([updatedItems count])
    {
        [contactsToPost addObjectsFromArray:updatedItems];
        [changesDict setObject:[NSNumber numberWithInt:[updatedItems count]] forKey:kUpdateKey];
    }
    
    if ([deletedItems count])
    {
        [contactsToPost addObjectsFromArray:deletedItems];
        [changesDict setObject:[NSNumber numberWithInt:[deletedItems count]] forKey:kDeleteKey];
    }
    
    return contactsToPost;
}

- (NSDictionary *)dictionaryToPost:(NSArray *)contactsToPost
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"" forKey:@"name"];
    [dict setObject:@"" forKey:@"description"];
    [dict setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"version"];
    
    [dict setObject:contactsToPost forKey:@"content"];
    
    return dict;
}

- (id)postContactsToServer:(NSData *)data
{
    NSString *url = [DataLoader getContactsVersionsUrl];
    if (!url)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:kNoServerUrlErrorInfo, NSLocalizedDescriptionKey, nil];
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:dict];
        return error;
    }
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    NSData *requestData = data;
    [request appendPostData:requestData];
    [request setRequestMethod:@"POST"];
    
    request.showAccurateProgress = YES;
    request.uploadProgressDelegate = self;
    
    [request startSynchronous];
    
    _Log(@"postContactsToServer responseStatusCode: %d", request.responseStatusCode);
    
    NSError *error = [request error];
    if (!error)
    {
        _Log(@"postContactsToServer success");
    }
    else
    {
        _Log(@"%@", [error localizedDescription]);
    }
    
    [request release];
    
    return error;
}

- (void)publishProgress:(int)progress
{
    [self performSelectorOnMainThread:@selector(publishProgressFunction:) withObject:[NSNumber numberWithInt:progress] waitUntilDone:NO];
}

- (void)publishProgressFunction:(NSNumber *)progress
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:progress forKey:kContactProgressKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kContactProgressNotification object:nil userInfo:userInfo];
}

// 返回 nil 或 error
- (id)checkChangesAndPost
{
    NSMutableArray *localContacts = [ContactsDetector parseAllLocalContacts:0];
    NSArray *lastPostedContacts = [NSArray arrayWithContentsOfFile:kLastPostedContactsFile];
    
    NSMutableDictionary *changesDict = [NSMutableDictionary dictionary];
    NSArray *contactsToPost = [self changedContacts:localContacts lastPost:lastPostedContacts andChangesDict:changesDict];
    
    if (![contactsToPost count])
    {
        NSString *message = @"备份已完成";
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey, nil];
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:dict];
        return error;
    }
    
    NSDictionary *dictToPost = [self dictionaryToPost:contactsToPost];
    
    [[ContactsDetector detector] publishProgress:85];
    
    NSError *error = nil;
    NSData *dataToPost = [NSPropertyListSerialization dataWithPropertyList:dictToPost format:kCFPropertyListXMLFormat_v1_0 options:nil error:&error];
    
    if (error)
    {
        return error;
    }
    
    id result = [self postContactsToServer:dataToPost];
    if (!result)
    {
        [localContacts writeToFile:kLastPostedContactsFile atomically:YES];
    }
    
    int newCount = [[changesDict objectForKey:kNewKey] intValue];
    int delCount = [[changesDict objectForKey:kDeleteKey] intValue];
    _localContactsCount = [localContacts count];
    
    _serverContactsCount += newCount-delCount;
    
    {
        id versionObject = [self getLatestContactInfo];
        if ([versionObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *latestContactInfo = (NSDictionary *)versionObject;
            if ([[latestContactInfo allKeys] count]) {
                
                NSString *key = [[latestContactInfo allKeys] objectAtIndex:0];
                NSObject *object = [latestContactInfo objectForKey:key];
                if ([object isKindOfClass:[NSNumber class]])
                {
                    _serverContactsCount = [(NSNumber *)object intValue];
                }
            }
        }
    }
    
    [[ContactsDetector detector] publishProgress:100];

    return changesDict;
}

- (id)getLastestVersionDict
{
    NSString *url = [DataLoader getContactsVersionsUrl];
    if (!url)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:kNoServerUrlErrorInfo, NSLocalizedDescriptionKey, nil];
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:dict];
        return error;
    }
    
    id result = nil;
    
    // 服务器数量，先从备份列表中找到最新的备份
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    //设置请求方式
    [request setRequestMethod:@"GET"];
    request.timeOutSeconds = kTimeOut;
    
    request.showAccurateProgress = YES;
    request.downloadProgressDelegate = self;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error)
    {
        NSData *responseData = [request responseData];
        
        if ([responseData length])
        {
            NSDictionary * dict = NSUtil::dictionaryWithContentsOfData(responseData);
            NSArray *array = [dict objectForKey:@"versionlist"];
            if ([array count])
            {
                result = [[array lastObject] objectForKey:@"version"];
            }
            
            //[dict writeToFile:NSUtil::DocumentsSubPath(@"contacttopost1.xml") atomically:YES];
        }
    }
    else
    {
        result = error;
        _Log(@"getLastestVersionDict:%@", [error localizedDescription]);
    }
    
    [request release];
    
    return result;
}

// 通过带status的新接口 获取version count
- (id)getLatestContactInfo
{
    NSString *url = [DataLoader getContactLatestVersionInfoUrl];
    if (!url)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:kNoServerUrlErrorInfo, NSLocalizedDescriptionKey, nil];
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:dict];
        return error;
    }
    
    _Log(@"getContactLatestVersionInfoUrl, %@", url);
    
    id result = nil;
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    //设置请求方式
    [request setRequestMethod:@"GET"];
    request.timeOutSeconds = kTimeOut;
    
    request.showAccurateProgress = YES;
    request.downloadProgressDelegate = self;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error)
    {
        NSData *responseData = [request responseData];
        if ([responseData length])
        {
            NSDictionary * dict = NSUtil::dictionaryWithContentsOfData(responseData);
            
            result = dict;
            
            _Log(@"getLatestContactInfo:\n%@", dict);
        }
    }
    else
    {
        result = error;
    }
    
    [request release];
    
    return result;
}

- (id)getContactsOfVersion:(NSString *)version
{
    NSString *url = [DataLoader getContactsDetailsUrl:version];
    if (!url)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:kNoServerUrlErrorInfo, NSLocalizedDescriptionKey, nil];
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:dict];
        return error;
    }
    
    _Log(@"getContactsOfVersion, %@", url);
    
    id result = nil;
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    //设置请求方式
    [request setRequestMethod:@"GET"];
    request.timeOutSeconds = kTimeOut;
    
    request.showAccurateProgress = YES;
    request.downloadProgressDelegate = self;
    
    [request startSynchronous];
        
    NSError *error = [request error];
    if (!error)
    {
        NSData *responseData = [request responseData];        
        if ([responseData length])
        {
            NSDictionary * dict = NSUtil::dictionaryWithContentsOfData(responseData);
            
            //[dict writeToFile:NSUtil::DocumentsSubPath(@"contacttopost1.xml") atomically:YES];
            
            NSArray *array = [dict objectForKey:@"recordlist"];
            result = array;
        }
    }
    else
    {
        result = error;
        _Log(@"getContactsOfVersion:%@, %@", version, [error localizedDescription]);
    }
    
    [request release];
    
    return result;
}

- (id)checkLocalAndServerContactsInfo
{
    id versionObject = [self getLatestContactInfo];
    if ([versionObject isKindOfClass:[NSError class]])
    {
        return versionObject;
    }
    else if (!versionObject)
    {
        _serverContactsCount = 0;
    }
    else if ([versionObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *latestContactInfo = (NSDictionary *)versionObject;
        if ([[latestContactInfo allKeys] count]) {
            
            NSString *key = [[latestContactInfo allKeys] objectAtIndex:0];
            NSObject *object = [latestContactInfo objectForKey:key];
            if ([object isKindOfClass:[NSNumber class]])
            {
                _serverContactsCount = [(NSNumber *)object intValue];
            }
        }
    }
    
    // 本地数量
    _localContactsCount = [ContactsDetector getLocalContactsCount];
    
    return nil;
}

- (void)saveInfoToPerson:(NSDictionary *)info toPerson:(ABRecordRef)person
{
    static const ABPropertyID c_propertyTypes[] =
    {
        kABPersonFirstNameProperty,
        kABPersonMiddleNameProperty,
        kABPersonLastNameProperty,
        kABPersonOrganizationProperty,
        kABPersonNoteProperty,
        kABPersonJobTitleProperty,
        kABPersonDepartmentProperty,
        kABPersonNicknameProperty,
        
        // 保存修改时间
        //kABPersonModificationDateProperty,
    };
    
    for (NSUInteger i = 0; i < (sizeof(c_propertyTypes) / sizeof(c_propertyTypes[0])); i++)
    {
        NSString *key = [NSString stringWithFormat:@"%d", c_propertyTypes[i]];
        
        NSString *value = [info objectForKey:key];
        if(value)
        {
            ABRecordSetValue(person, c_propertyTypes[i], value, /*&error*/nil);
        }
    }
    
    // 生日
    {
        NSString *key = [NSString stringWithFormat:@"%d", kABPersonBirthdayProperty];
        NSDate *value = [info objectForKey:key];
        if (value)
        {
            ABRecordSetValue(person, kABPersonBirthdayProperty, value, /*&error*/nil);
        }
    }
    
    //读取电话多值
    {
        NSString *key = [NSString stringWithFormat:@"%d", kABPersonPhoneProperty];
        NSArray *valueArray = [info objectForKey:key];
        
        if ([valueArray count])
        {
            //用于存放具有多个值的项
            ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        
            for (NSDictionary *dict in valueArray)
            {
                NSString *labelKey = [[dict allKeys] objectAtIndex:0];
                NSString *labelValue = [dict objectForKey:labelKey];
                ABMultiValueAddValueAndLabel(multi, labelValue, (CFStringRef)labelKey, NULL);
            }
            
            ABRecordSetValue(person, kABPersonPhoneProperty, multi, /*&error*/NULL);
        }
    }
    
    //获取URL多值
    {
        NSString *key = [NSString stringWithFormat:@"%d", kABPersonURLProperty];
        NSArray *valueArray = [info objectForKey:key];
        
        if ([valueArray count])
        {
            //用于存放具有多个值的项
            ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            
            for (NSDictionary *dict in valueArray)
            {
                NSString *labelKey = [[dict allKeys] objectAtIndex:0];
                NSString *labelValue = [dict objectForKey:labelKey];
                ABMultiValueAddValueAndLabel(multi, labelValue, (CFStringRef)labelKey, NULL);
            }
            
            ABRecordSetValue(person, kABPersonURLProperty, multi, NULL);
        }
    }
    
    //获取IM多值,
    {
        NSString *labelKey = [NSString stringWithFormat:@"%d", kABPersonInstantMessageProperty];
        NSDictionary *value = [info objectForKey:labelKey];
        
        if (value && [value isKindOfClass:[NSDictionary class]])
        {
            //用于存放具有多个值的项
            ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABDictionaryPropertyType);
            
            ABMultiValueAddValueAndLabel(multi, value, (CFStringRef)labelKey, NULL);
            
            ABRecordSetValue(person, kABPersonInstantMessageProperty, multi, NULL);
        }
    }
    
    //获取dates多值
    {
        NSString *key = [NSString stringWithFormat:@"%d", kABPersonDateProperty];
        NSArray *valueArray = [info objectForKey:key];
        
        if ([valueArray count])
        {
            //用于存放具有多个值的项
            ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiDateTimePropertyType);
            
            for (NSDictionary *dict in valueArray)
            {
                NSString *labelKey = [[dict allKeys] objectAtIndex:0];
                NSString *labelValue = [dict objectForKey:labelKey];
                ABMultiValueAddValueAndLabel(multi, labelValue, (CFStringRef)labelKey, NULL);
            }
            
            ABRecordSetValue(person, kABPersonDateProperty, multi, NULL);
        }
    }
    
    //获取email多值
    {
        NSString *key = [NSString stringWithFormat:@"%d", kABPersonEmailProperty];
        NSArray *valueArray = [info objectForKey:key];
        
        if ([valueArray count])
        {
            //用于存放具有多个值的项
            ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            
            for (NSDictionary *dict in valueArray)
            {
                NSString *labelKey = [[dict allKeys] objectAtIndex:0];
                NSString *labelValue = [dict objectForKey:labelKey];
                ABMultiValueAddValueAndLabel(multi, labelValue, (CFStringRef)labelKey, NULL);
            }
            
            ABRecordSetValue(person, kABPersonEmailProperty, multi, NULL);
        }
    }
    
    //读取地址多值
    {
        NSString *labelKey = [NSString stringWithFormat:@"%d", kABPersonAddressProperty];
        NSDictionary *value = [info objectForKey:labelKey];
        
        if (value && [value isKindOfClass:[NSDictionary class]])
        {
            //用于存放具有多个值的项
            ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABDictionaryPropertyType);
            
            ABMultiValueAddValueAndLabel(multi, value, (CFStringRef)labelKey, NULL);
            
            ABRecordSetValue(person, kABPersonAddressProperty, multi, NULL);
        }
    }
}

// 还原过程中新增的 record ，的id 提交到服务器端
- (id)postNewIdsToServer:(NSDictionary *)dict
{
    NSError *error = nil;
    NSData *dataToPost = [NSPropertyListSerialization dataWithPropertyList:dict format:kCFPropertyListXMLFormat_v1_0 options:nil error:&error];
    
    if (error)
    {
        return error;
    }

    NSString *url = [DataLoader getContactsChangeIdUrl];
    if (!url)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:kNoServerUrlErrorInfo, NSLocalizedDescriptionKey, nil];
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:dict];
        return error;
    }
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    NSData *requestData = dataToPost;
    [request appendPostData:requestData];
    [request setRequestMethod:@"POST"];
    
    request.uploadProgressDelegate = self;
    request.showAccurateProgress = YES;
    
    [request startSynchronous];
    
    _Log(@"postNewIdsToServer responseStatusCode: %d", request.responseStatusCode);
    
    error = [request error];
    if (!error)
    {
        _Log(@"postNewIdsToServer success");
    }
    else
    {
        _Log(@"%@", [error localizedDescription]);
    }
    
    [request release];
    
    return error;
}

- (id)restoreFromServer
{
    NSArray *serverContacts = nil;
    
    /*
    id versionObject = [self getLastestVersionDict];
    if ([versionObject isKindOfClass:[NSError class]])
    {
        return versionObject;
    }
    else if (!versionObject)
    {
        _serverContactsCount = 0;
    }
    else if ([versionObject isKindOfClass:[NSString class]])
    {
        id contactsObject = [self getContactsOfVersion:versionObject];
        
        if ([contactsObject isKindOfClass:[NSError class]])
        {
            return contactsObject;
        }
        else if (!contactsObject)
        {
            _serverContactsCount = 0;
        }
        else if ([contactsObject isKindOfClass:[NSArray class]])
        {
            _serverContactsCount = 0;
            
            serverContacts = (NSArray *)contactsObject;
            for (NSDictionary *dict in (NSArray *)contactsObject)
            {
                NSString *option = [dict objectForKey:kContactOperationKey];
                if (![option isEqualToString:kDeleteKey])
                {
                    _serverContactsCount++;
                }
            }
        }
    }*/
    
    [[ContactsDetector detector] publishProgress:0];
    
    id versionInfoObject = [self getLatestContactInfo];
    if ([versionInfoObject isKindOfClass:[NSError class]])
    {
        return versionInfoObject;
    }
    else if (!versionInfoObject)
    {
        _serverContactsCount = 0;
    }
    else if ([versionInfoObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *latestContactInfo = (NSDictionary *)versionInfoObject;
        if ([[latestContactInfo allKeys] count]) {
            
            NSString *key = [[latestContactInfo allKeys] objectAtIndex:0];
            _serverContactsCount = [[latestContactInfo objectForKey:key] intValue];
            
            if ([key length])
            {
                id contactsObject = [self getContactsOfVersion:key];
                
                if ([contactsObject isKindOfClass:[NSError class]])
                {
                    return contactsObject;
                }
                else if (!contactsObject)
                {
                    _serverContactsCount = 0;
                }
                else if ([contactsObject isKindOfClass:[NSArray class]])
                {
                    _serverContactsCount = 0;
                    
                    serverContacts = (NSArray *)contactsObject;
                    for (NSDictionary *dict in (NSArray *)contactsObject)
                    {
                        NSString *option = [dict objectForKey:kContactOperationKey];
                        if (![option isEqualToString:kDeleteKey])
                        {
                            _serverContactsCount++;
                        }
                    }
                }
            }
        }
    }
    
    [[ContactsDetector detector] publishProgress:20];
    
    NSMutableArray *localContacts = [ContactsDetector parseAllLocalContacts:20];
    
    int newCount = 0;
    int updateCount = 0;
    
    NSMutableDictionary *newIdDict = [NSMutableDictionary dictionary];
    
    int count = 0;
    
    for (NSDictionary *serverPerson in serverContacts)
    {
        [[ContactsDetector detector] publishProgress:(60+count*30.f/[serverContacts count])];
        
        count++;
        
        ABRecordID serverRId = [[serverPerson objectForKey:kContactRecordIDKey] intValue];
        NSString *serverPOption = [serverPerson objectForKey:kContactOperationKey];
        if ([serverPOption isEqualToString:kDeleteKey])
        {
            // 忽略服务器上已标记为 删除 的条目。
            continue;
        }
        
        NSDate *serverPDate = [serverPerson objectForKey:kPersonModifyDateKey];
        
        BOOL find = NO;
        
        for (NSDictionary *localPerson in localContacts)
        {
            ABRecordID localRId = [[localPerson objectForKey:kContactRecordIDKey] intValue];
            NSDate *localPDate = [localPerson objectForKey:kPersonModifyDateKey];
            
            if (serverRId == localRId)
            {
                find = YES;
                if (![localPDate isEqualToDate:serverPDate])
                {
                    // TODO: 修改联系人信息
                    
                    ABAddressBookRef addressBook = ABAddressBookCreate();
                    
                    ABRecordRef newPerson = ABAddressBookGetPersonWithRecordID(addressBook, localRId);
                    [self saveInfoToPerson:serverPerson toPerson:newPerson];
                    
                    //ABAddressBookAddRecord(addressBook, newPerson, nil);
                    ABAddressBookSave(addressBook, NULL);
                    
                    updateCount++;
                }

                break;
            }
        }
        
        if (!find)
        {
            // TODO: 添加联系人
            ABAddressBookRef addressBook = ABAddressBookCreate();
            
            ABRecordRef newPerson = ABPersonCreate();
            [self saveInfoToPerson:serverPerson toPerson:newPerson];
            
            ABAddressBookAddRecord(addressBook, newPerson, nil);
            ABAddressBookSave(addressBook, NULL);
            
            newCount++;
            
            ABRecordID recordId = ABRecordGetRecordID(newPerson);
            [newIdDict setObject:[NSNumber numberWithInt:recordId] forKey:[NSString stringWithFormat:@"%d", serverRId]];
        }
    }
    
    NSMutableDictionary *changesDict = [NSMutableDictionary dictionary];
    if (updateCount)
    {
        [changesDict setObject:[NSNumber numberWithInt:updateCount] forKey:kUpdateKey];
    }
    if (newCount)
    {
        [changesDict setObject:[NSNumber numberWithInt:newCount] forKey:kNewKey];
    }
    
    // TODO:保存本地数据
    _localContactsCount = [localContacts count];
    _localContactsCount += newCount;
    
    // 提交新ids 到服务器
    if (newCount)
    {
        _Log(@"post newids: \n%@", newIdDict);
        [self postNewIdsToServer:newIdDict];
    }
    
    [[ContactsDetector detector] publishProgress:100];
    
    return changesDict;
}

// ASIProgressDelegate
- (void)setProgress:(float)newProgress
{
    _Log(@"ASIProgressDelegate %f", newProgress);
}

@end

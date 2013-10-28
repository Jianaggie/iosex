//
//  GBDeviceInfo.m
//  VLC Remote
//
//  Created by Luka Mirošević on 15/02/2012.
//  Copyright (c) 2012 Goonbee. All rights reserved.
//
//  This software is licensed under the terms of the GNU General Public License.
//  http://www.gnu.org/licenses/

//NOTE, adjust code when double digit model numbers come out

#import "GBDeviceInfo.h"

#import <sys/utsname.h>

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>

@implementation GBDeviceInfo

+(GBDeviceDetails)deviceDetails {
    GBDeviceDetails details;
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *systemInfoString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //get data
    if ([[systemInfoString substringToIndex:6] isEqualToString:@"iPhone"]) {
        details.family = GBDeviceFamilyiPhone;
        details.bigModel = [[systemInfoString substringWithRange:NSMakeRange(6, 1)] intValue];
        details.smallModel = [[systemInfoString substringWithRange:NSMakeRange(8, 1)] intValue];
        
        if (details.bigModel == 1) {
            if (details.smallModel == 1) {
                details.model = GBDeviceModeliPhone;
            }
            else if (details.smallModel == 2) {
                details.model = GBDeviceModeliPhone3G;
            }
            else {
                details.model = GBDeviceModelUnknown;
            }
        }
        else if (details.bigModel == 2) {
            details.model = GBDeviceModeliPhone3GS;
        }
        else if (details.bigModel == 3) {
            details.model = GBDeviceModeliPhone4;
        }
        else if (details.bigModel == 4) {
            details.model = GBDeviceModeliPhone4S;
        }
        else if (details.bigModel == 5) {
            details.model = GBDeviceModeliPhone5;
        }
        else {
            details.model = GBDeviceModelUnknown;
        }
    }
    else if ([[systemInfoString substringToIndex:4] isEqualToString:@"iPad"]) {
        details.family = GBDeviceFamilyiPad;
        details.bigModel = [[systemInfoString substringWithRange:NSMakeRange(4, 1)] intValue];
        details.smallModel = [[systemInfoString substringWithRange:NSMakeRange(6, 1)] intValue];
        
        switch (details.bigModel) {
            case 1:
                details.model = GBDeviceModeliPad;
                break;
                
            case 2:
                details.model = GBDeviceModeliPad2;
                break;
                
            case 3:
                details.model = GBDeviceModeliPad3;
                break;
                
            case 4:
                details.model = GBDeviceModeliPad4;
                break;
                
            default:
                details.model = GBDeviceModelUnknown;
                break;
        }
    }
    else if ([[systemInfoString substringToIndex:4] isEqualToString:@"iPod"]) {
        details.family = GBDeviceFamilyiPod;
        details.bigModel = [[systemInfoString substringWithRange:NSMakeRange(4, 1)] intValue];
        details.smallModel = [[systemInfoString substringWithRange:NSMakeRange(6, 1)] intValue];
        
        switch (details.bigModel) {
            case 1:
                details.model = GBDeviceModeliPod;
                break;
                
            case 2:
                details.model = GBDeviceModeliPod2;
                break;
                
            case 3:
                details.model = GBDeviceModeliPod3;
                break;
                
            case 4:
                details.model = GBDeviceModeliPod4;
                break;
                
            case 5:
                details.model = GBDeviceModeliPod5;
                break;
                
            default:
                details.model = GBDeviceModelUnknown;
                break;
        }
    }
    else {
        details.family = GBDeviceFamilyUnknown;
        details.bigModel = 0;
        details.smallModel = 0;
        details.model = GBDeviceModelUnknown;
    }
    
    //get screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //ipad old
    if ((screenWidth == 768) && (screenHeight == 1024)) {
        details.display = GBDeviceDisplayiPad;
    }
    //iphone
    else if ((screenWidth == 320) && (screenHeight == 480)) {
        details.display = GBDeviceDisplayiPhone35Inch;
    }
    //iphone 4 inch
    else if ((screenWidth == 320) && (screenHeight == 568)) {
        details.display = GBDeviceDisplayiPhone4Inch;
    }
    //unknown
    else {
        details.display = GBDeviceDisplayUnknown;
    }
    
    return details;
}

+(NSString *)rawSystemInfoString {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *) _macAddress
{
	int					mib[6];
	size_t				len;
	char				*buf;
	unsigned char		*ptr;
	struct if_msghdr	*ifm;
	struct sockaddr_dl	*sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0)
	{
		_Log(@"Error: if_nametoindex error");
		return NULL;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
	{
		_Log(@"Error: sysctl, take 1");
		return NULL;
	}
	
	if ((buf = (char*)malloc(len)) == NULL)
	{
		_Log(@"Could not allocate memory. error!");
		return NULL;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
	{
		_Log(@"Error: sysctl, take 2");
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
	return [outstring uppercaseString];
}

+ (NSString*) md5:(NSString*)text
{
	if(nil==text || text.length<1) return nil;
    
    const char *value = [text UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    NSMutableString *hash = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++)
        [hash appendFormat:@"%02x",outputBuffer[count]];
	return [hash autorelease];
}

+ (NSString *)xUniqueIdentifier
{
    NSString *mac = [self _macAddress];
	NSString *str = [[NSString alloc] initWithFormat:@"xIdm.%@", mac];
	NSString *uid = [self md5:str];
	[str release];
	return uid;
}

@end
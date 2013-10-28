
#import "NSUtil.h"
#import "UIUtil.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <CommonCrypto/CommonDigest.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
@implementation NSString (utils)

- (UIColor *)toUIColor
{
	if (![self length])
	{
		return [UIColor blackColor];
	}
	
    unsigned int c;
    if ([self characterAtIndex:0] == '#') 
    {
        [[NSScanner scannerWithString:[self substringFromIndex:1]] scanHexInt:&c];
    } 
    else 
    {
        [[NSScanner scannerWithString:self] scanHexInt:&c];
    }
    
    if ([self length] == 9)
    {
        return [UIColor colorWithRed:((c & 0xff000000) >> 24)/255.0 green:((c & 0xff0000) >> 16)/255.0 blue:((c & 0xff00) >> 8)/255.0 alpha:(c & 0xff)/100.0];
    }
    else if ([self length] == 8)
    {
        return [UIColor colorWithRed:((c & 0xff00000) >> 20)/255.0 green:((c & 0xff000) >> 12)/255.0 blue:((c & 0xff0) >> 4)/255.0 alpha:(c & 0xf)/100.0];
    }
    else if ([self length] == 7)
    {
        return [UIColor colorWithRed:((c & 0xff0000) >> 16)/255.0 green:((c & 0xff00) >> 8)/255.0 blue:(c & 0xff)/255.0 alpha:1.0];
    }
    
    return [UIColor blackColor];
}

- (NSDictionary *)parseUrlParams
{
	NSRange range = [self rangeOfString:@"?"];
	if (range.length == 0)
	{
		return nil;
	}
	
	NSString *urlString = [NSString stringWithFormat:@"%@&", [self substringFromIndex:range.location+1]];
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
	NSRange tempRange = [urlString rangeOfString:@"&"];
    while ([urlString length] && tempRange.length) 
	{
		NSString *text = [urlString substringToIndex:tempRange.location];
		if (text)
		{
			NSRange range = [text rangeOfString:@"="];
			if (range.length)
			{				
				[dict setObject:[text substringFromIndex:range.location+1] forKey:[text substringWithRange:NSMakeRange(0, range.location)]];
			}
		}
		
        urlString = [urlString stringByReplacingOccurrencesOfString:
				[NSString stringWithFormat:@"%@&", text] withString:@""];
		
		tempRange = [urlString rangeOfString:@"&"];
    }
		
    return dict;
}

- (NSDictionary *)parseParams
{	
	NSString *urlString = [NSString stringWithFormat:@"%@|", self];
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
	NSRange tempRange = [urlString rangeOfString:@"|"];
    while ([urlString length] && tempRange.length) 
	{
		NSString *text = [urlString substringToIndex:tempRange.location];
		if (text)
		{
			NSRange range = [text rangeOfString:@"="];
			if (range.length)
			{				
				[dict setObject:[text substringFromIndex:range.location+1] forKey:[text substringWithRange:NSMakeRange(0, range.location)]];
			}
		}
		
        urlString = [urlString stringByReplacingOccurrencesOfString:
                     [NSString stringWithFormat:@"%@|", text] withString:@""];
		
		tempRange = [urlString rangeOfString:@"|"];
    }
    
    return dict;
}

- (NSString *)addPrevBlank
{
    return [NSString stringWithFormat:@"  %@", self];
}

@end
void NSUtil::startGettingInfo(NSString* url, id idDelegate)
{
    NSURL *requestURL = [NSURL URLWithString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestURL];
    [request setDelegate:idDelegate];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [request startAsynchronous];
}
//以hud的形式显示信息
void NSUtil::showMessageWithHUD(NSString* msg, id idDelegate)
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[idDelegate view] animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud showWhileExecuting:@selector(waitFor) onTarget:hud withObject:nil animated:YES];
}
#pragma mark Member variables

//
NSMutableDictionary *NSUtil::_settings =
#ifdef _PRELOAD_SETTINGS
LoadSettings();
#else
nil;
#endif


#pragma mark Network methods

// Check network connection status
#ifdef _FRAMEWORK_SystemConfiguration
NSUtil::NetworkConnection NSUtil::NetworkConnectionStatus()
{
	NetworkConnection status = NetworkConnectionNONE;

	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [@"www.apple.com" UTF8String]);
	if (reachability)
	{
		SCNetworkReachabilityFlags flags;
		if (SCNetworkReachabilityGetFlags(reachability, &flags))
		{
			if (flags & kSCNetworkReachabilityFlagsReachable)
			{
				if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
				{
					// if target host is reachable and no connection is required then we'll assume (for now) that your on Wi-Fi
					status = NetworkConnectionWIFI;
				}

				if ((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) ||
					(flags & kSCNetworkReachabilityFlagsConnectionOnTraffic))
				{
					// ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs
					if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
					{
						// ... and no [user] intervention is needed
						status = NetworkConnectionWIFI;
					}
				}
				
				if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
				{
					// ... but WWAN connections are OK if the calling application is using the CFNetwork (CFSocketStream?) APIs.
					status = NetworkConnectionWWAN;
				}
			}
		}
		CFRelease(reachability);
	}

	return status;
}

// Check if the network is available.
BOOL NSUtil::IsNetworkAvailable()
{

	// Set address to 0.0.0.0 to check the local network..
	struct sockaddr zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sa_len = sizeof(zeroAddress);
	zeroAddress.sa_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;

	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);

	if (!didRetrieveFlags)
	{
		return NO;
	}

	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	
	return (isReachable && !needsConnection);
}
#endif


#pragma mark Http request methods

// Request HTTP data
NSData *NSUtil::HttpData(NSString *url, NSData *post)
{
	UIUtil::ShowNetworkIndicator(YES);
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]]; 
	if (post)
	{
		[request setHTTPMethod:@"POST"];
		[request setHTTPBody:post];
	}
	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	UIUtil::ShowNetworkIndicator(NO);
	return data;
}

// Request HTTP string
NSString *NSUtil::HttpString(NSString *url, NSString *post)
{
	NSData *send = post ? [NSData dataWithBytes:[post UTF8String] length:[post length]] : nil;
	NSData *recv = NSUtil::HttpData(url, send);
	return recv ? [[[NSString alloc] initWithData:recv encoding:NSUTF8StringEncoding] autorelease] : nil;
}


// Request HTTP file
// Return error string, or nil on success
NSString *NSUtil::HttpFile(NSString *url, NSString *path)
{
	UIUtil::ShowNetworkIndicator(YES);
	
	NSError *error = nil;
	NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url] options:NSUncachedRead error:&error];
	if (data != nil)
	{
		[data writeToFile:path atomically:NO];
		[data release];
	}
	
	UIUtil::ShowNetworkIndicator(NO);
	
	return data ? nil : error.localizedDescription;
}


#pragma mark Misc methods

// Check email address
BOOL NSUtil::IsEmailAddress(NSString *emailAddress)
{
	NSString *emailRegEx = 
	@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
	@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
	@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
	@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
	@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
	@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
	@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
	
	NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
	return [regExPredicate evaluateWithObject:[emailAddress lowercaseString]];
}

// Calculate MD5 for a string
NSString *NSUtil::CalculateMD5(NSString *str)
{
	if (str == nil) return nil;
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	const char *cstr = [str UTF8String];
	CC_MD5(cstr, strlen(cstr), result);
	return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

// Convert number to string
NSString *NSUtil::FormatNumber(NSNumber *number, NSNumberFormatterStyle style)
{
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:style];
	NSString *result = [formatter stringFromNumber:number];
	[formatter release];
	return result;
}

// Convert date to string
NSString *NSUtil::FormatDate(NSDate *date, NSDateFormatterStyle dateStyle, NSDateFormatterStyle timeStyle)
{
	if ((dateStyle == kCFDateFormatterNoStyle) && (timeStyle == kCFDateFormatterNoStyle))
	{
		NSDate *now = [NSDate date];
		NSTimeInterval t1 = [now timeIntervalSinceReferenceDate];
		NSTimeInterval t2 = [date timeIntervalSinceReferenceDate];
		NSTimeInterval t = [[NSTimeZone defaultTimeZone] secondsFromGMT];
		NSInteger d1 = (t1 + t) / (24 * 60 * 60);
		NSInteger d2 = (t2 + t) / (24 * 60 * 60);
		NSInteger days = d2 - d1;
		
		//NSLog(@"%@", date);

		if (days == 0)
		{
			//return NSLocalizedString(@"Today", nil);
			timeStyle = NSDateFormatterShortStyle;
		}
		else if (days == -1)
		{
			return NSLocalizedString(@"Yesterday", nil);
		}
		else
		{
			dateStyle = NSDateFormatterMediumStyle;
		}
	}	
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateStyle:dateStyle];
	[formatter setTimeStyle:timeStyle];
	return [formatter stringForObjectValue:date];
}

NSString *NSUtil::FormatDataWithType(int type, NSDate *date)
{
    if (!date)
    {
        return nil;
    }
    
    NSString *pubDate = nil;
    switch (type)
    {
        case 0:
        {
            pubDate = NSUtil::FormatDate(date);
        }
            break;
            
        case 1:
        {
            pubDate = NSUtil::FormatDate(date, NSDateFormatterMediumStyle, kCFDateFormatterShortStyle);
        }
            break;
            
        case 2:
        {
            pubDate = NSUtil::FormatDate(date, NSDateFormatterMediumStyle, kCFDateFormatterNoStyle);
        }
            break;
            
        case 3:
        {
            pubDate = NSUtil::FormatDate(date, kCFDateFormatterNoStyle, kCFDateFormatterShortStyle);
        }
            break;
    }
    
    return pubDate;
}

NSDate * NSUtil::ParseDate(NSString * str)
{
	if (!str) 
		return nil;
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *date = [formatter dateFromString: str];
	return date;
}

NSString *NSUtil::FormatDateWithFormat(NSDate *date, NSString *format)
{
    if (!date)
		return nil;
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:format];
	NSString *str = [formatter stringFromDate:date];
	return str;
}

//
//
NSString * NSUtil::FlattenHTML(NSString *html)
{
    NSScanner *scanner;
    NSString *text = nil;
	
    scanner = [NSScanner scannerWithString:html];
	
    while ([scanner isAtEnd] == NO) 
	{
        // find start of tag
        [scanner scanUpToString:@"<" intoString:nil] ; 
		
        // find end of tag
        [scanner scanUpToString:@">" intoString:&text] ;
		
        html = [html stringByReplacingOccurrencesOfString:
				[NSString stringWithFormat:@"%@>", text] withString:@""];
		
    }
    
	html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
	html = [html stringByReplacingOccurrencesOfString:@" " withString:@""];
	//html = [html stringByReplacingOccurrencesOfString:@"&mdash;&mdash;" withString:@" "];
	
    return html;
}

time_t convertTimeStamp(NSString *stringTime) {
	// Convert timestamp string to UNIX time
    //
	time_t createdAt;
    struct tm created;
    time_t now;
    time(&now);
    
    if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		createdAt = mktime(&created);
	}
	return createdAt;
}

NSString *timestampWeibo(time_t createdAt)
{
	NSString *_timestamp = nil;
    
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, createdAt);
    if (distance < 0) distance = 0;
    
    if (distance < 60) {
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"秒前" : @"秒前"];
    }
    else if (distance < 60 * 60) {  
        distance = distance / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"分钟前" : @"分钟前"];
    }  
    else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"小时前" : @"小时前"];
    }
    else if (distance < 60 * 60 * 24 * 7) {
        distance = distance / 60 / 60 / 24;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"天前" : @"天前"];
    }
    else if (distance < 60 * 60 * 24 * 7 * 4) {
        distance = distance / 60 / 60 / 24 / 7;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"周前" : @"周前"];
    }
    else {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];        
        _timestamp = [dateFormatter stringFromDate:date];
    }
    return _timestamp;
}
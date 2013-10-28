
#import <Foundation/Foundation.h>

//
#undef NSLocalizedString 
#define NSLocalizedString(key, comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:(key) table:nil]

/*
//
#ifndef __OPTIMIZE__
#define _Log(s, ...) NSLog(@"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define _Log(s, ...) 
#endif*/

/*
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif*/


//
#define kSettingsFile	@"Settings.plist"

@interface NSString (utils)

- (UIColor *)toUIColor;

- (NSDictionary *)parseUrlParams;

- (NSDictionary *)parseParams;

- (NSString *)addPrevBlank;

@end

//
namespace NSUtil
{
	//异步下载软件列表，使用ASIHttpRequest
    void startGettingInfo(NSString* url, id idDelegate);
    //以hud的形式显示信息
    void showMessageWithHUD(NSString* msg, id idDelegate);
#pragma mark Appcalition path methods
	
	//
	NS_INLINE NSBundle *Bundle()
	{
		return [NSBundle mainBundle];
	}
	
	//
	NS_INLINE id BundleInfo(NSString *key)
	{
		return [Bundle() objectForInfoDictionaryKey:key];
	}
	
	//
	NS_INLINE NSString *BundleName()
	{
		return BundleInfo(@"CFBundleName");
	}
	
	//
	NS_INLINE NSString *BundleDisplayName()
	{
		return BundleInfo(@"CFBundleDisplayName");
	}
	
	//
	NS_INLINE NSString *BundleVersion()
	{
		return BundleInfo(@"CFBundleVersion");
	}
	
	//
	NS_INLINE NSString *BundlePath()
	{
		return [Bundle() bundlePath];
	}
	
	//
	NS_INLINE NSString *BundleSubPath(NSString *file)
	{
		return [BundlePath() stringByAppendingPathComponent:file];
	}
	
	//
	NS_INLINE NSString *UserDirectoryPath(NSSearchPathDirectory directory)
	{
		return [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) objectAtIndex:0];
	}
	
	//
	NS_INLINE NSString *DocumentsPath()
	{
		return UserDirectoryPath(NSDocumentDirectory);
	}
	
	// 
	NS_INLINE NSString *DocumentsSubPath(NSString *file)
	{
		return [DocumentsPath() stringByAppendingPathComponent:file];
	}
    
    //
	NS_INLINE NSString *CacheSubPath(NSString *file)
	{
		return [UserDirectoryPath(NSCachesDirectory) stringByAppendingPathComponent:file];
	}
    
    NS_INLINE NSString *TempSubPath(NSString *file)
	{
		return [NSTemporaryDirectory() stringByAppendingPathComponent:file];
	}
    
	//
	NS_INLINE NSFileManager *FileManager()
	{
		return [NSFileManager defaultManager];
	}
	
	//
	NS_INLINE BOOL IsPathExist(NSString* path)
	{
		return [FileManager() fileExistsAtPath:path];
	}
	
	//
	NS_INLINE BOOL IsFileExist(NSString* path)
	{
		BOOL isDirectory;
		return [FileManager() fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory;
	}
	
	NS_INLINE BOOL IsDirectoryExist(NSString* path)
	{
		BOOL isDirectory;
		return [FileManager() fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory;
	}
    
    NS_INLINE NSDate *ModifyDate(NSString *dir)
    {
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:dir error:nil];
        return [dict fileModificationDate];
    }
    
    NS_INLINE NSString *GetUUID()
    {
#if TARGET_IPHONE_SIMULATOR
#ifdef DEBUG
        return @"5073495ee44546a8dbfbe456ee285c27fb35622b";
        //return @"331ad2a2265ed6e6380e3482006e1aafe99e4d50";
        //return @"34cc348f2e02052a4b09051e0479cfb3fa6d93d2";
        //return @"58401517f74214c2f7e4ae5090015fdba600d928";
#endif
#endif
        return [UIDevice currentDevice].uniqueIdentifier;
    }
	
	
#pragma mark Settings dictionary methods

	// Load settings
	NS_INLINE NSMutableDictionary *LoadSettings(NSString *file = kSettingsFile)
	{
#ifdef _PRELOAD_SETTINGS
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#endif
		NSString *path = NSUtil::DocumentsSubPath(file);
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
		if (dict == nil) dict = [[NSMutableDictionary alloc] init];
#ifdef _PRELOAD_SETTINGS
		[pool release];
#endif
		return dict;
	}

    extern NSMutableDictionary *_settings;
    
	//
	NS_INLINE NSMutableDictionary *Settings()
	{
#ifndef _PRELOAD_SETTINGS
		if (_settings == nil) _settings = LoadSettings();
#endif
		return _settings;
	}
	
	//
	NS_INLINE void SaveSettings(NSString *file = kSettingsFile)
	{
		[Settings() writeToFile:DocumentsSubPath(file) atomically:YES];
	}

	//
	NS_INLINE id SettingForKey(NSString *key)
	{
		return [Settings() valueForKey:key];
	}

	//
	NS_INLINE void SetSettingForKey(NSString *key, id value = nil)
	{
		[Settings() setValue:value forKey:key];
	}

	// 
	NS_INLINE void SaveSettingForKey(NSString *key, id value = nil, NSString *file = kSettingsFile)
	{
		SetSettingForKey(key, value);
		SaveSettings(file);
	}


#pragma mark Network methods

	// Network connection enum
	enum NetworkConnection {NetworkConnectionNONE, NetworkConnectionWWAN, NetworkConnectionWIFI};

	// Check network connection status
	NetworkConnection NetworkConnectionStatus();
	
	// Check if the network is available.
	BOOL IsNetworkAvailable();

#pragma mark Http request methods

	// Request HTTP data
	NSData *HttpData(NSString *url, NSData *post = nil);
	
	// Request HTTP string
	NSString *HttpString(NSString *url, NSString *post = nil);
	
	// Request HTTP file
	// Return error string, or nil on success
	NSString *HttpFile(NSString *url, NSString *path);


#pragma mark Misc methods
	
	// Check email address
	BOOL IsEmailAddress(NSString *emailAddress);
	
	// Calculate MD5 for a string
	NSString *CalculateMD5(NSString *str);
	
	// Convert number to string
	NSString *FormatNumber(NSNumber *number, NSNumberFormatterStyle style = (NSNumberFormatterStyle)kCFNumberFormatterNoStyle);

	// Convert date to string
	NSString *FormatDate(NSDate *date = [NSDate date], NSDateFormatterStyle dateStyle = ()kCFDateFormatterNoStyle, NSDateFormatterStyle timeStyle = kCFDateFormatterNoStyle);
    
    NSString *FormatDataWithType(int type, NSDate *date);
	
	NSDate * ParseDate(NSString * str);
    
    NSString *FormatDateWithFormat(NSDate *date, NSString *format = @"yyyy-MM-dd HH:mm:ss");
    
    //
    NSString * FlattenHTML(NSString *html);
    
    // for weibo.
    time_t convertTimeStamp(NSString *stringTime);
    NSString *timestampWeibo(time_t createdAt);
    
    NS_INLINE CGFloat FolderSize(NSString *dir)
	{
		//
		unsigned long long size = 0;
		NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:dir];
		for (NSString *file in files)
		{
			NSString *path = [dir stringByAppendingPathComponent:file];
			NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
			size += [dict fileSize];
		}
		
		return size / (1024.0 * 1024.0);
	}
    
    NS_INLINE NSDictionary * dictionaryWithContentsOfData(NSData *data)
    {
        CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (CFDataRef)data,
                                                                   kCFPropertyListImmutable,
                                                                   NULL);
        if(plist == nil) return nil;
        if ([(id)plist isKindOfClass:[NSDictionary class]]) {
            return [(NSDictionary *)plist autorelease];
        }
        else {
            CFRelease(plist);
            return nil;
        }
    }
    
    NS_INLINE NSArray * arrayWithContentsOfData(NSData *data)
    {
        CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (CFDataRef)data,
                                                                   kCFPropertyListImmutable,
                                                                   NULL);
        if(plist == nil) return nil;
        if ([(id)plist isKindOfClass:[NSArray class]]) {
            return [(NSArray *)plist autorelease];
        }
        else {
            CFRelease(plist);
            return nil;
        }
    }
};


#import <Foundation/Foundation.h>

#define XLFLoadCategory(UNIQUE_NAME) @interface FORCELOAD_##UNIQUE_NAME :NSObject @end @implementation FORCELOAD_##UNIQUE_NAME @end

#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#pragma mark - 常用计算
#define select(condition,vTrue,vFalse)                         (condition?vTrue:vFalse)

#pragma mark - 系统属性
/**
 *  状态栏高度
 */
#define STATUSBAR_HEIGHT                                    20
/**
 *  导航栏高度
 */
#define NAVGATIONBAR_HEIGHT                                 44

/**
 *  屏幕高度
 */
#define SCREEN_HEIGHT                                       [UIScreen mainScreen].bounds.size.height
/**
 *  屏幕宽度
 */
#define SCREEN_WIDTH                                        [UIScreen mainScreen].bounds.size.width

/**
 *  操作系统版本号
 */
#define IOS_VERSION                                         [[[UIDevice currentDevice] systemVersion] floatValue]

/**
 *
 *  系统分配的软件颁布流水号,用于保存在NSUserDefaluts
 *
 */
#define DefaultCoreDataSQLiteFileName                       @"DefaultCoreData"

#pragma mark - 系统属性判断

/**
 *  是否iPhone
 */
#define IS_IPHONE                                           UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

/**
 *  url参数是否utf-16编码
 */
#define IS_UTF16ENCODE                                      NO

#pragma mark - 系统设置 key
/**
 *  是否自动登录
 */
#define kUserDefaultUserAutoLogin                           @"kUserDefaultUserAutoLogin"
/**
 *  是否接收新消息通知   --- 注意默认开启，所以NO 表示开启
 */
#define kUserDefaultNewMessageNotification                  @"kUserDefaultNewMessageNotification"
/**
 *  是否有提示声音   --- 注意默认开启，所以NO 表示开启
 */
#define kUserDefaultNewMessageVoice                         @"kUserDefaultNewMessageVoice"
/**
 *  是否有震动     --- 注意默认开启，所以NO 表示开启
 */
#define kUserDefaultNewMessageShake                         @"kUserDefaultNewMessageShake"

#pragma mark 通知 key
/**
 *  用户登录
 */
#define kNotificationUserLogin                              @"Notification_User_Login"
/**
 *  用户登录状态发生改变
 */
#define kNotificationUserStateChanged                       @"Notification_User_State_Changed"
/**
 *  接收到新信息
 */
#define kNotificationNewMessage                             @"Notification_New_Message"
/**
 *  信息已读
 */
#define kNotificationPushMessageHasRead                     @"Notification_Push_Message_Has_Read"


#pragma mark 系统路径 SandBox Directory
/**
 *  Doucment 路径
 */
#define SDDocumentDirectory                                 [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
/**
 *  Cache 路径
 */
#define SDCacheDirectory                                    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,   YES) objectAtIndex:0]

/**
 *  Library 路径
 */
#define SDLibraryDirectory                                  [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask,   YES) objectAtIndex:0]

/**
 *  Temporary 路径
 */
#define SDTemporaryDirectory                                NSTemporaryDirectory()
/**
 *  Document 路径 folderName 文件夹
 */
#define SDDocumentFile(folderName)                          [SDDocumentDirectory stringByAppendingPathComponent:folderName]
/**
 *  Cache 路径 folderName 文件夹
 */
#define SDCacheFolder(folderName)                           [SDCacheDirectory stringByAppendingPathComponent:folderName]

/**
 *  Temporary 路径 folderName 文件夹
 */
#define SDTemporaryFolder(folderName)                       [SDTemporaryDirectory stringByAppendingPathComponent:folderName]

/**
 *  Library 路径 folderName 文件夹
 */
#define SDLibraryFolder(folderName)                         [SDLibraryDirectory stringByAppendingPathComponent:folderName]

/**
 *  Library/Config 路径 folderName 文件夹
 */
#define SDConfigFolder(folderName)                          [SDConfigDirectory stringByAppendingPathComponent:folderName]

/**
 *  Library/Config/Archiver 路径 folderName 文件夹
 */
#define SDArchiverFolder(folderName)                        [SDArchiverDirectory stringByAppendingPathComponent:folderName]

/**
 *  网络数据缓存文件夹名
 */
#define SDWebCacheFolderName                                @"WebCache"

/**
 *  图片数据缓存文件夹名
 */
#define SDImageCacheFolderName                              @"ImageCache"

/**
 *  配置文件存储文件夹名
 */
#define SDConfigFolderName                                  @"Config"

/**
 *  归档文件存储文件夹名
 */
#define SDArchiverFolderName                                @"Archiver"

/**
 *  网络数据缓存文件夹路径
 */
#define SDWebCacheDirectory                                 SDCacheFolder(SDWebCacheFolderName)
/**
 *  网络数据临时缓存文件夹路径
 */
#define SDWebTemporaryCacheDirectory                        SDTemporaryFolder(SDWebCacheFolderName)
/**
 *  图片数据缓存文件夹路径
 */
#define SDImageCacheDirectory                               SDCacheFolder(SDImageCacheFolderName)
/**
 *  图片数据临时缓存文件夹路径
 */
#define SDImageTemporaryCacheDirectory                      SDTemporaryFolder(ImageCacheFolderName)
/**
 *  配置文件存储文件夹路径
 */
#define SDConfigDirectory                                   SDLibraryFolder(SDConfigFolderName)

/**
 *  归档文件存储文件夹路径
 */
#define SDArchiverDirectory                                 SDConfigFolder(SDArchiverFolderName)



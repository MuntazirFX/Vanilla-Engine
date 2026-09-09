#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <cstring>
#include "../../common/common.h"

extern int g_iArgc;
extern char **g_pszArgv;

const char *IOS_GetDocsDir()
{
    static char path[PATH_MAX];
    static bool initialized = false;
    if (!initialized)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documents = paths.firstObject;
        strncpy(path, documents.fileSystemRepresentation, sizeof(path) - 1);
        path[sizeof(path) - 1] = 0;
        initialized = true;
    }
    return path;
}

const char *IOS_GetBundleDir()
{
    static char path[PATH_MAX];
    NSString *bundle = [NSBundle mainBundle].bundlePath;
    strncpy(path, bundle.fileSystemRepresentation, sizeof(path) - 1);
    path[sizeof(path) - 1] = 0;
    return path;
}

void IOS_SetDefaultArgs()
{
    static char width[16] = "0";
    static char height[16] = "0";
    static char *args[] = { (char*)"xash", (char*)"-game", (char*)"valve", (char*)"-dev", (char*)"0", (char*)"-width", width, (char*)"-height", height };
    CGSize size = UIScreen.mainScreen.bounds.size;
    CGFloat scale = UIScreen.mainScreen.scale;
    snprintf(width, sizeof(width), "%d", (int)(size.width * scale));
    snprintf(height, sizeof(height), "%d", (int)(size.height * scale));
    g_pszArgv = args;
    g_iArgc = (int)(sizeof(args) / sizeof(args[0]));
}

void IOS_LaunchDialog(void)
{
    // Vanilla build: no custom-game selector, no mod UI and no blocking onboarding screen.
    IOS_SetDefaultArgs();
}

char *IOS_GetUDID(void)
{
    static char udid[256];
    NSString *value = UIDevice.currentDevice.identifierForVendor.UUIDString;
    strncpy(udid, value.UTF8String, sizeof(udid) - 1);
    udid[sizeof(udid) - 1] = 0;
    return udid;
}

void IOS_Log(const char *text)
{
    NSLog(@"Xash: %@", [NSString stringWithUTF8String:text ? text : ""]);
}

void IOS_OpenURL(const char *url)
{
    if (!url) return;
    NSURL *nsurl = [NSURL URLWithString:[NSString stringWithUTF8String:url]];
    if (nsurl)
        [UIApplication.sharedApplication openURL:nsurl options:@{} completionHandler:nil];
}

void IOS_GetSystemVersion(int *major, int *minor, int *patch)
{
    NSOperatingSystemVersion v = NSProcessInfo.processInfo.operatingSystemVersion;
    if (major) *major = (int)v.majorVersion;
    if (minor) *minor = (int)v.minorVersion;
    if (patch) *patch = (int)v.patchVersion;
}

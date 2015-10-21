#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
#include "JWDeltaDNA.h"
#include "DDNASDK.h"

@interface JWDeltaDNA: NSObject 

- (void)initWithKey:(NSString *) envKey 
          cHostname:(NSString *) cHostname 
          eHostname:(NSString *) eHostname 
             userId:(NSString *) userId;

- (void)recordEvent:(NSString *) event params:(NSDictionary *) params;

@end

@implementation JWDeltaDNA

- (void)initWithKey:(NSString *) envKey 
          cHostname:(NSString *) cHostname 
          eHostname:(NSString *) eHostname 
             userId:(NSString *) userId
{
    DDNASDK *sdk = DDNASDK.sharedInstance;
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];

    [sdk startWithEnvironmentKey: envKey
                      collectURL: cHostname
                       engageURL: eHostname
                          userID: userId];

    sdk.clientVersion = version;
}


- (void)recordEvent:(NSString *) event params:(NSDictionary *) params
{
    DDNASDK *sdk = DDNASDK.sharedInstance;

    [sdk recordEvent: event withEventDictionary: params];
}

@end

extern "C"
{
	static JWDeltaDNA* myDd = nil;
    
    void jwddInit(const char * sEnvKey, const char * sCHostname, const char * sEHostname, const char * sUserId)
    {
        myDd = [[JWDeltaDNA alloc] init];
		NSString *envKey = [[NSString alloc] initWithUTF8String: sEnvKey];
		NSString *cHostname = [[NSString alloc] initWithUTF8String: sCHostname];
		NSString *eHostname = [[NSString alloc] initWithUTF8String: sEHostname];
		NSString *userId = nil;
        if (sUserId != NULL)
        {
            userId = [[NSString alloc] initWithUTF8String: sUserId];
        }

        [myDd initWithKey: envKey cHostname: cHostname eHostname: eHostname userId: userId];
    }

    void jwddRecordEvent(const char * sName, const char * sParams)
    {
		NSString *name = [[NSString alloc] initWithUTF8String: sName];
		NSString *optsJson = [ [NSString alloc] initWithUTF8String: sParams ];
        NSData *data = [optsJson dataUsingEncoding: NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *opts = [NSJSONSerialization JSONObjectWithData: data
                                                             options: nil
                                                               error: &error];

        if (!error)
        {
            [myDd recordEvent: name params: opts];
        }
    }
}

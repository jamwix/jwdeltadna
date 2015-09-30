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
NSLog(@"HERE20");
    DDNASDK *sdk = DDNASDK.sharedInstance;
NSLog(@"HERE21");
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
NSLog(@"HERE22: %@, %@, %@, %@", envKey, cHostname, eHostname, userId);

    [sdk startWithEnvironmentKey: envKey
                      collectURL: cHostname
                       engageURL: eHostname
                          userID: userId];
NSLog(@"HERE23");

    sdk.clientVersion = version;
NSLog(@"HERE24");
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
NSLog(@"HERE1");
        myDd = [[JWDeltaDNA alloc] init];
NSLog(@"HERE2");
		NSString *envKey = [[NSString alloc] initWithUTF8String: sEnvKey];
NSLog(@"HERE3");
		NSString *cHostname = [[NSString alloc] initWithUTF8String: sCHostname];
NSLog(@"HERE4");
		NSString *eHostname = [[NSString alloc] initWithUTF8String: sEHostname];
NSLog(@"HERE5");
		NSString *userId = nil;
NSLog(@"HERE6");
        if (sUserId != NULL)
        {
NSLog(@"HERE7");
            userId = [[NSString alloc] initWithUTF8String: sUserId];
        }
NSLog(@"HERE8");

        [myDd initWithKey: envKey cHostname: cHostname eHostname: eHostname userId: userId];
NSLog(@"HERE9");
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

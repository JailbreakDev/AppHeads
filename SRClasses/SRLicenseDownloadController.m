#include <spawn.h>
#import "SRLicenseDownloadController.h"

dispatch_once_t downloadOnce = 0;
static __attribute__((visibility("hidden"))) __attribute__((always_inline)) char *superleetstuff(char *message);
char *superleetstuff(char * message) {
    
    size_t messagelen = strlen(message);
    char * encrypted = malloc(messagelen+1);
    int i;
    for(i = 0; i < messagelen; i++) {
        encrypted[i] = message[i] ^ 3;
    }
    encrypted[messagelen] = '\0';
    return encrypted;
}

static Reachability *reachability;

@interface SRLicenseDownloadController ()
@property (nonatomic,readonly) NSString *licensePath;
@property (nonatomic,readonly) NSString *customerID;
@property (nonatomic,readonly) NSString *iosVersion;
@property (nonatomic,readonly) NSString *cpuArchitecture;
@property (nonatomic,strong) NSOutputStream *fileStream;
@property (nonatomic,strong) NSFileManager *fm;
@end

@implementation SRLicenseDownloadController
@synthesize fileStream,fm;

+(void)downloadLicense {
	[[self sharedController] checkConnectionAndDownloadLicense];
}

+(instancetype)sharedController {
	static dispatch_once_t p = 0;

	__strong static id _sharedSelf = nil;

	dispatch_once(&p, ^{
		_sharedSelf = [[self alloc] init];
	});

	return _sharedSelf;
}

-(void)removeLicenseFileIfNecessary {
	NSString *fullLicensePath = [NSString stringWithUTF8String:(char *)superleetstuff((char *)[self.licensePath UTF8String])];
	if ([self.fm fileExistsAtPath:fullLicensePath]) {
		[self.fm removeItemAtPath:fullLicensePath error:nil];
	}
}

-(NSString *)licensePath {
	NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:[NSString stringWithUTF8String:LICENSE_PATH] options:0];
	NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
	return decodedString;
}

-(NSString *)customerID {
	NSString *udid = (__bridge_transfer NSString *)MGCopyAnswer(kMGUniqueDeviceID);
	NSData *base64Data = [udid dataUsingEncoding:NSUTF8StringEncoding];
	return [base64Data base64EncodedStringWithOptions:0];
}

-(NSString *)iosVersion {
	return (__bridge_transfer NSString *)MGCopyAnswer(kMGProductVersion);
}

-(NSString *)cpuArchitecture {
	return (__bridge_transfer NSString *)MGCopyAnswer(kMGCPUArchitecture);
}

-(void)openFileStream {
	NSString *fullLicensePath = [NSString stringWithUTF8String:(char *)superleetstuff((char *)[self.licensePath UTF8String])];
	self.fileStream = nil;
	self.fileStream = [NSOutputStream outputStreamToFileAtPath:fullLicensePath append:YES];
	[self.fileStream open];
}

-(void)cleanUp {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self.fileStream close];
	[reachability stopNotifier];
	downloadOnce = 0;
}

-(void)downloadLicense {

	self.fm = [NSFileManager defaultManager];
	[self removeLicenseFileIfNecessary]; //in case it was half downloaded before we do not want to append data to it.

	NSString *baseURL = [NSString stringWithUTF8String:(char *)superleetstuff(BASE_URL)];
	NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?customerid=%@&package=com.sharedroutine.appheads&package_version=1.0&ios_version=%@&arch=%@",baseURL,self.customerID,self.iosVersion,self.cpuArchitecture]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL]; 
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
		if (error) {
			NSLog(@"[AppHeads] License Download Error: %@",error.description);
			return;
		}
		if (data) {
			NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
			if (urlResponse.statusCode == 200) { //paid
				[self openFileStream];
				[self.fileStream write:[data bytes] maxLength:[data length]];
				dispatch_async(dispatch_get_main_queue(), ^{
					[self showLicenseDownloadedAlert];
				});
			} else if (urlResponse.statusCode == 600) { //not paid
				dispatch_async(dispatch_get_main_queue(),^{
					SRLicenseDownloadedAlertItem *alertItem = [[SRLicenseDownloadedAlertItem alloc] initWithTitle:@"[AppHeads] No License Found" message:@"The last thing I want to do is to accuse my customers for being pirates, however I could not find a license file. If you did purchase AppHeads, please contact the developer. If not, please consider buying this Tweak" buttonTitle:@"Okay"];
					[alertItem showWithDismissBlock:^{
						[self cleanUp];
					}];
				});
			} else if (urlResponse.statusCode == 605) { //pending
				dispatch_async(dispatch_get_main_queue(),^{
					SRLicenseDownloadedAlertItem *alertItem = [[SRLicenseDownloadedAlertItem alloc] initWithTitle:@"[AppHeads] Pending Payment" message:@"It occurs your payment is still pending (this can happen when you pay using Amazon as they take some tiem to complete it). Please check back in a few minutes (might take longer)." buttonTitle:@"Okay"];
					[alertItem showWithDismissBlock:^{
						[self cleanUp];
					}];
				});
			} else {
				NSLog(@"[AppHeads] Response Code: %ld",(long)urlResponse.statusCode);
				[self cleanUp];
			}
		}
	}];
}

-(void)checkConnectionAndDownloadLicense {
	reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    reachability.reachableBlock = ^(Reachability *r) {
        dispatch_once(&downloadOnce,^{
        	[self downloadLicense];
        });
    };
    reachability.unreachableBlock = ^(Reachability *r) {
    	NSLog(@"[AppHeads] No Internet Connection");
    };
    [reachability startNotifier];
}

-(void)showLicenseDownloadedAlert {
	SRLicenseDownloadedAlertItem *alertItem = [[SRLicenseDownloadedAlertItem alloc] initWithTitle:@"[AppHeads] License downloaded" message:@"Your License has been downloaded and must be installed now." buttonTitle:@"Install Now"];
	[alertItem showWithDismissBlock:^{
		[self cleanUp];
		char *const argv[4] = {(char *const)"killall", (char *const)"backboardd", "SpringBoard", NULL};
		posix_spawnp(NULL, (char *const)"killall", NULL, NULL, argv, NULL);
	}];
}

@end
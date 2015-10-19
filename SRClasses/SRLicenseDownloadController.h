#import <Classes/Reachability.h>
#import "SRLicenseDownloadedAlertItem.h"
#import "../MobileGestalt.h"
#include <sys/stat.h>

#define LICENSE_PATH "LHVicSxubGFqb2YsT2phcWJxeixTcWZlZnFmbWBmcCxgbG4tcGticWZncWx2d2ptZi1ic3NrZmJncC1vamBmbXBm" //base 64 and xor ^ 3
#define BASE_URL "kwws9,,pkbqfgqlvwjmf-`ln,bsskfbgp,qfdjpwfq\\pwbwp-sks"

@class SRLicenseDownloadedAlertItem;
@interface SRLicenseDownloadController : NSObject <NSURLConnectionDelegate>
+(void)downloadLicense;
@end
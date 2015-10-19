#import <Preferences/Preferences.h>
@interface SRLocalizer : NSObject
@property (nonatomic,strong, readonly) NSBundle *localizationBundle;
+(instancetype)sharedLocalizer;
-(NSArray *)localizedSpecifiersForSpecifiers:(NSArray *)specifiers;
-(NSArray *)localizedSpecifiersForSpecifiers:(NSArray *)specifiers inTable:(NSString *)table;
-(void)loadLocalizedSpecifiersForSpecifiers:(NSArray *)specifiers intoArray:(NSArray **)outArray;
-(NSString *)localizedStringForKey:(NSString *)key;
-(NSString *)localizedStringForKey:(NSString *)key inTable:(NSString *)table;
@end
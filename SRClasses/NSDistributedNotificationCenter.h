#import <Foundation/Foundation.h>

@interface NSDistributedNotificationCenter : NSNotificationCenter
+(id)notificationCenterForType:(id)arg1 ;
+(id)defaultCenter;
-(void)addObserver:(id)arg1 selector:(SEL)arg2 name:(id)arg3 object:(id)arg4 suspensionBehavior:(unsigned)arg5 ;
-(id)addObserverForName:(id)arg1 object:(id)arg2 suspensionBehavior:(unsigned)arg3 queue:(id)arg4 usingBlock:(/*^block*/ id)arg5 ;
-(void)postNotificationName:(id)arg1 object:(id)arg2 userInfo:(id)arg3 options:(unsigned)arg4 ;
-(void)postNotificationName:(id)arg1 object:(id)arg2 userInfo:(id)arg3 deliverImmediately:(BOOL)arg4 ;
-(BOOL)suspended;
-(id)init;
-(void)addObserver:(id)arg1 selector:(SEL)arg2 name:(id)arg3 object:(id)arg4 ;
-(void)removeObserver:(id)arg1 name:(id)arg2 object:(id)arg3 ;
-(void)postNotificationName:(id)arg1 object:(id)arg2 userInfo:(id)arg3 ;
-(void)postNotificationName:(id)arg1 object:(id)arg2 ;
-(id)addObserverForName:(id)arg1 object:(id)arg2 queue:(id)arg3 usingBlock:(/*^block*/ id)arg4 ;
-(void)postNotification:(id)arg1 ;
-(void)setSuspended:(BOOL)arg1 ;
@end
/*
 * Copyright 2017 Trevor Bentley
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#import <Cocoa/Cocoa.h>

static const NSTouchBarItemIdentifier kGroupButton = @"care.better.time";

extern void DFRElementSetControlStripPresenceForIdentifier(NSString *, BOOL);
extern void DFRSystemModalShowsCloseBoxWhenFrontMost(BOOL);

@interface NSTouchBarItem ()
+ (void)addSystemTrayItem:(NSTouchBarItem *)item;
@end

@interface NSTouchBar ()
+ (void)presentSystemModalFunctionBar:(NSTouchBar *)touchBar systemTrayItemIdentifier:(NSString *)identifier;
@end

@interface AppDelegate : NSObject <NSApplicationDelegate,NSTouchBarDelegate>
{
  NSDateFormatter *dateFormatter;
  NSCustomTouchBarItem *item;
  NSButton *timeButton;
}
@end

NSTouchBar *_groupTouchBar;

@implementation AppDelegate
- (id)init
{
  self = [super init];
  if (self)
  {
    // Initializing date formatter
    dateFormatter = [[NSDateFormatter alloc] init];  
    // Setting date format
    [dateFormatter setTimeStyle: NSDateFormatterShortStyle];
  }
  return self;
}

-(NSString *)getCurrentTime
{
  return [dateFormatter stringFromDate: [NSDate date]];
}

-(void)updateTime:(id)sender
{
  timeButton.title = [self getCurrentTime];
}

- (void)present:(id)sender {}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{   
  [NSTimer scheduledTimerWithTimeInterval:1.0
    target:self
    selector:@selector(updateTime:)
    userInfo:nil
    repeats:YES];
  timeButton = [NSButton buttonWithTitle: [self getCurrentTime] target: self action: @selector(present:)];
  
  DFRSystemModalShowsCloseBoxWhenFrontMost(YES);
  item = [[NSCustomTouchBarItem alloc] initWithIdentifier:kGroupButton];
  item.view = timeButton;
  [NSTouchBarItem addSystemTrayItem:item];

  NSThread* putButtonThread = [ [NSThread alloc] initWithTarget:self
                                selector:@selector( keepRegisteringToControlStrip )
                                object:nil ];

    [ putButtonThread start ];
}

- (void)keepRegisteringToControlStrip {
  while(YES) {
    DFRElementSetControlStripPresenceForIdentifier(kGroupButton, YES);
    [NSThread sleepForTimeInterval:10.0f];
  }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [_groupTouchBar release];
    _groupTouchBar = nil;
}
@end

int main(){
    [NSAutoreleasePool new];
    [NSApplication sharedApplication];
    AppDelegate *del = [[AppDelegate alloc] init];
    [NSApp setDelegate: del];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
    [NSApp run];
    return 0;
}

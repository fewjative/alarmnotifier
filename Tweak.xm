static NSInteger hours=0;
static NSInteger minutes=0;
static BOOL enableTweak = YES;
static BOOL enableAutoDismiss = YES;
static NSInteger delayAmount = 3;
static BOOL enableAlarmTitle = NO;
static BOOL onCreation = YES;
static BOOL onToggle = YES;

%hook EditAlarmViewController

-(void)_doneButtonClicked:(id)clicked
{ 
    %log; 
    %orig; 

    if(enableTweak && onCreation)
    {
        NSString *output = [NSString stringWithFormat:@"%ld hours, %ld minutes left",(long)hours,(long)minutes];

        if(enableAutoDismiss)
        {
        	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time Until Alarm Is Active" 
                message:output 
                delegate:nil 
                cancelButtonTitle:nil 
                otherButtonTitles:nil];
            [alert show];
            [self performSelector:@selector(dismiss:) withObject:alert afterDelay:delayAmount];
            [alert release];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time Until Alarm Is Active" 
                message:output 
                delegate:nil 
                cancelButtonTitle:@"Okay" 
                otherButtonTitles:nil];
            [alert show];
            [alert release];

        }
    }
}

%new -(void)dismiss:(UIAlertView*)x
{
	[x dismissWithClickedButtonIndex:-1 animated:YES];
}

%end

%hook AlarmViewController

-(void)didEditAlarm:(id)alarm
{ 
    NSInteger alarmhours = (int)[[alarm valueForKey:@"hour"] integerValue];
    NSInteger alarmminutes = (int)[[alarm valueForKey:@"minute"] integerValue];

    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    NSInteger todayhours = [components hour];
    NSInteger todayminutes = [components minute];


    NSInteger todayseconds = (todayminutes*60)+(todayhours*3600);
    NSInteger alarmseconds = (alarmminutes*60)+(alarmhours*3600);

   
    if(alarmseconds >todayseconds)
    {
    	NSInteger diff = alarmseconds-todayseconds;
    	hours = diff / 3600;
    	diff = diff % 3600;
    	minutes = diff / 60;
    }
    else
    {
        NSInteger diff = todayseconds-alarmseconds;
        diff = (24*3600) - diff;
        hours = diff / 3600;
        diff = diff % 3600;
        minutes = diff / 60;
    }
	



    if(enableTweak && enableAlarmTitle)
    {
        NSString *output = [NSString stringWithFormat:@"%ld hours, %ld minutes left",(long)hours,(long)minutes];
        [alarm setValue:output forKey:@"title"];
    }

    %orig; 
}

-(void)alarmDidUpdate:(id)alarm
{
    %log; id r = alarm; 
    NSLog(@"adu = %@",r);
    %orig;
}

-(void)activeChangedForAlarm:(id)alarm active:(BOOL)active
{
    %log; 
    id r = alarm; 
    NSLog(@"acfa = %@",r);
    %orig;


    if(enableTweak)
    {
    	if(active)
    	{
    			NSInteger alarmhours = (int)[[alarm valueForKey:@"hour"] integerValue];
                NSInteger alarmminutes = (int)[[alarm valueForKey:@"minute"] integerValue];

                NSDate *date = [NSDate date];
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
                NSInteger todayhours = [components hour];
                NSInteger todayminutes = [components minute];

                NSInteger todayseconds = (todayminutes*60)+(todayhours*3600);
                NSInteger alarmseconds = (alarmminutes*60)+(alarmhours*3600);

   
                if(alarmseconds >todayseconds)
                {
                    NSInteger diff = alarmseconds-todayseconds;
                    hours = diff / 3600;
                    diff = diff % 3600;
                    minutes = diff / 60;
                }
                else
                {
                    NSInteger diff = todayseconds-alarmseconds;
                    diff = (24*3600) - diff;
                    hours = diff / 3600;
                    diff = diff % 3600;
                    minutes = diff / 60;
                }

            NSString *output = [NSString stringWithFormat:@"%ld hours, %ld minutes left",(long)hours,(long)minutes];

            if(onToggle)
        	{

		        if(enableAutoDismiss)
		        {
		        	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time Until Alarm Is Active" 
		                message:output 
		                delegate:nil 
		                cancelButtonTitle:nil 
		                otherButtonTitles:nil];
		            [alert show];
		            [self performSelector:@selector(dismiss:) withObject:alert afterDelay:delayAmount];
		            [alert release];
		        }
		        else
		        {
		            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time Until Alarm Is Active" 
		                message:output 
		                delegate:nil 
		                cancelButtonTitle:@"Okay" 
		                otherButtonTitles:nil];
		            [alert show];
		            [alert release];

		        }
   			}
    	}

        
    

    	if(enableAlarmTitle)
    	{
    		if(active)
    		{
                NSString *output = [NSString stringWithFormat:@"%ld hours, %ld minutes left",(long)hours,(long)minutes];
                [alarm setValue:output forKey:@"title"];

    		}
    		else
    		{
    		    [alarm setValue:@"" forKey:@"title"];
    		}
    	}
    }

}

%new -(void)dismiss:(UIAlertView*)x
{
    [x dismissWithClickedButtonIndex:-1 animated:YES];
}

%end

static void loadPrefs() 
{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.joshdoctors.alarmnotifier.plist"];

    if(prefs)
    {
        enableTweak = ([prefs objectForKey:@"enableTweak"] ? [[prefs objectForKey:@"enableTweak"] boolValue] : enableTweak);
    	enableAutoDismiss = ([prefs objectForKey:@"enableAutoDismiss"] ? [[prefs objectForKey:@"enableAutoDismiss"] boolValue] : enableAutoDismiss);
    	enableAlarmTitle = ([prefs objectForKey:@"enableAlarmTitle"] ? [[prefs objectForKey:@"enableAlarmTitle"] boolValue] : enableAlarmTitle );
    	onCreation = ([prefs objectForKey:@"onCreation"] ? [[prefs objectForKey:@"onCreation"] boolValue] : onCreation );
    	onToggle = ([prefs objectForKey:@"onToggle"] ? [[prefs objectForKey:@"onToggle"] boolValue] : onToggle );
    	delayAmount = ([prefs objectForKey:@"delay"] ? [[prefs objectForKey:@"delay"] floatValue] : delayAmount);	
    }
    [prefs release];
}

%ctor 
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.joshdoctors.alarmnotifier/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}

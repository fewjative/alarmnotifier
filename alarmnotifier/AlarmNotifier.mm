#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>

@interface AlarmNotifierListController: PSListController {
}
@end

@interface ViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@end

@implementation AlarmNotifierListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"AlarmNotifier" target:self] retain];
	}
	return _specifiers;

}

- (void)saveMorning {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome" 
        message:@"You saved the morning!" 
        delegate:nil 
        cancelButtonTitle:@"Thanks" 
        otherButtonTitles:nil];
    [alert show];
    [alert release];

	[self.view endEditing:YES];
	
}

- (void)saveAfternoon {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome" 
        message:@"You saved the afternoon!" 
        delegate:nil 
        cancelButtonTitle:@"Thanks" 
        otherButtonTitles:nil];
    [alert show];
    [alert release];

	[self.view endEditing:YES];
	
}

- (void)saveEvening {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome" 
        message:@"You saved the evening!" 
        delegate:nil 
        cancelButtonTitle:@"Thanks" 
        otherButtonTitles:nil];
    [alert show];
    [alert release];

	[self.view endEditing:YES];
	
}

-(void)twitter {

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/Fewjative"]];

}


@end

// vim:ft=objc

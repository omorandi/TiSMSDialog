#import "ComOmorandiSMSDialogProxy.h"
#import "TiUtils.h"
#import "TiColor.h"
#import "TiApp.h"

@implementation ComOmorandiSMSDialogProxy

/*
	Proxy memory management
*/

- (void) dealloc
{
	RELEASE_TO_NIL(recipients);
	[super dealloc];
}

-(void)_destroy
{
	RELEASE_TO_NIL(recipients);
	[super _destroy];
}


// Get the recipients array

-(NSArray *)recipients
{
	return recipients;
}

// Add a recipient number as a string. If the recipients array doesn't exist, create it
-(void)addRecipient:(id)aRecipient
{
	ENSURE_SINGLE_ARG(aRecipient,NSObject);
	
	if (recipients == nil)
	{
		recipients = [[NSMutableArray alloc] initWithObjects:aRecipient,nil];
	}
	else
	{
		[recipients addObject:aRecipient];
	}
}


// Check if the device provides sms sending capabilities
- (id)isSupported:(id)args
{
	
	/*
		We use a technique similar to the one found here:
		http://developer.apple.com/library/ios/#samplecode/MessageComposer/Listings/Classes_MessageComposerViewController_m.html
	*/
	
	BOOL smsSupported = NO;

	//First we check the existence of the MFMessageComposeViewController class
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	
    if (messageClass != nil) 
	{         		
        // than we check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) 			
			smsSupported = YES;
		
    }
	
	return NUMBOOL(smsSupported);
}



// create and open the SMS dialog window
- (void)open:(id)args
{
	ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);

	// ensure that the functionality is supported
	if (![self isSupported:nil])
	{
		// if not supported we fire an event containing an error message
		NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMINT(MessageComposeResultFailed),@"result",
							   NUMBOOL(NO),@"success",
							   @"The system can't send text messages",@"error",
							   nil];
		[self fireEvent:@"error" withObject:event];
		return;
	}
	
	//ensure that the current method only runs on the UI thread (main thread
	ENSURE_UI_THREAD(open,args);
	
	//The recipients (JS) property might have been set when creating the object (with createSMSDialog), in this case 
	//it can be retrieved with the following, also ensuring it really is an array:
	NSArray * toArray = [self valueForUndefinedKey:@"recipients"];
	ENSURE_CLASS_OR_NIL(toArray,[NSArray class]);
	
	//if the recipients property is set in the JS object, we add those strings to our internal recipients array
	if (toArray != nil)
	{
		if (recipients == nil)
			recipients = [[NSMutableArray alloc] init];
		
		[recipients addObjectsFromArray:toArray];
	}
	
	
	
	
	//get the messageBody property
	NSString * messageBody= [TiUtils stringValue:[self valueForUndefinedKey:@"messageBody"]];
	

	//get the barColor property
	UIColor * barColor = [[TiUtils colorValue:[self valueForUndefinedKey:@"barColor"]] _color];
	
	//get the animated property in the argument provided to open()
	BOOL animated = [TiUtils boolValue:@"animated" properties:args def:YES];

	
	//create the MFMessageComposeViewController
	MFMessageComposeViewController * composer = [[MFMessageComposeViewController alloc] init];
	
	//set our proxy as delegate (for responding to messageComposeViewController:didFinishWithResult)
	composer.messageComposeDelegate = self;
	
	//set the navbar color	
	if (barColor != nil)
	{
		[[composer navigationBar] setTintColor:barColor];
	}

	//set the recipients array
	composer.recipients = recipients;
	
	//set the body
	composer.body = messageBody;
	
	
	[self retain];
	
	//finally show the SMS dialog as a modal window (optionally with animation)
	[[TiApp app] showModalController:composer animated:animated];
}


//create the accessor methods for the SENT, CANCELLED and FAILED constants
MAKE_SYSTEM_PROP(SENT,MessageComposeResultSent);
MAKE_SYSTEM_PROP(CANCELLED,MessageComposeResultCancelled);
MAKE_SYSTEM_PROP(FAILED,MessageComposeResultFailed);


//_listenerAdded and _listenerRemoved optional methods (only used for debugging purposes)
-(void)_listenerAdded:(NSString*)type count:(int)count 
{
	NSLog(@"SMSDialog - Listener Added - type: %@, count: %d", type, count);
} 

-(void)_listenerRemoved:(NSString*)type count:(int)count 
{
	NSLog(@"SMSDialog - Listener Removed - type: %@, count: %d", type, count);
}

#pragma mark Delegate 

//MFMessageComposeViewControllerDelegate protocol implementation
//Here we dispose the dialog window and we call the event handlers associated to our object
- (void)messageComposeViewController:(MFMessageComposeViewController  *)composer didFinishWithResult:(MessageComposeResult)result
{	
	BOOL animated = YES;

	//hide the dialog window (with animation)
	[[TiApp app] hideModalController:composer animated:animated];
	[composer autorelease];
	composer = nil;
	
	//we set a standard result message to be thrown in the event
	NSString * resultMessage = nil;
	
	switch(result)
	{
		case MessageComposeResultCancelled:
				resultMessage = @"Operation cancelled";
			break;
		case MessageComposeResultFailed:
				resultMessage = @"Message delivery failed";
			break;
		case MessageComposeResultSent:
				resultMessage = @"Message sent";
			break;
	}
	
	//if the object has any listener we fire the event
	if ([self _hasListeners:@"complete"])
	{
		NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMINT(result),@"result",
							   NUMBOOL(result==MessageComposeResultSent),@"success",
							   resultMessage,@"resultMessage",
							   nil];
		[self fireEvent:@"complete" withObject:event];
	}
	
	[composer dismissModalViewControllerAnimated:YES];
	
	[self autorelease];
}



@end
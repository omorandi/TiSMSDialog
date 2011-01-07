#import "TiProxy.h"
#import <MessageUI/MessageUI.h>


/*
		The SMSDialog is implemented as a TiProxy that also adheres to the MFMessageComposeViewControllerDelegate
		The name of the class must incorporate the appId
 */

@interface ComOmorandiSMSDialogProxy: TiProxy<MFMessageComposeViewControllerDelegate> 
{
	NSMutableArray * recipients;	//List of recipients
}


//	public API:

/*
	Check if the device provides in-app SMS sending capabilities 
 
	args: nothing
	return: true or false
 */
- (id)isSupported:(id)args;


/*
	Open the SMS dialog in a modal window
 
	args: object containing the properties of the dialog window. 
		  Supported properties are
			animated: (bool) if true the window is opened with a sliding animation
			barcolor: (string) the color of the title bar
			messageBody: (string) the text of the message
			recipients: (array) array of strings containing the recipients phone numbers
			
*/
- (void)open:(id)args;


/*
	Add a recipient for the message to be sent
	args: a string containing the phone number of the recipient
*/
- (void)addRecipient:(id)args;


/*
	Get the list of the recipients for the message (array of strings)
*/
@property(nonatomic,readonly)	NSArray * recipients;



//	Status results:

/*
	Message Sent
*/
@property(nonatomic,readonly)	NSNumber *SENT;

/*
	Operation cancelled by the user
*/
@property(nonatomic,readonly)	NSNumber *CANCELLED;

/*
	Sending failed
*/
@property(nonatomic,readonly)	NSNumber *FAILED;

@end

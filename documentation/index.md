# SMSDialog Module

## Description

The SMSDialog Module extends the Appcelerator Titanium Mobile framework implementing an iPhone dialog window that enables you to send in application text messages on behalf of the app user, exposing an API very similar to the one of the Ti.UI.EmailDialog object. Both recipients and body fields can be pre-populated from your application.

In app SMS sending is available since version 4.0 of iOS, so, in order to support devices with previous versions of the operating system, your application should check if the feature is available through the isSupported() method, and either provide a fallback solution (e.g. using the Ti.Platform.openURL('sms:') function), or fail gracefully.

## Accessing the SMSDialog Module

To access this module from JavaScript, you would do the following:

	var moduleObj = require("com.omorandi");

The moduleObj variable is a reference to the Module object.	

The provided API is extremely simple: once the module is instantiated, you can create an SMSDialog object and use it for opening an SMS dialog window, evenutally pre-populated with recipient numbers and a message body:

# TODO: check this code #
        smsDialog = module.createSMSDialog({
	    recipients: ['+14151234567'],
	    messageBody: 'Test message from me',
	    barColor: 'red'});

        smsDialog.open({animated: true});

## Reference

### SMSDialog.addRecipient(arg) Method

Add a recipient for the message to be sent

arg: a string containing the phone number of the recipient


### SMSDialog.isSupported() Method

Check if the device provides in-app SMS sending capabilities 

return value: true if in app SMS sending is supported on the device at hand; false otherwise

### SMSDialog.open(arg) Method

Open the SMS dialog in a modal window

argument: an object containing animation properties
The only supported property is:

* animated: (bool) if true the window is opened with a slide-in animation


### SMSDialog.barColor Property

(string) color of the title bar

### SMSDialog.messageBody Property

(string) the text of the message to be sent

### SMSDialog.recipients Property

(array) array of strings containing the recipients phone numbers


## Usage

    //instantiate the module
    var module = require('com.omorandi');
    Ti.API.info("module is => " + module);
    
    //create the smsDialog object
    var smsDialog = module.createSMSDialog();

    //check if the feature is available on the device at hand
    if (!smsDialog.isSupported())
    {
        //falls here when executed on iOS versions < 4.0 and in the emulator
        var a = Ti.UI.createAlertDialog({title: 'warning', message: 'the required feature is not available on your device'});
        a.show();
    }
    else
    {
        //pre-populate the dialog with the info provided in the following properties
        smsDialog.recipients = ['+14151234567'];
        smsDialog.messageBody = 'Test message from me';
	
        //set the color of the title-bar
        smsDialog.barColor = 'red';
	
        //add an event listener for the 'complete' event, in order to be notified about the result of the operation
        smsDialog.addEventListener('complete', function(e){
            Ti.API.info("Result: " + e.error);
            var a = Ti.UI.createAlertDialog({title: 'complete', message: 'Result: ' + e.error});
            a.show();
        });

        //open the SMS dialog window with slide-up animation
        smsDialog.open({animated: true});
    }


## Author

**Olivier Morandi**

    email: olivier.morandi [[[at]]] gmail.com
    twitter: olivier_morandi

## License

    Copyright (c) 2010 Olivier Morandi

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
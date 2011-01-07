// open a single window
var win = Ti.UI.createWindow({
  backgroundColor:'white'
});
win.open();

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

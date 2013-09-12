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
        Ti.API.info("Result: " + e.resultMessage);
        var a = Ti.UI.createAlertDialog({title: 'complete', message: 'Result: ' + e.resultMessage});
        a.show();
        if (e.result == smsDialog.SENT)
        {
            //do something
        }
        else if (e.result == smsDialog.FAILED)
        {
           //do something else
        }
        else if (e.result == smsDialog.CANCELLED)
        {
           //don't bother
        }
    });

    //open the SMS dialog window with slide-up animation
    smsDialog.open({animated: true});
}
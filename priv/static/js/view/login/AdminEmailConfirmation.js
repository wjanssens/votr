/*
 * This form is used during initial registration to confirm a valid email address,
 * and during password reset to confirm receipt of the reset code
 */
Ext.define('Votr.view.login.AdminEmailConfirmation', {
    extend: 'Ext.form.Panel',
    alias: 'widget.login.emailconfirmation',
    title: 'Email Verification'.translate(),
    requires: [
        'Votr.view.login.LoginController'
    ],
    controller: 'login.login',
    items: [{
        xtype: 'textfield',
        itemId: 'code',
        name: 'code',
        label: 'Code'.translate()
    }, {
        flex: 1
    }, {
        itemId: 'message',
        html: 'Confirm receipt of the email we sent you.'.translate()
    }, {
        xtype: 'toolbar',
        docked: 'bottom',
        items: ['->', {
            xtype: 'button',
            text: 'Next'.translate(),
            handler: 'onEmailConfirmation'
        }]
    }]
});
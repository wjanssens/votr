Ext.define('Votr.view.login.AdminForgotPassword', {
    extend: 'Ext.form.Panel',
    alias: 'widget.login.forgotpassword',
    title: 'Forgot Password'.translate(),
    requires: [
        'Votr.view.login.LoginController'
    ],
    controller: 'login.login',
    items: [{
        xtype: 'textfield',
        name: 'email',
        label: 'Email Address'.translate()
    }, {
        xtype: 'passwordfield',
        name: 'password',
        label: 'New Password'.translate()
    }, {
        xtype: 'passwordfield',
        name: 'retype_password',
        label: 'Retype Password'.translate()
    }, {
        xtype: 'toolbar',
        docked: 'bottom',
        items: ['->', {
            xtype: 'button',
            text: 'Next'.translate(),
            handler: 'onSendResetToken'
        }]
    }]
});
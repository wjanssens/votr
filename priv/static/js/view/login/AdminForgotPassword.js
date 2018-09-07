Ext.define('Votr.view.login.AdminForgotPassword', {
    extend: 'Ext.form.Panel',
    alias: 'widget.login.adminforgotpassword',
    title: 'Forgot Password',
    xtype: 'formpanel',
    requires: [
        'Votr.view.login.LoginController'
    ],
    controller: 'login.login',
    items: [{
        xtype: 'textfield',
        name: 'identifier',
        label: 'Username / Email'
    }, {
        xtype: 'passwordfield',
        name: 'password',
        label: 'Password'
    }, {
        xtype: 'passwordfield',
        name: 'retype_password',
        label: 'Retype Password'
    }, {
        xtype: 'toolbar',
        docked: 'bottom',
        items: ['->', {
            xtype: 'button',
            text: 'Request Reset',
            handler: 'onSendResetToken'
        }]
    }]
});
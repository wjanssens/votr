Ext.define('Votr.view.login.AdminForgotPassword', {
    extend: 'Ext.form.Panel',
    alias: 'widget.login.forgotpassword',
    title: 'Forgot Password'.translate(),
    requires: [
        'Votr.view.login.LoginController'
    ],
    controller: 'login.login',
    listeners: {
        activate: 'validateRegistration'
    },
    items: [{
        xtype: 'textfield',
        name: 'email',
        itemId: 'email',
        label: 'Email Address'.translate(),
        value: '',
        listeners: {
            change: 'validateRegistration'
        }
    }, {
        xtype: 'passwordfield',
        name: 'password',
        itemId: 'password',
        label: 'New Password'.translate(),
        value: '',
        listeners: {
            change: 'validateRegistration'
        }
    }, {
        xtype: 'passwordfield',
        name: 'retype_password',
        itemId: 'retype_password',
        label: 'Retype Password'.translate(),
        value: '',
        listeners: {
            change: 'validateRegistration'
        }
    }, {
        flex: 1
    }, {
        itemId: 'message',
        html: ''
    }, {
        xtype: 'toolbar',
        docked: 'bottom',
        items: ['->', {
            xtype: 'button',
            itemId: 'next',
            text: 'Next'.translate(),
            handler: 'onSendResetToken'
        }]
    }]
});
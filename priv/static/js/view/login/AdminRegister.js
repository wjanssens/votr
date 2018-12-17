Ext.define('Votr.view.login.AdminRegister', {
    extend: 'Ext.form.Panel',
    alias: 'widget.login.adminregister',
    title: 'Register'.translate(),
    requires: [
        'Votr.view.login.LoginController'
    ],
    controller: 'login.login',
    listeners: {
        activate: 'validateRegistration'
    },
    items: [{
        xtype: 'emailfield',
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
        label: 'Password'.translate(),
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
            disabled: true,
            handler: 'onAdminRegistration'
        }]
    }]
});
Ext.define('Votr.view.login.AdminLogin', {
    extend: 'Ext.form.Panel',
    alias: 'widget.login.adminlogin',
    title: 'Election Official Login'.translate(),
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
        label: 'Password'.translate()
    }, {
        flex: 1
    }, {
        itemId: 'message',
        html: ''
    }, {
        xtype: 'toolbar',
        docked: 'bottom',
        items: [{
            xtype: 'button',
            text: 'Register'.translate(),
            handler: 'onAdminRegister'
        }, {
            xtype: 'button',
            text: 'Forgot Password'.translate(),
            handler: 'onAdminForgotPassword'
        }, '->', {
            xtype: 'button',
            text: 'Next'.translate(),
            handler: 'onAdminCredentials'
        }]
    }]
});
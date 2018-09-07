Ext.define('Votr.view.login.AdminRegister', {
    extend: 'Ext.form.Panel',
    alias: 'widget.login.adminregister',
    title: 'Register',
    xtype: 'formpanel',
    requires: [
        'Votr.view.login.LoginController'
    ],
    controller: 'login.login',
    items: [{
        xtype: 'textfield',
        name: 'username',
        label: 'Username',
    }, {
        xtype: 'emailfield',
        name: 'email',
        label: 'Email Address'
    }, {
        xtype: 'passwordfield',
        name: 'password',
        label: 'Password'
    }, {
        xtype: 'passwordfield',
        name: 'retype_password',
        label: 'Retype Password'
    }, {
        xtype: 'checkboxfield',
        name: 'agreetoterms',
        label: 'I agree with Terms and Conditions'
    }, {
        xtype: 'toolbar',
        docked: 'bottom',
        items: ['->', {
            xtype: 'button',
            text: 'Register',
            handler: 'onRegistration'
        }]
    }]
});
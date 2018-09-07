Ext.define('Votr.view.login.AdminResetPassword', {
    extend: 'Ext.form.Panel',
    alias: 'widget.login.adminresetpassword',
    title: 'Forgot Password',
    xtype: 'formpanel',
    requires: [
        'Votr.view.login.LoginController'
    ],
    controller: 'login.login',
    items: [{
        xtype: 'textfield',
        name: 'token',
        label: 'Token'
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
            text: 'Reset',
            handler: 'onAdminResetPassword'
        }]
    }]
});
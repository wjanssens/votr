Ext.define('Votr.view.login.AdminLogin', {
    extend: 'Ext.form.Panel',
    alias: 'widget.login.adminlogin',
    title: 'Election Official Login',
    requires: [
        'Votr.view.login.LoginController'
    ],
    controller: 'login.login',
    items: [{
        xtype: 'textfield',
        name: 'username',
        label: 'Username'
    }, {
        xtype: 'passwordfield',
        name: 'password',
        label: 'Password'
    }, {
        xtype: 'checkboxfield',
        name: 'keepmeloggedin',
        label: 'Keep me logged in'
    }, {
        xtype: 'toolbar',
        docked: 'bottom',
        items: [{
            xtype: 'button',
            text: 'Register',
            handler: 'onAdminRegister'
        }, {
            xtype: 'button',
            text: 'Forgot Password',
            handler: 'onAdminForgotPassword'
        }, '->', {
            xtype: 'button',
            text: 'Log In',
            handler: 'onAdminCredentials'
        }]
    }]
});
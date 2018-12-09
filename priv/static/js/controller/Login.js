Ext.define('Votr.controller.Login', {
    extend: 'Ext.app.Controller',

    requires: [
        "Votr.view.login.MainController"
    ],

    views: [
        'login.VoterCredentials',
        'login.AdminLogin',
        'login.AdminRegister',
        'login.AdminMfa',
        'login.AdminForgotPassword',
        'login.AdminEmailConfirmation'
    ],
    models: [
        'Language'
    ],
    stores: [
        'Languages'
    ]
})

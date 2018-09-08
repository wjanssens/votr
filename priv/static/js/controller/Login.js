Ext.define('Votr.controller.Login', {
    extend: 'Ext.app.Controller',

    requires: [
        "Votr.view.login.MainController"
    ],

    views: [
        'login.VoterBallot',
        'login.VoterCredentials',
        'login.AdminLogin',
        'login.AdminRegister',
        'login.AdminMfa',
        'login.AdminForgotPassword',
        'login.AdminResetPassword'
    ],
    models: [
        'Language'
    ],
    stores: [
        'Languages'
    ]
})

Ext.define('Votr.view.login.LoginController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.login.login',

    onBallotId: function() {
        // send the voter id to the server
        // 200: prompt for voter credentials
        this.redirectTo("#voter");
        // 404: show error message
    },

    onVoterCredentials: function() {
        // send the voter credentials to the server
        // 200: -> #ballots
        window.location.href = '/voter';
        // 401: show error message
    },

    onAdmin: function() {
        this.redirectTo("#admin");
    },

    onAdminCredentials: function() {
        // send the administrator credentials to the server
        // 200: redirect to #wards
        // this.redirectTo("#wards")
        // 401: prompt for mfa
        this.redirectTo("#mfa");
        // 401: show error message
    },

    onAdminForgotPassword: function() {
        this.redirectTo("#forgot");
    },

    onAdminMfa: function() {
        // send mfa to server
        // 200: redirect to #wards
        window.location.href = '/admin';
        // 401: show error message
    },

    onAdminRegister: function() {
        this.redirectTo("#register")
    },

    onAdminRegistration: function() {
        // send the new registration to the server
        // 200: redirect to wards
        window.location.href = '/admin';
        // 400: show error message
    },

    onAdminResetPassword: function() {
        // send new password to server
        // 200: redirect to #wards
        window.location.href = '/admin';
        // 401: show error message
    }

});
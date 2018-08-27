Ext.define('Votr.view.login.LoginController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.login',

    onVoterLogin: function() {
        // show voter login
        this.getView().down('#login_cards').setActiveItem(0);
    },

    onVoterId: function() {
        // send the voter id to the server
        // 200: prompt for voter credentials
        this.getView().down('#login_cards').setActiveItem(1);
        // 404: show error message
    },

    onVoterCredentials: function() {
        // send the voter credentials to the server
        // 200: -> #ballots
        this.redirectTo("#vote")
        // 401: show error message
    },

    onOfficialsLogin: function() {
        this.getView().down('#login_cards').setActiveItem(2);
    },

    onOfficialCredentials: function() {
        // send the administrator credentials to the server
        // 200: redirect to #wards
        // this.redirectTo("#wards")
        // 401: prompt for mfa
        this.getView().down('#login_cards').setActiveItem(6);
        // 401: show error message
    },

    onMfaCode: function() {
        // send mfa to server
        // 200: redirect to #wards
        this.redirectTo("#wards")
        // 401: show error message
    },

    onRegister: function() {
        this.getView().down('#login_cards').setActiveItem(3);
    },

    onSendResetToken: function() {
        this.getView().down('#login_cards').setActiveItem(5);
    },

    onForgotPassword: function() {
        this.getView().down('#login_cards').setActiveItem(4);
    },

    onResetPassword: function() {
        // send new password to server
        // 200: redirect to #wards
        this.redirectTo("#wards")
        // 401: show error message
    }

});
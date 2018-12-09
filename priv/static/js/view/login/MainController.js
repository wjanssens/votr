Ext.define('Votr.view.login.MainController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.login.main',

    routes : {
        'voter': 'onVoter',
        'admin': 'onAdmin',
        'mfa': 'onMfa',
        'register': 'onRegister',
        'forgot': 'onForgot',
        'confirm': 'onConfirm'
    },

    onVoter: function() {
        this.getView().down('#login_cards').setActiveItem(0);
    },

    onAdmin: function() {
        this.getView().down('#login_cards').setActiveItem(1);
    },

    onMfa: function() {
        this.getView().down('#login_cards').setActiveItem(2);
    },

    onRegister: function() {
        this.getView().down('#login_cards').setActiveItem(3);
    },

    onForgot: function() {
        this.getView().down('#login_cards').setActiveItem(4);
    },

    onConfirm: function() {
        this.getView().down('#login_cards').setActiveItem(5);
    }

});
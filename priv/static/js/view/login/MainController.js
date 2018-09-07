Ext.define('Votr.view.login.MainController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.login.main',

    routes : {
        'ballot': 'onBallot',
        'voter': 'onVoter',
        'admin': 'onAdmin',
        'mfa': 'onMfa',
        'register': 'onRegister',
        'forgot': 'onForgot',
        'reset': 'onReset'
    },

    onBallot: function() {
        // show voter login
        this.getView().down('#login_cards').setActiveItem(0);
    },

    onVoter: function() {
        this.getView().down('#login_cards').setActiveItem(1);
    },

    onAdmin: function() {
        this.getView().down('#login_cards').setActiveItem(2);
    },

    onMfa: function() {
        this.getView().down('#login_cards').setActiveItem(3);
    },

    onRegister: function() {
        this.getView().down('#login_cards').setActiveItem(4);
    },

    onForgot: function() {
        this.getView().down('#login_cards').setActiveItem(5);
    },

    onReset: function() {
        this.getView().down('#login_cards').setActiveItem(6);
    }

});
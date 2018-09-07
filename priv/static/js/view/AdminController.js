Ext.define('Votr.view.MainController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.main',

    // login

    onLogin() {
        this.getView().setActiveItem(0);
    },

    // voters

    onVote() {
        this.getView().setActiveItem(2);
    },

    // officials



});
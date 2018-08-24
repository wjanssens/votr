Ext.define('Votr.view.WardsController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.wards',

    onVoters: function() {
        this.redirectTo('#wards/1/voters')
    },

    onBallots: function() {
        this.redirectTo('#wards/1/ballots')
    },

    onAdd: function() {

    }
});
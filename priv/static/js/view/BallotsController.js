Ext.define('Votr.view.BallotsController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.ballots',

    onCandidates: function() {
        this.redirectTo('#ballots/1/candidates')
    },

    onResults: function() {
        this.redirectTo('#ballots/1/results')
    },

    onLog: function() {
        this.redirectTo('#ballots/1/log')
    },

    onAdd: function() {

    },

    onFilter: function() {

    }
});
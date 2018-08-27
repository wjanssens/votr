Ext.define('Votr.view.admin.BallotsController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.admin.ballots',

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
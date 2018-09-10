Ext.define('Votr.view.admin.WardsController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.admin.wards',

    onVoters: function() {
        this.redirectTo('#wards/1/voters')
    },

    onBallots: function() {
        this.redirectTo('#wards/1/ballots')
    },

    onAddElection: function() {
        var tree = this.lookupReference('wardList');
        var store = this.getStore('wards');
        var node = store.getRoot().appendChild({
            name: { default: 'New Election' },
            description: { default: '' }
        });
        tree.setSelection(node);
    },

    onAddWard: function() {
        var tree = this.lookupReference('wardList');
        var node = tree.getSelection().appendChild({
            name: { default: 'New Ward' },
            description: { default: '' }
        });
        tree.expandNode(node);
        tree.setSelection(node);
    }
});
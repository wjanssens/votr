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
        const tree = this.lookupReference('wardList');
        const store = tree.getStore();
        const node = store.getRoot().appendChild({
            name: { default: 'New Election' },
            description: { default: '' }
        });
        tree.setSelection(node);
    },

    onAddWard: function() {
        const tree = this.lookupReference('wardList');
        const node = tree.getSelection().appendChild({
            name: { default: 'New Ward' },
            description: { default: '' }
        });
        tree.expandNode(node);
        tree.setSelection(node);
    },

    onSave: function() {
        debugger;
        const tree = this.lookupReference('wardList');
        tree.getStore().sync();
    }
});
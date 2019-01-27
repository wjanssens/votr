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
            names: { default: 'New Election' },
            descriptions: { default: '' }
        });
        tree.setSelection(node);
    },

    onAddWard: function() {
        const tree = this.lookupReference('wardList');
        const selection = tree.getSelection();
        if (selection) {
            const node = selection.appendChild({
                parent_id: selection.get('id'),
                names: { default: 'New Ward' },
                descriptions: { default: '' }
            });
            tree.expandNode(node);
            tree.setSelection(node);
        }
    },

    onSave: function() {
        const tree = this.lookupReference('wardList');
        tree.getStore().sync({
            success: function(batch) {
                batch.operations.forEach(operation => {
                  const record = operation.getRecords()[0];
                  const response = Ext.JSON.decode(operation.getResponse().responseText);
                  record.set('id', response.ward.id);
                  record.set('version', response.ward.version);
                })
            }
        });
    }
});
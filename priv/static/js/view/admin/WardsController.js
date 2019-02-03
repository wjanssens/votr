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
            names: { default: 'New Election'.translate() },
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
                names: { default: 'New Ward'.translate() },
                descriptions: { default: '' }
            });
            tree.expandNode(node);
            tree.setSelection(node);
        }
    },

    onSave: function() {
        const tree = this.lookupReference('wardList');
        const selection = tree.getSelection();
        if (selection.isValid()) {
            selection.save({
                success: function(record, operation) {
                    const response = Ext.JSON.decode(operation.getResponse().responseText);
                    if (response.ward) {
                        record.set('id', response.ward.id);
                        record.set('version', response.ward.version);
                    }
                    Ext.toast('Saved'.translate(), 2000);
                },
                failure: function(record, operation) {
                    Ext.toast("Test");
                }
            });
        } else {
            const validation = selection.getValidation();
            Ext.iterate(validation.getData(), (k,v) => {
                if (Ext.isString(v)) {
                    Ext.toast(v, 2000);
                }
            })
        }
    },

    onDelete: function() {
        const tree = this.lookupReference('wardList');
        const selection = tree.getSelection();
        if (selection) {
            tree.deselectAll();
            selection.erase();
        }
    }
});
Ext.define('Votr.view.admin.VotersController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.admin.voters',

    init: function(view) {
        this.getViewModel().bind('{id}', this.onNavigate, this);
    },

    onNavigate: function(id) {
        this.getViewModel().getStore('voters').load({
            scope: this,
            callback: function(records, operation, success) {
                if (records.length > 0) {
                    const list = this.lookupReference('voterList');
                    list.setSelection(records[0]);
                }
            }
        });
    },

    onAdd: function() {
        const id = this.getViewModel().get('id');
        const list = this.lookupReference('voterList');
        const store = list.getStore();
        const added = store.add({
            ballot_id: id,
            name: 'New Voter',
            weight: 1
        });
        list.setSelection(added[0]);
    },

    onSave: function() {
        const list = this.lookupReference('voterList');
        const selection = list.getSelection();
        if (selection.isValid()) {
            selection.save({
                success: function(record, operation) {
                    const response = Ext.JSON.decode(operation.getResponse().responseText);
                    if (response.ballot) {
                        record.set('id', response.ballot.id);
                        record.set('version', response.ballot.version);
                        record.set('updated_at', response.ballot.updated_at);
                    }
                    Ext.toast('Saved'.translate(), 2000);
                },
                failure: function(record, operation) {
                    Ext.toast("TODO");
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
        const list = this.lookupReference('voterList');
        const selection = list.getSelection();
        if (selection) {
            list.deselectAll();
            selection.erase();
        }
    }
});
Ext.define('Votr.view.admin.CandidatesController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.admin.candidates',

    init: function(view) {
        this.getViewModel().bind('{id}', this.onNavigate, this);
    },

    onNavigate: function(id) {
        this.getViewModel().getStore('candidates').load({
            scope: this,
            callback: function(records, operation, success) {
                if (records.length > 0) {
                    const list = this.lookupReference('candidateList');
                    list.setSelection(records[0]);
                }
            }
        });
    },

    onAdd: function() {
        const id = this.getViewModel().get('id');
        const list = this.lookupReference('candidateList');
        const store = list.getStore();
        const added = store.add({
            ballot_id: id,
            names: { default: 'New Candidate'.translate() },
            descriptions: { default: '' }
        });
        list.setSelection(added[0]);
    },

    onFilter: function() {

    },

    onSave: function() {
        const list = this.lookupReference('candidateList');
        const selection = list.getSelection();
        if (selection.isValid()) {
            selection.save({
                success: function(record, operation) {
                    const response = Ext.JSON.decode(operation.getResponse().responseText);
                    if (response.candidate) {
                        record.set('id', response.candidate.id);
                        record.set('version', response.candidate.version);
                        record.set('updated_at', response.candidate.updated_at);
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
        const list = this.lookupReference('candidateList');
        const selection = list.getSelection();
        if (selection) {
            list.deselectAll();
            selection.erase();
        }
    }
});
Ext.define('Votr.view.admin.BallotsController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.admin.ballots',

    init: function(view) {
        this.getViewModel().bind('{id}', this.onNavigate, this);
    },

    onNavigate: function(id) {
        this.getViewModel().getStore('ballots').load({
            scope: this,
            callback: function(records, operation, success) {
                if (records.length > 0) {
                    const list = this.lookupReference('ballotList');
                    list.setSelection(records[0]);
                }
            }
        });
    },

    onCandidates: function() {
        const list = this.lookupReference('ballotList');
        const selection = list.getSelection();
        this.redirectTo(`#ballots/${selection.get('id')}/candidates`)
    },

    onResults: function() {
        const list = this.lookupReference('ballotList');
        const selection = list.getSelection();
        this.redirectTo(`#ballots/${selection.get('id')}/results`)
    },

    onLog: function() {
        const list = this.lookupReference('ballotList');
        const selection = list.getSelection();
        this.redirectTo(`#ballots/${selection.get('id')}/log`)
    },

    onAdd: function() {
        const id = this.getViewModel().get('id');
        const list = this.lookupReference('ballotList');
        const store = list.getStore();
        const added = store.add({
            ward_id: id,
            titles: { default: 'New Ballot'.translate() },
            descriptions: { default: '' },
            method: 'scottish_stv',
            quota: 'droop',
            electing: 1,
            anonymous: true,
            shuffle: false,
            mutable: false,
            public: true
        });
        list.setSelection(added[0]);
    },

    onFilter: function() {

    },

    onSave: function() {
        const list = this.lookupReference('ballotList');
        const selection = list.getSelection();
        if (selection.isValid()) {
            selection.save({
                success: function(record, operation) {
                    const response = Ext.JSON.decode(operation.getResponse().responseText);
                    if (response.ballot) {
                        record.set('id', response.ballot.id);
                        record.set('version', response.ballot.version);
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
        const list = this.lookupReference('ballotList');
        const selection = list.getSelection();
        if (selection) {
            list.deselectAll();
            selection.erase();
        }
    }
});
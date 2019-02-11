Ext.define('Votr.view.admin.WardsController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.admin.wards',

    init: function(view) {
        this.getViewModel().bind('{id}', this.onNavigate, this);
    },

    onNavigate: function(id) {
        this.getViewModel().getStore('wards').load({
            scope: this,
            callback: function(records, operation, success) {
                if (records.length > 0) {
                    const list = this.lookupReference('wardList');
                    list.setSelection(records[0]);
                }
            }
        });
    },

    onWards: function() {
        const list = this.lookupReference('wardList');
        const selection = list.getSelection();
        this.redirectTo(`#wards/${selection.get('id')}`)
    },

    onVoters: function() {
        const id = this.getViewModel().get('id');
        this.redirectTo(`#wards/${id}/voters`)
    },

    onBallots: function() {
        const id = this.getViewModel().get('id');
        this.redirectTo(`#wards/${id}/ballots`)
    },

    onAdd: function() {
        const id = this.getViewModel().get('id');
        const name = id == 'root' ? 'New Election' : 'New Ward';
        const list = this.lookupReference('wardList');
        const store = list.getStore('wards');
        const node = store.add({
            names: { default: name.translate() },
            descriptions: { default: '' }
        });
        list.setSelection(node);
    },

    onSave: function() {
        const list = this.lookupReference('wardList');
        const selection = list.getSelection();
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
        const list = this.lookupReference('wardList');
        const selection = list.getSelection();
        if (selection) {
            list.deselectAll();
            selection.erase();
        }
    }
});
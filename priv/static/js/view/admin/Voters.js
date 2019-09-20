Ext.define('Votr.view.admin.Voters', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.admin.voters',
    padding: 0,
    layout: 'hbox',
    referernceHolder: true,
    viewModel: {
        stores: {
            voters: {
                model: 'Votr.model.admin.Voter',
                proxy: {
                    type: 'rest',
                    url: '../api/admin/wards/{id}/voters',
                    reader: { type: 'json', rootProperty: 'voters' }
                }
            },
        }
    },
    requires: [
        "Votr.view.admin.VotersController"
    ],
    controller: 'admin.voters',
    items: [{
        xtype: 'list',
        reference: 'voterList',
        width: 384,
        itemTpl: '<div><p>{name}<span style="float:right">{voted}</span></p></div>',
        bind: '{voters}'
    }, {
        xtype: 'admin.voter',
        flex: 1
    }, {
        xtype: 'toolbar',
        itemId: 'toolbar',
        docked: 'bottom',
        items: [{
            xtype: 'button',
            text: 'Add',
            handler: 'onAdd'
        }, '->', {
            xtype: 'button',
            text: 'Delete',
            ui: 'decline',
            handler: 'onDelete',
            bind: {
                disabled: '{!voterList.selection}'
            }
        }, '->', {
            xtype: 'button',
            text: 'Save',
            ui: 'confirm',
            handler: 'onSave',
            bind: {
                disabled: '{!voterList.selection}'
            }
        }]
    }]
});

Ext.define('Votr.view.admin.Voters', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.admin.voters',
    padding: 0,
    layout: 'hbox',
    referernceHolder: true,
    viewModel: {
        stores: {
            voters: 'Voters'
        }
    },
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
            itemId: 'add',
            iconCls: 'x-fa fa-plus',
            tooltip: 'Add Voter',
            handler: 'onSave'
        }, {
            xtype: 'button',
            itemId: 'import',
            text: 'Import',
            tooltip: 'Import',
            handler: 'onImport'
        }, '->', {
            xtype: 'button',
            itemId: 'save',
            text: 'Save',
            ui: 'action',
            handler: 'onSave'
        }]
    }]
});
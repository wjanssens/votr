Ext.define('Votr.view.admin.Wards', {
    extend: 'Ext.Panel',
    alias: 'widget.admin.wards',
    requires: [
        'Votr.view.admin.WardsController'
    ],
    controller: 'admin.wards',
    padding: 0,
    layout: 'hbox',
    items: [{
        xtype: 'tree',
        width: 384,
        rootVisible: false,
        store: 'Wards'
    }, {
        xtype: 'admin.ward',
        flex: 1
    }, {
        xtype: 'toolbar',
        itemId: 'toolbar',
        docked: 'bottom',
        items: [{
            xtype: 'button',
            itemId: 'back',
            iconCls: 'x-fa fa-plus',
            tooltip: 'Add Ward',
            handler: 'onAdd'
        }, '->', {
            xtype: 'button',
            itemId: 'voters',
            text: 'Voters',
            handler: 'onVoters'
        }, {
            xtype: 'button',
            itemId: 'ballots',
            text: 'Ballots',
            handler: 'onBallots'
        }, {
            xtype: 'button',
            itemId: 'save',
            text: 'Save',
            ui: 'action',
            handler: 'onSave'
        }]
    }]
});

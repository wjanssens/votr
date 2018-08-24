Ext.define('Votr.view.Wards', {
    extend: 'Ext.Panel',
    alias: 'widget.wards',
    requires: [
        'Votr.view.WardsController'
    ],
    controller: 'wards',
    padding: 0,
    layout: 'hbox',
    items: [{
        xtype: 'tree',
        width: 384,
        rootVisible: false,
        store: 'Wards'
    }, {
        xtype: 'ward',
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
        }]
    }]
});

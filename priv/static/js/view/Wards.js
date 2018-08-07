Ext.define('Votr.view.Wards', {
    extend: 'Ext.Panel',
    alias: 'widget.wards',
    title: 'Wards',
    layout: 'hbox',
    tools: [{
        iconCls: 'x-fa fa-search',
        handler: function () {
        }
    },{
        iconCls: 'x-fa fa-plus',
        handler: function () {
        }
    }],
    items: [{
        xtype: 'tree',
        width: 256,
        rootVisible: false,
        store: 'Wards'
    }, {
        xtype: 'ballot',
        flex: 1
    }]
});

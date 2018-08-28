Ext.define('Votr.view.voter.RankField', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.rankfield',
    layout: 'hbox',
    padding: 0,
    items: [{
        xtype: 'button',
        iconCls: 'x-fa fa-plus',
        width: 32,
        ui: 'action'
    },{
        xtype: 'textfield',
        editable: false,
        width: 32
    },{
        xtype: 'button',
        iconCls: 'x-fa fa-minus',
        width: 32,
        ui: 'action'
    }]
});
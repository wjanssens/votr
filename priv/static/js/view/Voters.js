Ext.define('Votr.view.Voters', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voters',
    layout: 'hbox',
    title: 'Voters',
    tools: [
        {
            iconCls: 'x-fa fa-plus',
            handler: function () {
            }
        }, {
            iconCls: 'x-fa fa-upload',
            handler: function () {
            }
        }, {
            iconCls: 'x-fa fa-filter',
            handler: function () {
            }
        }
    ],
    padding: 0,
    items: [{
        xtype: 'list',
        width: 256,
        itemTpl: '<div><p>{title}<span style="float:right">{electing} / {candidates}</span></p><p>{description}</p></div>',
        store: 'Voters'
    }, {
        xtype: 'voter',
        flex: 1
    }]
});
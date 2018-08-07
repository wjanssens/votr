Ext.define('Votr.view.Ballots', {
    extend: 'Ext.Panel',
    alias: 'widget.ballots',
    layout: 'hbox',
    title: 'Ballots',
    padding: 0,
    tools: [
        {
            iconCls: 'x-fa fa-plus',
            handler: function () {
            }
        }, {
            iconCls: 'x-fa fa-filter',
            handler: function () {
            }
        }
    ],
    items: [{
        xtype: 'list',
        width: 256,
        itemTpl: '<div><p>{title}<span style="float:right">{electing} / {candidates}</span></p><p style="color: var(--highlight-color)">{description}</p></div>',
        store: 'Ballots'
    }, {
        xtype: 'ballot',
        flex: 1
    }]
});
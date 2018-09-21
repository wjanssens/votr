Ext.define('Votr.view.admin.Results', {
    extend: 'Ext.Panel',
    alias: 'widget.admin.results',
    padding: 0,
    layout: 'hbox',
    items: [{
        xtype: 'list',
        width: 384,
        itemTpl: '<div><p>Round {round}</p></div>',
        store: 'admin.Results'
    }, {
        xtype: 'admin.result',
        flex: 1
    }, {
        xtype: 'toolbar',
        itemId: 'toolbar',
        docked: 'bottom',
        items: []
    }]
});

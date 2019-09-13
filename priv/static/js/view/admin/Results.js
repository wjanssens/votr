Ext.define('Votr.view.admin.Results', {
    extend: 'Ext.Panel',
    alias: 'widget.admin.results',
    padding: 0,
    layout: 'hbox',
    referenceHolder: true,
    viewModel: {
        stores: {
            rounds: 'admin.Results',
        }
    },
    items: [{
        xtype: 'list',
        width: 384,
        itemTpl: '<div><p>Round {round}</p></div>',
        bind: {
            store: '{rounds}'
        }
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

Ext.define('Votr.view.admin.Results', {
    extend: 'Ext.Panel',
    alias: 'widget.admin.results',
    padding: 0,
    layout: 'hbox',
    referenceHolder: true,
    viewModel: {
        stores: {
            resultRounds: {
                model: 'Votr.model.admin.ResultRound',
                proxy: {
                    type: 'rest',
                    url: '../api/admin/ballots/{id}/results',
                    reader: { type: 'json', rootProperty: 'data' }
                }
            }
        }
    },
    requires: [
        "Votr.view.admin.ResultsController"
    ],
    controller: 'admin.results',
    items: [{
        xtype: 'list',
        reference: 'resultRoundsList',
        width: 384,
        itemTpl: '<div><p>Round {round}</p></div>',
        bind: {
            store: '{resultRounds}'
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

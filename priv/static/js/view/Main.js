Ext.define('Votr.view.Main', {
    extend: 'Ext.Panel',
    padding: 0,
    layout: 'card',
    controller: 'main',
    itemId: 'main_cards',
    items: [
        {xtype: 'login'},
        {xtype: 'admin.main'},
        {xtype: 'voter.ballots'}
    ]
});